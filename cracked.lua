repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Player = game.Players.LocalPlayer

if not Player.Character or not Player:HasAppearanceLoaded() or not Player.Character:FindFirstChildOfClass("Humanoid") then
    Player.CharacterAdded:Wait()
    repeat task.wait() until Player:HasAppearanceLoaded() and Player.Character:FindFirstChildOfClass("Humanoid")
end

if isfile("RiftAssets/donotqueue.txt") then
    delfile("RiftAssets/donotqueue.txt")
    return
end

-- Load Rift UI libraries (Luarmor removed)
local LibraryRepository = "https://raw.githubusercontent.com/synnyyy/Obsidian/refs/heads/main"
local Libraries = {
    Library = LibraryRepository .. "/Library.lua",
    ThemeManager = LibraryRepository .. "/addons/ThemeManager.lua",
    Information = "https://raw.githubusercontent.com/Synergy-Networks/products/refs/heads/main/Rift/Assets/Information.lua"
}

local Total = 3
local Completed = 0

for Name, Url in next, Libraries do
    task.spawn(function()
        local Content = game:HttpGet(Url)
        Libraries[Name] = loadstring(Content)()
        Completed += 1
    end)
end

repeat task.wait() until Completed == Total

Libraries.Library:SetAssetsFolder("RiftAssets")
Libraries.Library:SetAssetsUrl("https://raw.githubusercontent.com/Synergy-Networks/products/refs/heads/main/Rift/Assets")
Libraries.Library:SetModulesUrl("https://raw.githubusercontent.com/synnyyy/Obsidian/refs/heads/main/addons")
Libraries.Library:CheckAssetsFolder()
Libraries.Library:LoadModules()

Libraries.ThemeManager:SetLibrary(Libraries.Library)
Libraries.ThemeManager:SetFolder("Rift")
Libraries.ThemeManager:LoadDefault()
Libraries.Library:SetNotifySide("left")

-- Game-specific ScriptId (used for UI purposes only)
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
    if identifyexecutor():lower():find("xeno") or identifyexecutor():lower():find("solara") then
        Libraries.Library:Notify({
            Title = "Warning",
            Description = "Anticheat bypass cannot be executed on Solara, Xeno or JJSploit. You may be prone to getting banned!",
            Time = 10,
            Icon = "triangle-alert"
        })
    else
        loadstring(game:HttpGet("https://rifton.top/scripts/DearInkGame.lua", true))()
    end

    if game.PlaceId == 125009265613167 then
        ScriptId = "35c035a1c5677a1890d453ab9ac92ed8"
    else
        return Libraries.Library:Notify({
            Title = "Notice",
            Description = "Execute Rift in the lobby, then again in the actual match.",
            Time = 10,
            Icon = "triangle-alert"
        })
    end
elseif game.PlaceId == 126509999114328 then
    ScriptId = "3e31d7e2b743f9e8e058142a6d520a42"
elseif game.PlaceId == 79546208627805 then
    Libraries.Library:Notify({
        Title = "Unsupported Game",
        Description = "Execute Rift on the actual game, NOT the lobby.",
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

-- Stub out the Luarmor API with just your actual script execution
Libraries.API = {
    script_id = ScriptId,
    check_key = function(_) return { code = "KEY_VALID" } end,
    load_script = function()
        -- Keep original Luarmor script URL, just skip validation
        loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/script.lua", true))()
    end
}

-- Fake key just for compatibility
getfenv().script_key = "DEV-MODE"
getgenv().script_key = "DEV-MODE"

-- Unload previous Library if needed
if getgenv().Library then
    getgenv().Library:Unload()
    getgenv().Library = nil
end

-- Run actual script
local Success, Err = pcall(function()
    Libraries.API.load_script()
end)

if not Success then
    Libraries.Library:Notify({
        Title = "Script Error",
        Description = "Error occurred:\n" .. Err,
        Time = 10,
        Icon = "triangle-alert"
    })
end
