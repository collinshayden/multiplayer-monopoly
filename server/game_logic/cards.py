"""
Description:    Base class definition for a Card object.
Author:         Jordan Bourdeau
Date:           10/22/2023
"""

from .player import Player
from .player_updates import PlayerUpdate


class Card:

    def __init__(self, description: str) -> None:
        """
        Description:    Class representing a chance/community chest card.
        :param description:    String value for the description of the card.
        :param deck:    The deck (community chest/chance) that the card belongs to.
        :returns:       None.
        """
        self.description: str = description
        self.in_use: bool = True

    def on_draw(self, owner: Player, players: list[Player]) -> dict[str, PlayerUpdate]:
        self.deactivate()
        return {}

    def reactivate(self) -> None:
        """
        Description:    Method to set in_use to True.
        :return:        None
        """
        self.in_use = True

    def deactivate(self) -> None:
        """
        Description:    Method to set in_use to False.
        :return:        None
        """
        self.in_use = False
