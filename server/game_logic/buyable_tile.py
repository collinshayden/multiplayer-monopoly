"""
Description:    Class representing a buyable tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""
from .player import Player
from .tile import Tile


class BuyableTile(Tile):

    def __init__(self, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group) -> None:
        """
        Description:            Class representing a tile which can be bought.
        :param owner:           Player who owns a tile.
        :param price:           Price to buy the tile.
        :param is_mortaged:     Boolean for if a tile has been mortgaged.
        :param mortage_price:   The amount of moneu which can be received when mortaged.
        :param group:           The group which the BuyableTile is a part of.
        """
        # TODO: Add call to superclass constructor
        self.owner = owner
        self.price = price
        self.is_mortaged = is_mortaged
        self.mortage_price = mortage_price
        self.group = group

    def compute_rent(self, dice_roll: int = None) -> int:
        """
        Description:        Method for computing rent for a set of properties.
        :param dice_roll:   Int value for the overall dice roll.
        :return:            Integer value for rent cost.
        """
        pass

    def compute_group_ownership(self):
        """
        Description:    Method for determining whether all properties of a given
                        type are owned.
        :return:        Return type depends on subclass type.
        """
        pass

    # TODO: Add additional implementation to this when the improvements are also kept track of.
    def compute_worth(self) -> int:
        """
        Description:    Method used to compute the value of a buyable tile by summing up the cost of selling all
                        improvements and mortgaging it.
        :return:        Sum worth of a property.
        """
        improvement_values: int = 0
        # TODO: Update this section with improvement values
        return 0 if self.is_mortaged else self.mortage_price + improvement_values
