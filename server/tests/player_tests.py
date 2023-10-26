"""
Description:    Test suite used to verify Player class functionality.
Author:         Jordan Bourdeau
Date:           10/24/23
"""

from ..game_logic.buyable_tile import BuyableTile
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

    def test_roll_dice(self):
        player: Player = self.make_player()
        # Invalid die rolls
        self.assertFalse(player.roll_dice((0, 0)))
        self.assertEqual(0, player.location)
        self.assertFalse(player.roll_dice((7, 7)))
        self.assertEqual(0, player.location)
        self.assertFalse(player.roll_dice((7.5, 7.5)))
        self.assertEqual(0, player.location)

        # Will convert doubles to integers with floor
        self.assertTrue(player.roll_dice((6.5, 6.5)))
        self.assertEqual(12, player.location)
        self.assertEqual(1, player.doubles_streak)

        # Roll should reset doubles
        player.roll_dice((1, 4))
        self.assertEqual(17, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.doubles_streak)

        # Roll 3 doubles in a row and check for jail condition and doubles streak
        self.assertTrue(player.roll_dice((1, 1)))
        self.assertTrue(player.roll_dice((1, 1)))
        self.assertEqual(2, player.doubles_streak)
        self.assertFalse(player.in_jail)

        # Verify behavior works as expected when player gets sent to jail
        self.assertTrue(player.roll_dice((1, 1)))
        self.assertEqual(0, player.doubles_streak)
        self.assertTrue(player.in_jail)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION, player.location)

        # Verify player can get out of jail with doubles
        self.assertTrue(player.roll_dice((1, 1)))
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION + 2, player.location)
        self.assertEqual(1, player.doubles_streak)

        # Put them back in jail by rolling 2 more doubles
        self.assertTrue(player.roll_dice((1, 1)))
        self.assertTrue(player.roll_dice((1, 1)))
        self.assertEqual(3, player.turns_in_jail)

        # Verify behavior when not rolling doubles in jail
        self.assertTrue(player.roll_dice((1, 2)))
        self.assertTrue(player.in_jail)
        self.assertEqual(2, player.turns_in_jail)
        self.assertTrue(player.roll_dice((1, 2)))
        self.assertTrue(player.in_jail)
        self.assertEqual(1, player.turns_in_jail)

        # After the 3rd roll, they will no longer have any turns left in jail but should still be at the jail location
        self.assertTrue(player.roll_dice((1, 2)))
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)

        # Verify their next roll does in fact move them
        self.assertTrue(player.roll_dice((1, 2)))
        self.assertEqual(JAIL_LOCATION + 3, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)

    def test_move_forward(self):
        player: Player = self.make_player()
        # Invalid movements
        self.assertEqual(0, player.location)
        self.assertFalse(player.move_forward(MIN_ROLL - 0.5))
        self.assertFalse(player.move_forward(MIN_ROLL - 1))
        self.assertFalse(player.move_forward(MAX_ROLL + 1))
        self.assertEqual(0, player.location)

        # Test range of valid values and take the player for a lap around the board. Make sure it wraps around.
        player.move_forward(MIN_ROLL)
        self.assertEqual(MIN_ROLL, player.location)
        player.move_forward(MAX_ROLL)
        self.assertEqual(14, player.location)
        player.move_forward(MAX_ROLL)
        self.assertEqual(26, player.location)
        player.move_forward(11)
        self.assertEqual(37, player.location)
        player.move_forward(2)
        self.assertEqual(39, player.location)
        player.move_forward(2)
        self.assertEqual(1, player.location)

    def test_move_to(self):
        player: Player = self.make_player()
        self.assertFalse(player.move_to(-1))
        self.assertEqual(0, player.location)
        self.assertFalse(player.move_to(40))
        self.assertEqual(0, player.location)
        self.assertTrue(player.move_to(39))
        self.assertEqual(39, player.location)
        self.assertTrue(player.move_to(1))
        self.assertEqual(1, player.location)

    def test_go_to_jail(self):
        player: Player = self.make_player()
        self.assertEqual(0, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)

        # Verify player went to jail
        player.go_to_jail()
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertTrue(player.in_jail)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)

        # Verify player cannot be sent to jail again and nothing has changed
        self.assertFalse(player.go_to_jail())
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertTrue(player.in_jail)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)

    def test_get_out_of_jail(self):
        player: Player = self.make_player()
        # Test when the player is not in jail
        self.assertFalse(player.get_out_of_jail())

        # Send player to jail
        player.go_to_jail()
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertTrue(player.in_jail)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)

        # Free player form jail. Does not move them but will update their status.
        self.assertTrue(player.get_out_of_jail())
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)

    def test_end_turn(self):
        player: Player = self.make_player()
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(PlayerStatus.GOOD, player.end_turn())
        self.assertEqual(0, player.turns_in_jail)
        player.go_to_jail()
        self.assertEqual(PlayerStatus.GOOD, player.end_turn())
        self.assertEqual(2, player.turns_in_jail)
        self.assertEqual(PlayerStatus.GOOD, player.end_turn())
        self.assertEqual(1, player.turns_in_jail)
        self.assertEqual(PlayerStatus.GOOD, player.end_turn())
        self.assertEqual(0, player.turns_in_jail)

    def test_update_money(self):
        player: Player = self.make_player()
        # Knock a player out when they don't have enough money
        self.assertEqual(STARTING_MONEY, player.money)
        self.assertEqual(PlayerStatus.GOOD, player.update_money(200))
        self.assertEqual(STARTING_MONEY + 200, player.money)
        self.assertEqual(PlayerStatus.GOOD, player.update_money(-1700))
        self.assertEqual(0, player.money)
        self.assertEqual(PlayerStatus.BANKRUPT, player.update_money(-1))
        self.assertEqual(0, player.money)
        self.assertFalse(player.active)

        # Redo this but give the player a faux-property so they can enter the IN_THE_HOLE state.
        player: Player = self.make_player()
        property: BuyableTile = BuyableTile(player, 200, False, 100, None)
        player.properties.append(property)
        self.assertEqual(STARTING_MONEY, player.money)
        self.assertEqual(PlayerStatus.IN_THE_HOLE, player.update_money(-(STARTING_MONEY + 1)))
        self.assertEqual(-1, player.money)

    def test_calculate_net_worth(self):
        player: Player = self.make_player()
        self.assertEqual(STARTING_MONEY, player.calculate_net_worth())
        property: BuyableTile = BuyableTile(player, 200, False, 100, None)
        player.properties.append(property)
        self.assertEqual(STARTING_MONEY + 100, player.calculate_net_worth())
        property.is_mortaged = True
        self.assertEqual(STARTING_MONEY, player.calculate_net_worth())


if __name__ == '__main__':
    unittest.main()
