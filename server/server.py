"""
Description:    Flask app running to handle HTTP requests managing the game state and communication across clients.
Date:           10/06/23
Author:         Jordan Bourdeau
"""

from game_logic.constants import SECRET_KEY
from game_logic.game import Game
from game_logic.player import Player
from game_logic.types import CardType, JailMethod

from flask import Flask, jsonify, request
from random import randint

app = Flask(__name__)
app.secret_key = SECRET_KEY

game: Game = Game()

# TODO: Add authentication based off player ID for requests


@app.route("/game", methods=["GET"])
def index():
    """
    Description:    Base endpoint which returns JSON formatted with the game state.
                    No authentication required to receive the game state.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    return jsonify(game.to_dict())


@app.route("/game/register_player", methods=["GET"])
def register_player():
    """
    Description:    Endpoint for registering a new player in the game. Requires their username and issues player ID.
    :return:        Returns json-formatted data with the game state.
    """
    global game

    try:
        username: str = request.args.get("username")
    # No query parameters passed in
    except AttributeError as e:
        return jsonify({"registered": False})

    """
    Checks that the total number of players is under the limit (8) then does the following:
        1) Creates a new player with a given username and adds it to the list of players.
        2) Generates a random, unique, 16 character hex ascii code for the player ID if they are added.
            -> This id is how the player will authenticate future requests.
        3) If the player is not created, the method will return None.
    """
    player_id: str = game.register_player(username)
    state: dict = game.to_dict()
    state["event"] = "registerPlayer"
    state["playerId"] = player_id
    state["success"] = player_id is None
    return jsonify(state)


@app.route("/game/roll_dice", methods=["GET"])
def roll_dice():
    """
    Description:    Endpoint for conducting a die roll. Game object keeps track of current player's turn.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("playerId").lower()
    # No query parameters passed in
    except AttributeError as e:
        player_id: str = ""

    """
    Does the following:
        1) Does the player ID correspond to a valid, active player?
        2) Create two random integers corresponding to valid die rolls.
        3) Move the player location index forward the appropriate amount, wrapping around at 40.
        4) If the player rolled doubles, increment their doubles streak.
        5) If the player rolled their third pair of doubles, move them to the jail tile and end their turn.
    """
    success: bool = game.roll_dice(player_id=player_id)
    state: dict = game.to_dict()
    state["event"] = "dieRoll"
    state["success"] = success
    return jsonify(state)


@app.route("/game/draw_card", methods=["GET"])
def draw_card():
    """
    Description:    Endpoint which will draw a chance/community chest card for the active player.
    :return:        Returns json-formatted data with the game state.
    """
    global game

    try:
        player_id: str = request.args.get("playerId").lower()
        card_arg: str = request.args.get("cardType").lower()
    # No query parameters passed in
    except AttributeError as e:
        player_id: str = ""
        card_arg: str = ""

    match card_arg:
        case "chance":
            card_type: CardType = CardType.CHANCE
        case "communityChest":
            card_type: CardType = CardType.COMMUNITY_CHEST
        case _:
            card_type: CardType = CardType.INVALID
    """
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
        2) Is the active player on one of the associated card tiles?
        3) Are there cards in the deck?
            -> If not, mark all cards as active and "reshuffle" the deck.
    Once this has been completed, the appropriate deterministic action will be taken by the game.
    """
    success: bool = game.draw_card(player_id=player_id, card_type=card_type)
    state: dict = game.to_dict()
    state["event"] = "cardDraw"
    state["success"] = success
    return jsonify(state)


@app.route("/game/buy_property")
def buy_property():
    """
    Description:    Endpoint which will take a property being purchased and compute game state based on the current
                    state.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("playerId").lower()
        property: str = request.args.get("property").lower()
    # No query parameters passed in
    except AttributeError as e:
        player_id: str = ""
        property: str = ""

    """
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
        2) Is the active player on the property which they are trying to purchase?
        3) Is the property unowned?
        4) Does the player have the funds to purchase the property?
    If the answers are all yes, the game will give ownership of the tile to the player and subtract their funds.
    """
    success: bool = game.buy_property(player_id=player_id, property=property)
    state: dict = game.to_dict()
    state["event"] = "transaction"
    state["success"] = success
    return jsonify(state)


@app.route("/game/buy_improvements")
def buy_improvements():
    """
    Description:    Endpoint for buying an improvement (hotel/house) on a property.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("playerId").lower()
        property: str = request.args.get("property").lower()
        amount: int = int(request.args.get("amount"))
    # No query parameters passed in
    except AttributeError as e:
        player_id: str = ""
        property: str = ""
        amount: int = 0

    """ 
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
        2) Is the property valid?
        3) Can the property be developed?
        4) Does the player own the property and its associated monopoly?
        5) Would the total number of improvements be less than or equal to the maximum number of improvements?
        6) Does the player have the funds to buy all the improvements?
    If the answers are all yes, the game will add an improvement to the property and subtract player funds.
    """
    success: bool = game.buy_improvement(player_id=player_id, property=property, amount=amount)
    state: dict = game.to_dict()
    state["event"] = "transaction"
    state["success"] = success
    return jsonify(state)


