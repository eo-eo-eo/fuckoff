if game.PlaceId ~= 117452115137842 and game.PlaceId ~= 83363871432855 then return end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("ApplyElevatorSettings")

local function createUICorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
end

local function setFont(obj)
	obj.FontFace = Font.new("rbxasset://fonts/families/PressStart2P.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

local function tweenColor(obj, color, time)
	local info = TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(obj, info, {BackgroundColor3 = color}):Play()
end

local function tweenScale(obj, scale, time)
	local info = TweenInfo.new(time or 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	TweenService:Create(obj, info, {Size = obj.Size * scale}):Play()
end

local function animateButton(btn)
	local normal = Color3.fromRGB(64, 68, 75)
	local hover = Color3.fromRGB(80, 85, 95)
	local down = Color3.fromRGB(50, 54, 60)

	btn.MouseEnter:Connect(function()
		tweenColor(btn, hover)
		tweenScale(btn, 1.05)
	end)

	btn.MouseLeave:Connect(function()
		tweenColor(btn, normal)
		tweenScale(btn, 1 / 1.05)
	end)

	btn.MouseButton1Down:Connect(function()
		tweenColor(btn, down)
	end)

	btn.MouseButton1Up:Connect(function()
		tweenColor(btn, btn:IsHovered() and hover or normal)
	end)
end

local function animateTextbox(tb)
	local normal = Color3.fromRGB(64, 68, 75)
	local focus = Color3.fromRGB(90, 95, 105)

	tb.MouseEnter:Connect(function()
		tweenScale(tb, 1.03)
	end)

	tb.MouseLeave:Connect(function()
		tweenScale(tb, 1 / 1.03)
	end)

	tb.Focused:Connect(function()
		tweenColor(tb, focus)
	end)

	tb.FocusLost:Connect(function()
		tweenColor(tb, normal)
	end)
end

local function createTextbox(placeholder, y, parent)
	local tb = Instance.new("TextBox")
	tb.Size = UDim2.new(1, -30, 0, 30)
	tb.Position = UDim2.new(0, 15, 0, y)
	tb.Text = placeholder
	tb.TextColor3 = Color3.fromRGB(180, 180, 180)
	tb.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
	tb.BorderSizePixel = 0
	tb.Parent = parent
	createUICorner(tb, 6)
	setFont(tb)
	tb.TextSize = 18

	tb.Focused:Connect(function()
		if tb.Text == placeholder then
			tb.Text = ""
			tb.TextColor3 = Color3.new(1, 1, 1)
		end
	end)

	tb.FocusLost:Connect(function()
		if tb.Text == "" then
			tb.Text = placeholder
			tb.TextColor3 = Color3.fromRGB(180, 180, 180)
		end
	end)

	animateTextbox(tb)
	return tb
end

local function createButton(text, y, parent, action)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -30, 0, 30)
	b.Position = UDim2.new(0, 15, 0, y)
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
	b.BorderSizePixel = 0
	b.Parent = parent
	createUICorner(b, 6)
	setFont(b)
	b.TextSize = 18
	b.MouseButton1Click:Connect(action)
	animateButton(b)
	return b
end

if game.PlaceId == 117452115137842 then
	local elevators = workspace:FindFirstChild("Elevators")
	if elevators then
		local names = {}
		for _, model in ipairs(elevators:GetChildren()) do
			if model:IsA("Model") then
				local original = model.Name
				if names[original] then
					local unique = original
					repeat
						unique = unique .. "."
					until not elevators:FindFirstChild(unique)
					model.Name = unique
				else
					names[original] = true
				end
			end
		end
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "ElevatorSpammerUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = CoreGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(300, 260)
	frame.Position = UDim2.new(0.5, -150, 0.5, -130)
	frame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 1
	frame.Parent = gui
	createUICorner(frame, 12)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 36)
	title.BackgroundTransparency = 1
	title.Text = "ElevatorSpammer"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	setFont(title)
	title.TextSize = 22
	title.Parent = frame

	local tb1 = createTextbox("Amount of People(any amount)", 46, frame)

	local btn2
	local function toggleBtn2()
		btn2.Text = (btn2.Text == "Let people in") and "Don't let people in" or "Let people in"
	end

	btn2 = createButton("Let people in", 86, frame, toggleBtn2)
	local tb3 = createTextbox("Mode(can be put as anything)", 126, frame)
	local tb4 = createTextbox("Map(can be put as anything)", 166, frame)

	local spamming = false
	local spamThread
	local btn

	btn = createButton("Spam", 210, frame, function()
		if spamming then
			spamming = false
			btn.Text = "Spam"
			if spamThread then
				task.cancel(spamThread)
				spamThread = nil
			end
			return
		end

		spamming = true
		btn.Text = "Stop Spam"

		spamThread = task.spawn(function()
			local val1 = tb1.Text
			local val2 = (btn2.Text == "Don't let people in")
			local val3 = tb3.Text
			local val4 = tb4.Text
			local elevatorsFolder = workspace:FindFirstChild("Elevators")
			if not elevatorsFolder then return end

			while spamming do
				for _, elevatorModel in ipairs(elevatorsFolder:GetChildren()) do
					if elevatorModel:IsA("Model") then
						remote:FireServer(val1, val2, val3, val4, elevatorModel)
						task.wait()
					end
					if not spamming then break end
				end
				task.wait()
			end
		end)
	end)

	local dragging, input, start, offset
	frame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			start = i.Position
			offset = frame.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement then
			input = i
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if i == input and dragging then
			local delta = i.Position - start
			frame.Position = UDim2.new(offset.X.Scale, offset.X.Offset + delta.X, offset.Y.Scale, offset.Y.Offset + delta.Y)
		end
	end)

	-- fade in
	TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
end
