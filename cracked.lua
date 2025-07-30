repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Player = game.Players.LocalPlayer

-- Wait for character to load
if not Player.Character or not Player:HasAppearanceLoaded() or not Player.Character:FindFirstChildOfClass("Humanoid") then
    Player.CharacterAdded:Wait()
    repeat task.wait() until Player:HasAppearanceLoaded() and Player.Character:FindFirstChildOfClass("Humanoid")
end

-- Check for do not queue file
if isfile("RiftAssets/donotqueue.txt") then
    delfile("RiftAssets/donotqueue.txt")
    return
end

-- Library URLs
local LibraryRepository = "https://raw.githubusercontent.com/synnyyy/Obsidian/refs/heads/main"
local Libraries = {
    Library = LibraryRepository .. "/Library.lua",
    ThemeManager = LibraryRepository .. "/addons/ThemeManager.lua",
    Information = "https://raw.githubusercontent.com/Synergy-Networks/products/refs/heads/main/Rift/Assets/Information.lua",
    API = "https://sdkapi-public.luarmor.net/library.lua"
}

-- Executor check
local ShitExecutor = (identifyexecutor():lower():find("xeno") or identifyexecutor():lower():find("solara")) ~= nil

-- Load all libraries asynchronously
local Total = 4
local Completed = 0

for Name, Url in next, Libraries do
    task.spawn(function()
        local Content = game:HttpGet(Url)
        Libraries[Name] = loadstring(Content)()
        Completed += 1
    end)
end

repeat task.wait() until Completed == Total

-- Set up library and theme
Libraries.Library:SetAssetsFolder("RiftAssets")
Libraries.Library:SetAssetsUrl("https://raw.githubusercontent.com/Synergy-Networks/products/refs/heads/main/Rift/Assets")
Libraries.Library:SetModulesUrl("https://raw.githubusercontent.com/synnyyy/Obsidian/refs/heads/main/addons")
Libraries.Library:CheckAssetsFolder()
Libraries.Library:LoadModules()

Libraries.ThemeManager:SetLibrary(Libraries.Library)
Libraries.ThemeManager:SetFolder("Rift")
Libraries.ThemeManager:LoadDefault()
Libraries.Library:SetNotifySide("left")

-- Game-specific script ID
local ScriptId = ""
if game.PlaceId == 72907489978215 then
    ScriptId = "1c57708a6733fcdac89be981d028aebc"
elseif game.PlaceId == 18687417158 then
    ScriptId = "296d23036fbb1af463d3ad03f08a67a4"
elseif game.PlaceId == 70876832253163 then
    ScriptId = "373f5d42922fa6b5ac57adbb41b8015f"
elseif game.PlaceId == 116495829188952 then
    ScriptId = "bd4df7f8b3bab2997c8557bd36685984"
elseif game.PlaceId == 126884695634066 then
    ScriptId = "271e9f42ea856423a03c9d04f3ac93ff"
elseif game.PlaceId == 126244816328678 then
    ScriptId = "065f7896c6ea7493f19d97109f73cc13"
elseif game.GameId == 7008097940 then
    if not ShitExecutor then
        loadstring(game:HttpGet("https://rifton.top/scripts/DearInkGame.lua", true))()
    else
        Libraries.Library:Notify({
            Title = "Warning",
            Description = "Anticheat bypass cannot be executed on Solara, Xeno or JJSploit. You may be prone to getting banned!",
            Time = 10,
            Icon = "triangle-alert"
        })
    end

    if game.PlaceId == 125009265613167 then
        ScriptId = "35c035a1c5677a1890d453ab9ac92ed8"
    else
        return Libraries.Library:Notify({
            Title = "Notice",
            Description = "Make sure to execute Rift on the lobby and then when you get in a game, execute it again.",
            Time = 10,
            Icon = "triangle-alert"
        })
    end
elseif game.PlaceId == 126509999114328 then
    ScriptId = "3e31d7e2b743f9e8e058142a6d520a42"
elseif game.PlaceId == 79546208627805 then
    Libraries.Library:Notify({
        Title = "Unsupported Game",
        Description = "Execute Rift on the actual game, NOT lobby.",
        Time = 5,
        Icon = "triangle-alert"
    })
    task.wait(5)
    Libraries.Library:Unload()
    getgenv().Library = nil
    return
elseif game.GameId == 7709344486 then
    ScriptId = "e5c48aeea839155dfa16c630eb41daad"
else
    Libraries.Library:Notify({
        Title = "Unsupported Game",
        Description = "Rift does not support this game.",
        Time = 5,
        Icon = "triangle-alert"
    })
    task.wait(5)
    Libraries.Library:Unload()
    getgenv().Library = nil
    return
end

-- Set script ID and force dev bypass
Libraries.API.script_id = ScriptId
getfenv().script_key = "DEV-MODE"
local KeyValidated = true

-- Clean up previous library instance if any
if getgenv().Library then
    getgenv().Library:Unload()
    getgenv().Library = nil
end

-- Set script key
getgenv().script_key = getfenv().script_key

-- Load actual script
local Success, Err = pcall(function()
    Libraries.API.load_script()
end)

if not Success then
    local ShowErrorUI = function(ErrorMsg)
        Libraries.Library = loadstring(game:HttpGet(LibraryRepository .. "/Library.lua"))()
        Libraries.ThemeManager = loadstring(game:HttpGet(LibraryRepository .. "/addons/ThemeManager.lua"))()
        Libraries.Library:SetAssetsFolder("RiftAssets")
        Libraries.Library:SetAssetsUrl("https://raw.githubusercontent.com/Synergy-Networks/products/refs/heads/main/Rift/Assets")
        Libraries.Library:SetModulesUrl("https://raw.githubusercontent.com/synnyyy/Obsidian/refs/heads/main/addons")
        Libraries.Library:CheckAssetsFolder()
        Libraries.Library:LoadModules()
        Libraries.ThemeManager:SetLibrary(Libraries.Library)
        Libraries.ThemeManager:SetFolder("Rift")
        Libraries.ThemeManager:LoadDefault()
        Libraries.Library:SetNotifySide("left")

        local Window = Libraries.Library:CreateChangableWindow({
            Title = "Rift",
            Footer = "Case: " .. ScriptId .. " • Executor: " .. identifyexecutor(),
            Icon = Libraries.Library:GetAsset("Logo.png"),
            Modal = true
        })

        local ErrorFrame = Window:CreateCanvas()
        ErrorFrame:AddLabel(
            "Rift encountered an unexpected error. Please report this to the developers if it continues.\n\n" ..
            "<font color=\"rgb(255, 0, 0)\"><b>Error:\n</b></font>" .. ErrorMsg .. "\n", true
        )

        ErrorFrame:AddButton("Report Issue", function()
            setclipboard("https://vaultcord.win/synergy")
            Libraries.Library:Notify({
                Title = "Report Issue",
                Description = "We have copied our Discord Server to your clipboard. Open a ticket and send the error screenshot.",
                Time = 15
            })
        end):AddButton("Exit", function()
            getgenv().Library:Unload()
            getgenv().Library = nil
        end)
    end

    ShowErrorUI(Err)
end
