"""
Description:    Class representing a utility tile.
Date:           10/18/2023
Author:         Hayden Collins
"""

from .BuyableTile import BuyableTile
from .Player import Player


class UtilityTile(BuyableTile):

    def __init__(self, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group) -> None:
        """
        Description:    Class representing the two utility tiles.
        :returns:       None.
        """
        super().__init__(owner, price, is_mortaged, mortage_price, group)

    def compute_rent(self, dice_roll: int = None) -> int:
        """
        Description:        Method used to compute rent based on a dice roll.
        :param dice_roll:   Integer value for the sum of the die roll.
        :return:            Computed rent cost.
        """
        if self.compute_group_ownership():
            return dice_roll * 10
        else:
            return dice_roll * 4

    def compute_group_ownership(self) -> bool:
        """
        Description:    Method to compute whether both utility tiles are owned.
        :return:        True/False if all utility tiles are owned.
        """
        pass

    def to_dict(self) -> dict:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        pass
