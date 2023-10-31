"""
Description:    Class representing a buyable tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .player import Player
from .tile import Tile


class AssetTile(Tile):

    def __init__(self, id: int, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group) -> None:
        """
        Description:            Class representing a tile which can be bought.
        :param owner:           Player who owns a tile.
        :param price:           Price to buy the tile.
        :param is_mortaged:     Boolean for if a tile has been mortgaged.
        :param mortage_price:   The amount of moneu which can be received when mortaged.
        :param group:           The group which the BuyableTile is a part of.
        """
        # TODO: Add call to superclass constructor
        self.owner: Player = owner
        self.price: int = price
        self.is_mortaged: bool = is_mortaged
        self.mortage_price: int = mortage_price
        self.group = group

    @property
    def liquid_value(self) -> int:
        # TODO overwrite in property subclass
        """
        Description:    Returns the value of the property
        :return:        int value representing how much money the property is worth
        """
        return 0 if self.is_mortaged else self.mortage_price

    @property
    def lift_mortage_cost(self) -> int:
        """
        Description:    Returns how much it costs to lift the mortage of a mortaged property
        :return:        int value of original mortage cost + 10%
        """
        return round(self.mortage_price * 1.1)


