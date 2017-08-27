# Watch

> Work In Progress: Version 0.1.0 (Beta)

### Watch provides a clean, obvious syntax for managing events within Roblox Lua code.

  - Supports FilteringEnabled and Experimental games
  - Eventing-made-easy with 4 way event communication.
      - Server > Server
      - Server > Client
      - Client > Server
      - Client > Client
  - Replaces the need to create RemoteFunction/RemoteEvent objects

## Installation:
  1. Create a new ModuleScript in ServerScriptService
  2. Rename the ModuleScript to **Watch**
  3. Copy the contents of Watch.lua into your ModuleScript and Save.
  
 To use **Watch** in your Scripts/LocalScripts:
 
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
      + local player = Watch('Player')
      + local data = Watch('DataStore')
      + local ray = Watch('FreezeRay')
  - Always *On* a **Verb** [Note: On is short for Upon]
      + local onRun = player:On('Run')
      + local onData = data:On('Update')
      + local onHit = ray:On('Hit')
  - Always *Do* a **Function**
      + local playSoundId = onRun:Do(function() runSound.Play() end)
      + local updateTxtId = onData:Do(function(txt) script.Parent.Text=txt end)
      + local hitHandlerId = onHit:Do(function(effect) session.status=effect end)
  - Always *Fire*, *FireOnce*, or *FireAcross* a **Verb**
      + player.Fire('Run')
      + data.FireAcross('Update', 'Data!')
      + ray.FireOnce('Hit', 'frozen')
&nbsp;

...more to come!
