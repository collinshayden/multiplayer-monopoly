"""
Description:    Class representing a Railroad tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .asset_tile import AssetTile
from .player import Player
from .types import AssetGroups, RailroadStatus
from .constants import RENTS


class RailroadTile(AssetTile):

    def __init__(self, id: int, owner: Player, price: int, is_mortgaged: bool, mortage_price: int) -> None:
        """
        Description:    Class representing a railroad tile.
        :param id:                  An integer identifier for each tile.
        :param owner:               Player owning the tile.
        :param price:               Price to purchase the property.
        :param is_mortgaged:         Boolean for whether the property is mortgaged or not.
        :param mortage_price:       The amount for mortgaging a property.
        :returns:        None.
        """
        super().__init__(id, owner, price, is_mortgaged, mortage_price, AssetGroups.RAILROAD)
        rent_map = RENTS[id]
        self.rent: int = 25

    def update_rent(self) -> None:
        pass

    def to_dict(self) -> dict:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        railroad_dict = {"id": self.id,
                         "owner": self.owner,
                         "price": self.price,
                         "isMortgaged": self.is_mortgaged,
                         "mortgagePrice": self.mortgage_price,
                         "rentMap": self.rent_map,
                         "rent": self.rent}
        return railroad_dict
