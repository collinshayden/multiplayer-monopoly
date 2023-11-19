# Event Handling

The following events are expected to be received by the client with each being a self-contained JSON object with known fields:
1. `showPlayerJoin`: A targeted event which indicates if display name input was successful and the player has joined the game. This event causes the client's screen to switch to a list of currently registered players. This event is the first event to be enqueued server-side into the Game object to confirm that they have successfully joined the queue.
```
{
	"type": "showPlayerJoin",
	"displayName": String
}
```

2. `promptStartGame`: A prompt event once a player has joined asking them if they would like to start the game.
```
{
	"type": "promptStartGame"
}

```
3. `showStartGame`: A broadcast event which indicates that one of the players has requested to start the game. This will cause a screen change to go to Monopoly board to begin gameplay. Will also need to clear out the promptStartGame dialog.
```
{
	"type": "showStartGame",
	"displayName": String
}
```
4. `showStartTurn`: A targeted event which indicates that a turn has started (perhaps at the beginning of the game), causing the recipient's screen to reflect the roll phase of their turn. This event should only be sent to the player whose turn is beginning, and each one of these events should be paired (one-to-one) with an `showEndTurn` event.
```
{
	"type": "showStartTurn",
	"displayName": String
}
```
5. `showRoll`: A broadcast event which indicates that a new roll has been made by some player. This will cause the dice display to update to reflect the most recent roll as specified in the Game object.
```
{
	"type": "showRoll",
	"displayName": String,
	"playerId": String,
	"first": int,
	"second": int
}
```

Note: Want not a need
6. `showPassGo`: A broadcast event which shows when a player passes Go and collects money.
```
{
	"type": "showGo",
	"displayName": String
}
```
7. `showRent`: A broadcast event which shows when a player passes Go and collects money.
```
{
	"type": "showRent",
	"propertyName": String,
	"activePlayerName": String,
	"landlordName": String,
	"amount": int
}
```
8. `showTax`: A broadcast event which shows when a player is getting taxed.
```
{
	"type": "showTax",
	"displayName": String,
	"amount": int
	"taxType": String,
}
```

9. `showMovePlayer`: A broadcast event which indicates that a player movement (possibly into or out of jail) has occurred and should be displayed. If a player makes a direct movement, this may (eventually, time allowing) cause a different animation of the tokens on the board showing how the movement occurs. If a player moves from "Jail" to "Just Visiting", then this is simply a direct movement. This event is used to drive the action feed, which will display whether a player has moved into or out of jail. That is, the `intoJail` and `outOfJail` parameters affect only the messages displayed in the action feed.
```
{
	"type": "movePlayer",
	"displayName": String,
	"directMovement": bool,
	"intoJail": bool,
	"outOfJail": bool
}
```
10. `promptPurchase`: A targeted event which indicates that a player should be prompted to purchase a property they have landed on.
```
{
	"type": "promptPurchase",
	"propertyName": String,
    "tileId": int
}
```
11.  `showPurchase`: A broadcast event which indicates that a player has made a purchase of a property, adding information to the action feed for all participants.
```
{
	"type": "showPurchase",
	"displayName": String,
	"propertyName": String
}
```
12.  `showImprovement`: A broadcast event which indicates that a player has added or removed improvements for a particular property, adding information to the action feed and causing the relevant tile to update its displayt to reflect the correct number of houses/hotels.
```
{
	"type": "showImprovements",
	"displayName": String,
	"propertyName": String,
	"changeInImprovements": int
}
```
13.  `showMortgage`: A broadcast event which indicates that a player has mortgaged or unmortgaged a particular property, adding information to the action feed. This also implies that the mortgage status has been been changed for a particular property in the Game object such that if a player were to view the title deed, it would now indicate as such.
```
{
	"type": "showMortgage",
	"displayName": String,
	"propertyName": int,
	"isMortgaged": bool
}
```
14.  `promptEndTurn`: A targeted event which indicates that a player has reached a point in their turn whereafter it is safe to end their turn at their own convenience (or possibly on a countdown). This event causes an "End Turn" button to appear.
```
{
	"type": "promptEndTurn"
}
```
15.  `showEndTurn`: A broadcast event to show a player ending their turn.
```
{
	"type": "showEndTurn",
	"displayName": String
}
```
16.  `promptLiquidate`: A targeted event which takes place when a player's balance has gone below 0 but they have enough total assets to pay the amount through mortgaging/selling improvements.
```
{
	"type": "promptLiquidate",
	"amountNeeded": 250
}
```
17.  `showLoser`: A broadcast event which indicates that a player has lost the game by going bankrupt (or if they forfeit by leaving the game, time allowing).
```
{
	"type": "showLoser",
	"displayName": String
}
```
18.  `showEndGame`: Causes the screen to change after the game has ended, displaying any closing information.
```
{
	"type": "endGame",
	"winnerName": String
}
```
19.  `showBankruptcy`: Informational event to be broadcast
```
{
	"type": "endGame",
	"displayName": String
}
```