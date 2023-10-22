"""
Description:    Flask app running to handle HTTP requests managing the game state and communication across clients.
Date:           10/06/23
Author:         Jordan Bourdeau
"""

from game_logic.constants import SECRET_KEY
from game_logic.Game import Game
from game_logic.Player import Player

from flask import Flask, jsonify, request
from random import randint

app = Flask(__name__)
app.secret_key = SECRET_KEY

game: Game = Game()


@app.route("/game", methods=["GET"])
def index():
    global game
    return jsonify(game.to_dict())


@app.route("/game/register_player", methods=["GET"])
def register_player():
    global game
    username: str = request.args.get("username")
    if username is None:
        return jsonify({"registered": False})
    game.register_player(username)
    return jsonify({"registered": True})


@app.route("/game/roll_dice", methods=["GET"])
def roll_dice():
    global game
    game.roll_dice()
    return jsonify(game.to_dict())


def reset_game():
    global game
    game = None


if __name__ == '__main__':
    app.run(debug=True, port=5000)
