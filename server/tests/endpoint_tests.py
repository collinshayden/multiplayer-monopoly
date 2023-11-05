"""
Description:    Test suite used to verify endpoint functionality.
Author:         Jordan Bourdeau
Date:           10/24/23
"""

from server.game_logic.asset_tile import AssetTile
from server.game_logic.constants import (JAIL_COST, JAIL_LOCATION, JAIL_TURNS, MAX_NUM_PLAYERS, MIN_NUM_PLAYERS,
                                         PLAYER_ID_LENGTH, START_LOCATION, STARTING_MONEY)
from server.game_logic.improvable_tile import ImprovableTile
from server.game_logic.player import Player
from server.game_logic.player_updates import BuyUpdate, GoToJailUpdate
from server.game_logic.railroad_tile import RailroadTile
from server.game_logic.types import PropertyStatus, RailroadStatus, UtilityStatus
from server.server import app, game

from flask_testing import TestCase
import json
import unittest


class EndpointTests(TestCase):

    # Used to configure the Flask app for testing endpoints
    def create_app(self):
        app.config["TESTING"] = True
        return app

    def setUp(self) -> None:
        """
        Description:    Method used to clear game state between tests.
        :return:        None.
        """
        game.__init__()

    def fill_players(self, amount: int) -> list[str]:
        """
        Description:    Helper method which will fill the game with players.
        :return:        None
        """
        players: list[str] = []
        for n in range(amount):
            players.append(game.register_player(f"player{n}"))
        self.assertEqual(amount, len(game.players))
        return players

    def authenticate(self, endpoint: str, event: str, require_active_player: bool = True,
                     require_active_game_tests: bool = True):
        """
        Description:                        Function used to eliminate repeat tests.
        :param endpoint:                    Flask app endpoint to test.
        :param event:                       Event name to return in JSON response.
        :param require_active_player:       Whether the tests require the active player be the one making a request.
        :param require_active_game_tests:   Whether the function will perform tests with an active game (often requires
                                            additional parameters that aren't accounted for here such as tile_id).
        :return:
        """
        # Verify endpoint does nothing when game hasn't started and there are no players
        expected: dict = {"event": event, "success": False}
        response = self.client.get(endpoint)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))

        # Verify endpoint does nothing when there are players, but the game hasn't started
        player_ids: list[str] = self.fill_players(MIN_NUM_PLAYERS)
        # No player ID
        response = self.client.get(endpoint)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        # Invalid player ID
        query_string: dict = {"player_id": "invalid"}
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        # Valid player ID
        query_string["player_id"] = player_ids[0]
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))

        if require_active_game_tests:
            # Verify endpoints does nothing when game has started
            game.start_game(player_ids[0])
            player_ids: list[str] = game.turn_order
            # No player ID
            response = self.client.get(endpoint)
            self.assert200(response)
            self.assertEqual(expected, json.loads(response.data))

            # Verify endpoint does nothing when passed an invalid player ID
            query_string["player_id"] = "invalid"
            response = self.client.get(endpoint, query_string=query_string)
            self.assert200(response)
            self.assertEqual(expected, json.loads(response.data))

            # Verify endpoint does nothing when passed a non-active player ID
            if require_active_player:
                query_string["player_id"] = player_ids[1]
                response = self.client.get(endpoint, query_string=query_string)
                self.assert200(response)
                self.assertEqual(expected, json.loads(response.data))

            # Verify endpoint updates active player when passed the active player ID
            expected["success"] = True
            query_string["player_id"] = player_ids[0]
            response = self.client.get(endpoint, query_string=query_string)
            self.assert200(response)
            self.assertEqual(expected, json.loads(response.data))

    def test_state(self):
        # Verify game state can be retrieved matches game state
        response = self.client.get("/game/state")
        self.assert200(response)
        self.assertEqual(game.to_dict(), json.loads(response.data))

    def test_start_game(self):
        endpoint: str = "/game/start_game"
        # Verify game cannot be started without players
        response = self.client.get(endpoint)
        self.assert200(response)
        json_data: dict = json.loads(response.data)
        expected: dict = {
            "event": "startGame",
            "success": False
        }
        self.assertEqual(expected, json_data)

        # Add minimum number of players
        players: list[str] = self.fill_players(MIN_NUM_PLAYERS)
        response = self.client.get(endpoint)
        self.assert200(response)
        # Verify that request without authentication doesn't work
        json_data: dict = json.loads(response.data)
        self.assertEqual(expected, json_data)
        # Provide id for authentication
        query_string: dict = {"player_id": players[0]}
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        json_data: dict = json.loads(response.data)
        expected["success"] = True
        self.assertEqual(expected, json_data)
        self.assertTrue(game.started)

    def test_register_player(self):
        endpoint: str = "/game/register_player"
        event: str = "registerPlayer"
        # Verify player cannot be registered without a display name
        response = self.client.get(endpoint)
        self.assert200(response)
        json_data: dict = json.loads(response.data)
        expected: dict = {"event": event, "registered": False}
        self.assertEqual(expected, json_data)

        # Register a valid display name
        query_string: dict = {"display_name": "Tester"}
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        json_data: dict = json.loads(response.data)
        self.assertEqual(json_data.get("event", ""), "registerPlayer")
        self.assertEqual(len(json_data.get("playerId", "")), PLAYER_ID_LENGTH)
        self.assertEqual(json_data.get("success", False), True)
        self.assertEqual(1, len(game.players))
        self.assertIn(json_data.get("playerId", ""), game.players.keys())

    def test_roll_dice(self):
        endpoint: str = "/game/roll_dice"
        event: str = "rollDice"
        self.authenticate(endpoint, event)
        player_ids: list[str] = game.turn_order
        query_string: dict = {"player_id": player_ids[0]}
        expected: dict = {
            "event": event,
            "success": True
        }
        # Verify player can keep rolling the dice until the end_turn method is called
        for n in range(5):
            response = self.client.get(endpoint, query_string=query_string)
            self.assert200(response)
            self.assertEqual(expected, json.loads(response.data))
        game.end_turn(player_ids[0])
        # End the turn and verify first player can no longer roll dice
        expected["success"] = False
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))

    def test_draw_card(self):
        endpoint: str = "/game/draw_card"
        event: str = "drawCard"
        self.authenticate(endpoint, event, require_active_game_tests=False)

    def test_buy_property(self):
        endpoint: str = "/game/buy_property"
        event: str = "buyProperty"
        self.authenticate(endpoint, event, require_active_game_tests=False)

        # Start the game and do active game tests with valid arguments
        player_ids: list[str] = game.turn_order
        game.start_game(player_ids[0])
        player_ids = game.turn_order
        player: Player = game.players[player_ids[0]]
        expected: dict = {
            "event": event,
            "success": False
        }
        # Will fail when given a tile which isn't an AssetTile
        query_string: dict = {
            "player_id": player_ids[0],
            "tile_id": 0  # Go tile
        }
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(0, len(player.assets))
        # Verify it works for an ImprovableTile, UtilityTile, and RailroadTile
        for idx, id in enumerate([3, 5, 12]):   # Baltic Avenue, Reading Railroad, Electric Company
            asset: AssetTile = game.tiles[id]
            self.assertTrue(isinstance(asset, AssetTile))
            query_string["tile_id"] = id
            # Verify inactive player cannot buy the asset
            expected["success"] = False
            query_string["player_id"] = player_ids[1]
            response = self.client.get(endpoint, query_string=query_string)
            self.assert200(response)
            self.assertEqual(expected, json.loads(response.data))
            self.assertIsNone(asset.owner)
            self.assertEqual(STARTING_MONEY, game.players[player_ids[1]].money)
            self.assertEqual(0, len(game.players[player_ids[1]].assets))

            # Verify active player can buy the asset
            expected["success"] = True
            query_string["player_id"] = player_ids[0]
            money: int = player.money
            response = self.client.get(endpoint, query_string=query_string)
            self.assert200(response)
            self.assertEqual(expected, json.loads(response.data))
            self.assertEqual(money - asset.price, player.money)
            self.assertEqual(idx + 1, len(player.assets))
            self.assertIn(asset, player.assets)

        self.assertEqual(PropertyStatus.NO_MONOPOLY, game.tiles[3].status)
        self.assertEqual(RailroadStatus.ONE_OWNED, game.tiles[5].status)
        self.assertEqual(UtilityStatus.NO_MONOPOLY, game.tiles[12].status)

        # Buy other brown property and utility and verify they become monoopolies
        query_string["tile_id"] = 1
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(PropertyStatus.MONOPOLY, game.tiles[1].status)
        self.assertEqual(PropertyStatus.MONOPOLY, game.tiles[3].status)

        query_string["tile_id"] = 28
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(UtilityStatus.MONOPOLY, game.tiles[12].status)
        self.assertEqual(UtilityStatus.MONOPOLY, game.tiles[28].status)

        # Buy other railroads and verify the property status changes accordingly
        for idx, id in enumerate([15, 25, 35]):
            query_string["tile_id"] = id
            railroad: RailroadTile = game.tiles[id]
            money = player.money
            response = self.client.get(endpoint, query_string=query_string)
            self.assert200(response)
            self.assertEqual(expected, json.loads(response.data))
            self.assertIs(player, railroad.owner)
            self.assertEqual(money - railroad.price, player.money)
            self.assertEqual(RailroadStatus.ONE_OWNED + idx + 1, railroad.status)

    def test_set_improvements(self):
        endpoint: str = "/game/set_improvements"
        event: str = "setImprovements"
        self.authenticate(endpoint, event, require_active_game_tests=False)

        # Start the game and do active game tests with valid arguments
        player_ids: list[str] = game.turn_order
        game.start_game(player_ids[0])
        player_ids = game.turn_order
        player: Player = game.players[player_ids[0]]
        expected: dict = {
            "event": event,
            "success": False
        }

        # Verify passing in no tile_id does nothing
        query_string: dict = {
            "player_id": player_ids[0],
            "quantity": 1
        }
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))

        # Try to improve a non-asset tile
        query_string["tile_id"] = 0
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(STARTING_MONEY, player.money)
        self.assertEqual(0, len(player.assets))

        # Try to improve unowned asset tiles (one of each asset type)
        for id in [3, 5, 12]:
            query_string["tile_id"] = id
            response = self.client.get(endpoint, query_string=query_string)
            self.assert200(response)
            self.assertEqual(expected, json.loads(response.data))
            self.assertEqual(STARTING_MONEY, player.money)
            self.assertEqual(0, len(player.assets))

        # Purchase monopolies for utilities and railroads
        # Verify they cannot be upgraded at any point
        for idx, id in enumerate([5, 15, 25, 35, 12, 28]):
            money: int = player.money
            asset: AssetTile = game.tiles[id]
            player.update(BuyUpdate(asset))
            self.assertEqual(money - asset.price, player.money)
            self.assertEqual(idx + 1, len(player.assets))
            # Shouldn't be able to upgrade any of these
            query_string["tile_id"] = id
            response = self.client.get(endpoint, query_string=query_string)
            self.assert200(response)
            self.assertEqual(expected, json.loads(response.data))

        # Purchase an improvable tile. Verify improvements fail.
        baltic: ImprovableTile = game.tiles[3]
        player.update(BuyUpdate(baltic))
        query_string["tile_id"] = 3
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))

        # Purchase rest of the monopoly.
        mediterranean: ImprovableTile = game.tiles[1]
        player.update(BuyUpdate(mediterranean))
        query_string["tile_id"] = 3
        player.money = STARTING_MONEY
        # Verify out of range quantities are not accepted
        for quantity in [-6, 6]:
            query_string["quantity"] = quantity
            response = self.client.get(endpoint, query_string=query_string)
            self.assert200(response)
            self.assertEqual(expected, json.loads(response.data))
            for asset in [mediterranean, baltic]:
                self.assertEqual(PropertyStatus.MONOPOLY, asset.status)

        expected["success"] = True
        query_string["quantity"] = 5
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(PropertyStatus.FIVE_IMPROVEMENTS, baltic.status)
        self.assertEqual(PropertyStatus.FOUR_IMPROVEMENTS, mediterranean.status)
        self.assertEqual(STARTING_MONEY - (9 * 50), player.money)

        # Verify selling 5 on baltic also sells 3 on mediterranean
        query_string["quantity"] = -5
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(PropertyStatus.MONOPOLY, baltic.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, mediterranean.status)
        self.assertEqual(STARTING_MONEY - (9 * 50) + (8 * 25), player.money)

        # Verify trying to sell another on Baltic fails and nothing changes.
        expected["success"] = False
        query_string["quantity"] = -1
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(PropertyStatus.MONOPOLY, baltic.status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, mediterranean.status)
        self.assertEqual(STARTING_MONEY - (9 * 50) + (8 * 25), player.money)

    def test_set_mortgage(self):
        endpoint: str = "/game/set_mortgage"
        event: str = "setMortgage"
        self.authenticate(endpoint, event, require_active_game_tests=False)

        # Start the game and do active game tests with valid arguments
        player_ids: list[str] = game.turn_order
        game.start_game(player_ids[0])
        player_ids = game.turn_order
        expected: dict = {
            "event": event,
            "success": False
        }
        query_string: dict = {
            "player_id": player_ids[0],
            "tile_id": 0
        }

        # Verify passing nothing in for mortgage fails
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))

        # Try to mortgage/unmortgage a non-asset tile and unowned asset tiles
        for mortgage in [True, False]:
            query_string["mortgage"] = mortgage
            for id in [0, 1, 5, 12]:
                query_string["tile_id"] = id
                response = self.client.get(endpoint, query_string=query_string)
                self.assert200(response)
                self.assertEqual(expected, json.loads(response.data))

        # Purchase a property
        player: Player = game.players[player_ids[0]]
        asset: ImprovableTile = game.tiles[1]
        player.update(BuyUpdate(asset))
        self.assertEqual(STARTING_MONEY - asset.price, player.money)
        self.assertIs(player, asset.owner)
        self.assertIn(asset, player.assets)

        # Attempt to unmortgage an already unmortgaged property
        money: int = player.money
        query_string["tile_id"] = 1
        query_string["mortgage"] = False
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(money, player.money)
        self.assertFalse(asset.is_mortgaged)

        # Mortgage the property and verify state updates
        query_string["mortgage"] = True
        expected["success"] = True
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(money + asset.mortage_price, player.money)
        self.assertTrue(asset.is_mortgaged)

        # Try to mortgage an already mortgaged property
        money = player.money
        query_string["mortgage"] = True
        expected["success"] = False
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(money, player.money)
        self.assertTrue(asset.is_mortgaged)

        # Unmortgage the property and verify state updates
        query_string["mortgage"] = False
        expected["success"] = True
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(money - asset.lift_mortage_cost, player.money)
        self.assertFalse(asset.is_mortgaged)

    def test_get_out_of_jail(self):
        endpoint: str = "/game/get_out_of_jail"
        event: str = "getOutOfJail"
        self.authenticate(endpoint, event, require_active_game_tests=False)

        # Start the game and do active game tests with valid arguments
        player_ids: list[str] = game.turn_order
        game.start_game(player_ids[0])
        player_ids = game.turn_order
        expected: dict = {
            "event": event,
            "success": False
        }
        # User that is not in jail cannot get out of jail
        query_string: dict = {"player_id": player_ids[0]}
        for method in ["doubles", "money", "card"]:
            query_string["method"] = method
            response = self.client.get(endpoint, query_string=query_string)
            self.assert200(response)
            self.assertEqual(expected, json.loads(response.data))
        # Send player to jail multiple times and verify each JailMethod works as expected
        player: Player = game.players[player_ids[0]]
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(START_LOCATION, player.location)
        self.assertEqual(STARTING_MONEY, player.money)

        # Doubles: Doesn't cost anything
        player.update(GoToJailUpdate())
        expected["success"] = True
        query_string["method"] = "doubles"
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(STARTING_MONEY, player.money)

        # Money: -50 money
        player.update(GoToJailUpdate())
        expected["success"] = True
        query_string["method"] = "money"
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(STARTING_MONEY + JAIL_COST, player.money)

        # Card: Returns false when they have no jail cards and true when they do
        player.update(GoToJailUpdate())
        player.money = STARTING_MONEY
        expected["success"] = False
        query_string["method"] = "card"
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertTrue(player.in_jail)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(STARTING_MONEY, player.money)

        # Increment jail cards and try again
        player.jail_cards += 1
        expected["success"] = True
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertFalse(player.in_jail)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(STARTING_MONEY, player.money)

    def test_end_turn(self):
        endpoint: str = "/game/end_turn"
        event: str = "endTurn"
        self.authenticate(endpoint, event)

        # Verify game state updated accordingly after valid request
        player_ids: list[str] = game.turn_order
        self.assertEqual(game.active_player_id, player_ids[1])

        query_string: dict = {"player_id": player_ids[1]}
        expected: dict = {"event": event, "success": True}
        response = self.client.get(endpoint, query_string=query_string)
        self.assert200(response)
        self.assertEqual(expected, json.loads(response.data))
        self.assertEqual(game.active_player_id, player_ids[0])

    def test_reset(self):
        endpoint: str = "/game/reset"
        event: str = "reset"
        self.authenticate(endpoint, event, require_active_player=False)


if __name__ == '__main__':
    unittest.main()
