"""
Description:    Class representing a Railroad tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .buyable_tile import BuyableTile
from .player import Player


class RailroadTile(BuyableTile):

    def __init__(self, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group) -> None:
        """
        Description:    Class representing a railroad tile.
        :returns:        None.
        """
        super().__init__(owner, price, is_mortaged, mortage_price, group)
        self.rent: int = 25

    def compute_rent(self, dice_roll: int = None) -> int:
        """
        Description:    Method for calculating railroad rent computations.
        :return:        Rent amount.
        """
        return self.rent * self.compute_group_ownership()

    def compute_group_ownership(self) -> int:
        """
        Description:    Method for computing the number of railroads owned to assist
                        with rent calculations.
        :return:        Integer for the number of owned railroads.
        """
        pass

    def to_dict(self) -> dict:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        pass
