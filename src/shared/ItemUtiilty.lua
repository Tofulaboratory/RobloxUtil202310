local module = {}

local ItemDataList = require(game:GetService("ReplicatedStorage").CreatorsFolder.ModuleScripts.Data.ItemDataList)

function module:Grant(key,target)
	local debounce : boolean = false
	local debounceDuration = 0.5

	target.Touched:Connect(function(otherPart:BasePart)
		if debounce then return end

		if otherPart and otherPart.Parent and otherPart.Parent:FindFirstChild("Humanoid") then
			local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
			if player == nil then return end

			ItemDataList:GetRoutine(key)(player,target)

			debounce = true
			wait(debounceDuration)
			debounce = false
		end
	end)
end

return module
