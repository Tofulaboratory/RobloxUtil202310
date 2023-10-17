local module = {}

local RS = game:GetService("ReplicatedStorage")
local DataTypes = require(RS.CreatorsFolder.ModuleScripts.Types.DataTypes)

local PlayerParamRequest : BindableFunction = RS.CreatorsFolder.Events.Data.PlayerParamRequest
local PlayerGameStartParamRequest : BindableFunction = RS.CreatorsFolder.Events.Data.PlayerGameStartParamRequest
local PlayerParamSaveEvent : BindableEvent = RS.CreatorsFolder.Events.Data.PlayerParamSaveEvent

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
