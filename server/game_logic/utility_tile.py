"""
Description:    Class representing a utility tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .asset_tile import AssetTile
from .player import Player
from .types import AssetGroups


class UtilityTile(AssetTile):

    def __init__(self, id: int, owner: Player, price: int, is_mortgaged: bool, mortage_price: int) -> None:
        """
        Description:    Class representing the two utility tiles.
        :returns:       None.
        """
        super().__init__(id, owner, price, is_mortgaged, mortage_price, AssetGroups.UTILITY)

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
        utility_dict = {"id": self.id,
                        "owner": self.owner,
                        "price": self.price,
                        "isMortgaged": self.is_mortgaged,
                        "mortgagePrice": self.mortgage_price}
        return utility_dict
