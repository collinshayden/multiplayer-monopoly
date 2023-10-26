"""
Description:    Class representing the information for a player.
Date:           10/18/2023
Author:         Jordan Bourdeau, Hayden Collins
"""

from .constants import JAIL_LOCATION, JAIL_TURNS, MAX_ROLL, MIN_ROLL, NUM_TILES, STARTING_MONEY, START_LOCATION
from .types import PlayerStatus

from random import randint


class Player:
    def __init__(self, player_id: str, username: str) -> None:
        from .buyable_tile import BuyableTile
        """
        Description:            Class representing a Player.
        :param player_id:       Unique 16-character ID generated from Game class
        :param username:    Display name/username
        """
        self.player_id: str = player_id
        self.username: str = username

        # State variables
        self.properties: list[BuyableTile] = []
        self.money: int = STARTING_MONEY
        self.location: int = START_LOCATION
        self.doubles_streak: int = 0
        self.jail_cards: int = 0
        self.turns_in_jail: int = 0
        self.status: PlayerStatus = PlayerStatus.GOOD

    @property
    def in_jail(self) -> bool:
        """
        Description:    Return whether the user is in jail.
        :return:        Boolean value for if the user has remaining turns in jail
        """
        return self.turns_in_jail > 0

    @property
    def active(self) -> bool:
        """
        Description:    Return whether the current player status != PlayerStatus.BANKRUPT
        :return:        True/False.
        """
        return self.status not in [PlayerStatus.BANKRUPT, PlayerStatus.INVALID]

    def roll_dice(self, dice: tuple[int, int] = (None, None)) -> bool:
        """
        Description:    Method used to roll dice for a player's turn and update their state accordingly.
        :param dice:    Allow for die roll to be passed in for testability. Will randomly be generated otherwise.
        :return:        Returns True once state has been updated or False if invalid dice are passed in.
        """
        if dice != (None, None):
            dice = int(dice[0]), int(dice[1])
            if not (1 <= dice[0] <= 6 and 1 <= dice[1] <= 6):
                return False
        else:
            dice = (randint(1, 6), randint(1, 6))

        # Rolled doubles while in jail. Get freed.
        if dice[0] == dice[1] and self.turns_in_jail > 0:
            self.get_out_of_jail()
            self.doubles_streak = 1
        # In jail but no doubles. Don"t move the player but allow them to continue their turn.
        elif self.turns_in_jail > 0:
            self.end_turn()
            return True
        # Rolled doubles for the third time. Send the user to jail without moving them first.
        elif dice[0] == dice[1] and self.doubles_streak == 2:
            self.go_to_jail()
            return True
        elif dice[0] == dice[1]:
            self.doubles_streak += 1
        else:
            self.doubles_streak = 0
        # Either doubles were rolled but the streak < 3 or there were no doubles. Move the player.
        self.move_forward(dice[0] + dice[1])
        self.end_turn()
        return True

    def move_forward(self, roll: int) -> bool:
        """
        Description:    Method to attempt to move a player a specified number of spaces.
        :param roll:    Value rolled for movement.
        :return:        Boolean value for if the move was successful.
        """
        if not MIN_ROLL <= roll <= MAX_ROLL:
            return False
        else:
            self.location = (self.location + roll) % NUM_TILES
            return True

    def move_to(self, location: int) -> bool:
        """
        Description:        Method for moving a player to a specified place on the board.
        :param location:    Index of the tile to move to.
        :return:            Boolean value for if the move was successful
        """
        if not START_LOCATION <= location < NUM_TILES:
            return False
        else:
            self.location = location
            return True

    def go_to_jail(self) -> bool:
        """
        Description:    Method for sending a user to jail. This automatically ends their turn when it happens.
        :return:        Returns True if the user was not in jail and was successfully sent to jail. False otherwise.
        """
        if self.turns_in_jail > 0:
            return False
        self.doubles_streak = 0
        self.location = JAIL_LOCATION
        self.turns_in_jail = JAIL_TURNS
        return True

    def get_out_of_jail(self) -> bool:
        """
        Description:    Method for freeing a user from jail.
        :return:        Returns True if the user still had turns left in jail. False otherwise.
        """
        if self.turns_in_jail > 0:
            self.turns_in_jail = 0
            return True
        return False

    def end_turn(self) -> PlayerStatus:
        """
        Description:    Method used to end a player's turn and update any necessary state variables (namely jail).
        :return:        Returns the player's current state.
        """
        if self.turns_in_jail > 0:
            self.turns_in_jail -= 1
        return self.status

    def update_money(self, delta: int) -> PlayerStatus:
        """
        Description:    Method to update a player's money and update their status if they are going to go bankrupt
                        or in the hole.
        :param delta:   Amount the player's money will change by.
        :return:        The updated player status.
        """
        total_worth: int = self.calculate_net_worth()
        # Unrecoverable amount of money being lost
        if delta + self.calculate_net_worth() < 0:
            self.money = 0
            self.status = PlayerStatus.BANKRUPT
        # Player temporarily goes into a negative balance while they are in the hole and have to sell things
        elif delta + self.money < 0:
            self.money += delta
            self.status = PlayerStatus.IN_THE_HOLE
        # The sum of the money delta and current money is positive. Adjust balance and set player status to GOOD.
        else:
            self.money += delta
            self.status = PlayerStatus.GOOD
        return self.status

    # TODO: Implement. Returns money for now.
    def calculate_net_worth(self) -> int:
        """
        Description:    Method used to calculate the net worth of a player based on the sum of:
                            1) Current money
                            2) Selling improvements
                            3) Mortgaging properties
        :return:        Final dollar amount for a player's net worth.
        """
        property_values: int = 0
        for property in self.properties:
            property_values += property.compute_worth()
        return self.money + property_values
    
    def to_dict(self) -> dict:
        """
        Description:    Method used to return a dictionary representation of the class.
                        Used for creating JSON representation of the game state.
        :return:        Dictionary of class attributes.
        """
        player_dict = {"displayName": self.username,
                       "money": self.money,
                       "location": self.location,
                       "doublesStreak": self.doubles_streak,
                       "jailCards": self.jail_cards,
                       "turnsInJail": self.turns_in_jail,
                       "active": self.active}
        return player_dict