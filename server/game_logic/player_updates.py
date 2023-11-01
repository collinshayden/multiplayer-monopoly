"""
Description:    File containing the PlayerUpdate objects which are passed a Player object and update their state.
Author:         Jordan Bourdeau
Date:           10/30/23
"""

from .asset_tile import AssetTile
from .types import AssetGroups, JailMethod, PropertyStatus, UtilityStatus, RailroadStatus
from .constants import (JAIL_COST, JAIL_LOCATION, JAIL_TURNS, MAX_DIE, MIN_DIE, NUM_TILES, START_LOCATION, GROUP_SIZE,
                        RENTS)
from .player import Player, PlayerStatus
from .asset_tile import AssetTile
from .property_tile import PropertyTile
from .railroad_tile import RailroadTile
from .utility_tile import UtilityTile


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


class MoneyUpdate(PlayerUpdate):
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


class GoToJailUpdate(PlayerUpdate):
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


class LeaveJailUpdate(PlayerUpdate):
    def __init__(self, method: JailMethod):
        """
        Description:    Object for sending a user to jail.
        """
        self.method: JailMethod = method

    def update(self, player: Player):
        """
        Description:    Method for freeing a user from jail.
        :return:        None.
        """
        # Do nothing if the player isn't in jail
        if player.turns_in_jail == 0:
            return
        # User rolled doubles and just gets out
        if self.method == JailMethod.DOUBLES:
            pass
        # User is paying to get out. Update money then set them free
        elif self.method == JailMethod.MONEY:
            player.update(MoneyUpdate(JAIL_COST))
        # User is using a get out of jail card. Decrement their number of jail cards (if they have 1+)
        elif self.method == JailMethod.CARD:
            if player.jail_cards > 0:
                player.jail_cards -= 1
            else:
                return
        # Invalid state. Return immediately. Should not be able to get here
        else:
            return
        # All valid methods will get here after any other associated state has been handled
        player.turns_in_jail = 0


class RollUpdate(PlayerUpdate):
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
            player.update(LeaveJailUpdate(JailMethod.DOUBLES))
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


class BuyUpdate(PlayerUpdate):
    def __init__(self, tile: AssetTile):
        """
        Description:    Object for a player buying a tile.
        :param tile:    The AssetTile object being bought.
        """
        self.tile: AssetTile = tile

    def update(self, player: Player):
        """
        Description:    Method for updating the player and tile states when a property is purchased.
        :param player:  Player purchasing a property.
        :return:        None.
        """
        # Can't buy a property that is already owned
        if self.tile in player.assets:
            return
        player.assets.append(self.tile)
        self.tile.owner = player
        player.money -= self.tile.price
        # List of tiles in the same group as the tile being bought
        group_share: list[AssetTile] = [asset for asset in player.assets if asset.group == self.tile.group]
        # Depending on the group, update all the matched group share property statuses accordingly
        match self.tile.group:
            case AssetGroups.RAILROAD:
                for asset in group_share:
                    # Sort of cursed way to convert from integer to enum representation
                    if len(group_share) < len(RailroadStatus):
                        asset.status = RailroadStatus(len(group_share))
            case AssetGroups.UTILITY:
                for asset in group_share:
                    if len(group_share) == GROUP_SIZE[AssetGroups.UTILITY]:
                        asset.status = UtilityStatus.MONOPOLY
            # Match any other property group
            case _:
                for asset in group_share:
                    if len(group_share) == GROUP_SIZE[self.tile.group]:
                        asset.status = PropertyStatus.MONOPOLY


class ImprovementUpdate(PlayerUpdate):
    def __init__(self, property: AssetTile, delta: int):
        """
        Description:        Update to change the number of improvements a property has.
        :param property:    The property to improve/degrade.
        :param delta:       Delta for the number of improvements to buy/sell.
        """
        self.asset: AssetTile = property
        self.delta: int = delta

    def update(self, player: Player):
        """
        Description:    Method for updating the property and player status when improving/degrading a property.
        :param player:  Player who is changing the number of improvements on a tile.
        :return:        None.
        """
        pass


class MortgageUpdate(PlayerUpdate):
    def __init__(self, property: AssetTile, mortgage: bool):
        """
        Description:        Update to mortgage a property owned by a player.
        :param property:    The property to mortgage.
        :param mortage:     Bool for whether property is being mortgaged (True) or unmortgaged (False).
        """
        self.asset: AssetTile = property
        self.mortgage: bool = mortgage

    def update(self, player: Player):
        """
        Description:    Method for updating the property and player status when mortgaging/unmortgaging.
        :param player:  Player who is mortgaging/unmortgaging.
        :return:        None.
        """

        # 1. Check the player owns the property
        if self.asset not in player.assets:
            return

        # If the player is trying to mortgage the property, verify it can be mortgaged then mortgage it
        if self.mortgage and not self.asset.is_mortgaged:
            player.update(MoneyUpdate(self.asset.mortage_price))
            self.asset.mortgage()
        # If the player is trying to unmortgage the property, verify it is already mortgaged then unmortgage it.
        elif not self.mortgage and self.asset.is_mortgaged:
            player.update(MoneyUpdate(-int(self.asset.lift_mortage_cost)))
            # Add additional check that they aren't bankrupt before unmortgaging it
            if player.status != PlayerStatus.BANKRUPT:
                self.asset.unmortgage()
        # Undefined state. Do nothing.
        else:
            return

class MoveUpdate(PlayerUpdate):
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


class LocationUpdate(PlayerUpdate):
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
