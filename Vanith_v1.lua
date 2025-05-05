local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Dynamic Nights",
    Icon = 7743870134, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Test script",
    LoadingSubtitle = "by Vanith",
    Theme = "Ocean", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Dynamic_Night"
    },
 
    Discord = {
       Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "AzkrU7J5Bs", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local fTab = Window:CreateTab("Main", 7733964719) -- Title, Image
 local fSection = fTab:CreateSection("Info")
 local fLabel = fTab:CreateLabel("This is just a script for random ass shit :)", 7733975185, Color3.fromRGB(70, 31, 120), false) -- Title, Icon, Color, IgnoreTheme
 local fLabel = fTab:CreateLabel("Box Color esp and normal color esp are still buggy", 7733975185, Color3.fromRGB(70, 31, 120), false) -- Title, Icon, Color, IgnoreTheme

 local dTab = Window:CreateTab("Random stuff", 7743871480) -- Title, Image
 local dSection = dTab:CreateSection(":D")
 -- Speed Slider
local speedSlider = dTab:CreateSlider({
    Name = "Speed",
    Range = {15, 400},
    Increment = 10,
    Suffix = "Studs",
    CurrentValue = 15,
    Flag = "Speed1",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

-- JumpPower Slider
local jumpSlider = dTab:CreateSlider({
    Name = "High Jump",
    Range = {50, 400},
    Increment = 10,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "Jump1",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
})

-- Reset Button
local resetButton = dTab:CreateButton({
    Name = "Reset Speed & Jump",
    Callback = function()
        local humanoid = game.Players.LocalPlayer.Character.Humanoid
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end,
})

--// ESP Variablen
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESPColor = Color3.fromRGB(255, 0, 0)
local ESPEnabled = false
local EnemiesOnly = false
local BoxEnabled = false
local NameTagsEnabled = false
local HealthBarsEnabled = false
local NameTagSize = 1
local HealthBarSize = 1
local NameTagColor = Color3.fromRGB(255, 255, 255)
local BoxESPColor = Color3.fromRGB(255, 255, 0) -- Eigene Farbe für BoxESP
local RainbowName = false
local FlyEnabled = false
local FlySpeed = 5
local FlyBodyGyro
local FlyBodyVelocity
local ESPList = {}

-- Rainbow Funktion
local function RainbowColor()
    local hue = tick() % 5 / 5
    return Color3.fromHSV(hue, 1, 1)
end

local function IsEnemy(player)
    if player.Team ~= nil and LocalPlayer.Team ~= nil then
        return player.Team ~= LocalPlayer.Team
    end
    return true
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESPList[player] then return end
    if EnemiesOnly and not IsEnemy(player) then return end

    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "Vanith_Highlight"
        highlight.Adornee = char
        highlight.FillColor = ESPColor
        highlight.OutlineColor = Color3.new(0, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = game.CoreGui

        ESPList[player] = {Highlight = highlight}

        if BoxEnabled then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "Vanith_Box"
            box.Adornee = char:FindFirstChild("HumanoidRootPart")
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = Vector3.new(4, 6, 2)
            box.Color3 = BoxESPColor
            box.Transparency = 0.25
            box.Parent = game.CoreGui
            ESPList[player].Box = box
        end
    end
end

local function AddExtraESP(player)
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if NameTagsEnabled and head then
        local tag = Instance.new("BillboardGui")
        tag.Name = "Vanith_NameTag"
        tag.Adornee = head
        tag.Size = UDim2.new(0, 200 * NameTagSize, 0, 50 * NameTagSize)
        tag.StudsOffset = Vector3.new(0, 2, 0)
        tag.AlwaysOnTop = true

        local label = Instance.new("TextLabel", tag)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = NameTagColor
        label.TextStrokeTransparency = 0.5
        label.TextScaled = true
        label.Name = "namet2"

        tag.Parent = game.CoreGui
        ESPList[player].NameTag = tag

        if RainbowName then
            task.spawn(function()
                while RainbowName and tag and label do
                    label.TextColor3 = RainbowColor()
                    task.wait(0.1)
                end
                if label then
                    label.TextColor3 = NameTagColor
                end
            end)
        end
    end

    if HealthBarsEnabled and head and humanoid then
        local bar = Instance.new("BillboardGui")
        bar.Name = "Vanith_HPBar"
        bar.Adornee = head
        bar.Size = UDim2.new(3 * HealthBarSize, 0, 0.2 * HealthBarSize, 0)
        bar.StudsOffset = Vector3.new(0, 3, 0)
        bar.AlwaysOnTop = true

        local frame = Instance.new("Frame", bar)
        frame.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        frame.BorderSizePixel = 0
        frame.Name = "HealthFrame"

        bar.Parent = game.CoreGui
        ESPList[player].HPBar = bar

        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if frame and frame.Parent then
                frame.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
            end
        end)
    end
end

-- Update CreateESP Funktion:
local oldCreateESP = CreateESP
CreateESP = function(player)
    oldCreateESP(player)
    if ESPList[player] then
        AddExtraESP(player)
    end
end

local function RemoveESP(player)
    if ESPList[player] then
        if ESPList[player].Highlight then ESPList[player].Highlight:Destroy() end
        if ESPList[player].Box then ESPList[player].Box:Destroy() end
        if ESPList[player].NameTag then ESPList[player].NameTag:Destroy() end
        if ESPList[player].HPBar then ESPList[player].HPBar:Destroy() end
        ESPList[player] = nil
    end
end

local function RefreshESP()
    for _, player in pairs(Players:GetPlayers()) do
        RemoveESP(player)
    end
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
    end
end

local function UpdateESPColor(color)
    for _, v in pairs(ESPList) do
        if v.Highlight then v.Highlight.FillColor = color end
        if v.Box then v.Box.Color3 = color end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if ESPEnabled then
            CreateESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(RemoveESP)--// Noclip
local NoclipEnabled = false

local Toggle = dTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        NoclipEnabled = Value
    end
})

--// Noclip Loop
game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
    end
end)

