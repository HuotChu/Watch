local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ClientIs = ReplicatedStorage:FindFirstChild('ClientIs')
local ServerIs = ReplicatedStorage:FindFirstChild('ServerIs')

local CreateRemote = function (name)
	local remote = Instance.new('RemoteEvent', ReplicatedStorage)
	remote.Name = name
	return remote
end

if not ClientIs then
	ClientIs = CreateRemote('ClientIs')
end

if not ServerIs then
	ServerIs = CreateRemote('ServerIs')
end

local Class = function (name)
	local t = {}
	t.__index = t
	t.New = function (name)
		return setmetatable({Name = name}, t)
	end
	return t
end

local Nouns = {}
local Noun = Class()
local Verbs = {}
local Verb = Class()
local Actions = {}

local New = function (which, name)
	local foo, where
	if which == 'Noun' then
		which = Noun
		where = Nouns
	else
		which = Verb
		where = Verbs
	end
	foo = which.New(name)
	where[name] = foo
	return foo
end

Verb.Do = function (this, action)
	local name = this.Name..'_'..string.sub( tostring({}), 8 )
	Actions[name] = action
	return name
end

Noun.On = function (this, VerbName)
	VerbName = this.Name..'_'..VerbName
	return Verb[VerbName] or New('Verb', VerbName)
end

Noun.FireAcross = function (this, VerbName, ...)
	if game.Players.LocalPlayer then
		ClientIs:FireServer(this, VerbName, ...)
	else
		ServerIs:FireAllClients(this, VerbName, ...)
	end
end

Noun.FireOnce = function (this, VerbName, ...)
	local name = this.Name..'_'..VerbName
	local verb = Verb[name] or New('Verb', VerbName)
	for path, action in pairs(Actions) do
		if path:find(name) then
			pcall(action, ...)
		end
	end
end

Noun.Fire = function (this, VerbName, ...)
	this:FireOnce(VerbName, ...)
	this:FireAcross(VerbName, ...)
end

local Watch = setmetatable({}, {
	__index = function (t, k)
		if Nouns[k] then return Nouns[k]
		else return rawget(t, k)
		end
	end,
	__call = function (this, ObjectName)
		return Nouns[ObjectName] or New('Noun', ObjectName)
	end
})

return Watch
