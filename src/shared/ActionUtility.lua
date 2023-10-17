local module = {}

local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")

--partがプレイヤーのパーツかどうか
function module:GetPlayerFromTouchedPart(part:BasePart) : Player
	if part and part.Parent and part.Parent:FindFirstChild("Humanoid") then
		local player = game.Players:GetPlayerFromCharacter(part.Parent)
		return player
	end

	return nil
end

--プレイヤーのダッシュ処理
local DashPlayerEvent = RS.CreatorsFolder.Events.Player.DashPlayerEvent
function module:DashPlayer(player:Player,dashPower:number)
	DashPlayerEvent:FireClient(player,dashPower)
end

--プレイヤーの速度変更処理
local PlayerAccelerationEvent = RS.CreatorsFolder.Events.Player.PlayerAccelerationEvent
function module:ChangePlayerSpeed(player:Player,rate : number,duration : number)
	PlayerAccelerationEvent:FireClient(player,rate,duration)
end

--プレイヤーのジャンプ力変更処理
local PlayerJumpPowerEvent = RS.CreatorsFolder.Events.Player.PlayerJumpPowerEvent
function module:ChangePlayerJumpPower(player:Player,rate : number,duration : number)
	PlayerJumpPowerEvent:FireClient(player,rate,duration)
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
				for i = 1, #debounceList do
					if debounceList[i] == name then
						return
					end
				end
				table.insert(debounceList,name)

				optional.onTouch(part,cd,optional.invoker)
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