--// Fly
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Direction = {
    Forward = false,
    Back = false,
    Left = false,
    Right = false,
    Up = false,
    Down = false
}

local Toggle = dTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        FlyEnabled = Value

        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart")

        if Value then
            FlyBodyVelocity = Instance.new("BodyVelocity")
            FlyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            FlyBodyVelocity.P = 1250
            FlyBodyVelocity.Velocity = Vector3.zero
            FlyBodyVelocity.Parent = root

            FlyBodyGyro = Instance.new("BodyGyro")
            FlyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            FlyBodyGyro.P = 3000
            FlyBodyGyro.CFrame = workspace.CurrentCamera.CFrame
            FlyBodyGyro.Parent = root
        else
            if FlyBodyVelocity then FlyBodyVelocity:Destroy() FlyBodyVelocity = nil end
            if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
        end
    end
})

local Toggle = dTab:CreateSlider({
    Name = "Fly Speed",
    Range = {50, 900},
    Increment = 10,
    Suffix = "Speed",
    CurrentValue = 50,
    Callback = function(fspeed)
        FlySpeed = fspeed
    end,
})

--// Key Input
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then Direction.Forward = true end
    if input.KeyCode == Enum.KeyCode.S then Direction.Back = true end
    if input.KeyCode == Enum.KeyCode.A then Direction.Left = true end
    if input.KeyCode == Enum.KeyCode.D then Direction.Right = true end
    if input.KeyCode == Enum.KeyCode.E then Direction.Up = true end
    if input.KeyCode == Enum.KeyCode.Q then Direction.Down = true end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then Direction.Forward = false end
    if input.KeyCode == Enum.KeyCode.S then Direction.Back = false end
    if input.KeyCode == Enum.KeyCode.A then Direction.Left = false end
    if input.KeyCode == Enum.KeyCode.D then Direction.Right = false end
    if input.KeyCode == Enum.KeyCode.E then Direction.Up = false end
    if input.KeyCode == Enum.KeyCode.Q then Direction.Down = false end
end)

--// Bewegungsloop
RunService.RenderStepped:Connect(function()
    if FlyEnabled and FlyBodyVelocity and FlyBodyGyro then
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera

        if root and cam then
            local moveVec = Vector3.zero

            -- Verarbeitet die Bewegungseingaben für Fly.
            if Direction.Forward then moveVec += cam.CFrame.LookVector end
            if Direction.Back then moveVec -= cam.CFrame.LookVector end
            if Direction.Left then moveVec -= cam.CFrame.RightVector end
            if Direction.Right then moveVec += cam.CFrame.RightVector end
            if Direction.Up then moveVec += Vector3.new(0, 1, 0) end
            if Direction.Down then moveVec -= Vector3.new(0, 1, 0) end

            -- Setzt die Geschwindigkeit basierend auf den Eingaben
            if moveVec.Magnitude > 0 then
                moveVec = moveVec.Unit * FlySpeed
            end

            FlyBodyVelocity.Velocity = moveVec
            FlyBodyGyro.CFrame = cam.CFrame
        end
    end
end)

dTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

local sLabel = dTab:CreateLabel("Esp stuff", 7733774602, Color3.fromRGB(175,0,255), false) -- Title, Icon, Color, IgnoreTheme
--// UI Elemente
local Toggle = dTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(Ece)
        ESPEnabled = Ece
        RefreshESP()
    end
})

