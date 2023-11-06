"""
Description:    Test suite for the Deck class.
Author:         Jordan Bourdeau
Date:           11/5/23
"""

from server.game_logic.cards import Card
from server.game_logic.deck import Deck

import unittest


class DeckTests(unittest.TestCase):
    def test_init(self):
        cards: list[Card] = [Card("1"), Card("2"), Card("3"), Card("4")]
        deck: Deck = Deck(cards)
        for card in cards:
            self.assertIn(card, deck.stack)
        self.assertEqual([], deck.discard)

    def test_draw(self):
        cards: list[Card] = [Card("1"), Card("2"), Card("3"), Card("4")]
        deck: Deck = Deck(cards)
        for idx, _ in enumerate(cards):
            card: Card = deck.draw()
            card.deactivate()
            self.assertIn(card, cards)
            self.assertEqual(len(cards) - idx - 1, len(deck.stack))
        # Drawing another card should result in the deck being shuffled and becoming full again
        card: Card = deck.draw()
        self.assertEqual(len(cards) - 1, len(deck.stack))

        # Test
        deck: Deck = Deck([])
        self.assertIsNone(deck.draw())

    def test_shuffle(self):
        cards: list[Card] = [Card("1"), Card("2"), Card("3"), Card("4")]
        deck: Deck = Deck(cards)
        # Empty the stack
        for _ in cards:
            card: Card = deck.stack.pop()
            card.deactivate()
            deck.discard.append(card)
        self.assertEqual(0, len(deck.stack))
        self.assertEqual(len(cards), len(deck.discard))
        # Shuffling deck puts all cards back
        deck._shuffle()
        self.assertEqual(len(cards), len(deck.stack))
        self.assertEqual([], deck.discard)
        # Set some cards to be in use and verify they don't get repopulated
        for idx, _ in enumerate(cards):
            card: Card = deck.stack.pop()
            if idx % 2 == 0:
                card.deactivate()
            deck.discard.append(card)
        self.assertEqual(0, len(deck.stack))
        self.assertEqual(len(cards), len(deck.discard))
        # Shuffling deck puts half the cards back
        deck._shuffle()
        self.assertEqual(len(cards)/2, len(deck.stack))
        self.assertEqual(len(cards)/2, len(deck.discard))

        # Test empty deck
        deck: Deck = Deck([])
        self.assertEqual([], deck.stack)
        self.assertEqual([], deck.discard)
        deck._shuffle()
        self.assertEqual([], deck.stack)
        self.assertEqual([], deck.discard)


if __name__ == '__main__':
    unittest.main()
