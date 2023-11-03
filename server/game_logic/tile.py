"""
Description:    Class representing a tile on the game board.
Date:           10/18/2023
Author:         Aidan Bonner, Jordan Bourdeau, Haydens Collins
"""

from server.game_logic.player import Player


class Tile:

    def __init__(self, id: int, name: str) -> None:
        """
        Description:             Class representing a Tile on the board.
        :param id:               An integer identifier for each tile.
        :returns:                None.
        """
        self.id: int = id
        self.name: str = name

    def land(self, player: Player, roll: int = None) -> dict:
        """
        Description:    Method which will be overridden in subclasses.
        :param player:  Player landing on the tile.
        :param roll:    Roll from the player (only used in Utility tiles).
        :return:        Dictionary mapping player IDs to PlayerUpdate objects.
        """
        return {}

    def to_dict(self) -> dict:
        state: dict = {
            "id": self.id,
            "name": self.name
        }
        return state
