"""
Description:    Class definition for the Street Repairs Card.
Author:         Aidan Bonner
Date:           11/4/2023
"""

from server.game_logic.player import Player
from player_updates import MoneyUpdate


class EveryoneMoneyCard:

    def __init__(self, text, deck, active: bool, owner: Player, individual_delta: int) -> None:
        """
        Description:    Class representing a chance/community chest card.
        :param name:    String value for the description of the card.
        :param update:  The effect of the card
        :param type:    The deck the card belongs to (Chance/Community Chest)
        :returns:       None.
        """
        super.__init__(text, deck, active, owner)
        self.individual_delta = individual_delta

    def draw(self, owner: Player, players: list[Player]) -> dict:
        owner_delta = self.individual_delta * (len(players) -1) * -1
        deltas_dict = {owner: owner_delta}
        for i in players:
            if i != owner:
                deltas_dict[i] = self.individual_delta
        return deltas_dict
