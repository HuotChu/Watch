# Watch

> Work In Progress: Version 0.2.0 (Beta)

### Watch provides a clean, obvious syntax for managing events within Roblox Lua code.

  - Eventing-made-easy with 4 way event communication.
      - Server > Server
      - Server > Client
      - Client > Server
      - Client > Client
  - Supports FilteringEnabled, Experimental, and Studio Solo Play
  - Watch the properties of any Table for changes!
  - Watch your own synthetic objects fire synthetic events!
  - No need to create RemoteEvents!!!

## Installation:
  1. Create a new ModuleScript in ServerScriptService
  2. Rename the ModuleScript to **Watch**
  3. Copy the contents of Watch.lua into your ModuleScript and Save.
  
 To use **Watch** in your Scripts/LocalScripts:
 
 ```lua
     local ServerScriptService = game:GetService('ServerScriptService')
     local Watch = require(ServerScriptService:WaitForChild('Watch'))
 ```
 
 > Sample Game with Examples (no copylock) [https://www.roblox.com/games/994624803/Watch-Module-for-Roblox-Development]

## Jasmine-inspired syntax

  - Type it like you say it
  - Easy to remember, fast to type

```lua
  ----[ Synthetic Event Example ]----
  
  -- Make up a name for the thing to watch
  local state = Watch('State')
  
  -- Name the event to listen to
  local stateChange = state:On('Change')
  
  -- attach event handler
  stateChange:Do(function (state) print(state) end)
  
  -- Easy way to write the same thing in one line...
  Watch('State'):On('Change'):Do(function (state) print(state) end)
  
  -- Pro-Tip #1: Method names *On* and *Do* are **optional**
  -- Pro-Tip #2: This form is not recommended, unless you understand why it works
  Watch('State')('Change')(function (state) print(state) end)
  
  -- Fire the event
  Watch('State'):Fire('change', 'someValue')
  
  -- Prints 'someValue'
```

**Watch** is designed to combine coding efficiency with common grammatical constructs.

  - Always *Watch* a **Noun** (*optionally pass a Table to Watch after the Name)
      + local player = Watch(**'Player'**)
      + local data = Watch(**'DataStore'**)
      + local ray = Watch(**'FreezeRay'**)
      + ----------------------TABLE EXAMPLE----------------------
      + local p1Health = Watch(**'Player1_Health'**, {name='Player1', health=100})
      
  - Always *On* a **Verb** [Note: On is short for Upon]
      + local onRun = player:On(**'Run'**)
      + local onData = data:On(**'Update'**)
      + local onHit = ray:On(**'Hit'**)
      + -----------TABLES TEND TO BREAK THE VERB RULE-----------
      + local onHealthChange = p1Health:On(**'health'**)
      
  - Always *Do* a **Function**
      + local playSoundId = onRun:Do(**function() runSound.Play() end**)
      + local updateTxtId = onData:Do(**function(txt) script.Parent.Text=txt end**)
      + local hitHandlerId = onHit:Do(**function(effect) session.status=effect end**)
      + ----------------------TABLE EXAMPLE----------------------
      + local p1HealthId = onHealthChange:Do(function (v, k) print(k..' is '..v) end)
      
  - Always *Fire*, *FireOnce*, or *FireAcross* a **Verb**
      + player:Fire(**'Run'**)
      + data:FireAcross(**'Update'**, 'Data!')
      + ray:FireOnce(**'Hit'**, 'frozen')
      + ------TABLE EVENTS FIRE WHEN PROPERTY VALUES CHANGE------
      + p1Health.health = '90'
      
## Four Ways to Fire Events

1. Watch(Noun):Fire(Verb, Args)
    * Fire - fires the event on both Client & Server
2. Watch(Noun):FireAcross(Verb, Args)
    * FireAcross - fires the event to the other side only
    * Client fires across to Server OR Server fires across to Client
3. Watch(Noun):FireOnce(Verb, Args)
    * FireOnce - fires the event to the same side only
    * Client fires to Client OR Server fires to Server
4. Watch(Noun, Table)
    * Returns a proxy table.
    * Changing the proxy updates the original table.
    * 'Get' and 'Set' fire events for watched properties only.
    * local foo = table.prop fires a 'Get' event
    * table.prop = 'foo' fires a 'Set' event
    * Event handlers receive 3 arguments on 'Get', 4 on 'Set'
    * Arguments, in order, are **value**, **key**, **accessType**, **oldValue**
        + value = the current value in the table
        + key = the property name of the table
        + accessType = the string 'Get' or 'Set'
        + oldValue = passed on 'Set', the value before it was changed

&nbsp;

...more to come!
