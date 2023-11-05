"""
Description:    Class representing the central Game object.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .asset_tile import AssetTile
from .improvable_tile import ImprovableTile
from .go_tile import GoTile
from .go_to_jail_tile import GoToJailTile
from .railroad_tile import RailroadTile
from .tile import Tile
from .utility_tile import UtilityTile
from .card import Card
from .constants import (JAIL_COST, INCOME_TAX, LUXURY_TAX, MAX_DIE, MIN_DIE, MAX_NUM_PLAYERS, MIN_NUM_PLAYERS,
                        NUM_TILES, PLAYER_ID_LENGTH, START_LOCATION)
from .player import Player
from .player_updates import (BuyUpdate, ImprovementUpdate, LeaveJailUpdate, MoneyUpdate, MortgageUpdate, PlayerUpdate,
                             RollUpdate)
from .roll import Roll
from .tax_tile import TaxTile
from .tile import Tile
from .types import AssetGroups, CardType, JailMethod, PlayerStatus, PropertyStatus
from .utility_tile import UtilityTile


import random
import secrets
import string


class Game:

    def __init__(self) -> None:
        """
        Description:    Main class holding all the game state used for managing game logic.
        :returns:       None.
        """
        self.started: bool = False
        self.players: dict[str: Player] = {}
        self.turn_order: list[str] = []
        self.active_player_idx: int = -1
        self.active_player_id: str = ""
        self.tiles: list[Tile] = self._make_board()
        self.community_deck: list[Card] = []
        self.chance_deck: list[Card] = []

    """ Exposed API Methods """

    def start_game(self, player_id: str) -> bool:
        """
        Description:        Method used to start the game with the currently active players (must be >= 2 and <= max).
        :param player_id:   ID of the player making the request.
        :return:            Boolean value if the game is successfully started.
        """
        if not self._valid_player(player_id, require_active_player=False) or self.started:
            return False
        elif MIN_NUM_PLAYERS <= len(self.players) <= MAX_NUM_PLAYERS:
            self.started = True
            # Shuffle turn order and set active player idx/id
            random.shuffle(self.turn_order)
            self.active_player_idx = 0
            self.active_player_id = self.turn_order[0]
            return True
        return False

    def register_player(self, display_name: str) -> str:
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
        self.players[player_id] = Player(id=player_id, display_name=display_name)
        self.turn_order.append(player_id)
        return player_id

    def roll_dice(self, player_id: str) -> bool:
        """
        Description:        Method for rolling the dice.
        :param player_id:   ID of the player making the request.
        :return:            True if the request succeeds. False otherwise.
        """
        # Reject requests when there are not enough players
        if len(self.players) < MIN_NUM_PLAYERS:
            return False
        if not self._valid_player(player_id, require_game_started=True):
            return False
        player: Player = self.players[self.active_player_id]
        roll: Roll = Roll(random.randint(MIN_DIE, MAX_DIE), random.randint(MIN_DIE, MAX_DIE))
        # Move the player
        player.update(RollUpdate(roll))
        # Get updates from the tile then apply them
        updates: dict[str: PlayerUpdate] = self.tiles[player.location].land(player, roll)
        self._apply_updates(updates)
        return player.status != PlayerStatus.INVALID

    # TODO: Impelement this function and the corresponding test.
    def draw_card(self, player_id: str, card_type: CardType) -> bool:
        """
        Description:        Method for rolling the dice.
        :param player_id:   ID of the player making the request.
        :param card_type:   Type of card being drawn.
        :return:            True if the request succeeds. False otherwise.
        """
        # Player ID isn't valid
        if not self._valid_player(player_id):
            return False
        # Card type isn't valid
        if card_type == CardType.INVALID:
            return False

        # TODO: Implement surrounding functionality and uncomment this.
        # Check that the tile they are on is a valid chance/community chest tile
        tile: Tile = self.tiles[self.players[player_id]]
        # match card_type:
        #     case CardType.CHANCE:
        #         if not isinstance(tile, Chance):
        #             return False
        #     case CardType.COMMUNITY_CHEST:
        #         if not isinstance(tile, CommunityChest):
        #             return False

        # TODO: Implement a "deck mechanism" here

        return True

    def buy_property(self, player_id: str, tile_id: int) -> bool:
        """
        Description:        Method used for the active player to buy a property.
        :param player_id:   ID of the player making the request.
        :param tile_id:     Integer ID for the tile being bought.
        :return:            True if the request succeeds. False otherwise.
        """
        # Player must be vai\lid (active player)
        if not self._valid_player(player_id):
            return False
        # Tile ID must be valid
        elif tile_id < START_LOCATION or tile_id >= NUM_TILES:
            return False
        tile: Tile = self.tiles[tile_id]
        player: Player = self.players[player_id]
        # Must be an AssetTile in order to buy it
        if not isinstance(self.tiles[tile_id], AssetTile):
            return False
        # Tile cannot be already owned
        if tile.owner is not None:
            return False
        # Only AssetTile objects can be purchased
        elif not isinstance(tile, AssetTile):
            return False
        # Player must have the funds to purchase the tile
        elif tile.price > player.money:
            return False
        # Player cannot
        player.update(BuyUpdate(tile))
        return True

    def improvements(self, player_id: str, tile_id: int, amount: int) -> bool:
        """
        Description:        Method used to buy improvements to a property.
        :param player_id:   ID of the player making the request.
        :param tile_id:     Integer ID for the tile being bought.
        :param amount:      Number of improvements to buy/sell.
        :return:            True if the request succeeds. False otherwise.
        """
        # Player ID is not the valid, active player.
        if not self._valid_player(player_id):
            return False
        # Invalid tile targeted for improvements.
        elif tile_id < START_LOCATION or tile_id >= NUM_TILES:
            return False
        tile: Tile = self.tiles[tile_id]
        # Only ImprovableTile objects can be upgraded
        if not isinstance(tile, ImprovableTile):
            return False
        # Property must be a monopoly
        if tile.status < PropertyStatus.MONOPOLY:
            return False
        # Number of upgrades could not bring property status below MONOPOLY or above FIVE_IMPROVEMENTS
        if (tile.status + amount) > PropertyStatus.FIVE_IMPROVEMENTS or (tile.status + amount) < PropertyStatus.MONOPOLY:
            return False
        player: Player = self.players[player_id]
        player.update(ImprovementUpdate(tile, amount))
        return True

    def mortgage(self, player_id: str, tile_id: int, mortgage: bool) -> bool:
        """
        Description:        Method for the active player to mortgage a property.
        :param player_id:   ID of the player making the request.
        :param tile_id:     Integer ID for the tile being bought.
        :param mortgage:    Boolean flag for if the player is mortgaging/unmortgaging (T = mortgage and vice versa).
        :return:            True if the request succeeds. False otherwise.
        """
        # Player ID is not the valid, active player.
        if not self._valid_player(player_id):
            return False
        # Invalid tile targeted for improvements.
        elif tile_id < START_LOCATION or tile_id >= NUM_TILES:
            return False
        tile: Tile = self.tiles[tile_id]
        player: Player = self.players[player_id]
        # Only AssetTile objects can be mortgaged
        if not isinstance(tile, AssetTile):
            return False
        # Tile must be owner
        elif tile.owner is not player:
            return False
        # Tile mortgage status can't match what is passed in
        elif tile.is_mortgaged == mortgage:
            return False
        player.update(MortgageUpdate(tile, mortgage))
        return True

    def get_out_of_jail(self, player_id: str, method: JailMethod) -> bool:
        """
        Description:        Method which is used to get a user out of jail.
        :param player_id:   ID for the player making the request.
        :param method:      The method being used to get out of jail.
        :return:            True if the request succeeds. False otherwise.
        """
        if not self._valid_player(player_id):
            return False
        player: Player = self.players[player_id]
        # If the player is not in jail, return False
        if not player.in_jail:
            return False
        # If the method is CARD but the player has no get out of jail cards return Fasle
        elif method == JailMethod.CARD and player.jail_cards == 0:
            return False
        player.update(LeaveJailUpdate(method))
        return True

    def end_turn(self, player_id: str) -> bool:
        """
        Description:        Method for ending the active player's turn.
        :param player_id:   ID of the player making the request.
        :return:            True if the request succeeds. False otherwise.
        """
        if not self._valid_player(player_id):
            return False
        self._next_player()
        return True

    def reset(self, player_id: str) -> bool:
        """
        Description:        Method for resetting the game.
        :param player_id:   ID of the player making the request.
        :return:            True if the request succeeds. False otherwise.
        """
        if not self._valid_player(player_id, require_active_player=False, require_game_started=True):
            return False
        self.__init__()
        return True

    """ Private Helper Methods """

    def _make_board(self) -> list[Tile]:
        """
        Description:    Method for creating the board tiles from scratch.
        :return:        List of tiles corresponding to the Monopoly board.
        """
        # TODO: Incorporate chance/community chest tiles
        # TODO: Incorporate tax tiles
        tiles: list[Tile] = [
            GoTile(),
            ImprovableTile(1, "Mediterranean Avenue", 60, AssetGroups.BROWN),
            Tile(2, "Community Chest"),
            ImprovableTile(3, "Baltic Avenue", 60, AssetGroups.BROWN),
            TaxTile(4, "Income Tax", INCOME_TAX),
            RailroadTile(5, "Reading Railroad"),
            ImprovableTile(6, "Oriental Avenue", 100, AssetGroups.LIGHT_BLUE),
            Tile(7, "Chance"),
            ImprovableTile(8, "Vermont Avenue", 100, AssetGroups.LIGHT_BLUE),
            ImprovableTile(9, "Connecticut Avenue", 120, AssetGroups.LIGHT_BLUE),
            Tile(10, "Jail"),
            ImprovableTile(11, "St. Charles Place", 140, AssetGroups.PINK),
            UtilityTile(12, "Electric Company"),
            ImprovableTile(13, "States Avenue", 140, AssetGroups.PINK),
            ImprovableTile(14, "Virginia Avenue", 160, AssetGroups.PINK),
            RailroadTile(15, "Pennsylvania Railroad"),
            ImprovableTile(16, "St. James Place", 180, AssetGroups.ORANGE),
            Tile(17, "Community Chest"),
            ImprovableTile(18, "Tennessee Avenue", 180, AssetGroups.ORANGE),
            ImprovableTile(19, "New York Avenue", 200, AssetGroups.ORANGE),
            Tile(20, "Free Parking"),
            ImprovableTile(21, "Kentucky Avenue", 220, AssetGroups.RED),
            Tile(22, "Chance"),
            ImprovableTile(23, "Indiana Avenue", 220, AssetGroups.RED),
            ImprovableTile(24, "Illinois Avenue", 240, AssetGroups.RED),
            RailroadTile(25, "B & O Railroad"),
            ImprovableTile(26, "Atlantic Avenue", 260, AssetGroups.YELLOW),
            ImprovableTile(27, "Ventnor Avenue", 260, AssetGroups.YELLOW),
            UtilityTile(28, "Water Works"),
            ImprovableTile(29, "Marvin Gardens", 280, AssetGroups.YELLOW),
            GoToJailTile(),
            ImprovableTile(31, "Pacific Avenue", 300, AssetGroups.GREEN),
            ImprovableTile(32, "North Carolina Avenue", 300, AssetGroups.GREEN),
            Tile(33, "Community Chest"),
            ImprovableTile(34, "Pennsylvania Avenue", 320, AssetGroups.GREEN),
            RailroadTile(35, "Short Line Railroad"),
            Tile(36, "Chance"),
            ImprovableTile(37, "Park Place", 350, AssetGroups.DARK_BLUE),
            TaxTile(38, "Luxury Tax", LUXURY_TAX),
            ImprovableTile(39, "Boardwalk", 400, AssetGroups.DARK_BLUE),
        ]
        return tiles

    def _apply_updates(self, deltas: dict[str, PlayerUpdate]) -> bool:
        """
        Description:    Private method used to apply PlayerUpdates to marked player IDs.
        :param deltas:  Dictionary mapping player IDs to an update object.
        :return:        True if the method succeeds. False if there are any invalid keys.
        """
        # Verify game has started
        if not self.started:
            return False
        delta_ids: set[str] = set([key for key in deltas.keys()])
        player_ids: set[str] = set([key for key in self.players.keys()])
        # All players who updates are being applied to must be a subset of valid players
        if not delta_ids.issubset(player_ids):
            return False
        # Apply all updates
        for id, update in deltas.items():
            self.players[id].update(update)
        return True

    def _valid_player(self, player_id: str, require_active_player: bool = True,
                      require_game_started: bool = False) -> bool:
        """
        Description:                    Method which checks to see if a player ID is valid to be making a move
        (is active player).
        :param player_id:               Unique string player ID.
        :param require_active_player:   Boolean for if the function requires the player to be the active player as
                                        opposed to just being a player in the game.
        :param require_game_started:    Boolean value for whether the game must have already been started for an action.
        :return:                        Boolean value for if the player is valid to be making a move.
        """
        # Checks that the player is the active player or in the list of players depending on boolean flag
        if require_active_player and self.active_player_id != player_id:
            return False
        elif player_id not in self.players.keys():
            return False
        # Check if the game has started if the boolean flag is active
        if require_game_started and not self.started:
            return False
        # Otherwise, return True and permit the action
        return True

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
            "started": self.started,
            "activePlayerId": self.active_player_id,
            "players": [player.to_dict() for player in self.players.values()],
            "tiles": [tile.to_dict() for tile in self.tiles]
        }
