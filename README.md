# Bot-Server

Hi, you will be building something we'll call a 'Bot-Server'. It will be built entirely in Ruby.

## Overview

You can imagine yourself as a little civilization of bots. The goal of your civilization is to get as many minerals as possible, as fast as possible. Your bots interact with a 'Landscape Server', which contains 100 cells. Each cell has a finite amount of minerals and food. You want minerals, so you mine the landscape. You need to feed yourself too, so you harvest food from the landscape. It is important to remember that mining is a destructive process. Mining a cell unfortunately reduces the amount of food in that cell.

Traveling out to the mines and the fields takes energy, and your bots have a finite amount of energy. Your energy can be replenished with food. The further away your mine is, the more food your bot needs to eat to get there. If a bot's energy runs out, it dies and is erased from the server.

Every time a bot mines, its mining experience (xp) increases. The more mining_xp a bot has, the more efficiently it can mine. Similarly, every time a bot harvests, its harvesting_xp increases. The higher it is, the more efficiently it can harvest.

When a bot mines minerals or harvests food without dying, the minerals and food are transferred to something we will call a 'stockpile'. The stockpile is where resources are stored. When bots need to eat, they take food from the stockpile. When you want to build a new bot, you pay for it with minerals from the stockpile.

So yep, new bots can be built at a mineral cost. More bots means a greater ability to harvest and mine. You want more minerals, so you may want more bots at some point.

## Database

Great, so your Bot-Server will have a database. Your database will contain a single stockpile. That stockpile will have a mineral_count and a food_count. Your database will also have a table of bots. Each bot will have an id, energy, mining_xp, and harvesting_xp. Mining and harvesting xp will initially be 1. You can decide how much energy a bot starts off with.

## API

A 'Command-Station' will be commanding your bots. Think of the Command-Station as a sort of dictator. You will be building API endpoints that allow the Command-Station to control and return information about your bots.

You will build a GET '/bots' endpoint that returns information on all your bots. You will also be building a GET '/bots/:id' endpoint which returns information about a single bot with a given id. Those routes might look like this:

```

GET '/bots'
description:
  returns information about all bots
response:
  [
    {
      "id" : __,
      "energy" : __,
      "mining_xp" : __,
      "harvesting_xp" : __
    },
    ...
  ]

GET '/bots/:id'
description:
  returns information about bot with specified id
response:
  {
    "id" : __,
    "energy" : __,
    "mining_xp" : __,
    "harvesting_xp" : __
  }

```

We should also build a POST '/bots' endpoint that will allow the Command Station to build a new bot for a mineral cost that you get to determine. It may look like this:

```
POST '/bots'
  description:
    creates a new bot. has a set mineral cost of ____.
  response:
    {
      "bot_id" : __,
      "bot_energy" : __,
      "bot_mining_xp" : __,
      "bot_harvesting_xp" : __,
      "mineral_cost" : __,
      "stockpile_mineral_count" : __
    }
```

You will build a GET '/stockpile' endpoint that returns information about the stockpile. It might look like this:

```
GET '/stockpile'
description:
  returns information about the stockpile
response:
  {
    "mineral_count" : __,
    "food_count" : __
  }
```

You will build a POST '/bots/:id/mine' endpoint that causes a bot with specified id to mine the landscape server at specified coords.

```
POST '/bots/:id/mine'
description:
  causes bot with specified id to mine from landscape server at specified coordinates. This has an energy cost equal to sqrt(x^2 + y^2). If energy cost exceeds energy of bot, nothing is mined, and the bot dies and is removed from the database. Otherwise, bot's energy is decremented, bot's experience is incremented, and the number of minerals it has mined are added to the stockpile.
data:
  {
    "x" : <between 1 - 100>,
    "y" : <between 1 - 100>
  }
response:
  {
    "bot_status" : <"alive" or "dead">,
    "bot_energy" : __,
    "mining_xp" : __,
    "distance_traveled" : __,
    "minerals_mined" : __
  }
```

And you will build a similar endpoint, POST '/bots/:id/harvest', that causes a bot with specified id to harvest from the landscape server at specified coords.

```
POST '/bots/:id/harvest'
description:
  causes bot with specified id to harvest from landscape server at specified coordinates. This has an energy cost equal to sqrt(x^2 + y^2). If energy cost exceeds energy of bot, nothing is harvested, and the bot dies and is removed from the database. Otherwise, bot's energy is decremented, bot's experience is incremented, and the amount of food it has harvested is added to the stockpile.
data:
  {
    "x" : <between 1 - 100>,
    "y" : <between 1 - 100>
  }
response:
  {
    "bot_status" : <"alive" or "dead">,
    "bot_energy" : __,
    "harvesting_xp" : __,
    "distance_traveled" : __,
    "food_harvested" : __
  }
```

Finally, your bots will need to be fed. Else, they will die. So we will build a POST '/bots/:id/feed' endpoint that feeds a bot with specified id with food from the stockpile.

```
POST '/bots/:id/feed'
description:
  feeds a bot with specified id. this increments the bot's energy and decrements the stockpile's food count by specified amount.
data:
  {
    "food_amount" : __
  }
response:
  {
    "bot_energy" : __,
    "stockpile_food_count" : __
  }
```
