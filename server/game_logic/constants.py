"""
Description:    File containing the constants used throughout the game logic.
Author:         Jordan Bourdeau
Date:           10/15/2023
"""

from .types import AssetGroups, PropertyStatus, RailroadStatus, UtilityStatus

# Secret key
SECRET_KEY: str = "replace"

# Constants for specific tiles
START_LOCATION: int = 0
NUM_TILES: int = 40
CHANCE_TILES: list[int] = [7, 22, 36]
COMMUNITY_CHEST_TILES: list[int] = [2, 17, 33]
NUM_CHANCE_CARDS: int = 16
NUM_COMMUNITY_CHEST_CARDS: int = 16

# Constants for bound checking rolls
MIN_DIE: int = 1
MAX_DIE: int = 6
MIN_ROLL: int = 2 * MIN_DIE
MAX_ROLL: int = 2 * MAX_DIE

# Other constants
STARTING_MONEY: int = 1500
GO_MONEY: int = 200
INCOME_TAX: int = -200
LUXURY_TAX: int = -75
MAX_NUM_IMPROVEMENTS: int = 5

# Jail Constants
JAIL_TURNS: int = 3
JAIL_LOCATION: int = 10
JAIL_COST: int = -50

# Player related constants
MIN_NUM_PLAYERS: int = 2
MAX_NUM_PLAYERS: int = 8
PLAYER_ID_LENGTH: int = 16

# Property Constants
NUM_RAILROADS: int = 4
UTILITY_COST: int = 150
RAILROAD_COST: int = 200

# Lookup table for the number of properties in an asset group
GROUP_SIZE: dict[AssetGroups: int] = {
    AssetGroups.UTILITY: 2,
    AssetGroups.RAILROAD: 4,
    AssetGroups.BROWN: 2,
    AssetGroups.LIGHT_BLUE: 3,
    AssetGroups.PINK: 3,
    AssetGroups.ORANGE: 3,
    AssetGroups.RED: 3,
    AssetGroups.YELLOW: 3,
    AssetGroups.GREEN: 3,
    AssetGroups.DARK_BLUE: 2
}

# Lookup table for the improvement costs of various groups
IMPROVEMENT_MAP: dict[AssetGroups: int] = {
    AssetGroups.BROWN: 50,
    AssetGroups.LIGHT_BLUE: 50,
    AssetGroups.PINK: 100,
    AssetGroups.ORANGE: 100,
    AssetGroups.RED: 150,
    AssetGroups.YELLOW: 150,
    AssetGroups.GREEN: 200,
    AssetGroups.DARK_BLUE: 200
}

# TODO add railroads
"""
Dictionary of dictionaries for rent amounts based on improvements. 
{tile_id: {PropertyStatus: rent_amount}}
source: https://www.falstad.com/monopoly.html
"""
RENTS: dict[int: dict[PropertyStatus: int]] = {
    # Browns
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
    # Light blues
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
    # Pinks
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
    # Oranges
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
    # Reds
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
    # Yellows
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
    # Greens
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
    # Blues
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

# Add in railroads
for tile_idx in [5, 15, 25, 35]:
    RENTS[tile_idx] = {
        RailroadStatus.ONE_OWNED: 25,
        RailroadStatus.TWO_OWNED: 50,
        RailroadStatus.THREE_OWNED: 100,
        RailroadStatus.FOUR_OWNED: 200,
    }

# Add in utilities
for tile_idx in [12, 28]:
    RENTS[tile_idx] = {
        UtilityStatus.NO_MONOPOLY: 4,
        UtilityStatus.MONOPOLY: 10
    }

COMMUNITY_CHEST: dict[int: str] = {
    1: "Advance to GO.",
    2: "Bank error in your favor.  Collect $200.",
    3: "Doctor's fees.  Pay $50.",
    4: "From sale of stock you get $50.",
    5: "Get out of Jail free.",
    6: "Go to jail.  Go directly to Jail. Do not pass Go. Do not collect $200.",
    7: "Grand Opera Night.  Collect $50 from every player for opening night seats.",
    8: "Holiday fund matures.  Receive $100.",
    9: "Income tax refund.  Collect $200.",
    10: "It is your birthday.  Collect $10 from every player",
    11: "Life insurance matures.  Collect $100",
    12: "Hospital fees.  Pay $50.",
    13: "School fees.  Pay $50",
    14: "Receive $25 consultancy fee.",
    15: "You are assessed for street repairs.  Pay $40 per house and $115 per hotel you own.",
    16: "You have won second prize in a beauty contest.  Collect $10.",
    17: "You inherit $100."
}

CHANCE: dict[int: str] = {
    1: "Advance to GO.",
    2: "Advance to Illinois Avenue.",
    3: "Advance to St. Charles Place.",
    4: "Advance to the nearest Utility.  If unowned, you may buy it from the Bank.  If owned, throw dice and pay owner a total of 10 times the amount owned.",
    5: "Advance to the nearest Railroad.  If unowned, you may buy it from the Bank.  If owned, pay the owner twice the rent they would be otherwise owned.",
    6: "Bank pays you dividend of $50.",
    7: "Go back 3 spaces.",
    8: "Get out of Jail free.",
    9: "Go to Jail.  Go directly to Jail. Do not pass Go. Do not collect $200.",
    10: "Make general repairs on all your property.  For each house, pay $25, for each hotel pay $100.",
    11: "Take a trip to Reading Railroad.",
    12: "Pay poor tax of $15.",
    13: "Take a walk on the Boardwalk.",
    14: "You have been elected Chairman of the Board.  Pay each player $50.",
    15: "Your building loan matures.  Receive $150."
}
