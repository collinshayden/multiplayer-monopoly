"""
Description:    Flask app running to handle HTTP requests managing the game state and communication across clients.
Date:           10/06/23
Author:         Jordan Bourdeau
"""

from game_logic.constants import SECRET_KEY
from game_logic.game import Game
from game_logic.types import CardType, JailMethod

from flask import Flask, jsonify, request
from random import randint
from typing import Any

app = Flask(__name__)
app.secret_key = SECRET_KEY

game: Game = Game()


@app.route("/game/state", methods=["GET"])
def state():
    """
    Description:    Base endpoint which returns JSON formatted with the game state.
                    No authentication required to receive the game state.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    return jsonify(game.to_dict())


@app.route("/game/start_game", methods=["GET"])
def start_game():
    """
    Description:    Endpoint for starting the game. Requires >= 2 players and <= max to be registered.
    :return:        Returns json-formatted data with the game state if it starts. Otherwise, simple message it failed to
                    start.
    """
    global game
    try:
        player_id: str = request.args.get("player_id").lower()
    # No query parameters passed in
    except (AttributeError, KeyError) as e:
        player_id: str = ""
    if player_id is None:
        player_id: str = ""
    success: bool = game.start_game(player_id=player_id)
    client_bindings: dict[str, Any] = {
        "event": "startGame",
        "success": success
    }
    return jsonify(client_bindings)


@app.route("/game/register_player", methods=["GET"])
def register_player():
    """
    Description:    Endpoint for registering a new player in the game. Requires their username and issues player ID.
    :return:        Returns json-formatted data with the game state.
    """
    global game

    try:
        display_name: str = request.args.get("display_name")
    # No query parameters passed in
    except (AttributeError, KeyError) as e:
        return jsonify({"event": "registerPlayer", "registered": False})
    if display_name is None:
        return jsonify({"event": "registerPlayer", "registered": False})
    """
    Checks that the total number of players is under the limit (8) then does the following:
        1) Creates a new player with a given username and adds it to the list of players.
        2) Generates a random, unique, 16 character hex ascii code for the player ID if they are added.
            -> This id is how the player will authenticate future requests.
        3) If the player is not created, the method will return None.
    """
    player_id: str = game.register_player(display_name)
    client_bindings: dict[str, Any] = {
        "event": "registerPlayer",
        "playerId": player_id,
        "success": player_id != "",
    }
    return jsonify(client_bindings)


@app.route("/game/roll_dice", methods=["GET"])
def roll_dice():
    """
    Description:    Endpoint for conducting a die roll. Game object keeps track of current player's turn.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("player_id").lower()
    # No query parameters passed in
    except (AttributeError, KeyError) as e:
        player_id: str = ""
    if player_id is None:
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
    client_bindings: dict[str, Any] = {
        "event": "rollDice",
        "success": success
    }
    return jsonify(client_bindings)


# TODO: Implement test method for this once it is implemented in Game class.
@app.route("/game/draw_card", methods=["GET"])
def draw_card():
    """
    Description:    Endpoint which will draw a chance/community chest card for the active player.
    :return:        Returns json-formatted data with the game state.
    """
    global game

    try:
        player_id: str = request.args.get("player_id").lower()
        card_arg: str = request.args.get("card_type").lower()
    # No query parameters passed in
    except (AttributeError, KeyError) as e:
        player_id: str = ""
        card_arg: str = ""
    if player_id is None or card_arg is None:
        player_id: str = ""
        card_arg: str = ""

    match card_arg:
        case "chance":
            card_type: CardType = CardType.CHANCE
        case "community_chest":
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
    client_bindings: dict[str, Any] = {
        "event": "drawCard",
        "success": success
    }
    return jsonify(client_bindings)


