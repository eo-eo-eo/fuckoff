if game.PlaceId ~= 117452115137842 and game.PlaceId ~= 83363871432855 then return end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function createButton(text, y, parent, action)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -30, 0, 34)
    b.Position = UDim2.new(0, 15, 0, y)
    b.Text = text
    b.Font = Enum.Font.SourceSansSemibold
    b.TextSize = 18
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
    b.BorderSizePixel = 0
    b.Parent = parent
    createUICorner(b, 8)
    b.MouseButton1Click:Connect(action)
    return b
end
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
    frame2.Parent = gui2
    createUICorner(frame2, 12)

    local title2 = Instance.new("TextLabel")
    title2.Size = UDim2.new(1, 0, 0, 36)
    title2.BackgroundTransparency = 1
    title2.Text = "Tower placer"
    title2.TextColor3 = Color3.fromRGB(255, 255, 255)
    title2.Font = Enum.Font.SourceSansSemibold
    title2.TextSize = 22
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

    local dragging, input, start, offset
    frame2.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = i.Position
            offset = frame2.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame2.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then
            input = i
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i == input and dragging then
            local d = i.Position - start
            frame2.Position = UDim2.new(offset.X.Scale, offset.X.Offset + d.X, offset.Y.Scale, offset.Y.Offset + d.Y)
        end
    end)
end
