"""
Description:    Types (namely enums) used throughout sections of code.
Author:         Jordan Bourdeau
Date:           10/24/23
"""

from enum import Enum


class CardType(Enum):
    CHANCE = 0
    COMMUNITY_CHEST = 1
    INVALID = 2


class JailMethod(Enum):
    DOUBLES = 0
    MONEY = 1
    CARD = 2
    INVALID = 3
