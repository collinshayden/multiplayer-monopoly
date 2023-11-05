"""
Description:    Class definition for a Card.
Author:         Jordan Bourdeau
Date:           10/22/2023
"""

from .player import Player
from .player_updates import PlayerUpdate


class Card:

    def __init__(self, text: str, deck, delta: int) -> None:
        """
        Description:    Class representing a chance/community chest card.
        :param text:    String value for the description of the card.
        :param deck:    The deck (community chest/chance) that the card belongs to.
        :param active:  Whether the card is currently in play
        :param owner:   The owner of a card (only for get out fo jail free cards).
        :returns:       None.
        """
        self.name: str = text
        self.deck = deck
        self.delta = delta
        self.in_deck = True

    def draw(self, owner: Player, players: list[Player]) -> dict:
        self.in_deck = False
        return{owner: PlayerUpdate(self.delta)}