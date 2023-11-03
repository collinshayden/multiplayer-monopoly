"""
Description:    Class representing the Go to Jail tile
Date:           11/1/2023
Author:         Aidan Bonner
"""

from server.game_logic.tile import Tile
from server.game_logic.player import Player
from server.game_logic.player_updates import GoToJailUpdate


class GoToJailTile(Tile):

    def __init__(self) -> None:
        """
        Description:    Class representing the Go -to-Jail tile.
        :returns:       None.
        """
        super().__init__(30, "Go to Jail")

    def land(self, player: Player, roll: int = None) -> dict[str: GoToJailUpdate]:
        """
        Description:    Method for sending the character to Jail for landing on this tile
        :returns:       The GoToJailUpdate object sending the Player to jail
        """
        return {player.player_id: GoToJailUpdate()}
