--[---- Watch API by HuotChu ----]--
--[---- Version 0.1.0 (Beta) ----]--

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
		if className ~= 'Object' or functionName then
			baseObject = setmetatable(baseObject, Part)
		end
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
		FireAcross = function (this, VerbName, ...)
			if isClient then
				ClientIs:FireServer(this.__super.Name, VerbName, ...)
			else
				ServerIs:FireAllClients(this.__super.Name, VerbName, ...)
			end
			return this
		end,
		FireOnce = function (this, VerbName, ...)
			local name = this.__super.Name..'_'..VerbName
			local verb = Verbs[name] or Verb(VerbName)
			for path, t in pairs(Functions) do
				if path:find(name) then
					t.fn(...)
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
	return Class('Object').New(instanceName, baseObject, functionName)
end

local Watch = {}

Watch.New = function (className, instanceName, Object, functionName)
	if className == 'Noun' then
		return Noun(instanceName, Object, functionName)
	else
		return Object(instanceName, Object, functionName)
	end
end

Watch = setmetatable(Watch, {
	__index = function (t, k)
		if Nouns[k] then return Nouns[k]
		else return rawget(t, k)
		end
	end,
	__call = function (t, instanceName, Object, functionName)
		local className = Object and 'Object' or 'Noun'
		local bucketName = className..'s'
		local bucket = Storage[bucketName]
		return (bucket and bucket[instanceName]) or t.New(className, instanceName, Object, functionName)
	end
})

if isServer then
	script:Clone().Parent = ReplicatedFirst
	
	local onClientIs = function (player, parentName, childName, ...)
		Watch(parentName):FireOnce(childName, ...)
	end
	ClientIs.OnServerEvent:Connect(onClientIs)
else
	local onServerIs = function (parentName, childName, ...)
		Watch(parentName):FireOnce(childName, ...)
	end
	ServerIs.OnClientEvent:Connect(onServerIs)
end

return Watch
