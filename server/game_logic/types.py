"""
Description:    Types (namely enums) used throughout sections of code.
Author:         Jordan Bourdeau
Date:           10/24/23
"""

from enum import Enum, IntEnum


class EventType(IntEnum):
    """
    Description:    Enumeration for the types of possible events. Will send certain events to all
                    player queues (ex. INFORMATION) and others to only select players (ex. PROMPT).
    STATUS:         Event type for something all players should see (ex. showRoll).
    PROMPT:         Event type which expects a prompt that only the active player should see.
    UPDATE:         Event type for an event all players should see, but should also be recorded in the history.
    """
    STATUS = 0
    PROMPT = 1
    UPDATE = 2


class CardType(IntEnum):
    """
    Description:     Enumeration for potential card types.
    CHANCE:          Chance card.
    COMMUNITY_CHEST: Community chest card.
    INVALID:         Undefined state. Should never be reached.
    """
    CHANCE = 0
    COMMUNITY_CHEST = 1
    INVALID = 2


class JailMethod(IntEnum):
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


class PlayerStatus(IntEnum):
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
    INVALID = 3


class PropertyStatus(IntEnum):
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


class RailroadStatus(IntEnum):
    """
    Description:    Enumeration for the number of owned railroads.
    #_OWNED:        Corresponds to the number of railroad tiles owned.
    """
    UNOWNED = 0
    ONE_OWNED = 1
    TWO_OWNED = 2
    THREE_OWNED = 3
    FOUR_OWNED = 4


class UtilityStatus(IntEnum):
    """
    Description:    Enumeration for the number of owned utilities.
    #_OWNED:        Corresponds to the number of utility tiles owned
    """
    NO_MONOPOLY = 0
    MONOPOLY = 1


class AssetGroups(IntEnum):
    """
    Description:    Enumeration of groups AssetTile objects can be part of.
    """
    UTILITY = 0
    RAILROAD = 1
    BROWN = 2
    LIGHT_BLUE = 3
    PINK = 4
    ORANGE = 5
    RED = 6
    YELLOW = 7
    GREEN = 8
    DARK_BLUE = 9

