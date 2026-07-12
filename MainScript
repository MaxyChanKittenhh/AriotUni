-- Initialize Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Nigga Panel",
    LoadingTitle = "Loading Tools...",
    LoadingSubtitle = "Max is fucking gay",
    ConfigurationSaving = { Enabled = false }
})

-- Create Tabs
local MovementTab = Window:CreateTab("Movement", 4483362458)
local UtilityTab = Window:CreateTab("Waypoints & Utility", 4483362458)
local StatsTab = Window:CreateTab("Stats", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local WorldTab = Window:CreateTab("World & Lighting", 4483362458)
local ServerTab = Window:CreateTab("Server Testing", 4483362458)
local UniversalTab = Window:CreateTab("Universal Scripts", 4483362458)
local MemeTab = Window:CreateTab("Fun / Troll", 4483362458)

-------------------------
-- MOVEMENT TAB
-------------------------
local noclipConnection
MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
    end,
})

local flyConnection
local flySpeed = 50

MovementTab:CreateToggle({
    Name = "Fly (True Movement)",
    CurrentValue = false,
    Callback = function(Value)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        
        if not root or not humanoid then return end
        
        if Value then
            local bv = Instance.new("BodyVelocity", root)
            bv.Name = "AdminFlyBV"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            
            local bg = Instance.new("BodyGyro", root)
            bg.Name = "AdminFlyBG"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.D = 50
            bg.P = 5000

            flyConnection = RunService.RenderStepped:Connect(function()
                local moveDir = humanoid.MoveDirection
                local camCFrame = Camera.CFrame
                local moveVector = (camCFrame.RightVector * moveDir.X) + (camCFrame.LookVector * moveDir.Z)
                bv.Velocity = moveVector * flySpeed
                bg.CFrame = camCFrame
            end)
            humanoid.PlatformStand = true
        else
            if flyConnection then flyConnection:Disconnect() end
            if root:FindFirstChild("AdminFlyBV") then root.AdminFlyBV:Destroy() end
            if root:FindFirstChild("AdminFlyBG") then root.AdminFlyBG:Destroy() end
            if humanoid then humanoid.PlatformStand = false end
        end
    end,
})

MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = "Studs/s",
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        flySpeed = Value
    end,
})

local function GetPlayerFromPartialName(namePart)
    namePart = string.lower(namePart)
    for _, p in ipairs(Players:GetPlayers()) do
        if string.sub(string.lower(p.Name), 1, #namePart) == namePart or string.sub(string.lower(p.DisplayName), 1, #namePart) == namePart then
            return p
        end
    end
    return nil
end

MovementTab:CreateInput({
    Name = "Teleport to Player",
    PlaceholderText = "Partial username or display name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local targetPlayer = GetPlayerFromPartialName(Text)
        local myChar = LocalPlayer.Character
        
        if targetPlayer and targetPlayer.Character and myChar then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if targetRoot and myRoot then
                myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end,
})

-------------------------
-- WAYPOINTS & UTILITY TAB
-------------------------
local savedWaypoint = nil

UtilityTab:CreateButton({
    Name = "Save Current Location",
    Callback = function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            savedWaypoint = root.CFrame
            Rayfield:Notify({
                Title = "Waypoint Saved",
                Content = "Location has been stored.",
                Duration = 2,
            })
        end
    end,
})

UtilityTab:CreateButton({
    Name = "Teleport to Saved Location",
    Callback = function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and savedWaypoint then
            root.CFrame = savedWaypoint
            Rayfield:Notify({
                Title = "Teleported",
                Content = "Returned to saved waypoint.",
                Duration = 2,
            })
        elseif not savedWaypoint then
            Rayfield:Notify({
                Title = "Error",
                Content = "No waypoint saved yet!",
                Duration = 2,
            })
        end
    end,
})

UtilityTab:CreateKeybind({
    Name = "Click to Teleport",
    CurrentKeybind = "LeftAlt",
    HoldToInteract = false,
    Flag = "ClickTPKeybind",
    Callback = function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and Mouse.Hit then
            root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end,
})

local antiAfkConnection
UtilityTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            antiAfkConnection = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        else
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end
        end
    end,
})

-------------------------
-- STATS TAB
-------------------------
StatsTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end,
})

StatsTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 500},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = Value
        end
    end,
})

-------------------------
-- VISUALS TAB
-------------------------
local espConnections = {}
local espEnabled = false

local function ApplyESP(character)
    if not character or character == LocalPlayer.Character then return end
    if not character:FindFirstChild("AdminESP") then
        local highlight = Instance.new("Highlight", character)
        highlight.Name = "AdminESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function HandlePlayer(player)
    if player == LocalPlayer then return end
    if player.Character then ApplyESP(player.Character) end
    local conn = player.CharacterAdded:Connect(function(char)
        if espEnabled then ApplyESP(char) end
    end)
    table.insert(espConnections, conn)
