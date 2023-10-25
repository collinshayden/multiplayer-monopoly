"""
Description:    Class representing the central Game object.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .buyable_tile import BuyableTile
from .card import Card
from .constants import MAX_NUM_PLAYERS, PLAYER_ID_LENGTH
from .player import Player
from .tile import Tile
from .types import CardType, JailMethod

import secrets
import string


class Game:

    def __init__(self) -> None:
        """
        Description:    Main class holding all the game state used for managing game logic.
        :returns:       None.
        """
        self.last_roll: tuple[int, int] = None, None
        self.players: dict[str: Player] = {}
        self.active_player_idx: int = 0
        self.active_player_id: str = ""
        self.tiles: list[Tile] = []
        self.community_deck: list[Card] = []
        self.chance_deck: list[Card] = []

    """ Exposed API Methods """

    def register_player(self, username: str) -> str:
        """
        Description:    Method used to register a player and return their player ID.
        :return:        Player ID generated or the empty string if player cap has been reached.
        """
        if len(self.players) == MAX_NUM_PLAYERS:
            return ""
        # Keep generating random 16-character hex strings until one is not taken
        character_set: str = string.ascii_lowercase + string.digits
        player_id: str = "".join(secrets.choice(character_set) for _ in range(PLAYER_ID_LENGTH))
        while self.players.get(player_id, None) is not None:
            player_id = "".join(secrets.choice(character_set) for _ in range(PLAYER_ID_LENGTH))
        self.players[player_id] = Player(player_id=username, display_name=username)
        return player_id

    def roll_dice(self, player_id: str) -> bool:
        """
        Description:        Method for rolling the dice.
        :param player_id:   ID of the player making the request.
        :return:            True if the request succeeds. False otherwise.
        """
        # Reject requests when there are no players or if the request is made from the wrong player.
        if len(self.players) == 0 or player_id != self.active_player_id:
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
        # TODO: Add actual authentication here. For testing, no auth is needed.
        self.__init__()
        return True

    """ Helper Methods """

    # takes a dict with player_ids as key and change in money as values
    # updates each players' money
    def update_money(self, deltas: dict) -> None:
        """
        Description:    Method used to update the money for players.
        :param deltas:  Changes to make to player money.
        :return:        None.
        """
        pass

    # TODO: Implement this. Returns default Tile() for now.
    def _match_tile(self, tile: str) -> Tile:
        """
        Description:    Private method to match string representations of a tile passed through JSON to the actual
                        object stored in the game state.
        :param tile:    String representation of the tile used in HTTP request.
        :return:        Tile object
        """
        return Tile()

    def _next_player(self) -> None:
        """
        Description:    Private method responsible for incrementing the active player.
        :return:        None.
        """
        if len(self.players) == 0:
            return
        self.active_player_id = (self.active_player_id + 1) % len(self.players)
        while not self.players[self.active_player_id].active:
            self._next_player()

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