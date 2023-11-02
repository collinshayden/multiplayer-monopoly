"""
Description:    Class representing the Go tile
Date:           11/1/2023
Author:         Aidan Bonner
"""

from server.game_logic.constants import GO_MONEY
from server.game_logic.player import Player
from server.game_logic.player_updates import MoneyUpdate
from server.game_logic.tile import Tile


class GoTile(Tile):
    
    def __init__(self) -> None:
        """
        Description:    Class representing the Go tile.
        :returns:       None.
        """
        pass

    def land(self, player: Player, roll: int = None) -> MoneyUpdate:
        """
        Description:    Method for paying the character for landing on Go.
        :returns:       The MoneyUpdate object giving the Player $200.
        """
        return MoneyUpdate(GO_MONEY)
