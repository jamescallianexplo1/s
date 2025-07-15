_SnROyAgBuyxC = "This file was protected with MoonSec V3"
MoonSec_StringsHiddenAttr = true

local var3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/Solara-Hub/refs/heads/main/NotifyLib.lua"))()
var3:SendNotification("Info", "If the key system doesn't start, try deleting the keysystem.key file in the workspace folder of your exploit", 25)
var3:SendNotification("Info", "And sorry for the key system :( I need to buy new components for my computer (it broke and is working very badly), and that's why I added key system", 25)

local var10 = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/Samuraa1-Hub/refs/heads/main/test.lua"))()

_G.KeyValid = true  -- Force key to always be valid
_G.L = "https://go.linkify.ru/1yuI"

for key, val in ipairs(game:GetService("CoreGui"):GetChildren()) do
	table.insert({}, val)
end

var10:Init({
	["GuiParent"] = game:GetService("CoreGui"),
	["Title"] = "Key System",
	["Link"] = _G.L,
	["Verify"] = function(...)
		return true  -- This makes any key accepted
	end,
	["Discord"] = "https://discord.gg/DPCKQRJmdF",
	["SaveKey"] = true,
	["Debug"] = false
})

local _var18 = _G.KeyValid
local var21 = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/LibraryOfScripts/refs/heads/main/test2.lua"))()
