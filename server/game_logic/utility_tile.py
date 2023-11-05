"""
Description:    Class representing a utility tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from typing import Any
from .asset_tile import AssetTile
from .player import Player
from .types import AssetGroups
from .constants import RENTS


class UtilityTile(AssetTile):

    def __init__(self, id: int, owner: Player, price: int, is_mortaged: bool, mortage_price: int) -> None:
        """
        Description:    Class representing the two utility tiles.
        :returns:       None.
        """
        super().__init__(id, owner, price, is_mortaged, mortage_price, AssetGroups.UTILITY)
        rent_map = RENTS[id]
        rent_multiplier = 4

    def to_dict(self) -> dict[str, Any]:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        client_bindings = {
            "id": self.id,
            "type": "utility",
            "owner": self.owner,
            "price": self.price,
            "isMortgaged": self.is_mortaged,
            "mortgagePrice": self.mortgage_price,
            "rentMap": self.rent_map,
            "rentMultiplier": self.rent_multiplier}
        return client_bindings
