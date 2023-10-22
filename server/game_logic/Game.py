"""
Description:    Class representing the central Game object.
Date:           10/18/2023
Author:         Hayden Collins
"""

from .constants import NUM_TILES
from .Player import Player
from .Tile import Tile

from random import randint

class Game:
    def __init__(self):
        self.players = []
        self.active_player_id = 0
        self.tiles = []
        self.community_deck = []
        self.chance_deck = []

    # moves a player by given delta
    def move(self, delta: int) -> None:
        player: Player = self.players[self.active_player_id]
        player.location = (player.location + delta) % NUM_TILES

    # takes a dict with player_ids as key and change in money as values
    # updates each players' money
    def update_money(self, deltas: dict) -> None:
        for player_id in deltas:
            self.players[player_id].money += deltas[player_id]

    def buy_property(self, tile: Tile) -> None:
        pass

    def buy_improvement(self, tile: Tile) -> None:
        pass

    def go_to_jail(self) -> None:
        pass

    def roll_dice(self) -> None:
        """
        Description:    Method for handling a user turn.
        :return:        None.
        """
        if len(self.players) == 0:
            return
        player: Player = self.players[self.active_player_id]
        dice = (randint(1,6), randint(1,6))
        print(dice)
        # Roll doubles in jail
        if dice[0] == dice[1] and player.turns_in_jail > 0:
            player.turns_in_jail = 0
            player.doubles_streak += 1
        # No doubles and in jail, decrement turns in jail and increment player
        elif player.turns_in_jail > 0:
            player.turns_in_jail -= 1
            self.increment_active_player()
            return
        # Roll doubles for the 3rd time -> go to jail
        elif dice[0] == dice[1] and player.doubles_streak == 2:
            player.turns_in_jail = 3
            player.doubles_streak = 0
            self.increment_active_player()
            return
        # Player will roll again
        elif dice[0] == dice[1]:
            player.doubles_streak += 1

        self.move(dice[0] + dice[1])
        if dice[0] != dice[1]:
            player.doubles_streak = 0
            self.increment_active_player()

    def increment_active_player(self) -> None:
        """
        Description:    Function responsible for incrementing the active player.
        :return:        None.
        """
        if len(self.players) == 0:
            return
        self.active_player_id = (self.active_player_id + 1) % len(self.players)
        while not self.players[self.active_player_id].active:
            self.increment_active_player()

    def register_player(self, username: str) -> int:
        """
        Description:    Method used to register a player and return their player ID.
        :return:        Player ID.
        """
        next_id: int = len(self.players)
        self.players.append(Player(next_id, username))
        return next_id

    def mortgage(self, tile: Tile) -> None:
        pass

    def pay_mortgage(self, tile: Tile) -> None:
        pass

    def to_dict(self) -> dict:
        return {
            "started": True,
            "activePlayerId": self.active_player_id,
            "players": [player.to_dict() for player in self.players]
        }