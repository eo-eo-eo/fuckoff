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
    loadstring(game:HttpGet("https://raw.githubusercontent.com/eo-eo-eo/fuckoff/refs/heads/main/lobby.lua"))()
end

if game.PlaceId == 83363871432855 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/eo-eo-eo/fuckoff/refs/heads/main/ingame.lua"))()
end
