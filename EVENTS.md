# Event Handling

The following events are expected to be received by the client with each being a self-contained JSON object with known fields:
1. `joinQueue`: A targeted event which indicates if display name input was successful and the player has joined the game. This event causes the client's screen to switch to a list of currently registered players. This event is the first event to be enqueued server-side into the Game object to confirm that they have successfully joined the queue.
```
{
	"type": "joinQueue"
}
```
2. `startGame`: A broadcast event which indicates that one of the players has requested to start the game. This will cause a screen change to go to Monopoly board to begin gameplay.
```
{
	"type": "startGame"
}
```
3. `startTurn`: A targeted event which indicates that a turn has started (perhaps at the beginning of the game), causing the recipient's screen to reflect the roll phase of their turn. This event should only be sent to the player whose turn is beginning, and each one of these events should be paired (one-to-one) with an `endTurn` event.
```
{
	"type": "startTurn"
}
```
4. `showRoll`: A broadcast event which indicates that a new roll has been made by some player. This will cause the dice display to update to reflect the most recent roll as specified in the Game object.
```
{
	"type": "showRoll",
}
```
5. `movePlayer`: A broadcast event which indicates that a player movement (possibly into or out of jail) has occurred and should be displayed. If a player makes a direct movement, this may (eventually, time allowing) cause a different animation of the tokens on the board showing how the movement occurs. If a player moves from "Jail" to "Just Visiting", then this is simply a direct movement. This event is used to drive the action feed, which will display whether a player has moved into or out of jail. That is, the `intoJail` and `outOfJail` parameters affect only the messages displayed in the action feed.
```
{
	"type": "movePlayer",
	"directMovement": bool,
	"movedIntoOrOutOfJail": bool
}
```
6. `promptPurchase`: A targeted event which indicates that a player should be prompted to purchase a property they have landed on.
```
{
	"type": "promptPurchase"
}
```
7.  `showPurchase`: A broadcast event which indicates that a player has made a purchase of a property, adding information to the action feed for all participants.
```
{
	"type": "showPurchase",
	"playerId": String,
	"tileId": int
}
```
8.  `showImprovement`: A broadcast event which indicates that a player has added or removed improvements for a particular property, adding information to the action feed and causing the relevant tile to update its displayt to reflect the correct number of houses/hotels.
```
{
	"type": "showImprovements",
	"tileId": int,
	"changeInImprovements": int
}
```
9.  `showMortgage`: A broadcast event which indicates that a player has mortgaged or unmortgaged a particular property, adding information to the action feed. This also implies that the mortgage status has been been changed for a particular property in the Game object such that if a player were to view the title deed, it would now indicate as such.
```
{
	"type": "showMortgage",
	"tileId": int,
	"isMortgaged": bool
}
```
10.  `promptEndTurn`: A targeted event which indicates that a player has reached a point in their turn whereafter it is safe to end their turn at their own convenience (or possibly on a countdown). This event causes an "End Turn" button to appear.
```
{
	"type": "promptEndTurn"
}
```
11.  `showLoser`: A broadcast event which indicates that a player has lost the game by going bankrupt (or if they forfeit by leaving the game, time allowing).
```
{
	"type": "showLoser",
	"playerId": String
}
```
12.  `endGame`: Causes the screen to change after the game has ended, displaying any closing information.
```
{
	"type": "endGame",
	"winningPlayerId": String
}
```
