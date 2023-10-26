"""
Description:    Class representing the central Game object.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .buyable_tile import BuyableTile
from .card import Card
from .constants import MAX_NUM_PLAYERS, MIN_NUM_PLAYERS, PLAYER_ID_LENGTH
from .player import Player
from .tile import Tile
from .types import CardType, JailMethod

import random
import secrets
import string


class Game:

    def __init__(self) -> None:
        """
        Description:    Main class holding all the game state used for managing game logic.
        :returns:       None.
        """
        self.last_roll: tuple[int, int] = None, None
        self.started: bool = False
        self.players: dict[str: Player] = {}
        self.turn_order: list[str] = []
        self.active_player_idx: int = -1
        self.active_player_id: str = ""
        self.tiles: list[Tile] = []
        self.community_deck: list[Card] = []
        self.chance_deck: list[Card] = []

    """ Exposed API Methods """

    def start_game(self, player_id: str) -> bool:
        """
        Description:        Method used to start the game with the currently active players (must be >= 2 and <= max).
        :param player_id:   ID of the player making the request.
        :return:            Boolean value if the game is successfully started.
        """
        if self.started:
            return False
        elif MIN_NUM_PLAYERS <= len(self.players) <= MAX_NUM_PLAYERS and player_id in self.players.keys():
            self.started = True
            # Shuffle turn order and set active player idx/id
            random.shuffle(self.turn_order)
            self.active_player_idx = 0
            self.active_player_id = self.turn_order[0]
            return True
        return False

    def register_player(self, username: str) -> str:
        """
        Description:    Method used to register a player and return their player ID. Doesn't allow players to be
                        added once the game has started.
        :return:        Player ID generated or the empty string if player cap has been reached.
        """
        if len(self.players) == MAX_NUM_PLAYERS or self.started:
            return ""
        # Keep generating random 16-character hex strings until one is not taken
        character_set: str = string.ascii_lowercase + string.digits
        player_id: str = "".join(secrets.choice(character_set) for _ in range(PLAYER_ID_LENGTH))
        while self.players.get(player_id, None) is not None:
            player_id = "".join(secrets.choice(character_set) for _ in range(PLAYER_ID_LENGTH))
        self.players[player_id] = Player(player_id=player_id, username=username)
        self.turn_order.append(player_id)
        return player_id

    def roll_dice(self, player_id: str) -> bool:
        """
        Description:        Method for rolling the dice.
        :param player_id:   ID of the player making the request.
        :return:            True if the request succeeds. False otherwise.
        """
        # Reject requests when there are no players or if the request is made from the wrong player.
        if len(self.players) < MIN_NUM_PLAYERS or player_id != self.active_player_id:
            return False
        player: Player = self.players[self.active_player_id]
        return player.roll_dice()

    def draw_card(self, player_id: str, card_type: CardType) -> bool:
        """
        Description:        Method for rolling the dice.
        :param player_id:   ID of the player making the request.
        :param card_type:   Type of card being drawn.
        :return:            True if the request succeeds. False otherwise.
        """
        if player_id != self.active_player_id:
            return False
        # TODO: Fill in body
        return True

    def buy_property(self, player_id: str, property: str) -> bool:
        """
        Description:        Method used for the active player to buy a property.
        :param player_id:   ID of the player making the request.
        :param property:    String representation of the property.
        :return:            True if the request succeeds. False otherwise.
        """
        if player_id != self.active_player_id:
            return False
        # TODO: Fill in body
        return True

    def buy_improvements(self, player_id: str, property: str, amount: int) -> bool:
        """
        Description:        Method used to buy improvements to a property.
        :param player_id:   ID of the player making the request.
        :param property:    String representation of the property.
        :param amount:      Number of improvements to buy.
        :return:            True if the request succeeds. False otherwise.
        """
        if player_id != self.active_player_id:
            return False
        # TODO: Fill in body
        return True

    def sell_improvements(self, player_id: str, property: str, amount: int) -> bool:
        """
        Description:        Method used to sell improvements on a property.
        :param player_id:   ID of the player making the request.
        :param property:    String representation of the property.
        :param amount:      Number of improvements to sell.
        :return:            True if the request succeeds. False otherwise.
        """
        if player_id != self.active_player_id:
            return False
        # TODO: Fill in body
        return True

    def mortgage(self, player_id: str, property: str) -> bool:
        """
        Description:        Method for the active player to mortgage a property.
        :param player_id:   ID of the player making the request.
        :param property:    String representation of the property.
        :return:            True if the request succeeds. False otherwise.
        """
        if player_id != self.active_player_id:
            return False
        # TODO: Fill in body
        return True

    def unmortgage(self, player_id: str, property: str) -> bool:
        """
        Description:        Method for the active player to pay off a mortgage.
        :param player_id:   ID of the player making the request.
        :param property:    String representation of the property.
        :return:            True if the request succeeds. False otherwise.
        """
        if player_id != self.active_player_id:
            return False
        # TODO: Fill in body
        return True

    def get_out_of_jail(self, player_id: str, method: JailMethod) -> bool:
        """
        Description:        Method which is used to get a user out of jail.
        :param player_id:   ID for the player making the request.
        :param method:      The method being used to get out of jail.
        :return:            True if the request succeeds. False otherwise.
        """
        if player_id != self.active_player_id:
            return False
        # TODO: Fill in body
        return True

    def end_turn(self, player_id: str) -> bool:
        """
        Description:        Method for ending the active player's turn.
        :param player_id:   ID of the player making the request.
        :return:            True if the request succeeds. False otherwise.
        """
        if player_id != self.active_player_id:
            return False
        # TODO: Fill in body
        return True

    def reset(self, player_id: str) -> bool:
        """
        Description:        Method for resetting the game.
        :param player_id:   ID of the player making the request.
        :return:            True if the request succeeds. False otherwise.
        """
        # Only allow a player from a running game to reset it
        if player_id not in self.players.keys() or not self.started:
            return False
        self.__init__()
        return True

    """ Helper Methods """

    # TODO: Implement this.
    def _update_money(self, deltas: dict) -> bool:
        """
        Description:    Private method used to update the money for players.
        :param deltas:  Dictionary mapping player IDs to monetary amount to update by.
        :return:        True if the method succeeds. False if there are any invalid keys.
        """
        if not self.started:
            return False
        player_deltas: list[tuple[Player, int]] = [(self.players.get(id, None), val) for (id, val) in deltas.items()
                                                   if self.players.get(id, None) is not None]
        # Make sure every key matched
        if len(player_deltas) != len(deltas):
            return False
        for player, delta in player_deltas:
            player.update_money(delta)
        return True

    # TODO: Implement this. Returns default Tile() for now.
    def _match_tile(self, tile: str) -> Tile:
        """
        Description:    Private method to match string representations of a tile passed through JSON to the actual
                        object stored in the game state.
        :param tile:    String representation of the tile used in HTTP request.
        :return:        Tile object matched from the string.
        """
        pass

    def _next_player(self) -> bool:
        """
        Description:    Private method responsible for incrementing the active player.
        :return:        Returns True if the next player is found and False otherwise.
        """
        if len(self.players) == 0 or not self.started:
            return False
        idx: int = (self.active_player_idx + 1) % len(self.turn_order)
        id: str = self.turn_order[idx]
        # Keep looping through the array until an active player is found, or it fully wraps around.
        while not self.players[id].active and idx != self.active_player_idx:
            idx = (idx + 1) % len(self.turn_order)
            id = self.turn_order[idx]
        # No other active players!
        if idx == self.active_player_idx:
            return False
        else:
            # Set new active player index and id then return True
            self.active_player_idx = idx
            self.active_player_id = self.turn_order[idx]
            return True

    def to_dict(self) -> dict:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        return {
            "die_1": self.last_roll[0],
            "die_2": self.last_roll[1],
            "started": True,
            "activePlayerId": self.active_player_id,
            "players": [player.to_dict() for player in self.players.values()]
        }
