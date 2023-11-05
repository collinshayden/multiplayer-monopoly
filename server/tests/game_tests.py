"""
Description:    Test suite used to verify Game class functionality.
Author:         Jordan Bourdeau
Date:           10/24/23
"""

from server.game_logic.constants import MAX_NUM_PLAYERS, PLAYER_ID_LENGTH, STARTING_MONEY
from server.game_logic.game import Game
from server.game_logic.types import PlayerStatus

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

    def test_draw_card(self):
        game: Game = Game()

    def test_buy_property(self):
        game: Game = Game()

    def test_buy_improvements(self):
        game: Game = Game()

    def test_sell_improvements(self):
        game: Game = Game()

    def test_mortgage(self):
        game: Game = Game()

    def test_unmortgage(self):
        game: Game = Game()

    def test_get_out_of_jail(self):
        game: Game = Game()

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

    def test_apply_update(self):
        pass

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
