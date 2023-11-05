"""
Description:    Class representing a utility tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .asset_tile import AssetTile
from .player import Player
from .roll import Roll
from .types import AssetGroups
from .constants import UTILITY_COST

from typing import Any


class UtilityTile(AssetTile):

    def __init__(self, id: int, name: str) -> None:
        """
        Description:    Class representing the two utility tiles.
        :returns:       None.
        """
        super().__init__(id, name, UTILITY_COST, AssetGroups.UTILITY)

    def land(self, player: Player, roll: Roll = None) -> dict:
        """
        Description:    Method which will be overridden in subclasses.
        :param player:  Player landing on the tile.
        :param roll:    Roll from the player (only used in Utility tiles).
        :return:        Dictionary mapping player IDs to PlayerUpdate objects.
        """
        # TODO: Handle the case where rent knocks a player out and the owner
        # TODO: does not actually get the full rent sum.
        from .player_updates import MoneyUpdate
        if self.owner is player or self.owner is None:
            return {}
        else:
            return {
                player.id: MoneyUpdate(-self.rent * roll.total),
                self.owner.id: MoneyUpdate(self.rent * roll.total)
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
