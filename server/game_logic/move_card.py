"""
Description:    Class definition for the Street Repairs Card.
Author:         Aidan Bonner
Date:           11/4/2023
"""

from server.game_logic.player import Player
from player_updates import MoveUpdate


class MoveCard:

    def __init__(self, text, deck, active: bool, new_position: int, delta: bool) -> None:
        """
        Description:    Class representing a chance/community chest card.
        :param name:    String value for the description of the card.
        :param update:  The effect of the card
        :param type:    The deck the card belongs to (Chance/Community Chest)
        :returns:       None.
        """
        super.__init__(text, deck, active)
        self.new_position: int = new_position
        self.delta: bool = delta

    def draw(self, owner: Player, players: list[Player]) -> dict:
        return {owner: MoveUpdate(self.new_position if not self.delta else owner.location + self.new_position)}