"""
Description:    Class representing a deck of chance/community chest cards.
Author:         Jordan Bourdeau
Date:           11/5/23
"""

from .cards import Card

import random

class Deck:
    def __init__(self, cards: list[Card]) -> None:
        # Perform shallow copy of list to not affect input list but keep reference to the elements
        self.stack: list[Card] = [card for card in cards]
        random.shuffle(self.stack)
        self.discard: list[Card] = []

    def peek(self) -> Card:
        """
        Description:    Method used to peek at the top card of the deck without drawing it. Will reshuffle the deck
                        if needed.
        :return:        Card object.
        """
        if len(self.stack) == 0:
            self._shuffle()
        # All cards are in use. Return None.
        if len(self.stack) == 0:
            return
        return self.stack[-1]

    def draw(self) -> Card:
        """
        Description:    Method used to retrieve the top Card object from the stack.
        :return:        Card object.
        """
        if len(self.stack) == 0:
            self._shuffle()
        # All cards are in use. Return None.
        if len(self.stack) == 0:
            return
        card: Card = self.stack.pop()
        self.discard.append(card)
        return card

    def _shuffle(self):
        """
        Description:    Private method used to shuffle all the cards back into the deck.
                        Performs garbage collection on any in-use cards (Jail cards) as well.
        :return:        None.
        """
        used_cards: list[Card] = []
        in_use: list[Card] = []
        # Check for any cards within the `in_use` pile and add them back in if they have been used
        for card in self.discard:
            if card.in_use:
                in_use.append(card)
            else:
                used_cards.append(card)
                card.reactivate()
        self.stack = used_cards
        self.discard = in_use
        random.shuffle(self.stack)

