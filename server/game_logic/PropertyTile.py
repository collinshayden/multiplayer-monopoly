# PropertyTile class
# Created by Hayden Collins 
# 2023/10/18

import BuyableTile, Player

class PropertyTile(BuyableTile):
    def __init__(self, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group,     improvementToRentAmount: dict, housePurchasePrice: int) -> None:
        super().__init__(owner, price, is_mortaged, mortage_price, group)
        self.improvements = 0
        self.improvementToRentAmount = improvementToRentAmount
        self.housePurchasePrice = housePurchasePrice
    
    def computeRent(self) -> int:
        # if player owns all properties of one color, inital rent is doubled when there are no improvements
        if self.computeGroupOwnership() and self.improvements == 0:
            return self.improvementToRentAmount[0] * 2
        else:
            return self.improvementToRentAmount[self.improvements]

    def computeGroupOwnership() -> bool:
        pass