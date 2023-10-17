local module = {}

local PlayerDataFetchRequest = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Data.PlayerDataFetchRequest
local DataTypes = require(game:GetService("ReplicatedStorage").CreatorsFolder.ModuleScripts.Types.DataTypes)

local SkillEvents = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Skill
local SkillScripts = game:GetService("ReplicatedStorage").CreatorsFolder.ModuleScripts.SkillScripts

local BeyStatusDataList = require(game:GetService("ReplicatedStorage").CreatorsFolder.ModuleScripts.Data.BeyStatusDataList)
local SkillDataList = require(game:GetService("ReplicatedStorage").CreatorsFolder.ModuleScripts.Data.SkillDataList)

local SkillBoardNormalSkillCoolTimeEvent = game:GetService("ReplicatedStorage").CreatorsFolder.Events.View.Gui.SkillBoardNormalSkillCoolTimeEvent
local SkillBoardEquipSkillCoolTimeEvent = game:GetService("ReplicatedStorage").CreatorsFolder.Events.View.Gui.SkillBoardEquipSkillCoolTimeEvent
local PlayerCurentBeyRequest = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Data.PlayerCurentBeyRequest

local StartSkillIntervalEvent = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Player.StartSkillIntervalEvent
local GetIsSkillIntervalRequest = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Player.GetIsSkillIntervalRequest

function module:TriggerSkill(key:string)
	if GetIsSkillIntervalRequest:Invoke("Normal") then return end

	SkillDataList:GetEventRef(key):FireServer()
	StartSkillIntervalEvent:Fire("Normal",SkillDataList:GetCoolTime(key))
end

function module:TriggerNormalSkill()
	if GetIsSkillIntervalRequest:Invoke("Normal") then return end

	local param : DataTypes.PlayerParam = PlayerDataFetchRequest:InvokeServer()
	local beyKey = PlayerCurentBeyRequest:InvokeServer()
	
	--warn(beyKey)
	if beyKey == nil or beyKey == "" then return end

	local skillKey = BeyStatusDataList:GetNormalSkillKey(beyKey)
	SkillDataList:GetEventRef(skillKey):FireServer()
	SkillBoardNormalSkillCoolTimeEvent:Fire(SkillDataList:GetCoolTime(skillKey))
	
	StartSkillIntervalEvent:Fire("Normal",SkillDataList:GetCoolTime(skillKey))
end

function module:TriggerEquipSkill()
	if GetIsSkillIntervalRequest:Invoke("Equip") then return end

	local param : DataTypes.PlayerParam = PlayerDataFetchRequest:InvokeServer()
	local skillKey = param.currentEquipSkillKey
	
	--今の装備ベイを取得して、スキルを出すかどうかを判断する
	local beyKey = PlayerCurentBeyRequest:InvokeServer()
	if beyKey == nil or beyKey == "" then
		return
	end

	--warn(skillKey)
	if skillKey == nil or skillKey == "" then return end

	SkillDataList:GetEventRef(skillKey):FireServer()
	SkillBoardEquipSkillCoolTimeEvent:Fire(SkillDataList:GetCoolTime(skillKey))
	
	StartSkillIntervalEvent:Fire("Equip",SkillDataList:GetCoolTime(skillKey))
end

function module:Initialize()
	for i,j in pairs(SkillDataList) do
		if not pcall(function() return j.key end) then continue end

		SkillEvents[j.key].OnServerEvent:Connect(function(player:Player)
			local ss = require(SkillScripts[j.key])
			ss:Start(player)
		end)
	end
end

return module
