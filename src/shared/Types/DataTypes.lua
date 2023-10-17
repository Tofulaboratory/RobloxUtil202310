local module = {}

--プレイヤーパラメータ
export type PlayerParam = {
	playerId : number,
	currentEquipSkillKey : string,
	point : number,
}

function module:GetInitialData(id) : PlayerParam
	return {
		playerId = id,
		currentEquipSkillKey = "CutOff",
		point = 0,
	}
end

return module
