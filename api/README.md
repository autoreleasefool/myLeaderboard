# API Reference

## Games

**GET** `/games/list`

Returns this list of games.

<summary>Example response</summary>
<details>

```
[
    {
        "id": 0,
        "name": "Hive",
        "hasScores": false,
        "image": "https://example.com/image/Hive.png"
    }
]
```

</details>

**POST** `/games/new`

Creates a new game.

<summary>Example input</summary>
<details>

```
{
    "name": "Patchwork",
    "hasScores": true
}
```

</details>

<summary>Example response</summary>
<details>

```
{
    "id": 1,
    "name": "Patchwork",
    "hasScores": true
}
```

</details>

**GET** `/games/standings/:gameId`

Returns the standings for a game, given by ID.

<summary>Example response</summary>
<details>

```
{
    "scoreStats": {
        "best": 41,
        "worst": -34,
        "average": 12,
        "gamesPlayed": 18
    },
    "records": {
        0: {
            "scoreStats": {
                "best": 41,
                "worst": -4,
                "average": 17,
                "gamesPlayed": 5
            },
            "lastPlayed": "2019-07-19T00:00:00.000Z",
            "overallRecord": {
                "wins": 4,
                "losses": 1,
                "ties": 0,
                "isBest": true
            },
            "records": {
                1: {
                    "wins" 4,
                    "losses": 1,
                    "ties": 0
                }
            }
        }
        1: {
            "scoreStats": {
                "best": 14,
                "worst": -34,
                "average": 5,
                "gamesPlayed": 5
            },
            "lastPlayed": "2019-07-19T00:00:00.000Z",
            "overallRecord": {
                "wins": 1,
                "losses": 4,
                "ties": 0,
                "isWorst": true
            },
            "records": {
                1: {
                    "wins" 1,
                    "losses": 4,
                    "ties": 0
                }
            }
        }
    }
}
```

</details>

## Players

**GET** `/players/list?withAvatars=<Bool>`

Returns the list of players. Optionally include the players' avatars in the response.

<summary>Example response</summary>
<details>

```
[
    {
        "id": 0,
        "displayName": "Joseph Roque",
        "username": "josephroquedev",
        "avatar": "https://example.com/image/JosephRoque.png"
    }
]
```

</details>

**POST** `/players/new`

Creates a new player.

<summary>Example input</summary>
<details>

```
{
    "name": "Joseph Roque",
    "username": "josephroquedev"
}
```

</details>

<summary>Example response</summary>
<details>

```
{
    "id": 1,
    "displayName": "Joseph Roque",
    "username": "josephroquedev"
}
```

</details>

**GET** `/players/record/:playerId/gameId`

Get the record for a single player, for a single game.

<summary>Example response</summary>
<details>

```
{
    "scoreStats": {
        "best": 41,
        "worst": -4,
        "average": 17,
        "gamesPlayed": 5
    },
    "lastPlayed": "2019-07-19T00:00:00.000Z",
    "overallRecord": {
        "wins": 4,
        "losses": 1,
        "ties": 0,
        "isBest": true
    },
    "record": {
        1: {
            "wins" 4,
            "losses": 1,
            "ties": 0
        }
    }
}
```

</details>

## Plays

**GET** `/plays/list`

Returns the list of plays.

<summary>Example response</summary>
<details>

```
[
    {
        "id": 0,
        "game": 0,
        "playedOn": "2019-07-01T00:00:00.000Z",
        "players": [1, 9],
        "winners": [1]
    },
    {
        "id": 245,
        "game": 1,
        "playedOn": "2019-08-21T21:07:43.038Z",
        "players": [5, 6],
        "winners": [6],
        "scores": [-5, 13]
    }
]
```

</details>

**POST** `/plays/record`

Record a new play of a game.

<summary>Example input</summary>
<details>

```
{
    "players": [0,1],
    "winners": [0],
    "scores": [25,33],
    "game": 0
}
```

</details>

<summary>Example response</summary>
<details>

```
{
    "id": 1,
    "players": [0,1],
    "winners": [0],
    "scores": [25,33],
    "game": 0,
    "playedOn": "2019-07-19T00:00:00.000Z"
}
```

</details>

## Miscellaneous

**POST** `misc/refresh`

Force the API to refetch from the database.

<summary>Example response</summary>
<details>

200 OK

</details>

**GET** `misc/hasUpdates?since=2019-07-19T00:00:00.000Z`

Check if there have been updates to the data since a given date. By checking this, you can avoid requerying the API for data you have retrieved since the given time in `since`.

<summary>Example response</summary>
<details>

```
{
    "hasUpdates": true
}
```

</details>

---