end

VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        espEnabled = Value
        if Value then
            for _, player in ipairs(Players:GetPlayers()) do HandlePlayer(player) end
            local joinConn = Players.PlayerAdded:Connect(function(player)
                if espEnabled then HandlePlayer(player) end
            end)
            table.insert(espConnections, joinConn)
        else
            for _, conn in ipairs(espConnections) do conn:Disconnect() end
            table.clear(espConnections)
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("AdminESP") then
                    player.Character.AdminESP:Destroy()
                end
            end
        end
    end,
})

-------------------------
-- WORLD & LIGHTING TAB
-------------------------
local originalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows
}

WorldTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
        else
            Lighting.Ambient = originalLighting.Ambient
            Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
            Lighting.Brightness = originalLighting.Brightness
            Lighting.GlobalShadows = originalLighting.GlobalShadows
        end
    end,
})

WorldTab:CreateSlider({
    Name = "Time of Day",
    Range = {0, 24},
    Increment = 1,
    Suffix = "Hours",
    CurrentValue = Lighting.ClockTime,
    Flag = "TimeOfDaySlider",
    Callback = function(Value)
        Lighting.ClockTime = Value
    end,
})

-------------------------
-- SERVER TESTING TAB
-------------------------
ServerTab:CreateInput({
    Name = "Force Equip Title",
    PlaceholderText = "Enter Title Name to force update...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local titleEvent = ReplicatedStorage:FindFirstChild("TitleAction")
        
        if titleEvent and titleEvent:IsA("RemoteEvent") then
            titleEvent:FireServer("Equip", Text)
            Rayfield:Notify({
                Title = "Event Fired",
                Content = "Fired TitleAction with data: " .. Text,
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Could not locate 'TitleAction' RemoteEvent.",
                Duration = 4,
            })
        end
    end,
})

-------------------------
-- UNIVERSAL SCRIPTS TAB
-------------------------
UniversalTab:CreateButton({
    Name = "Load Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
})

UniversalTab:CreateButton({
    Name = "Load Nameless Admin",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
    end,
})

UniversalTab:CreateButton({
    Name = "Load SimpleSpy (Remote Logger)",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
    end,
})

UniversalTab:CreateButton({
    Name = "Load Dex Explorer (V3)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))()
    end,
})

-------------------------
-- FUN / MEME TAB
-------------------------
local headSpinConnection
MemeTab:CreateToggle({
    Name = "Skibidi Spin",
    CurrentValue = false,
    Callback = function(Value)
        local char = LocalPlayer.Character
        local head = char and char:FindFirstChild("Head")
        local neck = head and head:FindFirstChild("Neck") or (char and char:FindFirstChild("Neck", true))
        
        if Value and neck then
            local currentAngle = 0
            headSpinConnection = RunService.RenderStepped:Connect(function()
                currentAngle = currentAngle + 0.5
                neck.C0 = neck.C0 * CFrame.Angles(0, 0.5, 0)
            end)
        else
            if headSpinConnection then
                headSpinConnection:Disconnect()
                headSpinConnection = nil
            end
        end
    end,
})

local caseOhConnection
MemeTab:CreateToggle({
    Name = "CaseOh Earthquake Landing",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            caseOhConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                local humanoid = char:WaitForChild("Humanoid")
                humanoid.StateChanged:Connect(function(old, new)
                    if new == Enum.HumanoidStateType.Landed then
                        local startTime = tick()
                        local shakeDuration = 0.5
                        local shakeConn
                        shakeConn = RunService.RenderStepped:Connect(function()
                            if tick() - startTime < shakeDuration then
                                local x = math.random(-2, 2)
                                local y = math.random(-2, 2)
                                local z = math.random(-2, 2)
                                Camera.CFrame = Camera.CFrame * CFrame.Angles(math.rad(x), math.rad(y), math.rad(z))
                            else
                                shakeConn:Disconnect()
                            end
                        end)
                    end
                end)
            end)
            
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.StateChanged:Connect(function(old, new)
                        if new == Enum.HumanoidStateType.Landed then
                            local startTime = tick()
                            local shakeDuration = 0.5
                            local shakeConn
                            shakeConn = RunService.RenderStepped:Connect(function()
                                if tick() - startTime < shakeDuration then
                                    local x = math.random(-2, 2)
                                    local y = math.random(-2, 2)
                                    local z = math.random(-2, 2)
                                    Camera.CFrame = Camera.CFrame * CFrame.Angles(math.rad(x), math.rad(y), math.rad(z))
                                else
                                    shakeConn:Disconnect()
                                end
                            end)
                        end
                    end)
                end
            end
        else
            if caseOhConnection then
                caseOhConnection:Disconnect()
                caseOhConnection = nil
            end
        end
    end,
})

-- Initialize the UI
Rayfield:LoadConfiguration()
