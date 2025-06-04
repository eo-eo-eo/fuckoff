print("Hi")
if game.PlaceId ~= 117452115137842 and game.PlaceId ~= 83363871432855 then return end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local remote = ReplicatedStorage:WaitForChild("ApplyElevatorSettings")

local globalHue = 0

local function createUICorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
end

local function createShadow(parent)
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageTransparency = 0.5
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.Size = UDim2.new(1, 10, 1, 10)
	shadow.Position = UDim2.new(0, -5, 0, -5)
	shadow.ZIndex = parent.ZIndex - 1
	shadow.Parent = parent
end

local function setFont(obj)
	obj.FontFace = Font.new("rbxasset://fonts/families/PressStart2P.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

local function pulseOnHover(button)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(0, 255, 255)}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.new(1, 1, 1)}):Play()
	end)
end

local rippleHue = 0
local function rippleEffect(button)
	button.ClipsDescendants = true
	button.MouseButton1Click:Connect(function()
		rippleHue = (rippleHue + 60) % 360
		local ripple = Instance.new("Frame")
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.BackgroundTransparency = 0.5
		ripple.BackgroundColor3 = Color3.fromHSV(rippleHue / 360, 1, 1)
		ripple.Position = UDim2.new(0, button.AbsoluteSize.X / 2, 0, button.AbsoluteSize.Y / 2)
		ripple.AnchorPoint = Vector2.new(0.5, 0.5)
		ripple.Parent = button
		createUICorner(ripple, 999)
		local tween = TweenService:Create(ripple, TweenInfo.new(0.6), {
			Size = UDim2.new(3, 0, 3, 0),
			BackgroundTransparency = 1
		})
		tween:Play()
		tween.Completed:Connect(function()
			ripple:Destroy()
		end)
	end)
end

local function applyGlowAndEffectsToTextBox(tb)
	local glow = Instance.new("UIStroke")
	glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	glow.Color = Color3.fromHSV(0, 1, 1)
	glow.Thickness = 2
	glow.Parent = tb
	RunService.RenderStepped:Connect(function()
		local color = Color3.fromHSV(globalHue / 360, 1, 1)
		glow.Color = color
		tb.TextColor3 = color
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
	tb.ZIndex = 2
	tb.Parent = parent
	createUICorner(tb, 6)
	createShadow(tb)
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

	applyGlowAndEffectsToTextBox(tb)

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
	b.ZIndex = 2
	b.Parent = parent
	createUICorner(b, 6)
	createShadow(b)
	setFont(b)
	b.TextSize = 18

	rippleEffect(b)
	pulseOnHover(b)

	return b
end

if game.PlaceId == 117452115137842 then
	local f = workspace:FindFirstChild("Elevators")
	if f then
		local n = {}
		for _, m in ipairs(f:GetChildren()) do
			if m:IsA("Model") then
				local o = m.Name
				if n[o] then
					local s = o
					repeat s = s .. "." until not f:FindFirstChild(s)
					m.Name = s
				else
					n[o] = true
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
	frame.Size = UDim2.fromOffset(320, 280)
	frame.Position = UDim2.new(0.5, -150, 0.5, -130)
	frame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 1
	frame.ZIndex = 2
	frame.Parent = gui
	createUICorner(frame, 12)
	createShadow(frame)

	local glow = Instance.new("UIStroke")
	glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	glow.Color = Color3.fromHSV(0, 1, 1)
	glow.Thickness = 4
	glow.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 36)
	title.BackgroundTransparency = 1
	title.Text = "ElevatorSpammer"
	title.TextColor3 = Color3.fromHSV(0, 1, 1)
	title.ZIndex = 3
	setFont(title)
	title.TextSize = 22
	title.Parent = frame

	local tb1 = createTextbox("Amount of People", 46, frame)

	local btn2
	local function toggleBtn2()
		if btn2 then
			btn2.Text = (btn2.Text == "Let people in") and "Don't let people in" or "Let people in"
		end
	end
	btn2 = createButton("Let people in", 86, frame, toggleBtn2)

	local tb3 = createTextbox("Mode", 126, frame)
	local tb4 = createTextbox("Map", 166, frame)

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

	createButton("Join endelss(wait ten sec)", 250, frame, function()
		firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Elevators["Elevator2.0 (endless mode)"].Entrance, 0)
		wait(2)
		game:GetService("ReplicatedStorage"):WaitForChild("ApplyElevatorSettings"):FireServer(1, false, "Nightmare", "Endless", workspace.Elevators["Elevator2.0 (endless mode)"])
	end)

	local dragging, input, start, offset

	frame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			start = i.Position
			offset = frame.Position

			local ripple = Instance.new("Frame")
			ripple.Size = UDim2.new(0, 0, 0, 0)
			ripple.BackgroundTransparency = 0.5
			ripple.BackgroundColor3 = Color3.fromHSV((globalHue + 120) / 360, 1, 1)
			ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
			ripple.AnchorPoint = Vector2.new(0.5, 0.5)
			ripple.Parent = frame
			createUICorner(ripple, 12)

			TweenService:Create(ripple, TweenInfo.new(0.6), {
				Size = UDim2.new(3, 0, 3, 0),
				BackgroundTransparency = 1
			}):Play()

			game.Debris:AddItem(ripple, 0.7)

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
			local d = i.Position - start
			frame.Position = UDim2.new(offset.X.Scale, offset.X.Offset + d.X, offset.Y.Scale, offset.Y.Offset + d.Y)
		end
	end)

	RunService.RenderStepped:Connect(function()
		globalHue = (globalHue + 1) % 360
		local color = Color3.fromHSV(globalHue / 360, 1, 1)
		glow.Color = color
		title.TextColor3 = color

		for _, child in ipairs(frame:GetChildren()) do
			if child:IsA("TextButton") or child:IsA("TextBox") then
				if child ~= btn then
					child.TextColor3 = color
				end
			end
		end
		btn.TextColor3 = color
	end)
