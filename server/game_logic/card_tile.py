"""
Description:    Class representing a chance/community chest tile.
Date:           11/5/2023
Author:         Jordan Bourdeau
"""

from .cards import Card
from .deck import Deck
from .player import Player
from .roll import Roll
from .tile import Tile


class CardTile(Tile):

    def __init__(self, id: int, name: str, deck: Deck, players: list[Player]) -> None:
        """
        Description:    Class representing a Tile on the board.
        :param id:      An integer identifier for each tile.
        :returns:       None.
        """
        super().__init__(id, name)
        self.deck: Deck = deck
        self.players: list[Player] = players

    def land(self, player: Player, roll: Roll = None) -> dict:
        """
        Description:    Method which will be overridden in subclasses.
        :param player:  Player landing on the tile.
        :param roll:    Roll from the player (only used in Utility tiles).
        :return:        Dictionary mapping player IDs to PlayerUpdate objects.
        """
        card: Card = self.deck.draw()
        return card.on_draw(player, self.players)
