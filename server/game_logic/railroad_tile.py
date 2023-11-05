"""
Description:    Class representing a Railroad tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .asset_tile import AssetTile
from .types import AssetGroups, RailroadStatus
from .constants import RAILROAD_COST

from typing import Any


class RailroadTile(AssetTile):

    def __init__(self, id: int, name: str) -> None:
        """
        Description:    Class representing a railroad tile.
        :param id:      An integer identifier for each tile.
        :param name:    Railroad name
        :returns:       None.
        """
        super().__init__(id, name, RAILROAD_COST, AssetGroups.RAILROAD)
