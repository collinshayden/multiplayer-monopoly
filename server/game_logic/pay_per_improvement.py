"""
Description:    Class definition for the Street Repairs Card.
Author:         Aidan Bonner
Date:           11/4/2023
"""

from server.game_logic.player import Player
from player_updates import MoneyUpdate


class PerImprovementCard:

    def __init__(self, text, deck, active: bool, house_amount: int, hotel_amount: int) -> None:
        """
        Description:    Class representing a chance/community chest card.
        :param text:    String value for the description of the card.
        :param update:  The effect of the card
        :param type:    The deck the card belongs to (Chance/Community Chest)
        :returns:       None.
        """
        super.__init__(text, deck, active)
        self.house_amount: int = house_amount
        self.hotel_amount: int = hotel_amount

    def draw(self, owner: Player, players: list[Player]) -> dict:
        house_num = 0
        hotel_num = 0
        for i in owner.assets:
            if i.improvements > 0 and i.improvements != 5:
                house_num += 1
            elif i.improvements == 5:
                hotel_num += 1
        update_amount = house_num * self.house_amount + hotel_num * self.hotel_amount
        return {owner: MoneyUpdate(update_amount)}
