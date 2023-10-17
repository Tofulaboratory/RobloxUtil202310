local module = {}

local TweenService = game:GetService("TweenService")
local EffectDataList = require(game:GetService("ReplicatedStorage").CreatorsFolder.ModuleScripts.Data.EffectDataList)

function module:CreateEffect(
	key : string,
	duration : number,
	beginCFrame : CFrame,
	offset : Vector3,
	rotateOffset : Vector3,
	size : number,
	optional : {
		offsetForward : number
	}
)	
	local effect : BasePart = nil

	local thread = coroutine.create(function()
		local root : Model = Instance.new("Model")
		root.Parent = workspace

		effect = EffectDataList:GetRef(key):Clone()
		effect.Parent = root
		
		if beginCFrame ~= nil then
			effect:PivotTo(beginCFrame)
			effect.Position += offset
			effect.Orientation += rotateOffset
			
			if optional ~= nil then 
				local a : Vector3 = effect.CFrame.LookVector
				local b : number = optional.offsetForward
				local angle = math.rad(math.deg(math.atan2(a.Z,a.X))-90)
				local dir = Vector3.new(
					math.sin(-angle)*b,
					0,
					math.cos(-angle)*b
				)
				effect.Position += dir
			end
		end

		root:ScaleTo(size)

		local _time=0
		while _time < duration  do
			_time += 1
			wait()
		end

		root:Destroy()
	end)
	coroutine.resume(thread)

	return effect
end

function module:CreateFolowEffect(
	key : string,
	duration : number,
	rotateOffset : Vector3,
	size : number,
	parent : Part,
	optional : {
		offsetForward : number
	}
)	
	local effect = nil
	effect = EffectDataList:GetRef(key):Clone()

	local thread = coroutine.create(function()
		local model = Instance.new("Model")
		model.Parent = parent
	
		effect = EffectDataList:GetRef(key):Clone()
		effect.Parent = model
		
		model:ScaleTo(size)

		local _time=0
		while _time < duration  do
			_time += 1
			effect:PivotTo(parent.CFrame)
			effect.Orientation += rotateOffset
			if optional ~= nil then 
				local a : Vector3 = effect.CFrame.LookVector
				local b : number = optional.offsetForward
				local angle = math.rad(math.deg(math.atan2(a.Z,a.X))-90)
				local dir = Vector3.new(
					math.sin(-angle)*b,
					0,
					math.cos(-angle)*b
				)
				effect.Position += dir
			end

			wait()
		end

		effect:Destroy()
	end)
	coroutine.resume(thread)

	return effect 
end

function module:CreateEffectWithMoveToTween(
	key : string,
	duration : number,
	beginCFrame : CFrame,
	offset : Vector3,
	rotateOffset : Vector3,
	size : number,
	tweenTargetPosition : Vector3,
	onDestroy : (touchPart:BasePart)->(),
	optional : {
		offsetForward : number
	}
)	
	local effect = nil
	
	local thread = coroutine.create(function()
		local root : Model = Instance.new("Model")
		root.Parent = workspace

		effect = EffectDataList:GetRef(key):Clone()
		effect.Parent = root

		local ti = TweenInfo.new(duration/30,Enum.EasingStyle.Quad)
		local goal = {}
		goal.Position = tweenTargetPosition

		local list = {}
		table.insert(list,effect)

		for i,j in pairs(effect:GetChildren()) do
			if j:IsA("BasePart") then
				table.insert(list,j)
			end
		end
		
		for i,j in pairs(list) do			
			j.Anchored = true
			if beginCFrame ~= nil then
				j:PivotTo(beginCFrame)
				j.Position += offset
				j.Orientation += rotateOffset

				if optional ~= nil then 
					local a : Vector3 = j.CFrame.LookVector
					local b : number = optional.offsetForward
					local angle = math.rad(math.deg(math.atan2(a.Z,a.X))-90)
					local dir = Vector3.new(
						math.sin(-angle)*b,
						0,
						math.cos(-angle)*b
					)
					j.Position += dir
				end
			end

			TweenService:Create(j,ti,goal):Play()
		end

		root:ScaleTo(size)

		local _time=0
		while _time < duration  do
			_time += 1
			wait()
		end

		onDestroy(effect)
		root:Destroy()
	end)
	coroutine.resume(thread)

	return effect
end

function module:CreateEffectWithMoveToPlayerForward(
	key : string,
	duration : number,
	size : number,
	beginForward : number,
	endForward : number,
	player : Player,
	onDestroy : (touchPart:BasePart)->()
)	
	local effect = nil

	local thread = coroutine.create(function()
		local root : Model = Instance.new("Model")
		root.Parent = workspace

		effect = EffectDataList:GetRef(key):Clone()
		effect.Parent = root
		
		local playerCFrame = player.Character:WaitForChild("HumanoidRootPart").CFrame

		local ti = TweenInfo.new(duration/30,Enum.EasingStyle.Quad)

		local list = {}
		table.insert(list,effect)

		for i,j in pairs(effect:GetChildren()) do
			if j:IsA("BasePart") then
				table.insert(list,j)
			end
		end

		for i,j in pairs(list) do			
			j.Anchored = true
			j:PivotTo(playerCFrame)

			local a : Vector3 = j.CFrame.LookVector
			local angle = math.rad(math.deg(math.atan2(a.Z,a.X))-90)
			local dir = Vector3.new(math.sin(-angle),0,math.cos(-angle))
			j.Position += dir*beginForward

			TweenService:Create(
				j,
				ti,
				{Position = playerCFrame.Position + dir*endForward}
			):Play()
		end

		root:ScaleTo(size)

		local _time=0
		while _time < duration  do
			_time += 1
			wait()
		end

		onDestroy(effect)
		root:Destroy()
	end)
	coroutine.resume(thread)

	return effect
end

return module


