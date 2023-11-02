"""
Description:    File containing the PlayerUpdate objects which are passed a Player object and update their state.
Author:         Jordan Bourdeau
Date:           10/30/23
"""

from server.game_logic.types import AssetGroups, JailMethod, PropertyStatus, UtilityStatus, RailroadStatus
from server.game_logic.constants import (JAIL_COST, JAIL_LOCATION, JAIL_TURNS, MAX_DIE, MAX_NUM_IMPROVEMENTS, MIN_DIE, NUM_TILES,
                        START_LOCATION, GROUP_SIZE, RENTS)
from server.game_logic.player import Player, PlayerStatus
from server.game_logic.improvable_tile import ImprovableTile


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

    def __init__(self, tile):
        """
        Description:    Object for a player buying a tile.
        :param tile:    The AssetTile object being bought.
        """
        self.tile = tile

    def update(self, player: Player):
        """
        Description:    Method for updating the player and tile states when a property is purchased.
        :param player:  Player purchasing a property.
        :return:        None.
        """
        player.assets.append(self.tile)
        self.tile.owner = player
        
        player.money -= self.tile.price
        # List of tiles in the same group as the tile being bought
        group_share: list = player.group_share(self.tile.group)
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
    def __init__(self, asset, delta: int):
        """
        Description:        Update to change the number of improvements a property has.
        :param asset:       The property to improve/degrade.
        :param delta:       Delta for the number of improvements to buy/sell.
        """
        self.asset = asset
        self.delta: int = delta

    def update(self, player: Player):
        """
        Description:    Method for updating the property and player status when improving/degrading a property.
        :param player:  Player who is changing the number of improvements on a tile.
        :return:        None.
        """
        # Must be a tile which allows improvements to be built.
        if not isinstance(self.asset, ImprovableTile):
            return
        # Tile must be owned by the player.
        elif self.asset not in player.assets:
            return
        # Must be non-zero and within the max/min ranges.
        elif self.delta == 0 or not -MAX_NUM_IMPROVEMENTS <= self.delta <= MAX_NUM_IMPROVEMENTS:
            return
        # Cannot sell more properties than what are currently owned (use -1 to get absolute number of improvements)
        elif self.delta < -(self.asset.status - 1):
            return
        # Evil enumeration integer conversion hacking with IntEnum.
        elif self.asset.status < PropertyStatus.MONOPOLY:
            return
        group_share: list = player.group_share(self.asset.group)
        # 2 cases:
        # 1. Player is looking to increase the number of improvements.
        if self.delta > 0:
            money_delta: int = self.asset.improvement_cost
            total_improvements: int = self.delta
            # Don't allow an upgrade which would make one property >= 2 improvements ahead
            for asset in group_share:
                # Force-upgrade other properties to be >= 1 less than target upgrade
                if asset is not self.asset:
                    total_improvements += max(self.asset.status + self.delta - asset.status - 1, 0)
            # Player does not have the funds necessary
            if player.money < money_delta * total_improvements:
                return
            else:
                # Upgrade all properties to the same minimum level
                for asset in group_share:
                    num_improvements: int = (self.asset.status + self.delta) - (asset.status + 1)
                    # Upgrade the target property to the target status
                    player.update(MoneyUpdate(-(money_delta * num_improvements)))
                    asset.status += num_improvements
                # Perform the final upgrade on the target property
                player.update(MoneyUpdate(-money_delta))
                self.asset.status += 1

        # 2. Player is looking to decrease the number of improvements.
        elif self.delta < 0:
            # Make the downgrade to the target property first
            money_delta: int = int(self.asset.improvement_cost / 2)
            num_downgrades: int = -self.delta
            self.asset.status = PropertyStatus(self.asset.status + self.delta)
            player.update(MoneyUpdate(num_downgrades * money_delta))
            # For every other property, if it is within 0 to 1 greater than the target property, do nothing.
            # If it is > 1 improvement than the target property, downgrade it by the delta.
            for asset in group_share:
                num_downgrades = 0 if 0 <= (asset.status - self.asset.status) <= 1 else -self.delta
                asset.status = PropertyStatus(asset.status - num_downgrades)
                player.update(MoneyUpdate(num_downgrades * money_delta))


class MortgageUpdate(PlayerUpdate):
    def __init__(self, property, mortgage: bool):
        """
        Description:        Update to mortgage a property owned by a player.
        :param property:    The property to mortgage.
        :param mortage:     Bool for whether property is being mortgaged (True) or unmortgaged (False).
        """
        self.asset = property
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

class NullUpdate(PlayerUpdate):
    def __init__(self):
        """
        Description:    Object used when nothing needs to happen to a Player but an update needs to be produced.
        :return:        None.
        """
        pass

    def update(self, player: Player):
        pass