@app.route("/game/sell_improvements")
def sell_improvements():
    """
    Description:    Endpoint for selling improvements (inverse of buying them).
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("playerId").lower()
        property: str = request.args.get("property").lower()
        amount: int = int(request.args.get("amount"))
    # No query parameters passed in
    except AttributeError as e:
        player_id: str = ""
        property: str = ""
        amount: int = 0

    """ 
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
        2) Is the property valid?
        3) Does the player own the property and its associated monopoly?
        4) Does the property have developments which can be sold?
        5) Are the number of developments being sold less than or equal to the total number of developments?
    If the answers are all yes, the game will sell the number of specified development and add player funds.
    """
    success: bool = game.sell_improvement(player_id=player_id, property=property, amount=amount)
    state: dict = game.to_dict()
    state["event"] = "transaction"
    state["success"] = success
    return jsonify(state)


@app.route("/game/mortgage")
def mortgage():
    """
    Description:    Endpoint for mortgaging a property.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("playerId").lower()
        property: str = request.args.get("property").lower()
    # No query parameters passed in
    except AttributeError as e:
        player_id: str = ""
        property: str = ""

    """
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
        2) Is the property valid?
        3) Does the player own the property?
        4) Is the property not currently mortgaged?
    If the answers are all yes, the game will mortgage the property and add player funds.
    """
    success: bool = game.mortgage(player_id=player_id, property=property)
    state: dict = game.to_dict()
    state["event"] = "transaction"
    state["success"] = success
    return jsonify(state)


@app.route("/game/unmortgage")
def unmortgage():
    """
    Description:    Endpoint for unmortgaging a property which is mortgaged.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("playerId").lower()
        property: str = request.args.get("property").lower()
    # No query parameters passed in
    except AttributeError as e:
        player_id: str = ""
        property: str = ""

    """
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
        2) Is the property valid?
        3) Does the player own the property?
        4) Is the property currently mortgaged?
        5) Does the player have the funds to unmortgage the property?
    If the answers are all yes, the game will unmortgage the property and subtract player funds.
    """
    success: bool = game.unmortgage(player_id=player_id, property=property)
    state: dict = game.to_dict()
    state["event"] = "transaction"
    state["success"] = success
    return jsonify(state)


@app.route("/game/get_out_of_jail")
def get_out_of_jail():
    """
    Description:    Endpoint for requesting to get out of jail.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("playerId").lower()
        method_arg: str = request.args.get("method").lower()
    # No query parameters passed in
    except AttributeError as e:
        player_id: str = ""
        method_arg: str = ""

    match method_arg:
        case "doubles":
            method: JailMethod = JailMethod.DOUBLES
        case "money":
            method: JailMethod = JailMethod.MONEY
        case "card":
            method: JailMethod = JailMethod.CARD
        case _:
            method: JailMethod = JailMethod.INVALID

    """
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
        2) Is the player currently in jail?
        3) If the player is using a get out of jail free card, do they currently own that card?
        4) If the player is getting out by doubles, was their last roll actually doubles?
        5) If the player is getting out with money, do they have the funds to do so?
    If the answers are all yes, the game will free the player from jail.
    """
    success: bool = game.get_out_of_jail(player_id=player_id, method=method)
    state: dict = game.to_dict()
    state["event"] = "getOutOfJail"
    state["success"] = success
    return jsonify(state)


@app.route("/game/end_turn")
def end_turn():
    """
    Description:    Endpoint for a player requesting to end their turn.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("playerId").lower()
    # No query parameters passed in
    except AttributeError as e:
        player_id: str = ""

    """
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
    If so, end the player's turn.
    """
    success: bool = game.end_turn(player_id=player_id)
    state: dict = game.to_dict()
    state["event"] = "turnEnd"
    state["success"] = success
    return jsonify(state)


@app.route("/game/reset", methods=["GET"])
def reset():
    """
    Description:    Endpoint used for resetting a game and clearing all associated state.
    :return:        Returns json-formatted data with the cleared game state.
    """
    global game
    try:
        player_id: str = request.args.get("playerId").lower()
    # No query parameters passed in
    except AttributeError as e:
        pass

    """
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
    If the request was from a valid and active player, then it will reset the game.
    """
    success: bool = game.reset(player_id=player_id)
    state: dict = game.to_dict()
    state["success"] = success
    return jsonify(state)


if __name__ == '__main__':
    app.run(debug=True, port=5000)
