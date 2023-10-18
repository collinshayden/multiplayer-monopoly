# Game class
# Created by Hayden Collins 
# 2023/10/18
import Player, Tile
from random import randint

class Game(): 
    def __init__(self, players: list, active_player_id: int, tiles: list, community_deck, chance_deck):
        self.players = players
        self.active_player_id = active_player_id
        self.tiles = tiles
        self.community_deck = community_deck
        self.chance_deck = chance_deck

    # return a tuple of two random dice rolls
    def roll_dice(self) -> tuple:
        return (randint(1,6), randint(1,6))

    # moves a player by given delta
    def move(self, delta: int) -> None:
        self.players[self.active_player_id].location += delta % 40

    # takes a dict with player_ids as key and change in money as values
    # updates each players' money
    def updateMoney(self, deltas: dict) -> None:
        for player_id in deltas:
            self.players[player_id].money += deltas[player_id]

    def buyProperty(self, tile: Tile) -> None:
        pass

    def buyImprovement(self, tile: Tile) -> None:
        pass

    def goToJail(self) -> None:
        pass

    def turn(self) -> None:
        pass

    def mortage(self, tile: Tile) -> None:
        pass

    def payMortage(self, tile: Tile) -> None:
        pass

