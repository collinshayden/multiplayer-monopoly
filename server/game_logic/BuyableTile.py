# BuyableTile class
# Created by Hayden Collins 
# 2023/10/18
import Player, Tile

class BuyableTile(Tile):
    def __init__(self, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group) -> None:
        self.owner = owner
        self.price = price
        self.is_mortaged = is_mortaged
        self.mortage_price = mortage_price
        self.group = group

    def computeRent():
        pass

    def computeGroupOwnership():
        pass