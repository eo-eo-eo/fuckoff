if game.PlaceId ~= 117452115137842 and game.PlaceId ~= 83363871432855 then return end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local remote = ReplicatedStorage:WaitForChild("ApplyElevatorSettings")

local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function setFont(obj)
    obj.FontFace = Font.new("rbxasset://fonts/families/PressStart2P.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
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
            tb.TextColor3 = Color3.new(1,1,1)
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
    b.Parent = parent
    createUICorner(b, 6)
    setFont(b)
    b.TextSize = 18
    b.MouseButton1Click:Connect(action)
    return b
end

if game.PlaceId == 117452115137842 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/eo-eo-eo/fuckoff/refs/heads/main/lobby.lua"))()
elseif game.PlaceId == 83363871432855 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/eo-eo-eo/fuckoff/refs/heads/main/ingame.lua"))()
end
