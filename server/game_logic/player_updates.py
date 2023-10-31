"""
Description:    File containing the PlayerUpdate objects which are passed a Player object and update their state.
Author:         Jordan Bourdeau
Date:           10/30/23
"""

from .asset_tile import AssetTile
from .constants import JAIL_LOCATION, JAIL_TURNS, MAX_DIE, MIN_DIE, NUM_TILES, START_LOCATION
from .player import Player, PlayerStatus


class PlayerUpdate:
    """
    Description:    Base class for the Update object interface. Construction varies based on update type.
    """

    def update(self, player: Player):
        """
        Description:    Method which takes
        :param player:  Player object to apply update to.
        :return:        Raises error if not overridden.
        """
        raise NotImplementedError()


class MoneyUpdate:
    def __init__(self, amount: int):
        """
        Description:    Object responsible
        :param amount:  The delta for the change in a player's money.
        """
        self.amount: int = amount

    def update(self, player: Player):
        """
        Description:    Method to update a player's money and update their status if they are going to go bankrupt
                        or in the hole.
        :return:        None.
        """
        net_worth: int = player.net_worth
        if self.amount + net_worth < 0:
            player.money = 0
            player.status = PlayerStatus.BANKRUPT
        # Player temporarily goes into a negative balance while they are in the hole and have to sell things
        elif self.amount + player.money < 0:
            player.money += self.amount
            player.status = PlayerStatus.IN_THE_HOLE
        # The sum of the money delta and current money is positive. Adjust balance and set player status to GOOD.
        else:
            player.money += self.amount
            player.status = PlayerStatus.GOOD


class GoToJailUpdate:
    def __init__(self):
        """
        Description:
        """
        pass

    def update(self, player: Player):
        """
        Description:    Method for sending a user to jail.
        :return:        None.
        """
        if player.turns_in_jail > 0:
            return
        player.doubles_streak = 0
        location: LocationUpdate = LocationUpdate(JAIL_LOCATION)
        player.update(location)
        player.turns_in_jail = JAIL_TURNS


class LeaveJailUpdate:
    def __init__(self):
        """
        Description:    Object for sending a user to jail.
        """
        pass

    def update(self, player: Player):
        """
        Description:    Method for freeing a user from jail.
        :return:        None.
        """
        if player.turns_in_jail > 0:
            player.turns_in_jail = 0


class RollUpdate:
    def __init__(self, die1: int, die2: int):
        """
        Description:    Object for performing a dice roll.
        """
        self.die1: int = die1
        self.die2: int = die2

    def update(self, player: Player):
        # Check early return conditions (invalid die roll)
        if not (MIN_DIE <= self.die1 <= MAX_DIE and MIN_DIE <= self.die2 <= MAX_DIE):
            return
        # Float values are passed in. Do nothing/
        elif isinstance(self.die1, float) or isinstance(self.die2, float):
            return
        # Get the player out of jail and increment doubles streak
        elif self.die1 == self.die2 and player.in_jail:
            player.update(LeaveJailUpdate())
        # Player is in jail but doesn't roll double. Decrement turns in jail.
        elif player.in_jail:
            player.turns_in_jail -= 1
            return  # Don't move them, exit early
        # Rolled double for the third time. Player goes straight to jail.
        elif self.die1 == self.die2 and player.doubles_streak == 2:
            player.update(GoToJailUpdate())
            player.doubles_streak = 0
            return  # Don't move them, exit early
        elif self.die1 == self.die2:
            player.doubles_streak += 1
        else:
            player.doubles_streak = 0
        # To get here means the player will be getting their movement
        player.update(MoveUpdate(self.die1 + self.die2))


class PropertyUpdate:
    def __init__(self):
        """
        Description:
        """
        pass

    def update(self, player: Player):
        pass


class MortgageUpdate:
    def __init__(self, property: AssetTile):
        """
        Description:        Update to mortgage a property owned by a player.
        :param property:    The property to mortgage.
        """
        self.property: AssetTile = property

    def update(self, player: Player):
        pass


class UnmortgageUpdate:
    def __init__(self):
        """
        Description:        Update to unmortgage a property owned by a player.
        :param property:    The property to unmortgage.
        """
        self.property: AssetTile = property

    def update(self, player: Player):
        pass


class MoveUpdate:
    def __init__(self, spaces: int):
        """
        Description:    Object which is used to move a Player object relative to their current position.
        :param spaces:  The number of spaces to move forward.
        """
        self.spaces: int = spaces

    def update(self, player: Player):
        """
        Description:    Method to attempt to move a player a specified number of spaces.
        :param player:  Player object to move.
        :return:        None.
        """
        player.location = (player.location + self.spaces) % NUM_TILES


class LocationUpdate:
    def __init__(self, destination: int):
        """
        Description:        Object used to move a Player object forward to a specific location.
        :param destination: The target tile index to move a Player to.
        """
        self.destination: int = destination

    def update(self, player: Player):
        """
        Description:    Method for moving a player to a specified place on the board.
        :param player:  Player object to move
        :return:        None.
        """
        if START_LOCATION <= self.destination < NUM_TILES:
            player.location = self.destination
