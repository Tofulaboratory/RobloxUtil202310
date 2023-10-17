local module = {}

function module:Grant(key,target)
	local PlayerEquipSkillUpdateDataEvent = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Data.PlayerEquipSkillUpdateDataEvent

	local debounce : boolean = false
	local debounceDuration = 1
	
	local function ChangeEquipSkill(player:Player)
		PlayerEquipSkillUpdateDataEvent:Fire(player,key)
	end
	
	local clickDetectorPart = Instance.new("Part")
	clickDetectorPart.Size = Vector3.one*10
	clickDetectorPart.Transparency = 1
	clickDetectorPart.Parent = target.Parent
	clickDetectorPart.Anchored = true
	clickDetectorPart.CFrame = target.CFrame
	clickDetectorPart.CanCollide = false
	
	local clickDetector = Instance.new("ClickDetector")
	clickDetector.Parent = clickDetectorPart
	clickDetector.MouseClick:Connect(function(player:Player)		
		ChangeEquipSkill(player)
	end)

	clickDetectorPart.Touched:Connect(function(otherPart:BasePart)
		if otherPart and otherPart.Parent and otherPart.Parent:FindFirstChild("Humanoid") then
			if debounce then return end
			local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
			if player == nil then return end
			ChangeEquipSkill(player)
			
			debounce = true
			wait(debounceDuration)
			debounce = false
		end
	end)
end

return module
