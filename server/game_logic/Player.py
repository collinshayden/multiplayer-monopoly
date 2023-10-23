"""
Description:    Class representing the information for a player.
Date:           10/18/2023
Author:         Hayden Collins
"""

from .constants import STARTING_MONEY

class Player:

    def __init__(self, player_id: int, display_name: str) -> None:
        self.player_id = player_id
        self.display_name = display_name
        self.money = STARTING_MONEY
        self.location = 0
        self.doubles_streak = 0
        self.jail_cards = 0
        self.turns_in_jail = 0
        self.active = True
    
    def to_dict(self) -> dict:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        player_dict = {'playerId': self.player_id,
                       'displayName': self.display_name,
                       'money': self.money,
                       'location': self.location,
                       'doublesStreak': self.doubles_streak,
                       'jailCards': self.jail_cards,
                       'turnsInJail': self.turns_in_jail,
                       'active': self.active}
        return player_dict