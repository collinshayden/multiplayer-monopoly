"""
Description:    Class representing a buyable tile.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .constants import IMPROVEMENT_MAP, RENTS
from .player import Player
from .tile import Tile
from .types import AssetGroups, PropertyStatus, RailroadStatus, UtilityStatus

from typing import Union


class AssetTile(Tile):

    def __init__(self, id: int, price: int, group: AssetGroups) -> None:
        """
        Description:            Class representing a tile which can be bought.
        :param id:              Tile ID
        :param price:           Price to buy the tile.
        :param group:           The group which the AssetTile is a part of.
        """
        super().__init__(id=id)
        self.price: int = price
        self.group: AssetGroups = group

        # Default values here
        self.owner: Player = None
        self.is_mortgaged: bool = False
        self.mortage_price: int = int(price / 2)

        self.status: Union[PropertyStatus, RailroadStatus, UtilityStatus]
        match group:
            case AssetGroups.UTILITY:
                self.status = UtilityStatus.NO_MONOPOLY
            case AssetGroups.RAILROAD:
                self.status = RailroadStatus.UNOWNED
            case _:
                self.status = PropertyStatus.NO_MONOPOLY

    @property
    def rent(self) -> int:
        """
        Description:    Property which will compute the rent based on the rent map and property status.
        :return:        Returns integer value for rent or -1 if it could not be computed.
        """
        # No rent if the tile is unowned or mortgaged.
        if self.is_mortgaged or self.owner is None:
            return 0
        # Otherwise, look up the cost in the rent map based on the number in the owner's list of assets.
        else:
            rent: dict = (RENTS.get(self.id, False))
            if rent is not None:
                rent = rent.get(self.status)
            return rent if rent is not None else -1

    @property
    def liquid_value(self) -> int:
        # TODO overwrite in property subclass
        """
        Description:    Returns the value of the property
        :return:        int value representing how much money the property is worth
        """
        return 0 if self.is_mortgaged else self.mortage_price

    @property
    def lift_mortage_cost(self) -> int:
        """
        Description:    Returns how much it costs to lift the mortage of a mortaged property
        :return:        int value of original mortage cost + 10%
        """
        return round(self.mortage_price * 1.1)

    # Simple interface methods to mortgage/unmortgage the property

    def mortgage(self):
        self.is_mortgaged = True

    def unmortgage(self):
        self.is_mortgaged = False
