"""
Description:    Class representing a utility tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from server.game_logic.asset_tile import AssetTile
from server.game_logic.player import Player
from server.game_logic.types import AssetGroups
from server.game_logic.constants import RENTS


class UtilityTile(AssetTile):

    def __init__(self, id: int, owner: Player, price: int, is_mortaged: bool, mortage_price: int) -> None:
        """
        Description:    Class representing the two utility tiles.
        :returns:       None.
        """
        super().__init__(id, owner, price, is_mortaged, mortage_price, AssetGroups.UTILITY)

    def to_dict(self) -> dict:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        utility_dict = {"id": self.id,
                        "owner": self.owner,
                        "price": self.price,
                        "isMortgaged": self.is_mortaged,
                        "mortgagePrice": self.mortgage_price,
                        "rentMap": self.rent_map,
                        "rentMultiplier": self.rent_multiplier}
        return utility_dict
