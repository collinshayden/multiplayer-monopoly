"""
Description:    Class representing a property tile.
Date:           10/18/2023
Author:         Hayden Collins
"""

import BuyableTile
import Player

class PropertyTile(BuyableTile):
    def __init__(self, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group,
                 improvementToRentAmount: dict, housePurchasePrice: int) -> None:
        super().__init__(owner, price, is_mortaged, mortage_price, group)
        self.improvements = 0
        self.improvementToRentAmount = improvementToRentAmount
        self.housePurchasePrice = housePurchasePrice
    
    def compute_rent(self) -> int:
        # if player owns all properties of one color, inital rent is doubled when there are no improvements
        if self.computeGroupOwnership() and self.improvements == 0:
            return self.improvementToRentAmount[0] * 2
        else:
            return self.improvementToRentAmount[self.improvements]

    def compute_group_ownership(self) -> bool:
        pass