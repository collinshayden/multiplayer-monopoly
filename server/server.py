"""
Description:    Flask app running to handle HTTP requests managing the game state and communication across clients.
Date:           10/06/23
Author:         Jordan Bourdeau
"""

from constants import SECRET_KEY
from game_logic.Game import Game

from flask import Flask, jsonify

app = Flask(__name__)
app.secret_key = SECRET_KEY

game: Game = None


@app.route("/")
def index():
    global game
    if game is None:
        game = Game()
    data: dict = {
        "connected": True
    }
    return jsonify(data)


if __name__ == '__main__':
    app.run(debug=True, port=5000)
