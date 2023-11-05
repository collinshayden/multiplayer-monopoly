"""
Description:    Class definition for the Chance and Community Chest card decks
Author:         Aidan Bonner
Date:           11/4/2023
"""

from .card import Card
from random import shuffle


class Deck:
    def __init__(self, stack: list[Card]) -> None:
        """
        Description:    The object representing the deck of cards.
        :param stack:   The list of cards in the deck.
        :returns:       None.
        """
        self.stack: list = stack
        self.discard: list = []
        self.in_use: list = []

    def draw(self) -> Card:
        """
        Description:    Method to draw a single Card from stack
        :returns:       The Card that was drawn
        """
        # Check that every card is not in the discard, refills and shuffles stack if so
        if len(self.stack) == 0:
            self.stack = self.discard
            self.discard = []
            self.__shuffle()
        drawn_card = self.stack.pop(0)
        self.discard.append(drawn_card)
        return drawn_card

    def __shuffle(self) -> None:
        shuffle(self.stack)