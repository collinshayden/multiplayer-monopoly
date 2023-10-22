"""
Description:    Class representing the information for a player.
Date:           10/18/2023
Author:         Hayden Collins
"""

class Player:
    def __init__(self, player_id: int, display_name: str) -> None:
        self.player_id = player_id
        self.display_name = display_name
        self.money = 1500
        self.location = 0
        self.doubles_streaks = 0
        self.jail_cards = 0
        self.turns_in_jail = 0
    