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
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(300, 260)
frame.Position = UDim2.new(0.5, -150, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
frame.BorderSizePixel = 0
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
    if btn2.Text == "Let people in" then
        btn2.Text = "Don't let people in"
    else
        btn2.Text = "Let people in"
    end
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
        local d = i.Position - start
        frame.Position = UDim2.new(offset.X.Scale, offset.X.Offset + d.X, offset.Y.Scale, offset.Y.Offset + d.Y)
    end
end)
