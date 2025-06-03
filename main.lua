if game.PlaceId ~= 117452115137842 and game.PlaceId ~= 83363871432855 then return end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
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

if game.PlaceId == 117452115137842 then
    local gui = Instance.new("ScreenGui")
    gui.Name = "AddCorruptedUI"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(260, 210)
    frame.Position = UDim2.new(0.5, -130, 0.5, -105)
    frame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    createUICorner(frame, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 36)
    title.BackgroundTransparency = 1
    title.Text = "Add Corrupted"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansSemibold
    title.TextSize = 22
    title.Parent = frame

    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, -30, 0, 34)
    textbox.Position = UDim2.new(0, 15, 0, 46)
    textbox.PlaceholderText = "Enter number"
    textbox.ClearTextOnFocus = false
    textbox.Font = Enum.Font.SourceSans
    textbox.TextSize = 18
    textbox.TextColor3 = Color3.new(1, 1, 1)
    textbox.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
    textbox.BorderSizePixel = 0
    textbox.Text = ""
    textbox.Parent = frame
    createUICorner(textbox, 8)

    local confirmFrame = Instance.new("Frame")
    confirmFrame.Size = UDim2.new(1, 0, 0, 60)
    confirmFrame.Position = UDim2.new(0, 0, 1, 10)
    confirmFrame.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
    confirmFrame.Visible = false
    confirmFrame.Parent = frame
    createUICorner(confirmFrame, 8)

    local warningLabel = Instance.new("TextLabel")
    warningLabel.Size = UDim2.new(1, -20, 0, 24)
    warningLabel.Position = UDim2.new(0, 10, 0, 4)
    warningLabel.BackgroundTransparency = 1
    warningLabel.Text = "This is irreversible. Are you sure?"
    warningLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    warningLabel.Font = Enum.Font.SourceSans
    warningLabel.TextSize = 16
    warningLabel.Parent = confirmFrame

    local yes = Instance.new("TextButton")
    yes.Size = UDim2.new(0.5, -12, 0, 24)
    yes.Position = UDim2.new(0, 6, 0, 32)
    yes.Text = "Yes"
    yes.Font = Enum.Font.SourceSansSemibold
    yes.TextSize = 16
    yes.TextColor3 = Color3.new(1, 1, 1)
    yes.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    yes.BorderSizePixel = 0
    yes.Visible = false
    yes.Parent = confirmFrame
    createUICorner(yes, 6)

    local no = Instance.new("TextButton")
    no.Size = UDim2.new(0.5, -12, 0, 24)
    no.Position = UDim2.new(0.5, 6, 0, 32)
    no.Text = "No"
    no.Font = Enum.Font.SourceSansSemibold
    no.TextSize = 16
    no.TextColor3 = Color3.new(1, 1, 1)
    no.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    no.BorderSizePixel = 0
    no.Visible = false
    no.Parent = confirmFrame
    createUICorner(no, 6)

    local function showConfirm(callback)
        confirmFrame.Visible = true
        yes.Visible = true
        no.Visible = true
        local conn1, conn2
        conn1 = yes.MouseButton1Click:Connect(function()
            callback()
            confirmFrame.Visible = false
            yes.Visible = false
            no.Visible = false
            conn1:Disconnect()
            conn2:Disconnect()
        end)
        conn2 = no.MouseButton1Click:Connect(function()
            confirmFrame.Visible = false
            yes.Visible = false
            no.Visible = false
            conn1:Disconnect()
            conn2:Disconnect()
        end)
    end

    createButton("Add", 90, frame, function()
        local v = tonumber(textbox.Text)
        if v then
            ReplicatedStorage:WaitForChild("RemoveCorrupted"):InvokeServer(-v)
        end
    end)

    createButton("Add Inf", 130, frame, function()
        showConfirm(function()
            ReplicatedStorage:WaitForChild("RemoveCorrupted"):InvokeServer(-math.huge)
        end)
    end)

    createButton("Add NaN-Counts as 0", 170, frame, function()
        showConfirm(function()
            ReplicatedStorage:WaitForChild("RemoveCorrupted"):InvokeServer(math.huge)
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
            local d = i.Position - start
            frame.Position = UDim2.new(offset.X.Scale, offset.X.Offset + d.X, offset.Y.Scale, offset.Y.Offset + d.Y)
        end
    end)
end

if game.PlaceId == 83363871432855 then
    local gui2 = Instance.new("ScreenGui")
    gui2.Name = "TowerPlacerUI"
    gui2.ResetOnSpawn = false
    gui2.Parent = player:WaitForChild("PlayerGui")

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

    local upgradesLevels = {"Lv2", "Lv3", "Lv4", "Lv5", "Lv6"}

    local function refreshTowers()    
        for _, v in pairs(scrollFrame:GetChildren()) do        
            if v:IsA("TextButton") then v:Destroy() end    
        end    
        towersList = {}    
        local towersFolder = ReplicatedStorage:WaitForChild("Towers")    
        local upgradesFolder = towersFolder:WaitForChild("Upgrades")    
        for _, model in pairs(towersFolder:GetChildren()) do        
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
        for _, lvl in ipairs(upgradesLevels) do        
            local lvlFolder = upgradesFolder:FindFirstChild(lvl)        
            if lvlFolder then            
                for _, model in pairs(lvlFolder:GetChildren()) do                
                    if model:IsA("Model") then                    
                        local priceValue = 0                    
                        local config = model:FindFirstChild("Config")                    
                        if config then                        
                            local price = config:FindFirstChild("Price")                        
                            if price and price:IsA("IntValue") then                            
                                priceValue = price.Value                        
                            end                    
                        end                    
                        table.insert(towersList, model.Name .." - ".. priceValue .. "G")                
                    end            
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
                local towerNameOnly = towerDisplayName:match("^(.-) %-")            
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
        local towerName = chooseTower.Text
        local towersFolder = ReplicatedStorage:WaitForChild("Towers")
        local upgradesFolder = towersFolder:WaitForChild("Upgrades")

        local foundModel = towersFolder:FindFirstChild(towerName)
        if not foundModel then
            for _, lvl in ipairs(upgradesLevels) do
                local lvlFolder = upgradesFolder:FindFirstChild(lvl)
                if lvlFolder then
                    foundModel = lvlFolder:FindFirstChild(towerName)
                    if foundModel then break end
                end
            end
        end

        if foundModel then
            local id = foundModel:GetAttribute("ID") or 0
            ReplicatedStorage:WaitForChild("PlaceTower"):InvokeServer(id, false)
        end
    end)

    placeButton.MouseButton1Click:Connect(function()
    placeButton.Text = "Click where you want to place(or click this again to place another one)"
    local conn
    conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local ray = workspace.CurrentCamera:ScreenPointToRay(mousePos.X, mousePos.Y)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {player.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 500, raycastParams)
            if raycastResult then
                local name = chooseTower.Text:split("-")[1]:gsub("%s+$", "")
                local args = {name, CFrame.new(raycastResult.Position)}
                ReplicatedStorage:WaitForChild("Functions"):WaitForChild("SpawnTower"):InvokeServer(unpack(args))
                placeButton.Text = "Place"
                conn:Disconnect()
            end
        end
    end)
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
