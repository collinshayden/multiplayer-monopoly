"""
Description:    Class representing a property tile.
Date:           10/18/2023
Author:         Hayden Collins
"""

from .BuyableTile import BuyableTile
from .Player import Player


class PropertyTile(BuyableTile):

    def __init__(self, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group,
                 improvement_rents: dict, improvement_cost: int) -> None:
        """
        Description:                Class representing a property tile inheriting from BuyableTile.
                                    Represents monopolies, utilities, and railroads.
        :param owner:               Player owning the tile.
        :param price:               Price to purchase the property.
        :param is_mortaged:         Boolean for whether the property is mortgaged or not.
        :param mortage_price:       The amount for mortgaging a property.
        :param group:               The group which the property belongs to.
        :param improvement_rents:   A map of the number of improvements to the rent cost.
        :param improvement_cost:    The cost of making an improvement.
        :returns:                   None.
        """
        super().__init__(owner, price, is_mortaged, mortage_price, group)
        self.improvements: int = 0
        self.improvement_rents: dict = improvement_rents
        self.improvement_cost: int = improvement_cost
    
    def compute_rent(self, dice_roll: int = None) -> int:
        """
        Description: Method for computing the rent of a property tile.
        :returns:     Returns the rent cost for the property.
        """
        # Ff player owns all properties of one color, inital rent is doubled when there are no improvements
        if self.compute_group_ownership() and self.improvements == 0:
            return self.improvement_rents[0] * 2
        else:
            return self.improvement_rents[self.improvements]

    def compute_group_ownership(self) -> bool:
        """
        Description:    Method which will determine if all of a single property type
                        are owned in order to assist in the rent calculation.
        :return:        Returns True/False accordingly.
        """
        pass

    def to_dict(self) -> dict:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        pass