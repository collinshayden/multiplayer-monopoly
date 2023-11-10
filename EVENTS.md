# Event Handling

The following events are expected to be received by the client with each being a self-contained JSON object with known fields:
1. `startSession`: The first event to be received after a connection has been established with the server. This will cause a display name input field to appear.
```
{
	"type": "startSession",
	"authToken": String
}
```
2. `enterQueue`: If display name input was successful and there is a session available to join, the user is taken to a new screen where they can see the current queue of people who will be in the game.
```
{
	"type": "enterQueue",
	"players": [
		{"playerId": int, "isReady": bool},
		{"playerId": int, "isReady": bool},
		...
	]
}
```
3. `updateQueue`: As more players join/leave the session queue, this event will be broadcasted to indicate the current set of players who wish to play in this session, as well as whether they are currently ready or not.
```
{
	"type": "updateQueue",
	"players": [
		{"playerId": int, "isReady": bool},
		{"playerId": int, "isReady": bool},
		...
	]
}
```
4. `toggleReadyPrompt`: Whenever the number of players reaches a specified minimum, this event causes a "Ready" button to appear, allowing players to indicate to the server that they are ready to start the game. If the number of players goes below the threshold (some players leave) then all players' ready status is reset to `false` and the button becomes inactive.
```
{
	"type": "toggleReadyPrompt",
	"show": bool
}
```
5. `startGame`: Indicates that enough players have both joined the queue and that they have all indicated that they are ready to play, causing a screen change to the Monopoly board to begin gameplay.
```
{
	"type": "startGame"
}
```
6. `startTurn`: Indicates that a turn change has occurred (or that the game has started), enabling or disabling clients' buttons and other inputs.
```
{
	"type": "startTurn",
	"activePlayerId": int
}
```
7. `showRoll`: Indicates that a new roll has been made and should be displayed.
```
{
	"type": "showRoll",
}
```
8. `movePlayer`: Indicates that a player movement (possibly into or out of jail) has occurred and should be displayed.
```
{
	"type": "movePlayer",
	"directMovement": bool,
	"intoJail": bool,
	"outOfJail": bool
}
```
9. `promptPurchase`: Indicates that a player should be presented with the opportunity to purchase a property they have landed on.
```
{
	"type": "promptPurchase",
	"tileId": int
}
```
10. `showPurchase`: Indicates that a player has made a purchase of a property, adding information to the action feed.
```
{
	"type": "showPurchase",
	"playerId": int,
	"tileId": int,
	"purchasePrice": int
}
```
11. `showCardDraw`: Indicates that a player has drawn a card, adding information to the action feed.
```
{
	"type": "showCardDraw",
	"cardType": enum CardType,
	"playerId": int,
	"cardText": String
}
```
12. `showImprovement`: Indicates that a player has added or removed improvements for a particular property, adding information to the action feed and causing the relevant tile to update its display.
```
{
	"type": "showImprovements",
	"tileId": int,
	"improvements": int
}
```
13. `showMortgage`: Indicates that a player has mortgaged or unmortgaged a particular property, adding information to the action feed and causing the relevant tile to update its display.
```
{
	"type": "showMortgage",
	"tileId": int,
	"mortgage": bool
}
```
14. `promptEndTurn`: Indicates that a player has reached a point in their turn whereafter it is safe to end their turn at their own convenience (or possibly on a countdown), causing an "End Turn" button to appear.
```
{
	"type": "promptEndTurn"
}
```
15. `showLoser`: Indicates that a player has lost the game by going bankrupt.
```
{
	"type": "showLoser",
	"playerId": int
}
```
16. `showWinner`: Indicates that a player has won by outlasting all other players and therefore that that the game has ended and the turn cycle has stopped.
```
{
	"type": "showWinner",
	"playerId": int
}
```
17. `endGame`: Causes the screen to change after the game has ended, displaying any closing information.
```
{
	"type": "endGame"
}
```
18. `promptRestart`: Prompts the user to join a new session. The next event to be received after this one should be `startSession`.
```
{
	"type": "promptRestartGame"
}
```

