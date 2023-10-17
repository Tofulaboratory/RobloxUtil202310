local DataStoreService = game:GetService("DataStoreService")
local RS = game:GetService("ReplicatedStorage")
local DataTypes = require(RS.Common.Types.DataTypes)

local _env = "dev"
--local env = "test"
--local env = "staging"
--local env = "prod"
local _version = "001"
local _key = "player_param"
local DataStoreKey = _env.._version.._key

local playerDataCache = {}
function UpdateDataCache(data:DataTypes.PlayerParam)
	if data == nil then return end
	
	--warn("update cache")
	for i=1,#playerDataCache do
		if playerDataCache[i].playerId == data.playerId then
			--warn("overwhite old cache data",playerDataCache[i].playerId)
			playerDataCache[i] = data
			return
		end
	end

	table.insert(playerDataCache,data)
	--warn("cache size:",#playerDataCache)
end

function GetDataCache(userId:number) : DataTypes.PlayerParam
	--warn("get cache")
	for i,j in pairs(playerDataCache) do
		if j.playerId == userId then
			return j
		end
	end

	--warn("don't find cache",userId)
	return nil
end

local PlayerParamBindableRequest : BindableFunction = RS.Common.BindableFunctions.PlayerParamBindableRequest
PlayerParamBindableRequest.OnInvoke = function(player:Player)
	return FetchPlayerParam(player.UserId)
end

local PlayerGameStartParamBindableRequest : BindableFunction = RS.Common.BindableFunctions.PlayerGameStartParamBindableRequest
PlayerGameStartParamBindableRequest.OnInvoke = function(player:Player)
	local data : DataTypes.PlayerParam = FetchPlayerParam(player.UserId)
	SavePlayerParam(player.UserId,data,false)
	return data
end

local PlayerParamSaveBindableEvent : BindableEvent = RS.Common.BindableEvents.PlayerParamSaveBindableEvent
PlayerParamSaveBindableEvent.Event:Connect(function(player:Player, data : DataTypes.PlayerParam, isCache : boolean)
	SavePlayerParam(player.UserId,data,isCache)	
end)

function Fetch(dataStore: DataStore, key : string, userId:number) : any
	local dataKey = userId.."_"..key
	local success, value = pcall(function()
		return dataStore:GetAsync(dataKey)
	end)

	if not success then 
		return nil 
	end

	return value
end

function Save(dataStore: DataStore, key : string, userId:number, data : DataTypes.PlayerParam, isCache : boolean)
	UpdateDataCache(data)
	if isCache then return end

	local dataKey = userId.."_"..key
	if data == nil then
		--warn("data don't save, because data is nil.")
	else
		dataStore:SetAsync(dataKey,data)	
	end
end

function FetchPlayerParam(userId:number) : DataTypes.PlayerParam
	local dataStore = DataStoreService:GetDataStore(DataStoreKey)
	local data = GetDataCache(userId)
	if data == nil then
		data = Fetch(dataStore,"player_param",userId)
		UpdateDataCache(data)
	end

	return data
end

function SavePlayerParam(userId:number, data : DataTypes.PlayerParam,isCache : boolean)
	local dataStore = DataStoreService:GetDataStore(DataStoreKey)
	Save(dataStore,"player_param",userId,data,isCache)
end