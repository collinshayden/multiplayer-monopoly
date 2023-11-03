import unittest

from server.game_logic.asset_tile import AssetTile
from server.game_logic.constants import JAIL_LOCATION, JAIL_TURNS, GO_MONEY, STARTING_MONEY
from server.game_logic.go_to_jail_tile import GoToJailTile
from server.game_logic.go_tile import GoTile
from server.game_logic.improvable_tile import ImprovableTile
from server.game_logic.player import Player
from server.game_logic.player_updates import BuyUpdate, ImprovementUpdate, PlayerUpdate
from server.game_logic.railroad_tile import RailroadTile
from server.game_logic.tile import Tile
from server.game_logic.types import AssetGroups, PropertyStatus, RailroadStatus, UtilityStatus
from server.game_logic.utility_tile import UtilityTile


class TileTests(unittest.TestCase):

    def make_player1(self) -> Player:
        id: str = "abcdefghi1234567"
        username: str = "Test"
        player: Player = Player(player_id=id, username=username)
        return player

    def make_player2(self) -> Player:
        id: str = "abcdefghi7777777"
        username: str = "Test2"
        player: Player = Player(player_id=id, username=username)
        return player

    def test_tile(self):
        tile: Tile = Tile(id=7, name="Test")
        player: Player = self.make_player1()
        updates: dict[str: PlayerUpdate] = tile.land(player, 7)
        self.assertEqual(0, len(updates))
        self.assertEqual(7, tile.id)

    def test_asset_tile(self):
        tile: AssetTile = AssetTile(id=19, name="New York Avenue", price=200, group=AssetGroups.ORANGE)
        # Verify computed properties work off the bat
        self.assertEqual(100, tile.mortage_price)
        self.assertEqual(PropertyStatus.NO_MONOPOLY, tile.status)
        self.assertEqual(110, tile.lift_mortage_cost)
        self.assertFalse(tile.is_mortgaged)
        self.assertIsNone(tile.owner)
        self.assertEqual(100, tile.liquid_value)
        self.assertEqual(0, tile.rent)

        player1: Player = self.make_player1()
        player2: Player = self.make_player2()
        # Landing does nothing since AssetTile isn't owned
        updates: dict[str: PlayerUpdate] = tile.land(player1, 7)
        self.assertEqual(0, len(updates))
        self.assertEqual(19, tile.id)
        # player1 now owns the tile
        player1.assets.append(tile)
        tile.owner = player1
        # player2 lands on the tile
        expected_rent: int = 16
        updates: dict[str: PlayerUpdate] = tile.land(player2, 7)
        self.assertEqual(2, len(updates))
        for id, update in updates.items():
            if id == player1.player_id:
                player1.update(update)
            elif id == player2.player_id:
                player2.update(update)
        self.assertEqual(STARTING_MONEY + expected_rent, player1.money)
        self.assertEqual(STARTING_MONEY - expected_rent, player2.money)
        # Make sure nothing happens when player1 lands on tile
        updates = tile.land(player1, 7)
        self.assertEqual(0, len(updates))
        self.assertEqual(STARTING_MONEY + expected_rent, player1.money)
        self.assertEqual(STARTING_MONEY - expected_rent, player2.money)

        # Test mortgage/unmortgage methods
        self.assertFalse(tile.is_mortgaged)
        for _ in range(2):
            tile.mortgage()
            self.assertEqual(0, tile.liquid_value)
            self.assertTrue(tile.is_mortgaged)
        for _ in range(2):
            tile.unmortgage()
            self.assertEqual(100, tile.liquid_value)
            self.assertFalse(tile.is_mortgaged)

    def test_go_tile(self):
        tile: GoTile = GoTile()
        player: Player = self.make_player1()
        self.assertEqual(STARTING_MONEY, player.money)
        updates: dict[str: PlayerUpdate] = tile.land(player, 7)
        self.assertEqual(1, len(updates))
        for id, update in updates.items():
            if id == player.player_id:
                player.update(update)
        self.assertEqual(STARTING_MONEY + GO_MONEY, player.money)

    def test_go_to_jail_tile(self):
        tile: GoToJailTile = GoToJailTile()
        player: Player = self.make_player1()
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(0, player.location)
        self.assertEqual(STARTING_MONEY, player.money)
        updates: dict[str: PlayerUpdate] = tile.land(player, 7)
        self.assertEqual(1, len(updates))
        for id, update in updates.items():
            if id == player.player_id:
                player.update(update)
        self.assertTrue(player.in_jail)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION, player.location)

    def test_improvable_tile(self):
        # Orange properties
        st_james: ImprovableTile = ImprovableTile(id=16, name="St. James Place", price=180, group=AssetGroups.ORANGE)
        ten_ave: ImprovableTile = ImprovableTile(id=18, name="Tennessee Ave", price=180, group=AssetGroups.ORANGE)
        ny_ave: ImprovableTile = ImprovableTile(id=19, name="New York Avenue", price=200, group=AssetGroups.ORANGE)
        player1: Player = self.make_player1()
        player2: Player = self.make_player2()
        monopoly: list[ImprovableTile] = [st_james, ten_ave, ny_ave]
        for tile in monopoly:
            self.assertIsNone(tile.owner)
            self.assertFalse(tile.is_mortgaged)
            self.assertEqual(100, tile.improvement_cost)
            self.assertEqual(tile.mortage_price, tile.liquid_value)
            player1.update(BuyUpdate(tile))
            self.assertIs(player1, tile.owner)
        for tile in monopoly:
            self.assertEqual(PropertyStatus.MONOPOLY, tile.status)
        # Verify rent is double the base rent since it is a monopoly
        base_rent: int = 16
        updates: dict[str: PlayerUpdate] = ny_ave.land(player2, 7)
        for id, update in updates.items():
            if id == player1.player_id:
                player1.update(update)
            elif id == player2.player_id:
                player2.update(update)
        self.assertEqual(STARTING_MONEY - base_rent * 2, player2.money)
        self.assertEqual(STARTING_MONEY + base_rent * 2 - 560, player1.money)
        # Build improvements on tile and verify rent is what is expected
        player1.money = STARTING_MONEY
        player2.money = STARTING_MONEY
        # Build hotels on everything
        player1.update(ImprovementUpdate(ny_ave, 5))
        self.assertEqual(PropertyStatus.FIVE_IMPROVEMENTS, ny_ave.status)
        self.assertEqual(PropertyStatus.FOUR_IMPROVEMENTS, st_james.status)
        self.assertEqual(PropertyStatus.FOUR_IMPROVEMENTS, ten_ave.status)
        self.assertEqual(200, player1.money)

        player1.update(ImprovementUpdate(st_james, 1))
        self.assertEqual(PropertyStatus.FIVE_IMPROVEMENTS, ny_ave.status)
        self.assertEqual(PropertyStatus.FIVE_IMPROVEMENTS, st_james.status)
        self.assertEqual(PropertyStatus.FOUR_IMPROVEMENTS, ten_ave.status)
        self.assertEqual(100, player1.money)

        # player1.update(ImprovementUpdate(ten_ave, 1))
        # self.assertEqual(PropertyStatus.FIVE_IMPROVEMENTS, ny_ave.status)
        # self.assertEqual(PropertyStatus.FIVE_IMPROVEMENTS, st_james.status)
        # self.assertEqual(PropertyStatus.FIVE_IMPROVEMENTS, ten_ave.status)
        # self.assertEqual(0, player1.money)


    def test_railroad_tile(self):
        player1: Player = self.make_player1()
        reading: RailroadTile = RailroadTile(id=5, name="Reading Railroad", price=200)
        pennsylvania: RailroadTile = RailroadTile(id=15, name="Pennsylvania Railroad", price=200)
        bno: RailroadTile = RailroadTile(id=25, name="B&O Railroad", price=200)
        short_line: RailroadTile = RailroadTile(id=35, name="Short Line Railroad", price=200)
        railroads: list[RailroadTile] = [reading, pennsylvania, bno, short_line]
        # Make sure all railroads are initialized correctly
        for railroad in railroads:
            self.assertEqual(RailroadStatus.UNOWNED, railroad.status)
            self.assertEqual(0, railroad.rent)
        # Buy Reading Railroad, check expected state
        player1.update(BuyUpdate(reading))
        self.assertIn(reading, player1.assets)
        self.assertIs(player1, reading.owner)
        self.assertEqual(RailroadStatus.ONE_OWNED, reading.status)
        self.assertEqual(25, reading.rent)
        for idx, railroad in enumerate([pennsylvania, bno, short_line]):
            self.assertEqual(RailroadStatus.UNOWNED, railroad.status)
            player1.update(BuyUpdate(railroad))
            self.assertEqual(RailroadStatus.ONE_OWNED + idx + 1, railroad.status)
            self.assertEqual(railroad.rent, 25 * 2**(idx + 1))

    def test_utility_tile(self):
        player: Player = self.make_player1()
        electric_company = UtilityTile(id=12, name="Electric Company", price=150)
        water_works = UtilityTile(id=28, name="Water Works", price=150)
        utilities: list[UtilityTile] = [electric_company, water_works]
        for utility in utilities:
            self.assertIsNone(utility.owner)
            self.assertEqual(0, utility.rent)
            self.assertEqual(UtilityStatus.NO_MONOPOLY, utility.status)
        # Buy Electric Company
        player.update(BuyUpdate(electric_company))
        self.assertIs(player, electric_company.owner)
        self.assertIsNone(water_works.owner)
        self.assertEqual(4, electric_company.rent)
        self.assertEqual(0, water_works.rent)
        self.assertEqual(UtilityStatus.NO_MONOPOLY, electric_company.status)
        self.assertEqual(UtilityStatus.NO_MONOPOLY, water_works.status)
        # Buy second utility, verify rent multiplier goes to 10 for both.
        player.update(BuyUpdate(water_works))
        self.assertIs(player, electric_company.owner)
        self.assertIs(player, water_works.owner)
        self.assertEqual(10, electric_company.rent)
        self.assertEqual(10, water_works.rent)
        self.assertEqual(UtilityStatus.MONOPOLY, electric_company.status)
        self.assertEqual(UtilityStatus.MONOPOLY, water_works.status)


if __name__ == '__main__':
    unittest.main()
