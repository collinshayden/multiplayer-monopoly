"""
Description:    Test suite for the PlayerUpdate objects.
Author:         Jordan Bourdeau
Date:           10/30/23
"""

from server.game_logic.asset_tile import AssetTile
from server.game_logic.constants import JAIL_LOCATION, JAIL_TURNS, STARTING_MONEY
from server.game_logic.player import Player, PlayerStatus
from server.game_logic.player_updates import *
from server.game_logic.tile import Tile
from server.game_logic.types import AssetGroups

import unittest


class UpdateTests(unittest.TestCase):

    def make_player(self) -> Player:
        id: str = "abcdefghi1234567"
        display_name: str = "Test"
        player: Player = Player(id=id, display_name=display_name)
        return player

    def test_buy_update(self):
        player: Player = self.make_player()
        # These assets correspond to the oranges on the original Monopoly board
        st_james: ImprovableTile = ImprovableTile(id=16, name="St. James Place", price=180, group=AssetGroups.ORANGE)
        ten_ave: ImprovableTile = ImprovableTile(id=18, name="Tennessee Ave", price=180, group=AssetGroups.ORANGE)
        ny_ave: ImprovableTile = ImprovableTile(id=19, name="New York Avenue", price=200, group=AssetGroups.ORANGE)
        assets: list = [st_james, ten_ave, ny_ave]
        # Properties are unowned, so they currently have a rent of 0
        for asset in assets:
            self.assertEqual(0, asset.rent)

        # Pre-Monopoly rents
        for asset in assets[:2]:
            starting_money: int = player.money
            self.assertIsNone(asset.owner)
            # Verify buying an asset will update the asset's owner and decrement the player's money.
            player.update(BuyUpdate(asset))
            self.assertEqual(player, asset.owner)
            self.assertEqual(starting_money - asset.price, player.money)
            self.assertIn(asset, player.assets)
            self.assertEqual(14, asset.rent)
        player.update(BuyUpdate(ny_ave))
        for asset in assets:
            self.assertEqual(PropertyStatus.MONOPOLY, asset.status)
        # Post-Monopoly rents
        self.assertEqual(14 * 2, st_james.rent)
        self.assertEqual(14 * 2, ten_ave.rent)
        self.assertEqual(16 * 2, ny_ave.rent)

        # Test with utility tiles
        electric_company: AssetTile = AssetTile(id=12, name="Electric Company", price=150, group=AssetGroups.UTILITY)
        water_works: AssetTile = AssetTile(id=28, name="Water Works", price=150, group=AssetGroups.UTILITY)
        # Buy electric company
        starting_money = player.money
        player.update(BuyUpdate(electric_company))
        self.assertEqual(player, electric_company.owner)
        self.assertEqual(starting_money - electric_company.price, player.money)
        self.assertIn(electric_company, player.assets)
        self.assertEqual(UtilityStatus.NO_MONOPOLY, electric_company.status)
        self.assertEqual(4, electric_company.rent)  # Utility rent multiplier is stored as rent
        # Buy Water Works
        starting_money = player.money
        player.update(BuyUpdate(water_works))
        self.assertEqual(player, water_works.owner)
        self.assertEqual(starting_money - water_works.price, player.money)
        self.assertIn(water_works, player.assets)
        self.assertEqual(UtilityStatus.MONOPOLY, water_works.status)
        self.assertEqual(UtilityStatus.MONOPOLY, electric_company.status)
        self.assertEqual(10, water_works.rent)  # Utility rent multiplier is stored as rent
        self.assertEqual(10, electric_company.rent)  # Utility rent multiplier is stored as rent

        # Test with railroad tiles
        reading: AssetTile = AssetTile(id=5, name="Reading Railroad", price=200, group=AssetGroups.RAILROAD)
        pennsylvania: AssetTile = AssetTile(id=15, name="Pennsylvania Railroad", price=200, group=AssetGroups.RAILROAD)
        bno: AssetTile = AssetTile(id=25, name="B&O Railroad", price=200, group=AssetGroups.RAILROAD)
        short_line: AssetTile = AssetTile(id=35, name="Short Line Railroad", price=200, group=AssetGroups.RAILROAD)
        # Player needs some more money to buy these tiles
        player.money = STARTING_MONEY
        for idx, railroad in enumerate([reading, pennsylvania, bno, short_line]):
            self.assertEqual(RailroadStatus.UNOWNED, railroad.status)
            self.assertEqual(0, railroad.rent)
            self.assertIsNone(railroad.owner)
            starting_money = player.money
            player.update(BuyUpdate(railroad))
            self.assertEqual(player, railroad.owner)
            self.assertEqual(starting_money - railroad.price, player.money)
            self.assertIn(railroad, player.assets)
            self.assertEqual(RailroadStatus(idx + 1), railroad.status)
            self.assertEqual(25 * 2**idx, railroad.rent)

        # Verify nothing happens if you try to buy a non-asset tile
        tile: Tile = Tile(id=0, name="Test")
        player.update(BuyUpdate(tile))
        self.assertEqual(0, tile.id)
        self.assertEqual("Test", tile.name)
        self.assertNotIn(tile, player.assets)

        # Verify nothing happens if you try to buy a tile which is too expensive
        starting_money = player.money
        expensive: AssetTile = AssetTile(id=39, name="Super Boardwalk", price=4000, group=AssetGroups.DARK_BLUE)
        self.assertIsNone(expensive.owner)
        self.assertNotIn(expensive, player.assets)
        self.assertEqual(starting_money, player.money)
        player.update(BuyUpdate(expensive))
        self.assertIsNone(expensive.owner)
        self.assertNotIn(expensive, player.assets)
        self.assertEqual(starting_money, player.money)

    def test_improvement_update(self):
        player: Player = self.make_player()
        # Improvable tiles
        st_james: ImprovableTile = ImprovableTile(id=16, name="St. James Place", price=180, group=AssetGroups.ORANGE)
        ten_ave: ImprovableTile = ImprovableTile(id=18, name="Tennessee Ave", price=180, group=AssetGroups.ORANGE)
        ny_ave: ImprovableTile = ImprovableTile(id=19, name="New York Avenue", price=200, group=AssetGroups.ORANGE)
        # Non-improvable tile monopolies
        reading = AssetTile(id=5, name="Reading Railroad", price=200, group=AssetGroups.RAILROAD)
        pennsylvania = AssetTile(id=15, name="Pennsylvania Railroad", price=200, group=AssetGroups.RAILROAD)
        bno = AssetTile(id=25, name="B&O Railroad", price=200, group=AssetGroups.RAILROAD)
        short_line = AssetTile(id=35, name="Short Line Railroad", price=200, group=AssetGroups.RAILROAD)

        electric_company: AssetTile = AssetTile(id=12, name="Electric Company", price=150, group=AssetGroups.UTILITY)
        water_works: AssetTile = AssetTile(id=28, name="Water Works", price=150, group=AssetGroups.UTILITY)

        # Try updating tiles the player doesn't own. Nothing happens.
        for idx, asset in enumerate([st_james, ten_ave,
                                     reading, pennsylvania, bno, short_line,
                                     electric_company, water_works]):
            # self.assertEqual(STARTING_MONEY, player.money)
            self.assertEqual(idx, len(player.assets))
            self.assertIsNone(asset.owner)
            player.update(ImprovementUpdate(asset, 1))
            if isinstance(asset, ImprovableTile):
                self.assertEqual(PropertyStatus.NO_MONOPOLY, asset.status)
            self.assertEqual(STARTING_MONEY, player.money)
            self.assertEqual(idx, len(player.assets))
            self.assertIsNone(asset.owner)
            # Give the player ownership and verify they still cannot improve
            player.update(BuyUpdate(asset))
            player.money += asset.price

        # Have the player "buy" the property (so it will update status accordingly).
        player.update(BuyUpdate(ny_ave))
        player.money += ny_ave.price

        # Verify the player cannot perform any out-of-bounds or 0 updates to number of improvements
        monopoly: list[ImprovableTile] = [st_james, ten_ave, ny_ave]
        for delta in [-6, -5, -1, 0, 6, 7]:
            for asset in monopoly:
                player.update(ImprovementUpdate(ny_ave, delta))
                self.assertEqual(STARTING_MONEY, player.money)
                self.assertEqual(PropertyStatus.MONOPOLY, asset.status)

        improvement_cost: int = 100     # For quick reference in this section
        # Verify 1 improvement can be made on a property, and it doesn't change the others
        player.update(ImprovementUpdate(ny_ave, 1))
        self.assertEqual(STARTING_MONEY - improvement_cost, player.money)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, ny_ave.status)
        self.assertEqual(PropertyStatus.MONOPOLY, st_james.status)
        self.assertEqual(PropertyStatus.MONOPOLY, ten_ave.status)

        # Verify trying to make a second improvement on a property will also upgrade the others by 1
        player.update(ImprovementUpdate(ny_ave, 1))
        self.assertEqual(STARTING_MONEY - 4 * improvement_cost, player.money)
        self.assertEqual(PropertyStatus.TWO_IMPROVEMENTS, ny_ave.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, st_james.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, ten_ave.status)

        # Verify the player cannot buy a hotel since it would cost too much money to upgrade everything
        player.money = 800
        player.update(ImprovementUpdate(ny_ave, 3))
        self.assertEqual(800, player.money)
        self.assertEqual(PropertyStatus.TWO_IMPROVEMENTS, ny_ave.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, st_james.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, ten_ave.status)
        # Reset player money
        player.money = STARTING_MONEY

        # Verify trying to sell one of the properties with 1 upgrade causes the one with 2 to sell an improvement
        player.update(ImprovementUpdate(st_james, -1))
        # Player sold 2 houses worth 100 each and get 50% back, so they recoup the original cost of 1 house
        self.assertEqual(STARTING_MONEY + improvement_cost, player.money)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, ny_ave.status)
        self.assertEqual(PropertyStatus.MONOPOLY, st_james.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, ten_ave.status)

        # Verify all improvements can be sold, and that 1/2 the improvement cost is regained for each one sold.
        player.update(ImprovementUpdate(ny_ave, -1))
        self.assertEqual(PropertyStatus.MONOPOLY, ny_ave.status)
        self.assertEqual(PropertyStatus.MONOPOLY, st_james.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, ten_ave.status)
        player.update(ImprovementUpdate(ten_ave, -1))
        for asset in [ny_ave, st_james, ten_ave]:
            self.assertEqual(PropertyStatus.MONOPOLY, asset.status)
        # Sell 2 more houses => recoup the price of another original house
        self.assertEqual(STARTING_MONEY + 2 * improvement_cost, player.money)

        # Verify buying 5 improvements on one property causes the other to be upgraded to 4.
        total_cost: int = (5 + 4 + 4) * improvement_cost
        player.money = total_cost
        player.update(ImprovementUpdate(ny_ave, 5))
        self.assertEqual(0, player.money)
        self.assertEqual(PropertyStatus.FIVE_IMPROVEMENTS, ny_ave.status)
        self.assertEqual(PropertyStatus.FOUR_IMPROVEMENTS, st_james.status)
        self.assertEqual(PropertyStatus.FOUR_IMPROVEMENTS, ten_ave.status)
        # Verify selling 5 improvements causes the other to be downgraded to 1 each.
        player.update(ImprovementUpdate(ny_ave, -5))
        self.assertEqual(PropertyStatus.MONOPOLY, ny_ave.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, st_james.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, ten_ave.status)
        # Sold 5 + 3 + 3 = 11 houses = Money should be 11 * 100 / 2 = 550
        self.assertEqual(550, player.money)
        # Try selling another house, verify nothing happens
        player.update((ImprovementUpdate(ny_ave, -1)))
        self.assertEqual(PropertyStatus.MONOPOLY, ny_ave.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, st_james.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, ten_ave.status)
        # Sold 5 + 3 + 3 = 11 houses = Money should be 11 * 100 / 2 = 550
        self.assertEqual(550, player.money)

        player.update((ImprovementUpdate(st_james, -1)))
        player.update((ImprovementUpdate(ten_ave, -1)))
        for asset in [st_james, ten_ave, ny_ave]:
            self.assertEqual(PropertyStatus.MONOPOLY, asset.status)
        self.assertEqual(650, player.money)

    def test_mortgage_update(self):
        # Make the player and given them an AssetTile
        player: Player = self.make_player()
        asset: AssetTile = AssetTile(id=0, name="Test", price=200, group=AssetGroups.ORANGE)
        asset.owner = player
        player.assets.append(asset)

        self.assertFalse(asset.is_mortgaged)
        self.assertEqual(STARTING_MONEY, player.money)
        self.assertEqual(STARTING_MONEY + 100, player.net_worth)

        # Verify setting flag to False doesn't change anything
        player.update(MortgageUpdate(asset, False))
        self.assertFalse(asset.is_mortgaged)
        self.assertEqual(STARTING_MONEY, player.money)
        self.assertEqual(STARTING_MONEY + 100, player.net_worth)

        # Set flag to True and verify player's money increases and property becomes mortgaged.
        for _ in range(2):  # Run 2 times to verify nothing happens to already mortgaged property
            player.update(MortgageUpdate(asset, True))
            self.assertTrue(asset.is_mortgaged)
            self.assertEqual(STARTING_MONEY + 100, player.money)
            self.assertEqual(STARTING_MONEY + 100, player.net_worth)

        # Verify unmortgaging a property takes 110% of the original mortgage price
        for _ in range(2):  # Run 2 times to verify nothing happens to already unmortgaged property
            player.update(MortgageUpdate(asset, False))
            self.assertFalse(asset.is_mortgaged)
            self.assertEqual(STARTING_MONEY - 10, player.money)
            self.assertEqual(STARTING_MONEY + 90, player.net_worth)

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
        player.update(RollUpdate(Roll(0, 0)))
        self.assertEqual(0, player.location)
        player.update(RollUpdate(Roll(7, 7)))
        self.assertEqual(0, player.location)
        player.update(RollUpdate(Roll(7, 7)))
        self.assertEqual(0, player.location)
        player.update(RollUpdate(Roll(3, 7)))
        self.assertEqual(0, player.location)

        # Will convert doubles to integers with floor
        player.update(RollUpdate(Roll(6, 6)))
        self.assertEqual(12, player.location)
        self.assertEqual(1, player.doubles_streak)

        # Roll should reset doubles
        player.update(RollUpdate(Roll(1, 4)))
        self.assertEqual(17, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.doubles_streak)

        # Roll 3 doubles in a row and check for jail condition and doubles streak
        for i in range(2):
            player.update(RollUpdate(Roll(1, 1)))
        self.assertEqual(2, player.doubles_streak)
        self.assertFalse(player.in_jail)

        # Verify behavior works as expected when player gets sent to jail
        player.update(RollUpdate(Roll(1, 1)))
        self.assertEqual(0, player.doubles_streak)
        self.assertTrue(player.in_jail)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION, player.location)

        # Verify player can get out of jail with doubles
        player.update(RollUpdate(Roll(1, 1)))
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION + 2, player.location)
        self.assertEqual(0, player.doubles_streak)

        # Put them back in jail by rolling 3 more doubles
        for i in range(3):
            player.update(RollUpdate(Roll(1, 1)))
        self.assertEqual(3, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(0, player.doubles_streak)

        # Verify behavior when not rolling doubles in jail
        player.update(RollUpdate(Roll(1, 2)))
        self.assertTrue(player.in_jail)
        self.assertEqual(2, player.turns_in_jail)
        player.update(RollUpdate(Roll(1, 2)))
        self.assertTrue(player.in_jail)
        self.assertEqual(1, player.turns_in_jail)

        # After the 3rd roll, they will no longer have any turns left in jail but should still be at the jail location
        player.update(RollUpdate(Roll(1, 2)))
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)

        # Verify their next roll does in fact move them
        player.update(RollUpdate(Roll(1, 2)))
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

    def test_leave_jail(self):
        def send_to_jail(player: Player):
            # Helper method to send a player to jail
            player.turns_in_jail = 3
            player.location = JAIL_LOCATION
            self.assertEqual(JAIL_LOCATION, player.location)
            self.assertTrue(player.in_jail)
            self.assertEqual(JAIL_TURNS, player.turns_in_jail)

        def verify_free(player: Player, location: int):
            # Helper method to make perform checks that a player was freed from ail
            self.assertEqual(location, player.location)
            self.assertFalse(player.in_jail)
            self.assertEqual(0, player.turns_in_jail)

        def verify_in_jail(player: Player):
            # Helper method to make perform checks that a player was freed from ail
            self.assertEqual(JAIL_LOCATION, player.location)
            self.assertTrue(player.in_jail)
            self.assertEqual(3, player.turns_in_jail)

        player: Player = self.make_player()
        verify_free(player, START_LOCATION)
        methods: list[JailMethod] = [JailMethod.MONEY, JailMethod.DOUBLES, JailMethod.CARD, JailMethod.INVALID]
        # Verify nothing changes when trying the different methods
        for method in methods:
            player.update(LeaveJailUpdate(method))
            verify_free(player, START_LOCATION)

        # Send them to jail. Free them with doubles. Should be freed but still in jail (roll is handled separately)
        send_to_jail(player)
        player.update(LeaveJailUpdate(JailMethod.DOUBLES))
        verify_free(player, JAIL_LOCATION)

        # Send them to jail. Using a card shouldn't work until they have one.
        send_to_jail(player)
        player.update(LeaveJailUpdate(JailMethod.CARD))
        verify_in_jail(player)
        player.jail_cards = 1
        player.update(LeaveJailUpdate(JailMethod.CARD))
        verify_free(player, JAIL_LOCATION)
        self.assertEqual(0, player.jail_cards)

        # Send them to jail. Free them with money. Verify it subtracts money from their balance.
        send_to_jail(player)
        self.assertEqual(STARTING_MONEY, player.money)
        player.update(LeaveJailUpdate(JailMethod.MONEY))
        # JAIL_COST is negative
        self.assertEqual(STARTING_MONEY + JAIL_COST, player.money)
        verify_free(player, JAIL_LOCATION)

        # Send them to jail. Free them with an invalid method and with other parameter types.
        send_to_jail(player)
        for method in [JailMethod.INVALID, 0, "foo", 3.5, []]:
            player.update(LeaveJailUpdate(method))
            verify_in_jail(player)

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
        asset: AssetTile = AssetTile(id=0, name="Test", price=200, group=AssetGroups.ORANGE)
        asset.owner = player
        player.assets.append(asset)
        self.assertEqual(STARTING_MONEY, player.money)
        money = MoneyUpdate(-(STARTING_MONEY + 1))
        player.update(money)
        self.assertEqual(PlayerStatus.IN_THE_HOLE, player.status)
        self.assertEqual(-1, player.money)


if __name__ == '__main__':
    unittest.main()
