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
end)
end)
frame.InputChanged:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseMovement then
input = i
end)
UserInputService.InputChanged:Connect(function(i)
if i == input and dragging then
local d = i.Position - start
frame.Position = UDim2.new(offset.X.Scale, offset.X.Offset + d.X, offset.Y.Scale, offset.Y.Offset + d.Y)
end)
