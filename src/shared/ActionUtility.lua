local module = {}

local RunService = game:GetService("RunService")

--partがプレイヤーのパーツかどうか
function module:GetPlayerFromTouchedPart(part:BasePart) : Player
	if part and part.Parent and part.Parent:FindFirstChild("Humanoid") then
		local player = game.Players:GetPlayerFromCharacter(part.Parent)
		return player
	end

	return nil
end

--プレイヤーのダッシュ処理
local DashPlayerEvent = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Player.DashPlayerEvent
function module:DashPlayer(player:Player,dashPower:number)
	DashPlayerEvent:FireClient(player,dashPower)
end

--プレイヤーの速度変更処理
local PlayerAccelerationEvent = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Player.PlayerAccelerationEvent
function module:ChangePlayerSpeed(player:Player,rate : number,duration : number)
	PlayerAccelerationEvent:FireClient(player,rate,duration)
end

--プレイヤーのジャンプ力変更処理
local PlayerJumpPowerEvent = game:GetService("ReplicatedStorage").CreatorsFolder.Events.Player.PlayerJumpPowerEvent
function module:ChangePlayerJumpPower(player:Player,rate : number,duration : number)
	PlayerJumpPowerEvent:FireClient(player,rate,duration)
end

--対象物への吹き飛ばし処理
function module:Impact(impacter:BasePart,target:BasePart,power)
	--if target == nil then return end
	--warn("impulse",impacter,target)

	--local bv=(target.Position-impacter.Position).Unit
	--target:ApplyImpulse(Vector3.new(bv.X,math.abs(bv.Y),bv.Z)*power)
	--target:ApplyAngularImpulse(Vector3.new(math.random(0,359),math.random(0,359),math.random(0,359)))
end

--攻撃の当たり判定の生成
function module:CreateCommonAttackCD(
	optional:{
		duration : number,
		touchableDelay : number,
		size : number,
		parent : BasePart,
		canCollide : boolean,
		offset : Vector3,
		onTouch : (part:BasePart,target:BasePart,invoker:Player) -> (),
		exclisionName : string,
		invoker : Player,
	}
)
	local thread = coroutine.create(function()
		--warn("AttackCD")
		--warn(optional)
		local cd : Part = Instance.new("Part")
		cd.Name = "AttackCD"
		cd.Parent = workspace
		cd.CanCollide = optional.canCollide
		cd.CollisionGroup = "attackCD"
		cd.Anchored = true
		cd.Size = Vector3.one*optional.size

		local mesh : SpecialMesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.Sphere
		mesh.Parent = cd

		if RunService:IsStudio() then
			cd.Transparency = 0.5
		else
			cd.Transparency = 1
		end

		wait(optional.touchableDelay/60)
		
		local debounceList : {string} = {}
		table.insert(debounceList,optional.exclisionName)
		
		local _time = 0
		cd.Touched:Connect(function(part:BasePart)
			if part and part.Parent and part.Parent:FindFirstChild("Humanoid") then
				local name = part.Parent.Name
				--warn("touch:",name)
				for i = 1, #debounceList do
					--warn("exc:",debounceList[i])
					if debounceList[i] == name then
						return
					end
				end
				table.insert(debounceList,name)

				module:Impact(cd,part,300)
				optional.onTouch(part,cd,optional.invoker)
				--_time += 100000
			end
		end)

		while _time < (optional.duration - optional.touchableDelay)  do
			_time += 1
			cd:PivotTo(optional.parent.CFrame)
			cd.Position += optional.offset
			wait()
		end

		cd:Destroy()
	end)
	coroutine.resume(thread)
end

return module
