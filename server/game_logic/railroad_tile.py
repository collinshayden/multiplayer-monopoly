"""
Description:    Class representing a Railroad tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from server.game_logic.asset_tile import AssetTile
from server.game_logic.player import Player
from server.game_logic.types import AssetGroups, RailroadStatus
from server.game_logic.constants import RENTS


class RailroadTile(AssetTile):

    def __init__(self, id: int, name: str, price: int) -> None:
        """
        Description:    Class representing a railroad tile.
        :param id:                  An integer identifier for each tile.
        :param owner:               Player owning the tile.
        :param price:               Price to purchase the property.
        :param is_mortgaged:         Boolean for whether the property is mortgaged or not.
        :param mortage_price:       The amount for mortgaging a property.
        :returns:        None.
        """
        super().__init__(id, name, price, AssetGroups.RAILROAD)