elseif game.PlaceId == 83363871432855 then
	local gui = Instance.new("ScreenGui")
	gui.Name = "MiniElevatorUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = CoreGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(220, 120)
	frame.Position = UDim2.new(0.5, -110, 0.5, -60)
	frame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 1
	frame.ZIndex = 2
	frame.Parent = gui
	createUICorner(frame, 12)
	createShadow(frame)

	local glow = Instance.new("UIStroke")
	glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	glow.Color = Color3.fromHSV(0, 1, 1)
	glow.Thickness = 4
	glow.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 36)
	title.BackgroundTransparency = 1
	title.Text = "Mini UI"
	title.TextColor3 = Color3.fromHSV(0, 1, 1)
	title.ZIndex = 3
	setFont(title)
	title.TextSize = 22
	title.Parent = frame

	local btn1 = createButton("Action 1", 46, frame, function()
		print("Mini Action 1")
	end)
	local btn2 = createButton("Action 2", 86, frame, function()
		print("Mini Action 2")
	end)

	local buttons = {btn1, btn2}
	for _, btn in ipairs(buttons) do
		pulseOnHover(btn)
	end

	-- Make frame draggable
	local dragging, input, start, offset

	frame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			start = i.Position
			offset = frame.Position

			local ripple = Instance.new("Frame")
			ripple.Size = UDim2.new(0, 0, 0, 0)
			ripple.BackgroundTransparency = 0.5
			ripple.BackgroundColor3 = Color3.fromHSV((globalHue + 120) / 360, 1, 1)
			ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
			ripple.AnchorPoint = Vector2.new(0.5, 0.5)
			ripple.Parent = frame
			createUICorner(ripple, 12)

			TweenService:Create(ripple, TweenInfo.new(0.6), {
				Size = UDim2.new(3, 0, 3, 0),
				BackgroundTransparency = 1
			}):Play()

			game.Debris:AddItem(ripple, 0.7)

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
			local d = i.Position - start
			frame.Position = UDim2.new(offset.X.Scale, offset.X.Offset + d.X, offset.Y.Scale, offset.Y.Offset + d.Y)
		end
	end)

	RunService.RenderStepped:Connect(function()
		globalHue = (globalHue + 1) % 360
		local color = Color3.fromHSV(globalHue / 360, 1, 1)
		glow.Color = color
		title.TextColor3 = color

		for _, child in ipairs(frame:GetChildren()) do
			if child:IsA("TextButton") or child:IsA("TextBox") then
				child.TextColor3 = color
			end
		end
	end)
end
