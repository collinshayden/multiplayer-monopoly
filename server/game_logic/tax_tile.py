"""
Description:    Class representing the income and luxury tax tiles
Date:           11/4/2023
Author:         Aidan Bonner
"""

from server.game_logic.tile import Tile
from server.game_logic.player import Player
from server.game_logic.player_updates import MoneyUpdate


class TaxTile(Tile):

    def __init__(self, id: int, name: str, amount: int) -> None:
        """
        Description:    Class representing the income and luxury tax tiles.
        :param amount:  The amount of tax levied
        :returns:       None.
        """
        super.__init__(id, name)

    def land(self, player: Player, roll: int = None)-> dict[str: MoneyUpdate]:
        """
        Description:    Method for taxing the player that lands on it
        :returns:       The MoneyUpdate taxing the player
        """
        return {player.id: MoneyUpdate(self.amount)}
