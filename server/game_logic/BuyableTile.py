"""
Description:    Class representing a buyable tile.
Date:           10/18/2023
Author:         Hayden Collins
"""
import Player
import Tile

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