# Watch

> Work In Progress: Alpha Version 2.0

Watch provides a clean, obvious syntax for managing events within Roblox Lua code.

  - Supports FilteringEnabled and Experimental games
  - Eventing-made-easy with 4 way event communication.
      - Server > Server
      - Server > Client
      - Client > Server
      - Client > Client
  - Replaces the need to create RemoteFunction/RemoteEvent objects

## Jasmine-inspired syntax

  - Type it like you say it
  - Easy to remember, fast to type

```lua
  -- Make up a name for the thing to watch
  local state = Watch('State')
  
  -- Name the event to listen to
  local stateChange = state:On('stateChange')
  
  -- attach event handler
  stateChange:Do(function (state) print(state) end)
  
  -- Easy way to write the same thing in one line...
  Watch('State'):On('stateChange'):Do(function (state) print(state) end)
  
  -- Fire the event
  Watch('State'):FireOnce('stateChange', 'someValue')
  
  -- Prints 'someValue'
```

&nbsp;

...more to come!
