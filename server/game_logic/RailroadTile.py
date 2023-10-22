"""
Description:    Class representing a Railroad tile.
Date:           10/18/2023
Author:         Hayden Collins
"""

import BuyableTile
import Player


class RailroadTile(BuyableTile):
    def __init__(self, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group) -> None: 
        super().__init__(owner, price, is_mortaged, mortage_price, group)
        self.rent = 25

    # computes rent based on number of other railroads owned
    def compute_rent(self) -> int:
        return self.rent * self.computeGroupOwnership
    
    # return number of total railroads owned
    def compute_group_ownership(self) -> int:
        pass