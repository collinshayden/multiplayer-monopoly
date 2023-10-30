"""
Description:    File containing the constants used throughout the game logic.
Author:         Jordan Bourdeau
Date:           10/15/2023
"""

from .types import AssetGroup, PropertyStatus

# Secret key
SECRET_KEY: str = "replace"

# Constants for specific tiles
START_LOCATION: int = 0
NUM_TILES: int = 40

# Constants for bound checking rolls
MIN_DIE: int = 1
MAX_DIE: int = 6
MIN_ROLL: int = 2 * MIN_DIE
MAX_ROLL: int = 2 * MAX_DIE

# Other constants
STARTING_MONEY: int = 1500
JAIL_TURNS: int = 3
JAIL_LOCATION: int = 10
PLAYER_ID_LENGTH: int = 16
MIN_NUM_PLAYERS: int = 2
MAX_NUM_PLAYERS: int = 8

GROUP_SIZE: dict[AssetGroup: int] = {
    AssetGroup.UTILITY: 2,
    AssetGroup.RAILROAD: 4,
    AssetGroup.BROWN: 2,
    AssetGroup.LIGHT_BLUE: 3,
    AssetGroup.PINK: 4,
    AssetGroup.ORANGE: 5,
}

# TODO add railroads
"""
Dictionary of dictionaries for rent amounts based on improvements. 
{tile_id: {PropertyStatus: rent_amount}}
source: https://www.falstad.com/monopoly.html
"""
RENTS: dict[int: dict[PropertyStatus: int]] = {
    1: {
        PropertyStatus.NO_MONOPOLY: 2,
        PropertyStatus.MONOPOLY: 4,
        PropertyStatus.ONE_IMPROVEMENT: 10,
        PropertyStatus.TWO_IMPROVEMENTS: 30,
        PropertyStatus.THREE_IMPROVEMENTS: 90,
        PropertyStatus.FOUR_IMPROVEMENTS: 160,
        PropertyStatus.FIVE_IMPROVEMENTS: 250,
    },
    3: {
        PropertyStatus.NO_MONOPOLY: 4,
        PropertyStatus.MONOPOLY: 8,
        PropertyStatus.ONE_IMPROVEMENT: 20,
        PropertyStatus.TWO_IMPROVEMENTS: 60,
        PropertyStatus.THREE_IMPROVEMENTS: 180,
        PropertyStatus.FOUR_IMPROVEMENTS: 320,
        PropertyStatus.FIVE_IMPROVEMENTS: 450,
    },
    6: {
        PropertyStatus.NO_MONOPOLY: 6,
        PropertyStatus.MONOPOLY: 12,
        PropertyStatus.ONE_IMPROVEMENT: 30,
        PropertyStatus.TWO_IMPROVEMENTS: 90,
        PropertyStatus.THREE_IMPROVEMENTS: 270,
        PropertyStatus.FOUR_IMPROVEMENTS: 400,
        PropertyStatus.FIVE_IMPROVEMENTS: 550,
    },
    8: {
        PropertyStatus.NO_MONOPOLY: 6,
        PropertyStatus.MONOPOLY: 12,
        PropertyStatus.ONE_IMPROVEMENT: 30,
        PropertyStatus.TWO_IMPROVEMENTS: 90,
        PropertyStatus.THREE_IMPROVEMENTS: 270,
        PropertyStatus.FOUR_IMPROVEMENTS: 400,
        PropertyStatus.FIVE_IMPROVEMENTS: 550,
    },
     9: {
        PropertyStatus.NO_MONOPOLY: 8,
        PropertyStatus.MONOPOLY: 16,
        PropertyStatus.ONE_IMPROVEMENT: 40,
        PropertyStatus.TWO_IMPROVEMENTS: 100,
        PropertyStatus.THREE_IMPROVEMENTS: 300,
        PropertyStatus.FOUR_IMPROVEMENTS: 450,
        PropertyStatus.FIVE_IMPROVEMENTS: 600,
    },
    11: {
        PropertyStatus.NO_MONOPOLY: 10,
        PropertyStatus.MONOPOLY: 20,
        PropertyStatus.ONE_IMPROVEMENT: 50,
        PropertyStatus.TWO_IMPROVEMENTS: 150,
        PropertyStatus.THREE_IMPROVEMENTS: 450,
        PropertyStatus.FOUR_IMPROVEMENTS: 625,
        PropertyStatus.FIVE_IMPROVEMENTS: 750,
    },
    13: {
        PropertyStatus.NO_MONOPOLY: 10,
        PropertyStatus.MONOPOLY: 20,
        PropertyStatus.ONE_IMPROVEMENT: 50,
        PropertyStatus.TWO_IMPROVEMENTS: 150,
        PropertyStatus.THREE_IMPROVEMENTS: 450,
        PropertyStatus.FOUR_IMPROVEMENTS: 625,
        PropertyStatus.FIVE_IMPROVEMENTS: 750,
    },
    14: {
        PropertyStatus.NO_MONOPOLY: 12,
        PropertyStatus.MONOPOLY: 24,
        PropertyStatus.ONE_IMPROVEMENT: 60,
        PropertyStatus.TWO_IMPROVEMENTS: 180,
        PropertyStatus.THREE_IMPROVEMENTS: 500,
        PropertyStatus.FOUR_IMPROVEMENTS: 700,
        PropertyStatus.FIVE_IMPROVEMENTS: 900,
    },
    16: {
        PropertyStatus.NO_MONOPOLY: 14,
        PropertyStatus.MONOPOLY: 28,
        PropertyStatus.ONE_IMPROVEMENT: 70,
        PropertyStatus.TWO_IMPROVEMENTS: 200,
        PropertyStatus.THREE_IMPROVEMENTS: 550,
        PropertyStatus.FOUR_IMPROVEMENTS: 750,
        PropertyStatus.FIVE_IMPROVEMENTS: 950,
    },
    18: {
        PropertyStatus.NO_MONOPOLY: 14,
        PropertyStatus.MONOPOLY: 28,
        PropertyStatus.ONE_IMPROVEMENT: 70,
        PropertyStatus.TWO_IMPROVEMENTS: 200,
        PropertyStatus.THREE_IMPROVEMENTS: 550,
        PropertyStatus.FOUR_IMPROVEMENTS: 750,
        PropertyStatus.FIVE_IMPROVEMENTS: 950,
    },
    19: {
        PropertyStatus.NO_MONOPOLY: 16,
        PropertyStatus.MONOPOLY: 32,
        PropertyStatus.ONE_IMPROVEMENT: 80,
        PropertyStatus.TWO_IMPROVEMENTS: 220,
        PropertyStatus.THREE_IMPROVEMENTS: 600,
        PropertyStatus.FOUR_IMPROVEMENTS: 800,
        PropertyStatus.FIVE_IMPROVEMENTS: 1000,
    },
    21: {
        PropertyStatus.NO_MONOPOLY: 18,
        PropertyStatus.MONOPOLY: 36,
        PropertyStatus.ONE_IMPROVEMENT: 90,
        PropertyStatus.TWO_IMPROVEMENTS: 250,
        PropertyStatus.THREE_IMPROVEMENTS: 700,
        PropertyStatus.FOUR_IMPROVEMENTS: 875,
        PropertyStatus.FIVE_IMPROVEMENTS: 1050,
    },
    23: {
        PropertyStatus.NO_MONOPOLY: 18,
        PropertyStatus.MONOPOLY: 36,
        PropertyStatus.ONE_IMPROVEMENT: 90,
        PropertyStatus.TWO_IMPROVEMENTS: 250,
        PropertyStatus.THREE_IMPROVEMENTS: 700,
        PropertyStatus.FOUR_IMPROVEMENTS: 875,
        PropertyStatus.FIVE_IMPROVEMENTS: 1050,
    },
    24: {
        PropertyStatus.NO_MONOPOLY: 20,
        PropertyStatus.MONOPOLY: 40,
        PropertyStatus.ONE_IMPROVEMENT: 100,
        PropertyStatus.TWO_IMPROVEMENTS: 300,
        PropertyStatus.THREE_IMPROVEMENTS: 750,
        PropertyStatus.FOUR_IMPROVEMENTS: 925,
        PropertyStatus.FIVE_IMPROVEMENTS: 1100,
    },
    26: {
        PropertyStatus.NO_MONOPOLY: 22,
        PropertyStatus.MONOPOLY: 44,
        PropertyStatus.ONE_IMPROVEMENT: 110,
        PropertyStatus.TWO_IMPROVEMENTS: 330,
        PropertyStatus.THREE_IMPROVEMENTS: 800,
        PropertyStatus.FOUR_IMPROVEMENTS: 975,
        PropertyStatus.FIVE_IMPROVEMENTS: 1150,
    },
    27: {
        PropertyStatus.NO_MONOPOLY: 22,
        PropertyStatus.MONOPOLY: 44,
        PropertyStatus.ONE_IMPROVEMENT: 110,
        PropertyStatus.TWO_IMPROVEMENTS: 330,
        PropertyStatus.THREE_IMPROVEMENTS: 800,
        PropertyStatus.FOUR_IMPROVEMENTS: 975,
        PropertyStatus.FIVE_IMPROVEMENTS: 1150,
    },
    29: {
        PropertyStatus.NO_MONOPOLY: 24,
        PropertyStatus.MONOPOLY: 48,
        PropertyStatus.ONE_IMPROVEMENT: 120,
        PropertyStatus.TWO_IMPROVEMENTS: 360,
        PropertyStatus.THREE_IMPROVEMENTS: 850,
        PropertyStatus.FOUR_IMPROVEMENTS: 1025,
        PropertyStatus.FIVE_IMPROVEMENTS: 1200,
    },
    31: {
        PropertyStatus.NO_MONOPOLY: 26,
        PropertyStatus.MONOPOLY: 52,
        PropertyStatus.ONE_IMPROVEMENT: 130,
        PropertyStatus.TWO_IMPROVEMENTS: 390,
        PropertyStatus.THREE_IMPROVEMENTS: 900,
        PropertyStatus.FOUR_IMPROVEMENTS: 1100,
        PropertyStatus.FIVE_IMPROVEMENTS: 1275,
    },
    32: {
        PropertyStatus.NO_MONOPOLY: 26,
        PropertyStatus.MONOPOLY: 52,
        PropertyStatus.ONE_IMPROVEMENT: 130,
        PropertyStatus.TWO_IMPROVEMENTS: 390,
        PropertyStatus.THREE_IMPROVEMENTS: 900,
        PropertyStatus.FOUR_IMPROVEMENTS: 1100,
        PropertyStatus.FIVE_IMPROVEMENTS: 1275,
    },
    34: {
        PropertyStatus.NO_MONOPOLY: 28,
        PropertyStatus.MONOPOLY: 56,
        PropertyStatus.ONE_IMPROVEMENT: 150,
        PropertyStatus.TWO_IMPROVEMENTS: 450,
        PropertyStatus.THREE_IMPROVEMENTS: 1000,
        PropertyStatus.FOUR_IMPROVEMENTS: 1200,
        PropertyStatus.FIVE_IMPROVEMENTS: 1400,
    },
    37: {
        PropertyStatus.NO_MONOPOLY: 35,
        PropertyStatus.MONOPOLY: 70,
        PropertyStatus.ONE_IMPROVEMENT: 175,
        PropertyStatus.TWO_IMPROVEMENTS: 500,
        PropertyStatus.THREE_IMPROVEMENTS: 1100,
        PropertyStatus.FOUR_IMPROVEMENTS: 1300,
        PropertyStatus.FIVE_IMPROVEMENTS: 1500,
    },
    39: {
        PropertyStatus.NO_MONOPOLY: 50,
        PropertyStatus.MONOPOLY: 100,
        PropertyStatus.ONE_IMPROVEMENT: 200,
        PropertyStatus.TWO_IMPROVEMENTS: 600,
        PropertyStatus.THREE_IMPROVEMENTS: 1400,
        PropertyStatus.FOUR_IMPROVEMENTS: 1700,
        PropertyStatus.FIVE_IMPROVEMENTS: 2000,
    },
}