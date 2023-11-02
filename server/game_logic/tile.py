"""
Description:    Class representing a tile on the game board.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""


class Tile:

    def __init__(self, id: int) -> None:
        """
        Description:    Class representing a Tile on the board.
        :param id:      An integer identifier for each tile.
        :returns:       None.
        """
        self.id: int = id

    def on_land(self, roll: int, player):
        """
        Description:    Tile method to be called when a tile gets landed on.
        :param roll:
        :param player:
        :return:
        """