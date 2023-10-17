local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local StartTimerRemoteEvent = RS.RemoteEvents.Common.StartTimer
local FinishTimerRemoteEvent = RS.RemoteEvents.Common.FinishTimer
local ResetTimerRemoteEvent = RS.RemoteEvents.Common.ResetTimer

local TimerTextRef = script.TimerTextRef.Value

StartTimerRemoteEvent.OnClientEvent:Connect(function()
	StartTimer()
end)

FinishTimerRemoteEvent.OnClientEvent:Connect(function()
	FinishTimer()
end)

ResetTimerRemoteEvent.OnClientEvent:Connect(function()
	ResetTimer()
end)

local _time = 0
local _isRunTimer = false

function formatTime(currentTime)
	local hours = math.floor(currentTime / 3600)
	local minutes = math.floor((currentTime - (hours * 3600))/60)
	local seconds = math.floor((currentTime - (hours * 3600) - (minutes * 60)))
	local f = "%02d:%02d:%02d"
	return f:format(hours, minutes, seconds)
end

function StartTimer()
	--warn("start timer")
	_isRunTimer = true
	RunService.Stepped:Connect(function(newElapsed, step)
		if not _isRunTimer then return end

		_time += step
		TImerTextRef.Text = formatTime(_time)
	end)
end

function FinishTimer()
	--warn("finish timer")
	_isRunTimer = false
end

function ResetTimer()
	--warn("reset timer")
	_isRunTimer = false
	_time = 0
	TImerTextRef.Text = formatTime(_time)
end

