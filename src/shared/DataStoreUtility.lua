local module = {}

local DataTypes = require(game:GetService("ReplicatedStorage").CreatorsFolder.ModuleScripts.Types.DataTypes)

local PlayerParamRequest : BindableFunction = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Data.PlayerParamRequest
local PlayerGameStartParamRequest : BindableFunction = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Data.PlayerGameStartParamRequest
local PlayerParamSaveEvent : BindableEvent = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Data.PlayerParamSaveEvent

function module:RequestPlayerParam(player:Player) : DataTypes.PlayerParam
	return PlayerParamRequest:Invoke(player)
end

function module:RequestGameStartPlayerParam(player:Player) : DataTypes.PlayerParam
	return PlayerGameStartParamRequest:Invoke(player)
end

function module:SavePlayerParam(player:Player, data : DataTypes.PlayerParam, isCache : boolean)
	PlayerParamSaveEvent:Fire(player,data,isCache)
end

return module
