"""
Description:    Test suite for the Card class representing a chance or community chest card.
Author:         Jordan Bourdeau
Date:           11/5/23
"""

from server.game_logic.cards import Card
from server.game_logic.player_updates import MoneyUpdate

import unittest


class CardTests(unittest.TestCase):
    def test_card(self):
        card: Card = Card("test")
        self.assertEqual(card.description, "test")
        self.assertTrue(card.in_use)
        for _ in range(2):
            card.deactivate()
            self.assertFalse(card.in_use)
        for _ in range(2):
            card.reactivate()
            self.assertTrue(card.in_use)


if __name__ == '__main__':
    unittest.main()
