--[---- Watch API by HuotChu ----]--
--[---- Version 0.2.0 (Beta) ----]--

local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')
local ReplicatedFirst = game:GetService('ReplicatedFirst')

local CreateRemote = function (name)
	local remote = Instance.new('RemoteEvent', ReplicatedStorage)
	remote.Name = name
	return remote
end

local ClientIs, ServerIs, isServer, isClient

if RunService:isServer() and not game.Players.LocalPlayer then
	isServer = true
	ClientIs = CreateRemote('ClientIs')
	ServerIs = CreateRemote('ServerIs')
else
	isClient = true
	ClientIs = ReplicatedStorage:WaitForChild('ClientIs')
	ServerIs = ReplicatedStorage:WaitForChild('ServerIs')
end

local Functions, Nouns, Objects, Verbs = {}, {}, {}, {}
local Storage = {
	Functions = Functions,
	Nouns = Nouns,
	Objects = Objects,
	Verbs = Verbs
}

local Class = function (className)
	local Part = {}
	Part.Class = 'Part'
	Part.Name = 'Part'
	Part.New = function (instanceName, baseObject, functionName)
		baseObject = baseObject or {}
		local bucketName = className..'s'
		Part.Class = className
		Part.Name = instanceName
		if functionName ~= nil then
			Part.__call = function (t, v)
				local fn = t[functionName]
				if fn and type(fn) == 'function' then
					return fn(t, v)
				end
			end
		end
		setmetatable(baseObject, Part)
		if Storage[bucketName] then
			Storage[bucketName][instanceName] = baseObject
		end
		return baseObject
	end
	Part.__index = Part
	Part.__super = Part
	return Part
end

local Function = function (instanceName, baseObject, functionName)
	return Class('Function').New(instanceName, baseObject, functionName)
end

local Verb = function (instanceName, baseObject, functionName)
	if not instanceName then
		print('Verb Error', instanceName, baseObject, functionName)
		return nil
	end
	baseObject = baseObject or {
		Do = function (this, callback)
			local instanceName = this.__super.Name..'_'..string.sub( tostring({}), 8 )
			Function(instanceName, {fn = callback}, 'fn')
			return instanceName
		end
	}
	functionName = functionName or 'Do'
	return Class('Verb').New(instanceName, baseObject, functionName)
end

local Unpack = function (...)
	
end

local Noun = function (instanceName, baseObject, functionName)
	if not instanceName then
		print('Noun Error', instanceName, baseObject, functionName)
		return nil
	end
	baseObject = baseObject or {
		On = function (this, VerbName)
			VerbName = this.__super.Name..'_'..VerbName
			return Verbs[VerbName] or Verb(VerbName)
		end,
		FireAcross = function (this, ...)
			if isClient then
				ClientIs:FireServer(this.__super.Name, ...)
			else
				ServerIs:FireAllClients(this.__super.Name, ...)
			end
			return this
		end,
		FireOnce = function (this, VerbName, ...)
			local args = {...}
			local temp
			if type(VerbName) == 'userdata' then
				temp = VerbName
				VerbName = args[1]
				args[1] = temp
			end
			local name = this.__super.Name..'_'..VerbName
			local verb = Verbs[name] or Verb(VerbName)
			for path, t in pairs(Functions) do
				if path:find(name) then
					-- if passed from Client, 1st argument will be the player
					t.fn(unpack(args))
				end
			end
			return this
		end,
		Fire = function (this, VerbName, ...)
			this:FireOnce(VerbName, ...)
			this:FireAcross(VerbName, ...)
			return this
		end
	}
	functionName = functionName or 'On'
	return Class('Noun').New(instanceName, baseObject, functionName)
end

local Object = function (instanceName, baseObject, functionName)
	-- store the object
	Objects[instanceName] = baseObject
	-- create a Noun for the prototype
	-- storing this doppleganger in Nouns reserves the instanceName as well
	local Temp = Noun(instanceName)
	-- create a proxy table
	local proxy = {}
	local meta = {
		__call = function (...) return baseObject.__call(...) end,
		__index = function (t, k)
			local verb = instanceName..'_'..k
			local value
			if Temp[k] then
				value = Temp[k]
			else
				value = baseObject[k]
				if Verbs[verb] then
					t:FireOnce(k, value, k, 'Get')
				end
			end
			return value
		end,
		__newindex = function (t, k, value)
			local verb = instanceName..'_'..k
			local cache = baseObject[k]
			baseObject[k] = value
			if Verbs[verb] then
				t:FireOnce(k, value, k, 'Set', cache)
			end
		end
	}
	setmetatable(proxy, meta)
	return proxy
end

local Watch = {}

Watch.New = function (className, instanceName, object, functionName)
	if className == 'Noun' then
		return Noun(instanceName, object, functionName)
	else
		return Object(instanceName, object, functionName)
	end
end

Watch = setmetatable(Watch, {
	__index = function (t, k)
		if Nouns[k] then return Nouns[k]
		else return rawget(t, k)
		end
	end,
	__call = function (t, instanceName, object, functionName)
		local className = object and 'Object' or 'Noun'
		local bucketName = className..'s'
		local bucket = Storage[bucketName]
		return (bucket and bucket[instanceName]) or t.New(className, instanceName, object, functionName)
	end
})

if isServer then
	script:Clone().Parent = ReplicatedFirst
	local onClientIs = function (player, parentName, childName, ...)
		Watch(parentName):FireOnce(player, childName, ...)
	end
	ClientIs.OnServerEvent:Connect(onClientIs)
else
	local onServerIs = function (parentName, childName, ...)
		Watch(parentName):FireOnce(childName, ...)
	end
	ServerIs.OnClientEvent:Connect(onServerIs)
end

return Watch
