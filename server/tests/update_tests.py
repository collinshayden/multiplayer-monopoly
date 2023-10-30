"""
Description:    Test suite for the PlayerUpdate objects.
Author:         Jordan Bourdeau
Date:           10/30/23
"""

from ..game_logic.asset_tile import AssetTile
from ..game_logic.constants import JAIL_LOCATION, JAIL_TURNS, STARTING_MONEY
from ..game_logic.player import Player, PlayerStatus
from ..game_logic.player_updates import *

import unittest


class MyTestCase(unittest.TestCase):

    def make_player(self) -> Player:
        id: str = "abcdefghi1234567"
        username: str = "Test"
        player: Player = Player(player_id=id, username=username)
        return player

    def test_move_forward(self):
        player: Player = self.make_player()
        self.assertEqual(0, player.location)
        # Test basic move
        move: MoveUpdate = MoveUpdate(5)
        player.update(move)
        self.assertEqual(5, player.location)
        # Test negative moves
        move = MoveUpdate(-3)
        player.update(move)
        self.assertEqual(2, player.location)
        # Test negative move to see if it wraps back around
        player.update(move)
        self.assertEqual(39, player.location)
        # Test positive move to wrap back around
        move = MoveUpdate(1)
        player.update(move)
        self.assertEqual(0, player.location)

    def test_move_to(self):
        player: Player = self.make_player()
        self.assertEqual(0, player.location)
        # Verify player can move to present location
        location: LocationUpdate = LocationUpdate(0)
        player.update(location)
        self.assertEqual(0, player.location)
        # Verify user can move to final tile
        location = LocationUpdate(39)
        player.update(location)
        self.assertEqual(39, player.location)
        # Verify values > 39 and < 0 do not move the player
        location = LocationUpdate(41)
        player.update(location)
        self.assertEqual(39, player.location)
        location = LocationUpdate(-1)
        player.update(location)
        self.assertEqual(39, player.location)

    def test_roll_dice(self):
        player: Player = self.make_player()
        # Invalid die rolls shouldn't move the player
        player.update(RollUpdate(0, 0))
        self.assertEqual(0, player.location)
        player.update(RollUpdate(7, 7))
        self.assertEqual(0, player.location)
        player.update(RollUpdate(7, 7))
        self.assertEqual(0, player.location)
        player.update(RollUpdate(3, 7))
        self.assertEqual(0, player.location)

        # Will convert doubles to integers with floor
        player.update(RollUpdate(6, 6))
        self.assertEqual(12, player.location)
        self.assertEqual(1, player.doubles_streak)

        # Roll should reset doubles
        player.update(RollUpdate(1, 4))
        self.assertEqual(17, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.doubles_streak)

        # Roll 3 doubles in a row and check for jail condition and doubles streak
        for i in range(2):
            player.update(RollUpdate(1, 1))
        self.assertEqual(2, player.doubles_streak)
        self.assertFalse(player.in_jail)

        # Verify behavior works as expected when player gets sent to jail
        player.update(RollUpdate(1, 1))
        self.assertEqual(0, player.doubles_streak)
        self.assertTrue(player.in_jail)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION, player.location)

        # Verify player can get out of jail with doubles
        player.update(RollUpdate(1, 1))
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION + 2, player.location)
        self.assertEqual(0, player.doubles_streak)

        # Put them back in jail by rolling 3 more doubles
        for i in range(3):
            player.update(RollUpdate(1, 1))
        self.assertEqual(3, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(0, player.doubles_streak)

        # Verify behavior when not rolling doubles in jail
        player.update(RollUpdate(1, 2))
        self.assertTrue(player.in_jail)
        self.assertEqual(2, player.turns_in_jail)
        player.update(RollUpdate(1, 2))
        self.assertTrue(player.in_jail)
        self.assertEqual(1, player.turns_in_jail)

        # After the 3rd roll, they will no longer have any turns left in jail but should still be at the jail location
        player.update(RollUpdate(1, 2))
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)

        # Verify their next roll does in fact move them
        player.update(RollUpdate(1, 2))
        self.assertEqual(JAIL_LOCATION + 3, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)

    def test_go_to_jail(self):
        player: Player = self.make_player()
        self.assertEqual(0, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)

        # Verify player went to jail
        jail: GoToJailUpdate = GoToJailUpdate()
        player.update(jail)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertTrue(player.in_jail)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)

        # Verify player cannot be sent to jail again and nothing has changed
        player.update(jail)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertTrue(player.in_jail)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)

    def test_get_out_of_jail(self):
        player: Player = self.make_player()
        self.assertEqual(0, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)
        # Test when the player is not in jail
        leave_jail: LeaveJailUpdate = LeaveJailUpdate()
        player.update(leave_jail)
        self.assertEqual(0, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)

        # Send player to jail
        player.turns_in_jail = 3
        player.location = JAIL_LOCATION
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertTrue(player.in_jail)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)

        # Free player form jail. Does not move them but will update their status.
        player.update(leave_jail)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)

    def test_update_money(self):
        player: Player = self.make_player()
        # Add money
        money: MoneyUpdate = MoneyUpdate(200)
        self.assertEqual(STARTING_MONEY, player.money)
        player.update(money)
        self.assertEqual(PlayerStatus.GOOD, player.status)
        self.assertEqual(STARTING_MONEY + 200, player.money)
        # Subtract money exactly to 0, verify they are still in GOOD state
        money = MoneyUpdate(-1700)
        player.update(money)
        self.assertEqual(PlayerStatus.GOOD, player.status)
        self.assertEqual(0, player.money)
        # Make them go bankrupt
        money = MoneyUpdate(-1)
        player.update(money)
        self.assertEqual(PlayerStatus.BANKRUPT, player.status)
        self.assertEqual(0, player.money)
        self.assertFalse(player.active)

        # Redo this but give the player a faux-property so they can enter the IN_THE_HOLE state.
        player: Player = self.make_player()
        property: AssetTile = AssetTile(player, 200, False, 100, None)
        player.properties.append(property)
        self.assertEqual(STARTING_MONEY, player.money)
        money = MoneyUpdate(-(STARTING_MONEY + 1))
        player.update(money)
        self.assertEqual(PlayerStatus.IN_THE_HOLE, player.status)
        self.assertEqual(-1, player.money)


if __name__ == '__main__':
    unittest.main()
