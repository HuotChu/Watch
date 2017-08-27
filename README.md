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

  > Installation:
  > - Create a new ModuleScript in ServerScriptService
  > - Rename the ModuleScript to **Watch**
  > - Copy the contents of Watch.lua into your ModuleScript and Save.
  
  > To use in Scripts/LocalScripts:
 ```lua
     local ServerScriptService = game:GetService('ServerScriptService')
     local Watch = require(ServerScriptService:WaitForChild('Watch'))
 ```

## Jasmine-inspired syntax

  - Type it like you say it
  - Easy to remember, fast to type

```lua
  -- Make up a name for the thing to watch
  local state = Watch('State')
  
  -- Name the event to listen to
  local stateChange = state:On('change')
  
  -- attach event handler
  stateChange:Do(function (state) print(state) end)
  
  -- Easy way to write the same thing in one line...
  Watch('State'):On('change'):Do(function (state) print(state) end)
  
  -- Fire the event
  Watch('State'):Fire('change', 'someValue')
  
  -- Prints 'someValue'
```

**Watch** is designed to combine coding efficiency with grammatical concepts.

  - Always *Watch* a **Noun**
      + local player = Watch('Player')   -- Noun (person)
      + local data = Watch('DataStore')  -- Noun (place)
      + local ray = Watch('FreezeRay')   -- Noun (thing)
  - Always *On* a **Verb** [Note: On is short for Upon]
      + local onRun = player:On('Run')   -- Verb (walk)
      + local onData = data:On('Update') -- Verb (update)
      + local onHit = ray:On('Hit')      -- Verb (hit)
  - Always *Do* a **Function**
      + local playSoundId = onRun:Do(function() runSound.Play() end)
      + local updateTxtId = onData:Do(function(txt) script.Parent.Text=txt end)
      + local hitHandlerId = onHit:Do(function(effect) session.status=effect end)
  - Always *Fire*, *FireOnce*, or *FireAcross* a **Verb**
      + player.Fire('Run')                   -- Fire at BOTH Client & Server
      + data.FireAcross('Update', 'Data!')   -- Client Fires @ Server OR Server Fires @ Client
      + ray.FireOnce('Hit', 'frozen')        -- Client Fires @ Client OR Server Fires @ Server
&nbsp;

...more to come!