@app.route("/game/buy_property")
def buy_property():
    """
    Description:    Endpoint which will take a property being purchased and compute game state based on the current
                    state.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("player_id").lower()
        tile_id: int = int(request.args.get("tile_id"))
    # No query parameters passed in
    except (AttributeError, KeyError, TypeError, ValueError) as e:
        player_id: str = ""
        tile_id: int = -1
    if player_id is None or tile_id is None:
        player_id: str = ""
        tile_id: int = -1

    """
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
        2) Is the property unowned?
        3) Does the player have the funds to purchase the property?
    If the answers are all yes, the game will give ownership of the tile to the player and subtract their funds.
    """
    success: bool = game.buy_property(player_id=player_id, tile_id=tile_id)
    client_bindings: dict[str, Any] = {
        "event": "buyProperty",
        "success": success
    }
    return jsonify(client_bindings)


@app.route("/game/set_improvements")
def set_improvements():
    """
    Description:    Endpoint for buying/selling improvements (hotels/houses) for a property.
    :return:        Returns a JSON-serliazable status response.
    """
    global game
    try:
        player_id: str = request.args.get("player_id").lower()
        tile_id: int = int(request.args.get("tile_id"))
        quantity: int = int(request.args.get("quantity"))
    # No query parameters passed in
    except (AttributeError, KeyError, TypeError, ValueError) as e:
        player_id: str = ""
        tile_id: int = -1
        quantity: int = 0
    if player_id is None or tile_id is None or quantity is None:
        print("3")
        player_id: str = ""
        tile_id: int = -1
        quantity: int = 0

    """ 
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
        2) Is the property valid?
        3) Is the property improvable?
        4) Does the player own the property and have a monopoly over its color group?
        5) Is the requested quantity of improvements allowed?
        6) Does the player have the funds to buy improvements (if ?
    If the answers are all yes, the game will add an improvement to the property and subtract player funds.
    """
    success: bool = game.improvements(player_id=player_id, tile_id=tile_id, amount=quantity)
    client_bindings: dict[str, Any] = {
        "event": "setImprovements",
        "success": success
    }
    return jsonify(client_bindings)


@app.route("/game/set_mortgage")
def set_mortgage():
    """
    Description:    Endpoint for mortgaging/unmortgaging a property.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("player_id").lower()
        tile_id: int = int(request.args.get("tile_id"))
        mortgage: bool = True if request.args.get("mortgage").lower() == "true" else False
    # No query parameters passed in or invalid integer value for tile ID
    except (AttributeError, KeyError, TypeError, ValueError) as e:
        player_id: str = ""
        tile_id: int = -1
        mortgage: bool = False
    if player_id is None or tile_id is None:
        player_id: str = ""
        tile_id: int = -1
        mortgage: bool = False

    """
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
        2) Is the property valid?
        3) Does the player own the property?
        4) Is the property not currently mortgaged?
    If the answers are all yes, the game will mortgage the property and add player funds.
    """
    success: bool = game.mortgage(player_id=player_id, tile_id=tile_id, mortgage=mortgage)
    client_bindings: dict[str, Any] = {
        "event": "setMortgage",
        "success": success
    }
    return jsonify(client_bindings)


@app.route("/game/get_out_of_jail")
def get_out_of_jail():
    """
    Description:    Endpoint for requesting to get out of jail.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("player_id").lower()
        method_arg: str = request.args.get("method").lower()
    # No query parameters passed in
    except (AttributeError, KeyError) as e:
        player_id: str = ""
        method_arg: str = ""
    if player_id is None or method_arg is None:
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
    client_bindings: dict[str, Any] = {
        "event": "getOutOfJail",
        "success": success
    }
    return jsonify(client_bindings)


@app.route("/game/end_turn")
def end_turn():
    """
    Description:    Endpoint for a player requesting to end their turn.
    :return:        Returns json-formatted data with the game state.
    """
    global game
    try:
        player_id: str = request.args.get("player_id").lower()
    # No query parameters passed in
    except (AttributeError, KeyError) as e:
        player_id: str = ""
    if player_id is None:
        player_id: str = ""

    """
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
    If so, end the player's turn.
    """
    success: bool = game.end_turn(player_id=player_id)
    client_bindings: dict[str, Any] = {
        "event": "endTurn",
        "success": success
    }
    return jsonify(client_bindings)


@app.route("/game/reset", methods=["GET"])
def reset():
    """
    Description:    Endpoint used for resetting a game and clearing all associated state.
    :return:        Returns json-formatted data with the cleared game state.
    """
    global game
    try:
        player_id: str = request.args.get("player_id").lower()
    # No query parameters passed in
    except (AttributeError, KeyError) as e:
        player_id: str = ""
    if player_id is None:
        player_id: str = ""

    """
    Checks the following:
        1) Does the player ID correspond to a valid, active player?
    If the request was from a valid and active player, then it will reset the game.
    """
    success: bool = game.reset(player_id=player_id)
    client_bindings: dict[str, Any] = {
        "event": "reset",
        "success": success
    }
    return jsonify(client_bindings)


if __name__ == '__main__':
    app.run(debug=True, port=5000)
