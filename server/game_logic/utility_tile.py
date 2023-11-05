"""
Description:    Class representing a utility tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from server.game_logic.asset_tile import AssetTile
from server.game_logic.player import Player
from server.game_logic.types import AssetGroups
from server.game_logic.constants import RENTS

from typing import Any


class UtilityTile(AssetTile):

    def __init__(self, id: int, name: str, price: int) -> None:
        """
        Description:    Class representing the two utility tiles.
        :returns:       None.
        """
        super().__init__(id, name, price, AssetGroups.UTILITY)

    def land(self, player: Player, roll: int = None) -> dict:
        """
        Description:    Method which will be overridden in subclasses.
        :param player:  Player landing on the tile.
        :param roll:    Roll from the player (only used in Utility tiles).
        :return:        Dictionary mapping player IDs to PlayerUpdate objects.
        """
        # TODO: Handle the case where rent knocks a player out and the owner
        # TODO: does not actually get the full rent sum.
        from server.game_logic.player_updates import MoneyUpdate
        if self.owner is player or self.owner is None:
            return {}
        else:
            return {
                player.id: MoneyUpdate(-self.rent * roll),
                self.owner.id: MoneyUpdate(self.rent * roll)
            }

    def to_dict(self) -> dict[str, Any]:
        """
        Description:    Overridden to_dict() method which replaces 'rent' with 'rentMultiplier'.
        :return:        Dictionary for the tile state.
        """
        client_bindings: dict = super().to_dict()
        client_bindings.pop("rent")
        client_bindings["rentMultiplier"] = self.rent
        return client_bindings
