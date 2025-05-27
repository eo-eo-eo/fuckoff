local allowedUsers = {
    "Username1",
    "Username2",
    "dfsadfdfafs"
}

local localPlayer = game:GetService("Players").LocalPlayer

if table.find(allowedUsers, localPlayer.Name) then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/eo-eo-eo/fuckoff/refs/heads/main/main.lua"))()
else
    game:GetService("TeleportService"):Teleport(72028966925446)
end
