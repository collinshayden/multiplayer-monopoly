"""
Description:    Class representing the information for a player.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .constants import JAIL_LOCATION, JAIL_TURNS, MAX_ROLL, MIN_ROLL, NUM_TILES, STARTING_MONEY, START_LOCATION
from .types import PlayerStatus

from random import randint


class Player:
    def __init__(self, player_id: str, username: str) -> None:
        from .asset_tile import AssetTile
        """
        Description:            Class representing a Player.
        :param player_id:       Unique 16-character ID generated from Game class
        :param username:    Display name/username
        """
        self.player_id: str = player_id
        self.username: str = username

        # State variables
        self.properties: list[AssetTile] = []
        self.money: int = STARTING_MONEY
        self.location: int = START_LOCATION
        self.doubles_streak: int = 0
        self.jail_cards: int = 0
        self.turns_in_jail: int = 0
        self.status: PlayerStatus = PlayerStatus.GOOD

    @property
    def in_jail(self) -> bool:
        """
        Description:    Return whether the user is in jail.
        :return:        Boolean value for if the user has remaining turns in jail
        """
        return self.turns_in_jail > 0

    @property
    def active(self) -> bool:
        """
        Description:    Return whether the current player status != PlayerStatus.BANKRUPT
        :return:        True/False.
        """
        return self.status not in [PlayerStatus.BANKRUPT, PlayerStatus.INVALID]

    @property
    def net_worth(self) -> int:
        """
        Description:    Method used to calculate the net worth of a player based on the sum of:
                            1) Current money
                            2) Selling improvements
                            3) Mortgaging properties
        :return:        Final dollar amount for a player's net worth.
        """
        property_values: int = 0
        for property in self.properties:
            property_values += property.liquid_value
        return self.money + property_values

    def update(self, update) -> PlayerStatus:
        """
        Description:    Method taking in a PlayerUpdate object and calling its update() method on self.
        :param update:  The PlayerUpdate whose update() method will be called.
        :return:        Updated PlayeStatus.
        """
        update.update(self)
        return self.status
    
    def to_dict(self) -> dict:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        player_dict = {"displayName": self.username,
                       "money": self.money,
                       "location": self.location,
                       "doublesStreak": self.doubles_streak,
                       "jailCards": self.jail_cards,
                       "turnsInJail": self.turns_in_jail,
                       "active": self.active}
        return player_dict
