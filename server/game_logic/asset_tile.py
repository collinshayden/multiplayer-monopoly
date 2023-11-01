"""
Description:    Class representing a buyable tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .player import Player
from .tile import Tile
from.types import AssetGroups


class AssetTile(Tile):

    def __init__(self, id: int, owner: Player, price: int, group: AssetGroups) -> None:
        """
        Description:            Class representing a tile which can be bought.
        :param owner:           Player who owns a tile.
        :param price:           Price to buy the tile.
        :param is_mortgaged:     Boolean for if a tile has been mortgaged.
        :param mortage_price:   The amount of moneu which can be received when mortaged.
        :param group:           The group which the BuyableTile is a part of.
        """
        # TODO: Add call to superclass constructor
        self.owner: Player = owner
        self.price: int = price
        self.group: AssetGroups = group

        # Default values here
        self.is_mortgaged: bool = False
        self.mortage_price: int = int(price / 2)

    @property
    def liquid_value(self) -> int:
        # TODO overwrite in property subclass
        """
        Description:    Returns the value of the property
        :return:        int value representing how much money the property is worth
        """
        return 0 if self.is_mortgaged else self.mortage_price

    @property
    def lift_mortage_cost(self) -> int:
        """
        Description:    Returns how much it costs to lift the mortage of a mortaged property
        :return:        int value of original mortage cost + 10%
        """
        return round(self.mortage_price * 1.1)

    # Simple interface methods to mortgage/unmortgage the property

    def mortgage(self):
        self.is_mortgaged = True

    def unmortgage(self):
        self.is_mortgaged = False
