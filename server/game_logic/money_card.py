"""
Description:    Class definition for the Street Repairs Card.
Author:         Aidan Bonner
Date:           11/4/2023
"""

from server.game_logic.player import Player
from player_updates import MoneyUpdate


class MoneyCard:

    def __init__(self, text, deck, active: bool, money_delta: int) -> None:
        """
        Description:    Class representing a chance/community chest card.
        :param name:    String value for the description of the card.
        :param update:  The effect of the card
        :param type:    The deck the card belongs to (Chance/Community Chest)
        :returns:       None.
        """
        super.__init__(text, deck, active)
        self.money_delta = money_delta

    def draw(self, owner: Player, players: list[Player]) -> dict:
        return {owner: MoneyUpdate(self.money_delta)}