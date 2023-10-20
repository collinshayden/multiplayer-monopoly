"""
Description:    Class representing a utility tile.
Date:           10/18/2023
Author:         Hayden Collins
"""

import BuyableTile, Player

class UtilityTile(BuyableTile):
    def __init__(self, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group) -> None: 
        super().__init__(owner, price, is_mortaged, mortage_price, group)

    # computes rent based on number of other railroads owned
    def compute_rent(self, dice_roll: int) -> int:
        if self.computeGroupOwnership():
            return dice_roll * 10
        else:
            return dice_roll * 4
        
    # return number of total railroads owned
    def compute_group_ownership(self) -> bool:
        pass