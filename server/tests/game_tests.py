"""
Description:    Test suite used to verify Game class functionality.
Author:         Jordan Bourdeau
Date:           10/24/23
"""

from server.game_logic.constants import (CHANCE_TILES, COMMUNITY_CHEST_TILES, MAX_NUM_PLAYERS, NUM_CHANCE_CARDS,
                                         NUM_COMMUNITY_CHEST_CARDS, PLAYER_ID_LENGTH, STARTING_MONEY)
from server.game_logic.game import Game
from server.game_logic.player_updates import *
from server.game_logic.tile import Tile
from server.game_logic.types import CardType, PlayerStatus

import unittest


class GameTests(unittest.TestCase):

    """ Test Exposed API Methods """
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
        # Can't register a player beyond the maximum
        display_name = f"test{MAX_NUM_PLAYERS + 1}"
        id = game.register_player(display_name)
        self.assertTrue(id == "")
        self.assertEqual(MAX_NUM_PLAYERS, len(game.players))

    def test_roll_dice(self):
        game: Game = Game()
        # Can't roll dice when there is < 2 players or the active player ID is invalid
        self.assertFalse(game.roll_dice("bogus"))
        # Get a valid ID and verify it still doesn't let them roll the dice
        display_name: str = "player1"
        id: str = game.register_player(display_name)
        self.assertFalse(game.roll_dice(id))

        # Create a second player and now there are enough to start but the active player ID has not been decided.
        display_name2: str = "player2"
        id2: str = game.register_player(display_name2)
        self.assertFalse(game.roll_dice(id))

        # Start the game and get the turn order
        game.start_game(id2)
        turn_order: list[str] = game.turn_order
        # Can't roll the dice without being the active player
        self.assertFalse(game.roll_dice(turn_order[1]))
        # Can roll the dice as the active player
        self.assertTrue(game.roll_dice(turn_order[0]))

    # TODO: Expand this test once all Card subclasses are implemented
    def test_draw_card(self):
        game: Game = Game()
        id1: str = game.register_player("player1")
        id2: str = game.register_player("player2")
        game.start_game(id1)
        id1, id2 = game.turn_order
        self.assertEqual(NUM_CHANCE_CARDS, len(game.chance_deck.stack))
        self.assertEqual(NUM_COMMUNITY_CHEST_CARDS, len(game.community_chest_deck.stack))
        # Can't draw a card since they aren't on the correct tile type
        self.assertFalse(game.draw_card(id1, CardType.CHANCE))
        self.assertFalse(game.draw_card(id1, CardType.COMMUNITY_CHEST))
        self.assertEqual(NUM_CHANCE_CARDS, len(game.chance_deck.stack))
        self.assertEqual(NUM_COMMUNITY_CHEST_CARDS, len(game.community_chest_deck.stack))

        # Move player to community chest tile and verify they can draw a community chest card
        player: Player = game.players[id1]
        player.location = COMMUNITY_CHEST_TILES[0]
        self.assertFalse(game.draw_card(id1, CardType.CHANCE))
        self.assertTrue(game.draw_card(id1, CardType.COMMUNITY_CHEST))
        self.assertEqual(NUM_CHANCE_CARDS, len(game.chance_deck.stack))
        self.assertEqual(NUM_COMMUNITY_CHEST_CARDS - 1, len(game.community_chest_deck.stack))

        # Move player to chance tile and verify they can draw a chance card
        player.location = CHANCE_TILES[0]
        self.assertTrue(game.draw_card(id1, CardType.CHANCE))
        self.assertFalse(game.draw_card(id1, CardType.COMMUNITY_CHEST))
        self.assertEqual(NUM_CHANCE_CARDS - 1, len(game.chance_deck.stack))
        self.assertEqual(NUM_COMMUNITY_CHEST_CARDS - 1, len(game.community_chest_deck.stack))

        # Draw the rest of the cards and verify the deck gets refilled at the final draw
        for _ in range(NUM_CHANCE_CARDS):
            self.assertTrue(game.draw_card(id1, CardType.CHANCE))
        for card in game.chance_deck.discard:
            self.assertFalse(card.in_use)
        # Deck is refilled since cards are deactivated as they are drawn
        self.assertEqual(NUM_CHANCE_CARDS - 1, len(game.chance_deck.stack))
        for card in game.chance_deck.stack:
            self.assertTrue(card.in_use)

        # Verify non-active player cannot draw a card
        player2: Player = game.players[id2]
        player2.location = COMMUNITY_CHEST_TILES[0]
        self.assertFalse(game.draw_card(id2, CardType.CHANCE))
        self.assertFalse(game.draw_card(id2, CardType.COMMUNITY_CHEST))
        self.assertEqual(NUM_CHANCE_CARDS - 1, len(game.chance_deck.stack))
        self.assertEqual(NUM_COMMUNITY_CHEST_CARDS - 1, len(game.community_chest_deck.stack))

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

        # Verify non-active player cannot buy a property
        self.assertFalse(game.buy_property(id2, 3))

        # Buy Baltic avenue, verify it subtracted funds and added to player assets
        self.assertTrue(game.buy_property(id1, 3))
        self.assertIs(player1, baltic.owner)
        self.assertEqual(STARTING_MONEY - baltic.price, player1.money)
        self.assertIn(baltic, player1.assets)

        # Verify property cannot be bought again and that nothing changed
        self.assertFalse(game.buy_property(id1, 3))
        self.assertIs(player1, baltic.owner)
        self.assertEqual(STARTING_MONEY - baltic.price, player1.money)
        self.assertIn(baltic, player1.assets)

        # Verify buying a monopoly updates the property status
        self.assertEqual(PropertyStatus.NO_MONOPOLY, baltic.status)
        self.assertTrue(game.buy_property(id1, 1))
        self.assertIs(player1, mediterranean.owner)
        self.assertEqual(STARTING_MONEY - baltic.price - mediterranean.price, player1.money)
        self.assertIn(mediterranean, player1.assets)
        self.assertEqual(PropertyStatus.MONOPOLY, mediterranean.status)
        self.assertEqual(PropertyStatus.MONOPOLY, baltic.status)

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

    def test_improvements(self):
        game: Game = Game()
        game: Game = Game()
        id1: str = game.register_player("player1")
        id2: str = game.register_player("player2")
        game.start_game(id1)
        player_id1, player_id2 = game.turn_order
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

        # Verify negative improvements return False when there are no existing improvEments
        for id in improvable_ids:
            money = player.money
            tile: improvable_ids = game.tiles[id]
            self.assertFalse(game.improvements(player_id1, id, -1))
            self.assertEqual(PropertyStatus.MONOPOLY, tile.status)
            self.assertEqual(money, player.money)

        # Verify properties can be upgraded 1-by-1 all the way to max improvements
        for n in range(1, 6):
            for id in improvable_ids:
                money = player.money
                tile: ImprovableTile = game.tiles[id]
                self.assertTrue(game.improvements(player_id1, id, 1))
                self.assertEqual(PropertyStatus.MONOPOLY + n, tile.status)
                self.assertEqual(money - tile.improvement_cost, player.money)

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

        # Degrade ny_ave to MONOPOLY and verify other 2 properties were degraded to ONE_IMPROVEMENT
        money = player.money
        self.assertTrue(game.improvements(player_id1, 19, -5))
        self.assertEqual(PropertyStatus.MONOPOLY, game.tiles[19].status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, game.tiles[18].status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, game.tiles[16].status)
        self.assertEqual(money + (5 + 4 + 4) * 50, player.money)

        # Verify other properties cannot be degraded by 2 since it would drop them below MONOPOLY
        money = player.money
        self.assertFalse(game.improvements(player_id1, 18, -2))
        self.assertEqual(PropertyStatus.MONOPOLY, game.tiles[19].status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, game.tiles[18].status)
        self.assertEqual(PropertyStatus.ONE_IMPROVEMENT, game.tiles[16].status)
        self.assertEqual(money, player.money)


    def test_mortgage(self):
        game: Game = Game()
        id1: str = game.register_player("player1")
        id2: str = game.register_player("player2")
        game.start_game(id1)
        id1, id2 = game.turn_order
        # Shouldn't allow the non-active player to go
        self.assertFalse(game.mortgage(id2, 1, True))
        # Don't allow for invalid tile IDs
        invalid_tile_ids: list[int] = [-5, -1, 40, 45]
        for tile_id in invalid_tile_ids:
            self.assertFalse(game.mortgage(id1, tile_id, True))
        # Don't allow non-property tiles to be mortgaged
        self.assertFalse(game.mortgage(id1, 0, True))

        # Buy Boardwalk
        player1: Player = game.players[id1]
        boardwalk: AssetTile = game.tiles[39]
        player1.update(BuyUpdate(boardwalk))
        expected_money: int = STARTING_MONEY - boardwalk.price
        self.assertEqual(expected_money, player1.money)
        self.assertIs(player1, boardwalk.owner)
        self.assertIn(boardwalk, player1.assets)
        self.assertFalse(boardwalk.is_mortgaged)

        # This will do nothing since property is not mortgaged
        game.mortgage(id1, 39, False)
        self.assertEqual(expected_money, player1.money)
        self.assertIs(player1, boardwalk.owner)
        self.assertIn(boardwalk, player1.assets)
        self.assertFalse(boardwalk.is_mortgaged)

        # This will mortgage the property
        game.mortgage(id1, 39, True)
        expected_money += boardwalk.mortage_price
        self.assertEqual(expected_money, player1.money)
        self.assertIs(player1, boardwalk.owner)
        self.assertIn(boardwalk, player1.assets)
        self.assertTrue(boardwalk.is_mortgaged)

        # This will unmortgage the property at 10% interest
        game.mortgage(id1, 39, False)
        expected_money -= boardwalk.lift_mortage_cost
        self.assertEqual(1080, expected_money)
        self.assertEqual(expected_money, player1.money)
        self.assertIs(player1, boardwalk.owner)
        self.assertIn(boardwalk, player1.assets)
        self.assertFalse(boardwalk.is_mortgaged)

        # Transition to next player
        game.end_turn(id1)
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

    def test_get_out_of_jail(self):
        game: Game = Game()
        id1: str = game.register_player("player1")
        id2: str = game.register_player("player2")
        game.start_game(id1)
        id1, id2 = game.turn_order
        player: Player = game.players[id1]
        # Verify pre-conditions
        self.assertEqual(STARTING_MONEY, player.money)
        self.assertEqual(START_LOCATION, player.location)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(0, player.doubles_streak)
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
        # Give them a get out of jail card and try again
        player.jail_cards += 1
        game.get_out_of_jail(id1, JailMethod.CARD)
        self.assertEqual(STARTING_MONEY, player.money)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(0, player.doubles_streak)
        # Send them back to jail then get them out using money
        player.update(GoToJailUpdate())
        game.get_out_of_jail(id1, JailMethod.MONEY)
        self.assertEqual(STARTING_MONEY + JAIL_COST, player.money)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(0, player.doubles_streak)
        # Send them back to jail then get them out using 'doubles'
        # Note: roll_dice handles DOUBLES condition.
        player.update(GoToJailUpdate())
        game.get_out_of_jail(id1, JailMethod.DOUBLES)
        self.assertEqual(STARTING_MONEY + JAIL_COST, player.money)
        self.assertEqual(JAIL_LOCATION, player.location)
        self.assertEqual(0, player.turns_in_jail)
        self.assertEqual(0, player.doubles_streak)

    def test_end_turn(self):
        game: Game = Game()
        id1: str = game.register_player("player1")
        id2: str = game.register_player("player2")
        id3: str = game.register_player("player3")
        game.start_game(id1)
        id1, id2, id3 = game.turn_order
        self.assertEqual(game.active_player_id, id1)
        # Nothing should happen since they aren't the active player
        game.end_turn(id2)
        self.assertEqual(game.active_player_id, id1)
        # Progresses the next player
        game.end_turn(id1)
        self.assertEqual(game.active_player_id, id2)
        # Does nothing since they aren't the active playerR
        game.end_turn(id1)
        self.assertEqual(game.active_player_id, id2)
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
