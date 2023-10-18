# RailroadTile class
# Created by Hayden Collins 
# 2023/10/18

import BuyableTile, Player

class RailroadTile(BuyableTile):
    def __init__(self, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group) -> None: 
        super().__init__(owner, price, is_mortaged, mortage_price, group)
        self.rent = 25

    # computes rent based on number of other railroads owned
    def computeRent(self) -> int:
        return self.rent * self.computeGroupOwnership
    
    # return number of total railroads owned
    def computeGroupOwnership(self) -> int:
        pass