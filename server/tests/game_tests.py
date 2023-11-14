"""
Description:    Test suite used to verify Game class functionality.
Author:         Jordan Bourdeau
Date:           10/24/23
"""

from server.game_logic.constants import (CHANCE_TILES, COMMUNITY_CHEST_TILES, MAX_NUM_PLAYERS, NUM_CHANCE_CARDS,
                                         NUM_COMMUNITY_CHEST_CARDS, PLAYER_ID_LENGTH, STARTING_MONEY)
from server.game_logic.event import Event
from server.game_logic.game import Game
from server.game_logic.player_updates import *
from server.game_logic.tile import Tile
from server.game_logic.types import CardType, EventType, PlayerStatus

import unittest


class GameTests(unittest.TestCase):

    """ Test Exposed API Methods """
    def test_get_events(self):
        game: Game = Game()
        # Can't start game with no players and without valid player ID
        id1: str = game.register_player("test1")
        id2: str = game.register_player("test2")
        self.assertTrue(game.start_game(id1))
        id1, id2 = game.turn_order
        ids: list[str] = [id1, id2]

        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Test case: Empty event queue
        result_empty_queue: list[dict] = game.get_events(id1)
        self.assertEqual([], result_empty_queue)
        self.assertEqual([], game.event_queue[id1])  # Player1's queue should be empty

        # Test case: Non-empty event queue for a single player
        event1: Event = Event({"name": "event1"})
        event2: Event = Event({"name": "event2"})
        game._enqueue_event(event1, EventType.UPDATE, target=id1)
        game._enqueue_event(event2, EventType.PROMPT, target=id1)

        result_single_player: list[dict] = game.get_events(id1)
        expected_result_single_player: list[dict] = [event1.serialize(), event2.serialize()]
        self.assertEqual(expected_result_single_player, result_single_player)
        self.assertEqual([], game.event_queue[id1])  # Player1's queue should be cleared

        # Test case: Non-empty event queue for multiple players
        event3 = Event({"name": "event3"})
        event4 = Event({"name": "event4"})
        game._enqueue_event(event3, EventType.UPDATE, target=id1)
        game._enqueue_event(event4, EventType.PROMPT, target=id2)

        result_multiple_players_player1: list[dict] = game.get_events(id1)
        expected_result_multiple_players_player1: list[dict] = [event3.serialize()]
        self.assertEqual(result_multiple_players_player1, expected_result_multiple_players_player1)
        self.assertEqual(game.event_queue[id1], [])  # Player1's queue should be cleared

        result_multiple_players_player2: list[dict] = game.get_events(id2)
        expected_result_multiple_players_player2: list[dict] = [event4.serialize()]
        self.assertEqual(expected_result_multiple_players_player2, result_multiple_players_player2)
        self.assertEqual([], game.event_queue[id2] )  # Player2's queue should be cleared

    def test_start_game(self):
        game: Game = Game()
        # Can't start game with no players and without valid player ID
        self.assertFalse(game.start_game(""))
        id1: str = game.register_player("test1")

        # Valid id but not enough players
        self.assertFalse(game.start_game(id1))
        id2: str = game.register_player("test2")

        # Valid number of players but invalid ID
        self.assertFalse(game.start_game(""))
        # Valid start
        self.assertTrue(game.start_game(id1))

        # Verify events are enqueued as expected
        # 2 from the UPDATE events when each player joined and then 2 from startGame + startTurn
        self.assertEqual(4, len(game.event_history))
        event_names: list[str] = ["playerJoin", "playerJoin", "startGame", "startTurn"]
        for event, name in zip(game.event_history, event_names):
            self.assertEqual(event.parameters["name"], name)
        id1, id2 = game.turn_order
        # Verify the active player's last two events are startTurn and promptRoll
        last_2: list[Event] = game.event_queue[id1][-2:]
        self.assertEqual(["startTurn", "promptRoll"], [event.parameters["name"] for event in last_2])

        # Verify it creates a turn order with the 2 ids and sets active player id and idx
        self.assertEqual(2, len(game.turn_order))
        self.assertEqual(0, game.active_player_idx)
        self.assertEqual(game.turn_order[0], game.active_player_id)

        # Can't start game again while it is still running
        self.assertFalse(game.start_game(id1))
        self.assertFalse(game.start_game(id2))

    def test_register_player(self):
        game: Game = Game()
        self.assertEqual(0, len(game.players))
        # Verify up to the maximum number of players can be added
        for i in range(1, MAX_NUM_PLAYERS + 1):
            display_name: str = f"test{i}"
            id: str = game.register_player(display_name)
            self.assertEqual(PLAYER_ID_LENGTH, len(id))
            self.assertEqual(i, len(game.players))
            self.assertEqual(display_name, game.players[id].display_name)
            self.assertEqual(id, game.players[id].id)
            self.assertEqual(i, len(game._players))
            # Verify new player got a "startGamePrompt" event
            self.assertEqual(2, len(game.event_queue[id]))
            self.assertEqual("playerJoin", game.event_queue[id][0].parameters["name"])
            self.assertEqual("startGamePrompt", game.event_queue[id][1].parameters["name"])

            # For each new player, verify the event queue was updated accordingly for existing ones
            for n in range(i):
                old_id: str = list(game.players.keys())[n]
                # 2 events from when they were created, and then 1 more for every player after
                self.assertEqual(2 + (i - n - 1), len(game.event_queue[old_id]))

        # Can't register a player beyond the maximum
        display_name = f"test{MAX_NUM_PLAYERS + 1}"
        id = game.register_player(display_name)
        self.assertTrue(id == "")
        self.assertEqual(MAX_NUM_PLAYERS, len(game.players))

    def test_roll_dice(self):
        game: Game = Game()
        # Can't roll dice when there is < 2 players or the active player ID is invalid
        self.assertEqual(False, game.roll_dice("bogus"))
        self.assertEqual(0, len(game.event_history))

        # Get a valid ID and verify it still doesn't let them roll the dice
        display_name: str = "player1"
        id: str = game.register_player(display_name)
        self.assertEqual(False, game.roll_dice(id))
        self.assertEqual(1, len(game.event_history))

        # Create a second player and now there are enough to start but the active player ID has not been decided.
        display_name2: str = "player2"
        id2: str = game.register_player(display_name2)
        self.assertEqual(False, game.roll_dice(id))
        self.assertEqual(2, len(game.event_history))

        # Start the game and get the turn order
        game.start_game(id2)
        id1, id2 = game.turn_order
        ids: list[str] = [id1, id2]
        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Can't roll the dice without being the active player
        self.assertEqual(False, game.roll_dice(id2))
        # Verify nothing changed
        for id in ids:
            self.assertEqual(0, len(game.event_queue[id]))
        self.assertEqual(0, len(game.event_history))

        # Can roll the dice as the active player
        roll: Roll = Roll(1, 2)
        player: Player = game.players[id1]
        self.assertEqual(0, player.doubles_streak)
        self.assertFalse(player.roll_again)
        result = game.roll_dice(id1, roll=roll)
        # Verify they got all expected events
        self.assertEqual(4, len(game.event_queue[id1]))
        expected: dict = {
            "name": "showRoll",
            "playerId": id1,
            "die1": roll.first,
            "die2": roll.second,
            "doubles": roll.is_doubles
        }
        self.assertEqual(expected, game.event_queue[id1][0].parameters)
        expected = {
            "name": "movePlayer",
            "spaces": roll.total
        }
        self.assertEqual(expected, game.event_queue[id1][1].parameters)
        expected = {
            "name": "promptPurchase",
            "tileId": player.location
        }
        self.assertEqual(expected, game.event_queue[id1][2].parameters)
        expected = {"name": "promptEndTurn"}
        self.assertEqual(expected, game.event_queue[id1][3].parameters)
        game.end_turn(id1)
        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Verify player cannot roll again since they did not get doubles
        self.assertFalse(game.roll_dice(id1), roll)

        # Verify no events were enqueued
        for id in ids:
            self.assertEqual(0, len(game.event_queue[id]))
        self.assertEqual(0, len(game.event_history))

        # Roll doubles and verify the community chest card is drawn
        roll = Roll(1, 1)
        player2: Player = game.players[id2]
        start_length: int = len(game.community_chest_deck.stack)
        self.assertEqual(0, len(game.community_chest_deck.discard))
        self.assertTrue(game.roll_dice(id2, roll=roll))
        self.assertEqual(roll.total, player2.location)
        self.assertEqual(1, player2.doubles_streak)
        self.assertTrue(player2.roll_again)
        # Verify they got all expected events
        self.assertEqual(4, len(game.event_queue[id2]))
        expected = {
            "name": "showRoll",
            "playerId": id2,
            "die1": roll.first,
            "die2": roll.second,
            "doubles": roll.is_doubles
        }
        self.assertEqual(expected, game.event_queue[id2][0].parameters)
        expected = {
            "name": "movePlayer",
            "spaces": roll.total
        }
        self.assertEqual(expected, game.event_queue[id2][1].parameters)
        # Since this is randomized we don't know exactly what card will be drawn.
        self.assertEqual("showCardDraw", game.event_queue[id2][2].parameters["name"])
        expected = {"name": "promptRoll"}
        self.assertEqual(expected, game.event_queue[id2][3].parameters)
        self.assertEqual(1, len(game.community_chest_deck.discard))
        self.assertEqual(start_length - 1, len(game.community_chest_deck.stack))
        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Resets doubles condition. Test rolling onto a tile which does nothing (Jail).
        roll = Roll(3, 5)
        self.assertTrue(game.roll_dice(id2, roll))
        self.assertEqual(2, len(game.event_history))
        self.assertEqual(2, len(game.event_queue[id1]))
        self.assertEqual(3, len(game.event_queue[id2]))
        expected = {
            "name": "showRoll",
            "playerId": id2,
            "die1": roll.first,
            "die2": roll.second,
            "doubles": roll.is_doubles
        }
        self.assertEqual(expected, game.event_queue[id2][0].parameters)
        expected = {
            "name": "movePlayer",
            "spaces": roll.total
        }
        self.assertEqual(expected, game.event_queue[id2][1].parameters)
        expected = {"name": "promptEndTurn"}
        self.assertEqual(expected, game.event_queue[id2][2].parameters)
        game.end_turn(id2)
        self.assertEqual(id1, game.active_player_id)
        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Test rolling doubles 3 times to go to jail.
        roll = Roll(1, 1)
        self.assertTrue(game.roll_dice(id1, roll))
        self.assertEqual(5, player.location)
        self.assertEqual(4, len(game.event_queue[id1]))
        expected: dict = {
            "name": "showRoll",
            "playerId": id1,
            "die1": roll.first,
            "die2": roll.second,
            "doubles": roll.is_doubles
        }
        self.assertEqual(expected, game.event_queue[id1][0].parameters)
        expected = {
            "name": "movePlayer",
            "spaces": roll.total
        }
        self.assertEqual(expected, game.event_queue[id1][1].parameters)
        expected = {
            "name": "promptPurchase",
            "tileId": player.location
        }
        self.assertEqual(expected, game.event_queue[id1][2].parameters)
        expected = {"name": "promptRoll"}
        self.assertEqual(expected, game.event_queue[id1][3].parameters)
        self.assertEqual(1, player.doubles_streak)
        self.assertTrue(player.roll_again)
        # Roll doubles onto community chest
        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Test rolling doubles 3 times to go to jail.
        roll = Roll(6, 6)
        self.assertTrue(game.roll_dice(id1, roll))
        self.assertEqual(17, player.location)
        self.assertEqual(4, len(game.event_queue[id1]))
        expected: dict = {
            "name": "showRoll",
            "playerId": id1,
            "die1": roll.first,
            "die2": roll.second,
            "doubles": roll.is_doubles
        }
        self.assertEqual(expected, game.event_queue[id1][0].parameters)
        expected = {
            "name": "movePlayer",
            "spaces": roll.total
        }
        self.assertEqual(expected, game.event_queue[id1][1].parameters)
        self.assertEqual("showCardDraw", game.event_queue[id1][2].parameters["name"])
        expected = {"name": "promptRoll"}
        self.assertEqual(expected, game.event_queue[id1][3].parameters)
        self.assertEqual(2, player.doubles_streak)
        self.assertTrue(player.roll_again)

        # Roll doubles on last time. Verify they go straight to jail and do not enqueue an event from landing on a tile.
        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Test rolling doubles 3 times to go to jail.
        self.assertTrue(game.roll_dice(id1, roll))
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(4, len(game.event_queue[id1]))
        expected: dict = {
            "name": "showRoll",
            "playerId": id1,
            "die1": roll.first,
            "die2": roll.second,
            "doubles": roll.is_doubles
        }
        self.assertEqual(expected, game.event_queue[id1][0].parameters)
        expected: dict = {
            "name": "goToJail",
            "player": game.players[id1].display_name
        }
        self.assertEqual(expected, game.event_queue[id1][1].parameters)
        # Verify the endTurn and startTurn events were automatically performed
        expected: dict = {
            "name": "endTurn",
            "player": player.display_name
        }
        self.assertEqual(expected, game.event_queue[id1][2].parameters)
        expected: dict = {
            "name": "startTurn",
            "player": player2.display_name
        }
        self.assertEqual(expected, game.event_queue[id1][3].parameters)
        self.assertTrue(player.in_jail)
        self.assertFalse(player.roll_again)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)
        # Auto-increment to the next player
        self.assertEqual(id2, game.active_player_id)

        # Verify rolling doubles twice then non-doubles doesn't put you in jail
        roll = Roll(6, 6)
        start_location: int = player2.location
        # Rolled onto jail but not in jail
        self.assertEqual(JAIL_LOCATION, start_location)
        self.assertTrue(game.roll_dice(id2, roll))
        self.assertEqual(start_location + roll.total, player2.location)
        self.assertTrue(game.roll_dice(id2, roll))
        self.assertEqual(start_location + 2 * roll.total, player2.location)
        self.assertEqual(2, player2.doubles_streak)
        self.assertEqual(0, player2.turns_in_jail)
        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Roll a non-double and verify the player lands on Luxury Tax and pays the money.
        roll = Roll(1, 3)
        self.assertTrue(game.roll_dice(id2, roll))
        self.assertEqual(38, player2.location)
        self.assertEqual(0, player2.doubles_streak)
        self.assertFalse(player2.in_jail)
        self.assertEqual(STARTING_MONEY + game.tiles[38].amount, player2.money)
        # Verify events were enqueued successfully
        expected = {
            "name": "showRoll",
            "playerId": id2,
            "die1": roll.first,
            "die2": roll.second,
            "doubles": roll.is_doubles
        }
        self.assertEqual(expected, game.event_queue[id2][0].parameters)
        expected = {
            "name": "movePlayer",
            "spaces": roll.total
        }
        self.assertEqual(expected, game.event_queue[id2][1].parameters)
        expected = {
            "name": "showTax",
            "amount": game.tiles[38].amount,
            "tileId": 38
        }
        self.assertEqual(expected, game.event_queue[id2][2].parameters)
        expected = {"name": "promptEndTurn"}
        self.assertEqual(expected, game.event_queue[id2][3].parameters)
        game.end_turn(id2)
        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Have a player pass go when rolling and verify it increments their money.
        player.turns_in_jail = 0
        player.location = 37
        roll = Roll(1, 2)
        self.assertTrue(game.roll_dice(id1, roll))
        self.assertEqual(START_LOCATION, player.location)
        self.assertEqual(STARTING_MONEY + GO_MONEY, player.money)

    def test_buy_property(self):
        game: Game = Game()
        id1: str = game.register_player("player1")
        id2: str = game.register_player("player2")
        mediterranean: ImprovableTile = game.tiles[1]
        baltic: ImprovableTile = game.tiles[3]
        # Verify game must be started before property can be bought
        self.assertFalse(game.buy_property(id1, 3))
        self.assertIsNone(baltic.owner)
        game.start_game(id1)
        id1, id2 = game.turn_order
        player1: Player = game.players[id1]
        player2: Player = game.players[id2]
        ids: list[str] = [id1, id2]
        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Verify non-active player cannot buy a property
        self.assertFalse(game.buy_property(id2, 3))
        # Verify nothing changed
        for id in ids:
            self.assertEqual(0, len(game.event_queue[id]))
        self.assertEqual(0, len(game.event_history))

        # Buy Baltic avenue, verify it subtracted funds and added to player assets
        self.assertTrue(game.buy_property(id1, 3))
        self.assertIs(player1, baltic.owner)
        self.assertEqual(STARTING_MONEY - baltic.price, player1.money)
        self.assertIn(baltic, player1.assets)
        # Verify a showPurchase event was created
        for id in ids:
            self.assertEqual(1, len(game.event_queue[id]))
            self.assertEqual("showPurchase", game.event_queue[id][-1].parameters["name"])
            self.assertEqual(3, game.event_queue[id][-1].parameters["tileId"])
        self.assertEqual(1, len(game.event_history))

        # Verify property cannot be bought again and that nothing changed
        self.assertFalse(game.buy_property(id1, 3))
        self.assertIs(player1, baltic.owner)
        self.assertEqual(STARTING_MONEY - baltic.price, player1.money)
        self.assertIn(baltic, player1.assets)
        # Verify nothing has changed
        for id in ids:
            self.assertEqual(1, len(game.event_queue[id]))
            self.assertEqual("showPurchase", game.event_queue[id][-1].parameters["name"])
            self.assertEqual(3, game.event_queue[id][-1].parameters["tileId"])
        self.assertEqual(1, len(game.event_history))

        # Verify buying a monopoly updates the property status
        self.assertEqual(PropertyStatus.NO_MONOPOLY, baltic.status)
        self.assertTrue(game.buy_property(id1, 1))
        self.assertIs(player1, mediterranean.owner)
        self.assertEqual(STARTING_MONEY - baltic.price - mediterranean.price, player1.money)
        self.assertIn(mediterranean, player1.assets)
        self.assertEqual(PropertyStatus.MONOPOLY, mediterranean.status)
        self.assertEqual(PropertyStatus.MONOPOLY, baltic.status)
        # Verify purchase is reflected in event queue
        for id in ids:
            self.assertEqual(2, len(game.event_queue[id]))
            self.assertEqual("showPurchase", game.event_queue[id][-1].parameters["name"])
            self.assertEqual(1, game.event_queue[id][-1].parameters["tileId"])
        self.assertEqual(2, len(game.event_history))

        # Verify player cannot buy a property exceeding their money
        player1.money = 0
        boardwalk: ImprovableTile = game.tiles[39]
        self.assertFalse(game.buy_property(id1, 39))
        self.assertIsNone(boardwalk.owner)
        self.assertNotIn(boardwalk, player1.assets)
        self.assertEqual(0, player1.money)

        # Verify player cannot buy a non-asset tile (ex. Free Parking)
        free_parking: Tile = game.tiles[20]
        self.assertFalse(game.buy_property(id1, 20))
        self.assertNotIn(free_parking, player1.assets)
        self.assertEqual(0, player1.money)

        # Verify nothing changed
        for id in ids:
            self.assertEqual(2, len(game.event_queue[id]))
            self.assertEqual("showPurchase", game.event_queue[id][-1].parameters["name"])
            self.assertEqual(1, game.event_queue[id][-1].parameters["tileId"])
        self.assertEqual(2, len(game.event_history))

    def test_improvements(self):
        game: Game = Game()
        game: Game = Game()
        id1: str = game.register_player("player1")
        id2: str = game.register_player("player2")
        game.start_game(id1)
        player_id1, player_id2 = game.turn_order
        ids: list[str] = [player_id1, player_id2]
        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Buy an improvable monopoly, utility monopoly, and railroad monopoly
        improvable_ids: list[int] = [16, 18, 19]
        utility_ids: list[int] = [12, 28]
        railroad_ids: list[int] = [5, 15, 25, 35]
        player: Player = game.players[player_id1]
        player.money = 4000
        for id in improvable_ids + utility_ids + railroad_ids:
            money: int = player.money
            tile: AssetTile = game.tiles[id]
            game.buy_property(player_id1, id)
            self.assertIs(player, tile.owner)
            self.assertIn(tile, player.assets)
            self.assertEqual(money - tile.price, player.money)
        for id in improvable_ids:
            tile: ImprovableTile = game.tiles[id]
            self.assertEqual(PropertyStatus.MONOPOLY, tile.status)

        # Clear out event queue
        for id in ids:
            self.assertEqual(len(improvable_ids) + len(utility_ids) + len(railroad_ids), len(game.event_queue[id]))
            game.event_queue[id] = []
        self.assertEqual(len(improvable_ids) + len(utility_ids) + len(railroad_ids), len(game.event_history))
        game.event_history = []

        # Verify improvements return False on utility and railroad tiles
        for id in utility_ids:
            money = player.money
            tile: UtilityTile = game.tiles[id]
            self.assertEqual(UtilityStatus.MONOPOLY, tile.status)
            self.assertFalse(game.improvements(player_id1, id, 1))
            self.assertEqual(UtilityStatus.MONOPOLY, tile.status)
            self.assertEqual(money, player.money)
        for id in railroad_ids:
            tile: RailroadTile = game.tiles[id]
            self.assertEqual(RailroadStatus.FOUR_OWNED, tile.status)
            self.assertFalse(game.improvements(player_id1, id, 1))
            self.assertEqual(RailroadStatus.FOUR_OWNED, tile.status)
            self.assertEqual(money, player.money)

        # Verify negative improvements return False when there are no existing improvements
        for id in improvable_ids:
            money = player.money
            tile: improvable_ids = game.tiles[id]
            self.assertFalse(game.improvements(player_id1, id, -1))
            self.assertEqual(PropertyStatus.MONOPOLY, tile.status)
            self.assertEqual(money, player.money)

        # Make sure no events were enqueued throughout all those failed improvements
        for player_id in ids:
            self.assertEqual(0, len(game.event_queue[player_id]))
        self.assertEqual(0, len(game.event_history))

        # Verify properties can be upgraded 1-by-1 all the way to max improvements
        for n in range(1, 6):
            for id in improvable_ids:
                money = player.money
                tile: ImprovableTile = game.tiles[id]
                self.assertTrue(game.improvements(player_id1, id, 1))
                self.assertEqual(PropertyStatus.MONOPOLY + n, tile.status)
                self.assertEqual(money - tile.improvement_cost, player.money)
        # Verify each improvement enqueued an event to the players and event history
        for player_id in ids:
            self.assertEqual(5 * len(improvable_ids), len(game.event_queue[player_id]))
            self.assertEqual("showImprovements", game.event_queue[player_id][-1].parameters["name"])
            self.assertEqual(1, game.event_queue[player_id][-1].parameters["number"])
        self.assertEqual(5 * len(improvable_ids), len(game.event_history))

        # Verify non-monopoly property cannot be improved OR degraded
        money = player.money
        baltic: ImprovableTile = game.tiles[3]
        self.assertTrue(game.buy_property(player_id1, 3))
        self.assertIs(player, baltic.owner)
        self.assertIn(baltic, player.assets)
        self.assertEqual(money - baltic.price, player.money)
        self.assertEqual(PropertyStatus.NO_MONOPOLY, baltic.status)
        for n in [-6, -5, -1, 0, 1, 2, 3, 4, 5, 6]:
            self.assertFalse(game.improvements(player_id1, 3, n))
            self.assertIs(player, baltic.owner)
            self.assertIn(baltic, player.assets)
            self.assertEqual(money - baltic.price, player.money)
            self.assertEqual(PropertyStatus.NO_MONOPOLY, baltic.status)
        # Verify nothing changed
        for player_id in ids:
            self.assertEqual(5 * len(improvable_ids) + 1, len(game.event_queue[player_id]))
            # Purchased Baltic avenue
            self.assertEqual("showPurchase", game.event_queue[player_id][-1].parameters["name"])
        self.assertEqual(5 * len(improvable_ids) + 1, len(game.event_history))

        # Degrade ny_ave to MONOPOLY and verify other 2 properties were degraded to ONE_IMPROVEMENT
        money = player.money
        self.assertTrue(game.improvements(player_id1, 19, -5))
        self.assertEqual(PropertyStatus.MONOPOLY, game.tiles[19].status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, game.tiles[18].status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, game.tiles[16].status)
        self.assertEqual(money + (5 + 4 + 4) * 50, player.money)
        # Verify there has been one additional event enqueued.
        for player_id in ids:
            self.assertEqual(5 * len(improvable_ids) + 2, len(game.event_queue[player_id]))
            self.assertEqual("showImprovements", game.event_queue[player_id][-1].parameters["name"])
            self.assertEqual(-5, game.event_queue[player_id][-1].parameters["number"])
        self.assertEqual(5 * len(improvable_ids) + 2, len(game.event_history))

        # Verify other properties cannot be degraded by 2 since it would drop them below MONOPOLY
        money = player.money
        self.assertFalse(game.improvements(player_id1, 18, -2))
        self.assertEqual(PropertyStatus.MONOPOLY, game.tiles[19].status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, game.tiles[18].status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, game.tiles[16].status)
        self.assertEqual(money, player.money)
        # Verify nothing changed.
        for player_id in ids:
            self.assertEqual(5 * len(improvable_ids) + 2, len(game.event_queue[player_id]))
            self.assertEqual("showImprovements", game.event_queue[player_id][-1].parameters["name"])
            self.assertEqual(-5, game.event_queue[player_id][-1].parameters["number"])
        self.assertEqual(5 * len(improvable_ids) + 2, len(game.event_history))

    def test_mortgage(self):
        game: Game = Game()
        id1: str = game.register_player("player1")
        id2: str = game.register_player("player2")
        game.start_game(id1)
        id1, id2 = game.turn_order
        ids: list[str] = [id1, id2]

        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []

        # Shouldn't allow the non-active player to go
        self.assertFalse(game.mortgage(id2, 1, True))
        # Don't allow for invalid tile IDs
        invalid_tile_ids: list[int] = [-5, -1, 40, 45]
        for tile_id in invalid_tile_ids:
            self.assertFalse(game.mortgage(id1, tile_id, True))
        # Don't allow non-property tiles to be mortgaged
        self.assertFalse(game.mortgage(id1, 0, True))

        for id in ids:
            self.assertEqual(0, len(game.event_queue[id]))
        self.assertEqual(0, len(game.event_history))

        # Buy Boardwalk
        player1: Player = game.players[id1]
        boardwalk: AssetTile = game.tiles[39]
        player1.update(BuyUpdate(boardwalk))
        expected_money: int = STARTING_MONEY - boardwalk.price
        self.assertEqual(expected_money, player1.money)
        self.assertIs(player1, boardwalk.owner)
        self.assertIn(boardwalk, player1.assets)
        self.assertFalse(boardwalk.is_mortgaged)
        for id in ids:
            self.assertEqual(0, len(game.event_queue[id]))
        self.assertEqual(0, len(game.event_history))

        # This will do nothing since property is not mortgaged
        game.mortgage(id1, 39, False)
        self.assertEqual(expected_money, player1.money)
        self.assertIs(player1, boardwalk.owner)
        self.assertIn(boardwalk, player1.assets)
        self.assertFalse(boardwalk.is_mortgaged)
        for id in ids:
            self.assertEqual(0, len(game.event_queue[id]))
        self.assertEqual(0, len(game.event_history))

        # This will mortgage the property
        game.mortgage(id1, 39, True)
        expected_money += boardwalk.mortage_price
        self.assertEqual(expected_money, player1.money)
        self.assertIs(player1, boardwalk.owner)
        self.assertIn(boardwalk, player1.assets)
        self.assertTrue(boardwalk.is_mortgaged)
        # Event gets added to the queue
        for id in ids:
            self.assertEqual(1, len(game.event_queue[id]))
            event: Event = game.event_queue[id][-1]
            self.assertEqual("showMortgageChange", event.parameters["name"])
            self.assertEqual(True, event.parameters["mortgaged"])
        self.assertEqual(1, len(game.event_history))
        event: Event = game.event_history[-1]
        self.assertEqual("showMortgageChange", event.parameters["name"])
        self.assertEqual(True, event.parameters["mortgaged"])

        # This will unmortgage the property at 10% interest
        game.mortgage(id1, 39, False)
        expected_money -= boardwalk.lift_mortage_cost
        self.assertEqual(1080, expected_money)
        self.assertEqual(expected_money, player1.money)
        self.assertIs(player1, boardwalk.owner)
        self.assertIn(boardwalk, player1.assets)
        self.assertFalse(boardwalk.is_mortgaged)
        # Event gets added to the queue
        for id in ids:
            self.assertEqual(2, len(game.event_queue[id]))
            event: Event = game.event_queue[id][-1]
            self.assertEqual("showMortgageChange", event.parameters["name"])
            self.assertEqual(False, event.parameters["mortgaged"])
        self.assertEqual(2, len(game.event_history))
        event: Event = game.event_history[-1]
        self.assertEqual("showMortgageChange", event.parameters["name"])
        self.assertEqual(False, event.parameters["mortgaged"])

        # Transition to next player
        game.end_turn(id1)
        # Clear out event queue
        for id in ids:
            game.event_queue[id] = []
        game.event_history = []
        baltic: ImprovableTile = game.tiles[3]
        player2: Player = game.players[id2]
        player2.update(BuyUpdate(baltic))
        self.assertEqual(STARTING_MONEY - baltic.price, player2.money)
        self.assertIs(player1, boardwalk.owner)
        self.assertIn(boardwalk, player1.assets)
        self.assertFalse(boardwalk.is_mortgaged)

        # Verify player1 can't mortgage since it is not their turn
        self.assertFalse(game.mortgage(id1, 39, True))
        self.assertEqual(expected_money, player1.money)
        self.assertIs(player1, boardwalk.owner)
        self.assertIn(boardwalk, player1.assets)
        self.assertFalse(boardwalk.is_mortgaged)
        for id in ids:
            self.assertEqual(0, len(game.event_queue[id]))
        self.assertEqual(0, len(game.event_history))

    def test_get_out_of_jail(self):
        game: Game = Game()
        id1: str = game.register_player("player1")
        id2: str = game.register_player("player2")
        game.start_game(id1)
        id1, id2 = game.turn_order
        ids: list[str] = [id1, id2]
        player: Player = game.players[id1]
        for id in ids:
            game.event_queue[id] = []

        # Verify pre-conditions
        self.assertEqual(STARTING_MONEY, player.money)
        self.assertEqual(START_LOCATION, player.location)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(0, player.doubles_streak)
        for id in ids:
            self.assertEqual(0, len(game.event_queue[id]))

        # Send player to jail and verify it worked
        player.update(GoToJailUpdate())
        self.assertEqual(STARTING_MONEY, player.money)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)
        self.assertEqual(0, player.doubles_streak)

        # Test get out of jail method with a card
        # Nothing should happen since they have no cards
        game.get_out_of_jail(id1, JailMethod.CARD)
        self.assertEqual(STARTING_MONEY, player.money)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(JAIL_TURNS, player.turns_in_jail)
        self.assertEqual(0, player.doubles_streak)
        self.assertEqual(0, len(game.event_queue[id1]))
        self.assertEqual(0, len(game.event_queue[id2]))

        # Give them a get out of jail card and try again
        player.jail_cards += 1
        game.get_out_of_jail(id1, JailMethod.CARD)
        self.assertEqual(STARTING_MONEY, player.money)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(0, player.doubles_streak)
        for id in ids:
            self.assertEqual(1, len(game.event_queue[id]))
            self.assertEqual("showFreeFromJail", game.event_queue[id][0].parameters["name"])

        # Send them back to jail then get them out using money
        player.update(GoToJailUpdate())
        game.get_out_of_jail(id1, JailMethod.MONEY)
        self.assertEqual(STARTING_MONEY + JAIL_COST, player.money)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(0, player.doubles_streak)
        for id in ids:
            self.assertEqual(2, len(game.event_queue[id]))
            for i in range(2):
                self.assertEqual("showFreeFromJail", game.event_queue[id][i].parameters["name"])

        # Send them back to jail then get them out using 'doubles'
        # Note: roll_dice handles DOUBLES condition.
        player.update(GoToJailUpdate())
        game.get_out_of_jail(id1, JailMethod.DOUBLES)
        self.assertEqual(STARTING_MONEY + JAIL_COST, player.money)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(0, player.doubles_streak)
        for id in ids:
            self.assertEqual(3, len(game.event_queue[id]))
            for i in range(3):
                self.assertEqual("showFreeFromJail", game.event_queue[id][i].parameters["name"])

    def test_end_turn(self):
        game: Game = Game()
        id1: str = game.register_player("player1")
        id2: str = game.register_player("player2")
        id3: str = game.register_player("player3")
        game.start_game(id1)
        id1, id2, id3 = game.turn_order
        ids: list[str] = [id1, id2, id3]
        self.assertEqual(game.active_player_id, id1)

        # Clear event queues
        game.event_history = []
        for id in ids:
            game.event_queue[id] = []

        # Nothing should happen since they aren't the active player
        game.end_turn(id2)
        self.assertEqual(game.active_player_id, id1)
        for id in ids:
            self.assertEqual(0, len(game.event_queue[id]))
        self.assertEqual(0, len(game.event_history))

        # Progresses the next player
        game.end_turn(id1)
        self.assertEqual(game.active_player_id, id2)

        # Ensure the endTurn and startTurn events are correctly enqueued
        expected_end: dict = {
            "name": "endTurn",
            "player": game.players[id1].display_name
        }
        expected_start: dict = {
            "name": "startTurn",
            "player": game.players[id2].display_name
        }
        for id in [id1, id3]:
            self.assertEqual(2, len(game.event_queue[id]))  # Two events for the player ending the turn
            self.assertEqual(expected_end, game.event_queue[id][0].parameters)
            self.assertEqual(expected_start, game.event_queue[id][1].parameters)
        self.assertEqual(2, len(game.event_history))


        # Verify next player has 1 additional event for the promptRoll
        self.assertEqual(3, len(game.event_queue[id2]))  # Two events for the player ending the turn
        self.assertEqual("endTurn", game.event_queue[id2][0].parameters["name"])
        self.assertEqual("startTurn", game.event_queue[id2][1].parameters["name"])
        self.assertEqual("promptRoll", game.event_queue[id2][2].parameters["name"])

        # Does nothing since they aren't the active player
        game.end_turn(id1)
        self.assertEqual(game.active_player_id, id2)

        # Ensure no additional events are enqueued
        self.assertEqual(2, len(game.event_queue[id1]))
        self.assertEqual(3, len(game.event_queue[id2]))
        self.assertEqual(2, len(game.event_queue[id3]))

        game.end_turn(id2)
        self.assertEqual(game.active_player_id, id3)

        # Make sure it wraps back around properly
        game.end_turn(id3)
        self.assertEqual(game.active_player_id, id1)

    def test_reset(self):
        game: Game = Game()
        # Register 8 players
        for i in range(1, MAX_NUM_PLAYERS + 1):
            display_name: str = f"test{i}"
            id: str = game.register_player(display_name)
        self.assertEqual(MAX_NUM_PLAYERS, len(game.players))
        # Verify reset doesn't work without valid ID
        self.assertFalse(game.reset("bogus"))
        self.assertEqual(MAX_NUM_PLAYERS, len(game.players))
        # Game hasn't started and so it cannot be reset
        self.assertFalse(game.reset(id))
        # Start the game then verify it can be reset
        game.start_game(id)
        self.assertTrue(game.started)
        self.assertTrue(game.reset(id))
        self.assertEqual(0, len(game.players))

    """ Test Private Helper Methods """

    def test_enqueue_event(self):
        game: Game = Game()
        # Add players and start the game without calling that method
        player1: Player = Player("player1", "Player 1")
        player2: Player = Player("player2", "Player 2")
        game.players = {
            "player1": player1,
            "player2": player2
        }
        game.event_queue = {
            "player1": [],
            "player2": []
        }
        game._players.extend([player1, player2])
        game.turn_order = ["player1", "player2"]
        game.active_player_id = "player1"
        game.active_player_idx = 0
        game.started = True

        # Test enqueueing an event without a "name" field.
        event: Event = Event({})
        game._enqueue_event(event, EventType.STATUS)
        for id in game.turn_order:
            self.assertEqual(0, len(game.event_queue[id]))
        event = Event({"name": "event"})
        # Test enqueueing a valid STATUS event that players see but is not stored in game history.
        game._enqueue_event(event, EventType.STATUS)
        self.assertEqual(0, len(game.event_history))
        for id in game.turn_order:
            self.assertEqual(1, len(game.event_queue[id]))
            self.assertIs(event, game.event_queue[id][0])
            # Clear out queue to stage for next text
            game.event_queue[id] = []

        # Test enqueueing a valid UPDATE event which goes to players and the game history.
        game._enqueue_event(event, EventType.UPDATE)
        self.assertEqual(1, len(game.event_history))
        for id in game.turn_order:
            self.assertEqual(1, len(game.event_queue[id]))
            self.assertIs(event, game.event_queue[id][0])
            # Clear out queue to stage for next text
            game.event_queue[id] = []

        # Test enqueueing a valid PROMPT event which only goes to the active player.
        game.event_history = []
        game._enqueue_event(event, EventType.PROMPT)
        self.assertEqual(0, len(game.event_history))
        self.assertEqual(1, len(game.event_queue["player1"]))
        self.assertEqual(0, len(game.event_queue["player2"]))
        game.event_queue["player1"] = []

        # Test adding another event and verify the order is as expected
        event1 = Event({"name": "event1"})
        event2 = Event({"name": "event2"})
        game._enqueue_event(event1, EventType.STATUS)
        game._enqueue_event(event2, EventType.STATUS)

        expected_order = [event1, event2]
        for id in game.turn_order:
            self.assertEqual(expected_order, game.event_queue[id])
            game.event_queue[id] = []

        # Test enqueueing an event with a specific target player
        target_event = Event({"name": "targetEvent"})
        game._enqueue_event(target_event, EventType.STATUS, target="player2")
        self.assertEqual(1, len(game.event_queue["player2"]))
        self.assertIs(target_event, game.event_queue["player2"][0])

    def test_apply_updates(self):
        game: Game = Game()
        # Verify apply updates doesn't work before the game started
        self.assertFalse(game._apply_updates({}))
        self.assertFalse(game._apply_updates({"notreal": MoneyUpdate(50)}))
        id1: str = game.register_player("player1")
        id2: str = game.register_player("player2")
        # Nothing changes when applying updates to valid player when game hasn't started
        self.assertEqual(STARTING_MONEY, game.players[id1].money)
        self.assertFalse(game._apply_updates({id1: MoneyUpdate(50)}))
        self.assertEqual(STARTING_MONEY, game.players[id1].money)
        game.start_game(id1)
        self.assertTrue(game._apply_updates({id1: MoneyUpdate(50),
                                             id2: MoneyUpdate(-50)}))
        self.assertEqual(STARTING_MONEY + 50, game.players[id1].money)
        self.assertEqual(STARTING_MONEY - 50, game.players[id2].money)
        self.assertFalse(game._apply_updates({"notreal": MoneyUpdate(50),
                                              id2: MoneyUpdate(-50)}))

    def test_valid_player(self):
        game: Game = Game()
        self.assertFalse(game._valid_player("", require_active_player=True,  require_game_started=False))
        self.assertFalse(game._valid_player("", require_active_player=False, require_game_started=False))
        self.assertFalse(game._valid_player("", require_active_player=False, require_game_started=True))
        valid_id: str = game.register_player("test")
        # Game hasn't started so there is no active player ID but the player has been created
        self.assertFalse(game._valid_player(valid_id, require_active_player=True, require_game_started=False))
        self.assertTrue(game._valid_player(valid_id, require_active_player=False, require_game_started=False))
        self.assertFalse(game._valid_player(valid_id, require_active_player=False, require_game_started=True))
        valid_id2: str = game.register_player("test2")
        self.assertTrue(game.start_game(valid_id2))
        # Start the game and verify require active player works
        id1, id2 = game.turn_order
        self.assertTrue(game._valid_player(id1, require_active_player=True, require_game_started=False))
        self.assertTrue(game._valid_player(id1, require_active_player=True, require_game_started=True))
        self.assertFalse(game._valid_player(id2, require_active_player=True, require_game_started=False))
        self.assertFalse(game._valid_player(id2, require_active_player=True, require_game_started=True))

    def test_next_player(self):
        game: Game = Game()
        # Game hasn't started yet and there are no players
        self.assertFalse(game._next_player())
        # Populate the game with players
        ids: list[str] = []
        for i in range(1, MAX_NUM_PLAYERS + 1):
            display_name: str = f"test{i}"
            id: str = game.register_player(display_name)
            ids.append(id)
        # Game hasn't started yet. Cannot get the next player.
        self.assertFalse(game._next_player())
        game.start_game(id)
        # Note: This test fails with very low odds when the randomized order is also the order players joined
        self.assertFalse(ids == game.turn_order)
        # Increment the player in 2 loops and verify it properly wraps around
        for i in range(2 * MAX_NUM_PLAYERS):
            self.assertEqual(game.turn_order[i % MAX_NUM_PLAYERS], game.active_player_id)
            self.assertTrue(game._next_player())
        # Set the player at index 1 to inactive and verify it skips him
        id = game.turn_order[1]
        game.players[id].status = PlayerStatus.BANKRUPT
        self.assertEqual(game.turn_order[0], game.active_player_id)
        self.assertTrue(game._next_player())
        self.assertEqual(game.turn_order[2], game.active_player_id)
        # Set all but 2 to be inactive
        game.players[id].status = PlayerStatus.GOOD
        for i in range(2, MAX_NUM_PLAYERS):
            id = game.turn_order[i]
            game.players[id].status = PlayerStatus.BANKRUPT
        game.active_player_idx = 0
        game.active_player_id = game.turn_order[0]
        # Make sure it just loops between the same two people
        for i in range(3):
            self.assertTrue(game._next_player())
            self.assertEqual(game.turn_order[1], game.active_player_id)
            self.assertTrue(game._next_player())
            self.assertEqual(game.turn_order[0], game.active_player_id)
        # Make it just a single player left and verify it returns False
        id = game.turn_order[1]
        game.players[id].status = PlayerStatus.BANKRUPT
        self.assertFalse(game._next_player())


if __name__ == '__main__':
    unittest.main()
