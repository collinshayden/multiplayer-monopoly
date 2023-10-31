"""
Description:    Class representing a property tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .asset_tile import AssetTile
from .player import Player
from .constants import RENTS


class PropertyTile(AssetTile):

    def __init__(self, id: int, owner: Player, price: int, is_mortaged: bool, mortage_price: int, group, improvement_cost: int) -> None:
        """
        Description:                Class representing a property tile inheriting from BuyableTile.
                                    Represents monopolies, utilities, and railroads.
        :param id:                  An integer identifier for each tile.
        :param owner:               Player owning the tile.
        :param price:               Price to purchase the property.
        :param is_mortaged:         Boolean for whether the property is mortgaged or not.
        :param mortage_price:       The amount for mortgaging a property.
        :param group:               The group which the property belongs to.
        :param improvement_cost:    The cost of making an improvement.
        :returns:                   None.
        """
        super().__init__(id, owner, price, is_mortaged, mortage_price, group)
        self.rent_map: dict = RENTS[id]
        self.rent: int = self.rent_map[0]
        self.improvements: int = 0
        self.improvement_cost: int = improvement_cost

    
    def update_rent(self, ) -> None:
        pass
        
    
        
    def to_dict(self) -> dict:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        property_dict = {"id": self.id,
            "owner": self.owner,
            "price": self.price,
            "isMortgaged": self.is_mortaged,
            "mortgagePrice": self.mortage_price,
            "group": self.group,
            "rentMap": self.rent_map,
            "rent": self.rent,
            "improvements": self.improvements,
            "improvementCost": self.improvement_cost}
        return property_dict