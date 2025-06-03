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

local function applyEffectsToTextButton(button)
	pulseOnHover(button)
	rippleEffect(button)
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
	applyEffectsToTextButton(b)
	b.MouseButton1Click:Connect(action)
	return b
end

-- ElevatorSpammer GUI for PlaceId 117452115137842
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
		game:GetService("ReplicatedStorage"):WaitForChild("ApplyElevatorSettings"):FireServer(1, false, Nightmare, Endless, workspace.Elevators["Elevator2.0 (endless mode)"])
	end)

	-- Dragging logic
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
			local delta = i.Position - start
			frame.Position = UDim2.new(offset.X.Scale, offset.X.Offset + delta.X, offset.Y.Scale, offset.Y.Offset + delta.Y)
		end
	end)

	-- Rainbow effect
	RunService.RenderStepped:Connect(function(dt)
		globalHue = (globalHue + dt * 0.5) % 1
		local color = Color3.fromHSV(globalHue, 1, 1)
		glow.Color = color
		title.TextColor3 = color
	end)
end

-- TowerPlacer GUI for PlaceId 83363871432855 with matching effects and rainbow

if game.PlaceId == 83363871432855 then
	local gui2 = Instance.new("ScreenGui")
	gui2.Name = "TowerPlacerUI"
	gui2.ResetOnSpawn = false
	gui2.Parent = CoreGui

	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.fromOffset(260, 150)
	frame2.Position = UDim2.new(0.5, -130, 0.5, -75)
	frame2.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	frame2.BorderSizePixel = 0
	frame2.BackgroundTransparency = 1
	frame2.Parent = gui2
	createUICorner(frame2, 12)
	createShadow(frame2)

	local glow2 = Instance.new("UIStroke")
	glow2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	glow2.Color = Color3.fromHSV(0, 1, 1)
	glow2.Thickness = 4
	glow2.Parent = frame2

	local title2 = Instance.new("TextLabel")
	title2.Size = UDim2.new(1, 0, 0, 36)
	title2.BackgroundTransparency = 1
	title2.Text = "Tower placer"
	title2.TextColor3 = Color3.fromHSV(0, 1, 1)
	title2.Font = Enum.Font.SourceSansSemibold
	title2.TextSize = 22
	title2.ZIndex = 3
	title2.Parent = frame2

	local chooseTower = createButton("Choose Tower", 46, frame2, function() end)
	local placeButton = createButton("Place", 90, frame2, function() end)

	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Size = UDim2.new(1, -30, 0, 0)
	dropdownFrame.Position = UDim2.new(0, 15, 0, 80)
	dropdownFrame.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
	dropdownFrame.BorderSizePixel = 0
	dropdownFrame.ClipsDescendants = true
	dropdownFrame.Parent = frame2
	createUICorner(dropdownFrame, 8)

	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = dropdownFrame
	scrollFrame.ScrollBarThickness = 6

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = scrollFrame
	uiListLayout.Padding = UDim.new(0, 4)

	local expanded = false
	local towersList = {}

	local searchFolders = {
		ReplicatedStorage:WaitForChild("Towers"),
		ReplicatedStorage.Towers:WaitForChild("Skins"),
		ReplicatedStorage.Towers.Upgrades:WaitForChild("Lv2"),
		ReplicatedStorage.Towers.Upgrades:WaitForChild("Lv3"),
		ReplicatedStorage.Towers.Upgrades:WaitForChild("Lv4"),
		ReplicatedStorage:WaitForChild("Projectiles"),
		ReplicatedStorage:WaitForChild("Bin"),
	}

	local function refreshTowers()
		for _, v in pairs(scrollFrame:GetChildren()) do
			if v:IsA("TextButton") then v:Destroy() end
		end

		towersList = {}

		for _, folder in ipairs(searchFolders) do
			for _, model in ipairs(folder:GetChildren()) do
				if model:IsA("Model") then
					local priceValue = 0
					local config = model:FindFirstChild("Config")
					if config then
						local price = config:FindFirstChild("Price")
						if price and price:IsA("IntValue") then
							priceValue = price.Value
						end
					end
					table.insert(towersList, model.Name .. " - " .. priceValue .. "G")
				end
			end
		end

		for i, towerDisplayName in ipairs(towersList) do
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 28)
			btn.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
			btn.BorderSizePixel = 0
			btn.Font = Enum.Font.SourceSansSemibold
			btn.TextSize = 16
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Text = towerDisplayName
			btn.LayoutOrder = i
			btn.Parent = scrollFrame
			createUICorner(btn, 6)
			applyEffectsToTextButton(btn)
			btn.MouseButton1Click:Connect(function()
				chooseTower.Text = towerDisplayName
				expanded = false
				dropdownFrame:TweenSize(UDim2.new(1, -30, 0, 0), "Out", "Quart", 0.3, true)
			end)
		end

		wait()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
	end

	chooseTower.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			refreshTowers()
			dropdownFrame:TweenSize(UDim2.new(1, -30, 0, 150), "Out", "Quart", 0.3, true)
		else
			dropdownFrame:TweenSize(UDim2.new(1, -30, 0, 0), "Out", "Quart", 0.3, true)
		end
	end)

	placeButton.MouseButton1Click:Connect(function()
		local towerName = chooseTower.Text:match("^(.-) %-") or ""
		local foundModel

		for _, folder in ipairs(searchFolders) do
			foundModel = folder:FindFirstChild(towerName)
			if foundModel then break end
		end

		if foundModel then
			local args = {
				foundModel.Name,
				player.Character and player.Character:FindFirstChild("Head") and player.Character.Head.CFrame
			}
			if args[2] then
				ReplicatedStorage:WaitForChild("Functions"):WaitForChild("SpawnTower"):InvokeServer(unpack(args))
			end
		end
	end)

	local dragging2, input2, start2, offset2
	frame2.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging2 = true
			start2 = i.Position
			offset2 = frame2.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging2 = false
				end
			end)
		end
	end)
	frame2.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement then
			input2 = i
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if i == input2 and dragging2 then
			local d = i.Position - start2
			frame2.Position = UDim2.new(offset2.X.Scale, offset2.X.Offset + d.X, offset2.Y.Scale, offset2.Y.Offset + d.Y)
		end
	end)

	RunService.RenderStepped:Connect(function(dt)
		globalHue = (globalHue + dt * 0.5) % 1
		local color = Color3.fromHSV(globalHue, 1, 1)
		glow2.Color = color
		title2.TextColor3 = color
		chooseTower.TextColor3 = color
		placeButton.TextColor3 = color
	end)
end