local Toggle = dTab:CreateToggle({
    Name = "Box Esp",
    CurrentValue = false,
    Callback = function(Value)
        BoxEnabled = Value
        RefreshESP()
    end
})

local Toggle = dTab:CreateToggle({
    Name = "Enemy only",
    CurrentValue = false,
    Callback = function(Value)
        EnemiesOnly = Value
        RefreshESP()
    end
})

dTab:CreateToggle({
    Name = "ESP Healthbars",
    CurrentValue = false,
    Callback = function(Value)
        HealthBarsEnabled = Value
        RefreshESP()
    end
})

dTab:CreateToggle({
    Name = "ESP Nametags",
    CurrentValue = false,
    Callback = function(Value)
        NameTagsEnabled = Value
        RefreshESP()
    end
})
--Color shit
local Toggle = dTab:CreateColorPicker({
    Name = "ESP color",
    Color = ESPColor,
    Callback = function(Color)
        ESPColor = Color
        UpdateESPColor(Color)
    end
})

dTab:CreateColorPicker({
    Name = "Box ESP Color",
    Color = BoxESPColor,
    Callback = function(Color)
        BoxESPColor = Color
        for _, v in pairs(ESPList) do
            if v.Box then
                v.Box.Color3 = Color
            end
        end
    end
})

dTab:CreateSlider({
    Name = "Nametag Height",
    Range = {0.5, 2},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(Value)
        NameTagSize = Value
        RefreshESP()
    end
})

dTab:CreateColorPicker({
    Name = "Nametag color",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        NameTagColor = Value
        RefreshESP()
    end
})

dTab:CreateSlider({
    Name = "Health Bar Größe",
    Range = {0.5, 2},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(Value)
        HealthBarSize = Value
        RefreshESP()
    end
})

--------------------------- [ This is the new script section under this :) ] ----------------------------------

local sTab = Window:CreateTab("Scripts", 7743869612)
local sSection = sTab:CreateSection("Scripts")
local Button = sTab:CreateButton({
    Name = "Infinite Yield (Solara)",
    Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Infinite-Yield_500"))()
    end,
 })
 local Button = sTab:CreateButton({
    Name = "Normal Infinite Yield",
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
 })
 local Button = sTab:CreateButton({
    Name = "FrostHub by Vanith",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Snipez-Dev/Synap-Src/refs/heads/main/FrostHub"))()
    end,
 })
 local Button = sTab:CreateButton({
    Name = "Universal Hack by Homohack",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dementiaenjoyer/homohack/main/loader.lua"))()
    end,
 })

 local Label = sTab:CreateLabel("Brookhaven", 7743871480, Color3.fromRGB(70, 31, 120), false) -- Title, Icon, Color, IgnoreTheme
 local Button = sTab:CreateButton({
    Name = "Mango Hub",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/rogelioajax/lua/main/MangoHub", true))()
    end,
 })
 local Button = sTab:CreateButton({
    Name = "Unlock All Eggs",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/L0RD-SUD0/Unlock-all-egg-hunt-event-/refs/heads/main/ss"))()
    end,
 })
 local Button = sTab:CreateButton({
    Name = "Ice Hub new style (Orbit)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Waza80/scripts-new/main/IceHubBrookhaven.lua"))()
    end,
 })

 local Label = sTab:CreateLabel("Realistic hood test", 7743871480, Color3.fromRGB(70, 31, 120), false) -- Title, Icon, Color, IgnoreTheme
 local Button = sTab:CreateButton({
    Name = "Realistic hood with Universal hitbox expander?",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/YellowGregs/Loadstring/refs/heads/main/rhtestesting.lua"))()
    end,
 })

 local Label = sTab:CreateLabel("Break In 2", 7743871480, Color3.fromRGB(70, 31, 120), false) -- Title, Icon, Color, IgnoreTheme
 local Button = sTab:CreateButton({
    Name = "Break In 2 Starry",
    Callback = function()
        loadstring(game:HttpGet("https://luau.tech/build"))();
    end,
 })
 local Button = sTab:CreateButton({
    Name = "Break In DP Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/COOLXPLO/DP-HUB-coolxplo/refs/heads/main/BreakInStory.lua"))()
    end,
 })

 local Label = sTab:CreateLabel("Dead Rails", 7743871480, Color3.fromRGB(70, 31, 120), false) -- Title, Icon, Color, IgnoreTheme
 local Button = sTab:CreateButton({
    Name = "Airflow",
    Callback = function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/255ac567ced3dcb9e69aa7e44c423f19.lua"))()
    end,
 })
 local Button = sTab:CreateButton({
    Name = "Kiciahook",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kiciahook/kiciahook/refs/heads/main/loader.lua"))()
    end,
 })
