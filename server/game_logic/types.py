"""
Description:    Types (namely enums) used throughout sections of code.
Author:         Jordan Bourdeau
Date:           10/24/23
"""

from enum import Enum


class CardType(Enum):
    """
    Description:     Enumeration for potential card types.
    CHANCE:          Chance card.
    COMMUNITY_CHEST: Community chest card.
    INVALID:        Undefined state. Should never be reached.
    """
    CHANCE = 0
    COMMUNITY_CHEST = 1
    INVALID = 2


class JailMethod(Enum):
    """
    Description:    Enumeration for potential methods to get out of jail
    DOUBLES:        Player rolled doubles
    MONEY:          Player is paying the $50 to get out.
    CARD:           Player is using a get out of jail free card.
    INVALID:        Undefined state. Should never be reached.
    """
    DOUBLES = 0
    MONEY = 1
    CARD = 2
    INVALID = 3


class PlayerStatus(Enum):
    """
    Description:    Enumeration of potential player statuses.
    GOOD:           Player status is normal
    BANKRUPT:       Player has ran out of money.
    IN_THE_HOLE:    Player is not bankrupt yet, but must sell properties to stay afloat.
    INVALID:        Undefined state. Should never be reached.
    """
    GOOD = 0
    BANKRUPT = 1
    IN_THE_HOLE = 2
    INVALID = 4


class PropertyStatus(Enum):
    """
    Description:    Enumeration of potential rents for properties
    NO_MONOPOLY:    base rent
    MONOPOLY:       rent when all properties in a group are owned
    #_IMPROVEMENTS: rent for the number of houses built on the property (1-5)
    """
    NO_MONOPOLY = 0
    MONOPOLY = 1
    ONE_IMPROVEMENT = 2
    TWO_IMPROVEMENTS = 3
    THREE_IMPROVEMENTS = 4
    FOUR_IMPROVEMENTS = 5
    FIVE_IMPROVEMENTS = 6

