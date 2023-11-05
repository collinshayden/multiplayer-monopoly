"""
Description:    Class definition for a Card.
Author:         Jordan Bourdeau
Date:           10/22/2023
"""

from .player import Player


class Card:

    def __init__(self, name: str, chance: bool, active: bool, owner: Player) -> None:
        """
        Description:    Class representing a chance/community chest card.
        :param name:    String value for the name/description of the card.
        :param chance:  Boolean value for whether the card belongs to chance or community chest.
        :param owner:   The owner of a card (only for get out fo jail free cards).
        :returns:       None.
        """
        self.name: str = name
        self.chance: bool = chance
        self.active: bool = active
        self.owner: Player = owner
