"""
Description:    Class representing a property tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .asset_tile import AssetTile
from .constants import IMPROVEMENT_MAP
from .types import AssetGroups


class ImprovableTile(AssetTile):

    def __init__(self, id: int, price: int, group: AssetGroups) -> None:
        """
        Description:                Class representing a property tile inheriting from AssetTile which can be upgraded.
        :param id:                  An integer identifier for each tile.
        :param price:               Price to purchase the property.
        :param group:               The group which the property belongs to.
        :returns:                   None.
        """
        super().__init__(id, price, group)

    @property
    def improvement_cost(self) -> int:
        """
        Description:    Computed property which looks at the improvement cost lookup table.
        :return:        Integer value for the cost to improve a property.
        """
        return IMPROVEMENT_MAP[self.group]
        
    def to_dict(self) -> dict:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        property_dict = {"id": self.id,
            "owner": self.owner,
            "price": self.price,
            "isMortgaged": self.is_mortgaged,
            "mortgagePrice": self.mortage_price,
            "group": self.group,
            "rentMap": self.rent_map,
            "rent": self.rent,
            "improvements": self.improvements,
            "improvementCost": self.improvement_cost}
        return property_dict