"""
Description:    Class representing a property tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from server.game_logic.asset_tile import AssetTile
from server.game_logic.constants import IMPROVEMENT_MAP
from server.game_logic.types import AssetGroups, PropertyStatus


class ImprovableTile(AssetTile):

    def __init__(self, id: int, name: str, price: int, group: AssetGroups) -> None:
        """
        Description:                Class representing a property tile inheriting from AssetTile which can be upgraded.
        :param id:                  An integer identifier for each tile.
        :param price:               Price to purchase the property.
        :param group:               The group which the property belongs to.
        :returns:                   None.
        """
        super().__init__(id, name, price, group)

    @property
    def improvement_cost(self) -> int:
        """
        Description:    Computed property which looks at the improvement cost lookup table.
        :return:        Integer value for the cost to improve a property.
        """
        return IMPROVEMENT_MAP[self.group]

    @property
    def liquid_value(self) -> int:
        """
        Description:    Returns the value of the property if all improvements were sold and it was mortgaged.
        :return:        int value representing how much money the property is worth
        """
        if self.is_mortgaged:
            return 0
        total_worth: int = self.mortage_price
        total_worth += max(0, self.status - PropertyStatus.MONOPOLY) * self.improvement_cost/2
        return total_worth
