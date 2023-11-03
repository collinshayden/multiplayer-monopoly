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
        super().__init__(0, "Go")

    def land(self, player: Player, roll: int = None) -> dict[str: MoneyUpdate]:
        """
        Description:    Method for paying the character for landing on Go.
        :returns:       The MoneyUpdate object giving the Player $200.
        """
        return {player.player_id: MoneyUpdate(GO_MONEY)}
