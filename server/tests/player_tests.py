"""
Description:    Test suite used to verify Player class functionality.
Author:         Jordan Bourdeau
Date:           10/24/23
"""

from ..game_logic.asset_tile import AssetTile
from ..game_logic.constants import JAIL_LOCATION, JAIL_TURNS, MAX_ROLL, MIN_ROLL, STARTING_MONEY
from ..game_logic.player import Player
from ..game_logic.types import PlayerStatus

import unittest


class MyTestCase(unittest.TestCase):

    def make_player(self) -> Player:
        id: str = "abcdefghi1234567"
        username: str = "Test"
        player: Player = Player(player_id=id, username=username)
        return player

    def test_in_jail(self):
        player: Player = self.make_player()
        self.assertFalse(player.in_jail)
        player.turns_in_jail = 1
        self.assertTrue(player.in_jail)

    def test_active(self):
        player: Player = self.make_player()
        self.assertTrue(player.active)
        player.status = PlayerStatus.BANKRUPT
        self.assertFalse(player.active)
        player.status = PlayerStatus.IN_THE_HOLE
        self.assertTrue(player.active)
        player.status = PlayerStatus.INVALID
        self.assertFalse(player.active)

    def test_calculate_net_worth(self):
        player: Player = self.make_player()
        self.assertEqual(STARTING_MONEY, player.net_worth)
        property: AssetTile = AssetTile(player, 200, False, 100, None)
        player.properties.append(property)
        self.assertEqual(STARTING_MONEY + 100, player.net_worth)
        property.is_mortaged = True
        self.assertEqual(STARTING_MONEY, player.net_worth)


if __name__ == '__main__':
    unittest.main()
