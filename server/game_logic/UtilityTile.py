# UtilityTile class
# Created by Hayden Collins 
# 2023/10/18

import BuyableTile, Player

class UtilityTile(BuyableTile):
    def __init__(self, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group) -> None: 
        super().__init__(owner, price, is_mortaged, mortage_price, group)

    # computes rent based on number of other railroads owned
    def computeRent(self, dice_roll: int) -> int:
        if self.computeGroupOwnership():
            return dice_roll * 10
        else:
            return dice_roll * 4
        
    # return number of total railroads owned
    def computeGroupOwnership(self) -> bool:
        pass