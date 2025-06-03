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

local function rippleEffect(button)
	button.ClipsDescendants = true
	button.MouseButton1Click:Connect(function(x, y)
		local ripple = Instance.new("Frame")
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.BackgroundTransparency = 0.5
		ripple.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
		ripple.Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y)
		ripple.AnchorPoint = Vector2.new(0.5, 0.5)
		ripple.Parent = button
		createUICorner(ripple, 999)

		TweenService:Create(ripple, TweenInfo.new(0.5), {
			Size = UDim2.new(1.5, 0, 4, 0),
			BackgroundTransparency = 1
		}):Play()

		game.Debris:AddItem(ripple, 0.6)
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
	pulseOnHover(tb)

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
	b.MouseButton1Click:Connect(action)
	pulseOnHover(b)
	rippleEffect(b)
	return b
end

local function createSmoothShapeAnimation(frame)
	local targetCorners = {
		UDim.new(0, 30),
		UDim.new(0, 60),
		UDim.new(0, 30),
		UDim.new(0, 12),
	}
	local corner = Instance.new("UICorner")
	corner.CornerRadius = targetCorners[1]
	corner.Parent = frame

	local index = 1
	task.spawn(function()
		while frame and frame.Parent do
			local nextIndex = (index % #targetCorners) + 1
			local tween = TweenService:Create(corner, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CornerRadius = targetCorners[nextIndex]})
			tween:Play()
			tween.Completed:Wait()
			index = nextIndex
		end
	end)
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
	frame.Size = UDim2.fromOffset(300, 260)
	frame.Position = UDim2.new(0.5, -150, 0.5, -130)
	frame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 1
	frame.ZIndex = 2
	frame.Parent = gui
	createUICorner(frame, 12)
	createShadow(frame)

	createSmoothShapeAnimation(frame)

	TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 36)
	title.BackgroundTransparency = 1
	title.Text = "ElevatorSpammer"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.ZIndex = 3
	setFont(title)
	title.TextSize = 22
	title.Parent = frame

	local tb1 = createTextbox("Amount of People", 46, frame)

	local btn2
	local function toggleBtn2()
		btn2.Text = (btn2.Text == "Let people in") and "Don't let people in" or "Let people in"
	end

	btn2 = createButton("Let people in", 86, frame, toggleBtn2)

	local tb3 = createTextbox("Mode", 126, frame)
	local tb4 = createTextbox("Map", 166, frame)

	local spamming = false
	local spamThread

	local btn = createButton("Spam", 210, frame, function()
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
	local function bounceTween(obj)
		local info = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local goal1 = {Position = obj.Position + UDim2.new(0, 10, 0, 10)}
		local goal2 = {Position = obj.Position}
		local tween1 = TweenService:Create(obj, info, goal1)
		local tween2 = TweenService:Create(obj, info, goal2)
		tween1:Play()
		tween1.Completed:Wait()
		tween2:Play()
	end

	frame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			start = i.Position
			offset = frame.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging = false
					bounceTween(frame)
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
end
