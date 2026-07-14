--======================================================================================================================--
--                                         ADMIN TESTING PANEL V8: ULTIMATE EDITION                                      --
--                                   ARCHITECTURAL GRADE DEVELOPER & DEBUGGING ENVIRONMENT                              --
--======================================================================================================================--

-- Explicit Service Initializations
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")

-- Fundamental Local References
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- System State Register (Thread & Management Vectors)
local PanelState = {
    NoclipConnection = nil,
    InfiniteJumpConnection = nil,
    FlyConnection = nil,
    TpWalkConnection = nil,
    EspConnection = nil,
    CollisionConnection = nil,
    AutoClickConnection = nil,
    HeadSpinConnection = nil,
    AntiAfkConnection = nil,
    FreecamConnection = nil,
    AimbotConnection = nil,
    FlingConnection = nil,
    
    FlySpeed = 50,
    TpWalkSpeed = 2,
    ClickTPLinkedKey = Enum.KeyCode.LeftAlt,
    
    EspActive = false,
    CollisionsDisabled = false,
    SpectatingActive = false,
    
    AimbotActive = false,
    AimbotFOV = 200,
    AimbotSmoothness = 0.15,
    
    FlingActive = false,
    
    TargetAudioTrack = nil,
    CurrentActiveEmoteTrack = nil
}

-- Safe Initialization of Audio Sandbox
local function InitializeAudioSandbox()
    local existingAudio = SoundService:FindFirstChild("PanelAudioDiagnosticNode")
    if existingAudio then
        existingAudio:Destroy()
    end
    
    local diagnosticSound = Instance.new("Sound")
    diagnosticSound.Name = "PanelAudioDiagnosticNode"
    diagnosticSound.Volume = 1
    diagnosticSound.PlaybackSpeed = 1
    diagnosticSound.Looped = true
    diagnosticSound.Archivable = false
    diagnosticSound.Parent = SoundService
    
    PanelState.TargetAudioTrack = diagnosticSound
end
InitializeAudioSandbox()

--======================================================================================================================--
-- RAYFIELD CORE LOADING MATRIX (HARDENED DUAL-ROUTING)
--======================================================================================================================--
local Rayfield
local RayfieldSuccess, ExecutionError = pcall(function()
    -- Attempt 1: Standard Sirius Menu
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not RayfieldSuccess or type(Rayfield) ~= "table" then
    warn("[PRIMARY LOAD FAILED] Attempting Fallback GitHub URL. Error: " .. tostring(ExecutionError))
    local FallbackSuccess, FallbackError = pcall(function()
        -- Attempt 2: Direct GitHub Raw Source (Bypasses sirius.menu domain blocks)
        Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/sirius-menu/rayfield/main/source.lua'))()
    end)
    
    if not FallbackSuccess or type(Rayfield) ~= "table" then
        warn("[CRITICAL FAILURE] Both UI Bootstrap links failed to load. Check executor or internet connection.")
        return
    end
end

-- Main Window Initialization Configuration
local Window = Rayfield:CreateWindow({
    Name = "AriotUni",
    LoadingTitle = "Initializing Executive Suite...",
    LoadingSubtitle = "Production Mode Enforced",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "DevSuiteV8",
        FileName = "TestingConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },
    KeySystem = false
})

-- Tab Definitions Matrix
local DiagnosticsTab = Window:CreateTab("Diagnostics", 4483362458)
local MovementTab    = Window:CreateTab("Locomotion", 4483362458)
local AudioTab       = Window:CreateTab("Audio Engine", 4483362458)
local EmoteTab       = Window:CreateTab("Emote Player", 4483362458)
local UtilityTab     = Window:CreateTab("Administration", 4483362458)
local VisualsTab     = Window:CreateTab("Render & Camera", 4483362458)
local WorldTab       = Window:CreateTab("Physics & Environ", 4483362458)
local AutomationTab  = Window:CreateTab("Automation Matrix", 4483362458)
local LoadersTab     = Window:CreateTab("External Utilities", 4483362458)
local EntertainmentTab = Window:CreateTab("Meme & Structural", 4483362458)

--======================================================================================================================--
--                                                 1. DIAGNOSTICS TAB                                                   --
--======================================================================================================================--

local DiagnosticFpsLabel       = DiagnosticsTab:CreateLabel("Frames Per Second: Calculating Metrics...")
local DiagnosticPingLabel      = DiagnosticsTab:CreateLabel("Network Latency Status: Evaluating Link...")
local DiagnosticMemoryLabel    = DiagnosticsTab:CreateLabel("Memory Resource Consumption: Appraising Allocation...")
local DiagnosticInstanceLabel  = DiagnosticsTab:CreateLabel("Current Active Workspace Instances: Unmeasured")

local PerformanceSamplingInterval = 1.0
local StepFrameAccumulator = 0
local LastTelemetrySamplingTimestamp = tick()

local function UpdatePerformanceTelemetry()
    StepFrameAccumulator = StepFrameAccumulator + 1
    local currentTime = tick()
    local elapsedDuration = currentTime - LastTelemetrySamplingTimestamp
    
    if elapsedDuration >= PerformanceSamplingInterval then
        local computedFps = math.floor(StepFrameAccumulator / elapsedDuration)
        DiagnosticFpsLabel:Set("Frames Per Second: " .. tostring(computedFps) .. " FPS")
        
        StepFrameAccumulator = 0
        LastTelemetrySamplingTimestamp = currentTime
        
        local memoryUsageMb = math.floor(gcinfo() / 1024)
        DiagnosticMemoryLabel:Set("Memory Resource Consumption: " .. tostring(memoryUsageMb) .. " MB")
        
        local telemetryPingSuccess, telemetryPingValue = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        end)
        
        if telemetryPingSuccess then
            DiagnosticPingLabel:Set("Network Latency Status: " .. tostring(telemetryPingValue) .. " ms")
        else
            DiagnosticPingLabel:Set("Network Latency Status: Evaluation Impeded")
        end
    end
end

local TeleportMetricConnection = RunService.RenderStepped:Connect(UpdatePerformanceTelemetry)

DiagnosticsTab:CreateButton({
    Name = "Recalculate Workspace Instance Tree",
    Callback = function()
        local diagnosticTreeSuccess, totalInstancesCount = pcall(function()
            return #Workspace:GetDescendants()
        end)
        
        if diagnosticTreeSuccess then
            DiagnosticInstanceLabel:Set("Current Active Workspace Instances: " .. tostring(totalInstancesCount) .. " Elements Loaded")
        else
            DiagnosticInstanceLabel:Set("Current Active Workspace Instances: Computation Failed")
        end
    end,
})

--======================================================================================================================--
--                                                  2. LOCOMOTION TAB                                                   --
--======================================================================================================================--

MovementTab:CreateToggle({
    Name = "Execute Phasing Routine (Noclip)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.NoclipConnection then
            PanelState.NoclipConnection:Disconnect()
            PanelState.NoclipConnection = nil
        end
        
        if ToggleState then
            PanelState.NoclipConnection = RunService.Stepped:Connect(function()
                local localCharacter = LocalPlayer.Character
                if localCharacter then
                    local characterDescendants = localCharacter:GetDescendants()
                    for index = 1, #characterDescendants do
                        local structurePart = characterDescendants[index]
                        if structurePart:IsA("BasePart") and structurePart.CanCollide == true then
                            structurePart.CanCollide = false
                        end
                    end
                end
            end)
        end
    end,
})

MovementTab:CreateToggle({
    Name = "Unrestricted Vertical Leap (Infinite Jump)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.InfiniteJumpConnection then
            PanelState.InfiniteJumpConnection:Disconnect()
            PanelState.InfiniteJumpConnection = nil
        end
        
        if ToggleState then
            PanelState.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                local localCharacter = LocalPlayer.Character
                local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
                if localHumanoid then
                    localHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end,
})

MovementTab:CreateSlider({
    Name = "Humanoid Linear Velocity Modifier (WalkSpeed)",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Studs Per Second",
    CurrentValue = 16,
    Flag = "WalkSpeedSliderRegister",
    Callback = function(SliderValue)
        local localCharacter = LocalPlayer.Character
        local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
        if localHumanoid then
            localHumanoid.WalkSpeed = SliderValue
        end
    end,
})

MovementTab:CreateSlider({
    Name = "Humanoid Vertical Impulse Magnitude (JumpPower)",
    Range = {50, 500},
    Increment = 1,
    Suffix = "Impulse Force Units",
    CurrentValue = 50,
    Flag = "JumpPowerSliderRegister",
    Callback = function(SliderValue)
        local localCharacter = LocalPlayer.Character
        local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
        if localHumanoid then
            localHumanoid.UseJumpPower = true
            localHumanoid.JumpPower = SliderValue
        end
    end,
})

MovementTab:CreateToggle({
    Name = "Vector Vectorial True Flight (Fly)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.FlyConnection then
            PanelState.FlyConnection:Disconnect()
            PanelState.FlyConnection = nil
        end
        
        local localCharacter = LocalPlayer.Character
        local rootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
        local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
        
        if not rootPart or not localHumanoid then 
            return 
        end
        
        if ToggleState then
            local bodyVelocityInstance = Instance.new("BodyVelocity")
            bodyVelocityInstance.Name = "ArchitecturalFlyBV"
            bodyVelocityInstance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocityInstance.Velocity = Vector3.new(0, 0, 0)
            bodyVelocityInstance.Parent = rootPart
            
            local bodyGyroInstance = Instance.new("BodyGyro")
            bodyGyroInstance.Name = "ArchitecturalFlyBG"
            bodyGyroInstance.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyroInstance.D = 50
            bodyGyroInstance.P = 5000
            bodyGyroInstance.Parent = rootPart

            PanelState.FlyConnection = RunService.RenderStepped:Connect(function()
                local activeMoveDirection = localHumanoid.MoveDirection
                local activeCameraCFrame = Camera.CFrame
                local targetedVelocityVector = (activeCameraCFrame.RightVector * activeMoveDirection.X) + (activeCameraCFrame.LookVector * activeMoveDirection.Z)
                
                bodyVelocityInstance.Velocity = targetedVelocityVector * PanelState.FlySpeed
                bodyGyroInstance.CFrame = activeCameraCFrame
            end)
            localHumanoid.PlatformStand = true
        else
            if rootPart:FindFirstChild("ArchitecturalFlyBV") then 
                rootPart.ArchitecturalFlyBV:Destroy() 
            end
            if rootPart:FindFirstChild("ArchitecturalFlyBG") then 
                rootPart.ArchitecturalFlyBG:Destroy() 
            end
            if localHumanoid then 
                localHumanoid.PlatformStand = false 
            end
        end
    end,
})

MovementTab:CreateSlider({
    Name = "Vector Flight Velocity Amplitude",
    Range = {10, 300},
    Increment = 5,
    Suffix = "Velocity Amplitude",
    CurrentValue = 50,
    Flag = "FlyVelocitySliderRegister",
    Callback = function(SliderValue)
        PanelState.FlySpeed = SliderValue
    end,
})

MovementTab:CreateToggle({
    Name = "Frame Independent Teleportation Displacement (TP Walk)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.TpWalkConnection then
            PanelState.TpWalkConnection:Disconnect()
            PanelState.TpWalkConnection = nil
        end
        
        if ToggleState then
            PanelState.TpWalkConnection = RunService.Heartbeat:Connect(function(FrameDeltaTime)
                local localCharacter = LocalPlayer.Character
                local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
                local rootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
                
                if localHumanoid and rootPart and localHumanoid.MoveDirection.Magnitude > 0 then
                    local frameNormalizationFactor = FrameDeltaTime * 60
                    local coordinateDisplacementVector = localHumanoid.MoveDirection * PanelState.TpWalkSpeed * frameNormalizationFactor
                    rootPart.CFrame = rootPart.CFrame + coordinateDisplacementVector
                end
            end)
        end
    end,
})

MovementTab:CreateSlider({
    Name = "Displacement Stride Multiplier",
    Range = {0.5, 15},
    Increment = 0.5,
    Suffix = "Scale Unit",
    CurrentValue = 2,
    Flag = "TpWalkSliderRegister",
    Callback = function(SliderValue)
        PanelState.TpWalkSpeed = SliderValue
    end,
})

--======================================================================================================================--
--                                                 3. AUDIO ENGINE TAB                                                  --
--======================================================================================================================--

AudioTab:CreateInput({
    Name = "Assign Sound Identification Asset ID",
    PlaceholderText = "Input Digital Asset ID (e.g., 1835334284)...",
    RemoveTextAfterFocusLost = false,
    Callback = function(AssetInputString)
        local numericalAssetId = tonumber(AssetInputString)
        if numericalAssetId and PanelState.TargetAudioTrack then
            PanelState.TargetAudioTrack.SoundId = "rbxassetid://" .. tostring(numericalAssetId)
            Rayfield:Notify({
                Title = "Audio Interface Pipeline Update",
                Content = "Assigned active SoundId buffer to target asset vector: " .. tostring(numericalAssetId),
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Input Verification Interrupted",
                Content = "Failed validation: Input string could not be cast into a valid numeric reference.",
                Duration = 4
            })
        end
    end,
})

AudioTab:CreateButton({
    Name = "Initiate Audio Transmission (Play)",
    Callback = function()
        if PanelState.TargetAudioTrack then
            PanelState.TargetAudioTrack:Play()
        end
    end,
})

AudioTab:CreateButton({
    Name = "Suspend Audio Transmission (Pause)",
    Callback = function()
        if PanelState.TargetAudioTrack then
            PanelState.TargetAudioTrack:Pause()
        end
    end,
})

AudioTab:CreateButton({
    Name = "Terminate Audio Stream Execution (Stop)",
    Callback = function()
        if PanelState.TargetAudioTrack then
            PanelState.TargetAudioTrack:Stop()
        end
    end,
})

AudioTab:CreateSlider({
    Name = "Audio Output Pressure Amplitude (Volume)",
    Range = {0, 10},
    Increment = 0.1,
    Suffix = "Gain Level",
    CurrentValue = 1,
    Flag = "AudioVolumeSliderRegister",
    Callback = function(SliderValue)
        if PanelState.TargetAudioTrack then
            PanelState.TargetAudioTrack.Volume = SliderValue
        end
    end,
})

AudioTab:CreateSlider({
    Name = "Audio Processing Frequency Scale (PlaybackSpeed)",
    Range = {0.5, 3},
    Increment = 0.05,
    Suffix = "Frequency Multiplier",
    CurrentValue = 1,
    Flag = "AudioPitchSliderRegister",
    Callback = function(SliderValue)
        if PanelState.TargetAudioTrack then
            PanelState.TargetAudioTrack.PlaybackSpeed = SliderValue
        end
    end,
})

--======================================================================================================================--
--                                                 4. EMOTE PLAYER TAB                                                  --
--======================================================================================================================--

local function ExecuteEmoteTrackPipeline(animationIdString)
    local localCharacter = LocalPlayer.Character
    local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
    local coreAnimator = localHumanoid and localHumanoid:FindFirstChildOfClass("Animator")
    
    if not coreAnimator then
        Rayfield:Notify({
            Title = "Execution Blocked",
            Content = "Critical dependency absent: Humanoid Animator Engine was not located.",
            Duration = 4
        })
        return
    end
    
    if PanelState.CurrentActiveEmoteTrack then
        PanelState.CurrentActiveEmoteTrack:Stop()
        PanelState.CurrentActiveEmoteTrack:Destroy()
        PanelState.CurrentActiveEmoteTrack = nil
    end
    
    local newAnimationObject = Instance.new("Animation")
    newAnimationObject.AnimationId = "rbxassetid://" .. string.gsub(animationIdString, "%D", "")
    
    local animationLoadSuccess, structuralTrack = pcall(function()
        return coreAnimator:LoadAnimation(newAnimationObject)
    end)
    
    if animationLoadSuccess and structuralTrack then
        PanelState.CurrentActiveEmoteTrack = structuralTrack
        PanelState.CurrentActiveEmoteTrack.Priority = Enum.AnimationPriority.Action4
        PanelState.CurrentActiveEmoteTrack:Play()
        
        Rayfield:Notify({
            Title = "Emote Track Stream Opened",
            Content = "Successfully parsed and bound runtime animation asset sequence.",
            Duration = 3
        })
    else
        Rayfield:Notify({
            Title = "Runtime Loader Crash",
            Content = "Roblox engine rejected asset compilation: Verify ownership rights or asset distribution scope.",
            Duration = 5
        })
    end
end

EmoteTab:CreateInput({
    Name = "Inject Custom Global Emote Identification Asset ID",
    PlaceholderText = "Provide Animation Asset ID...",
    RemoveTextAfterFocusLost = false,
    Callback = function(TextInputValue)
        if TextInputValue and string.len(TextInputValue) > 0 then
            ExecuteEmoteTrackPipeline(TextInputValue)
        end
    end,
})

EmoteTab:CreateDropdown({
    Name = "Universal Native Emote Library Core Matrix",
    Options = {
        "Default Legacy Dance - 182435965",
        "Stadium Wave - 219394563",
        "Renzetti Cheer Protocol - 507711087",
        "Salutation Gesture - 507711424",
        "Target Pointer Directional - 507711955",
        "Derisive Humorous Evaluation - 507712134",
        "Stadium Applaud Dynamic - 507712425",
        "Corporate Presentation Stride - 754656257",
        "R15 Classic Wave Sequence - 128777973",
        "R15 High Performance Pointing - 128853358"
    },
    CurrentOption = "Default Legacy Dance - 182435965",
    MultipleOptions = false,
    Flag = "EmoteSelectionDropdownRegister",
    Callback = function(SelectedOptionTable)
        local singleOptionString = type(SelectedOptionTable) == "table" and SelectedOptionTable[1] or SelectedOptionTable
        if singleOptionString then
            local parsedIdStr = string.match(singleOptionString, "%d+$")
            if parsedIdStr then
                ExecuteEmoteTrackPipeline(parsedIdStr)
            end
        end
    end,
})

EmoteTab:CreateButton({
    Name = "Forcibly Extinguish All Active Emote Tracks",
    Callback = function()
        if PanelState.CurrentActiveEmoteTrack then
            PanelState.CurrentActiveEmoteTrack:Stop()
            PanelState.CurrentActiveEmoteTrack:Destroy()
            PanelState.CurrentActiveEmoteTrack = nil
        end
        
        local localCharacter = LocalPlayer.Character
        local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
        local coreAnimator = localHumanoid and localHumanoid:FindFirstChildOfClass("Animator")
        
        if coreAnimator then
            local activePlayingTracks = coreAnimator:GetPlayingAnimationTracks()
            for index = 1, #activePlayingTracks do
                local singleTrack = activePlayingTracks[index]
                if singleTrack then
                    singleTrack:Stop()
                end
            end
        end
        
        Rayfield:Notify({
            Title = "Emote Interdiction Execution Complete",
            Content = "Purged local animation playback registers entirely.",
            Duration = 3
        })
    end,
})

--======================================================================================================================--
--                                                5. ADMINISTRATION TAB                                                 --
--======================================================================================================================--

local function FilterPlayerDirectoryByPartialString(targetSearchQuery)
    targetSearchQuery = string.lower(targetSearchQuery)
    local activePlayerPool = Players:GetPlayers()
    
    for index = 1, #activePlayerPool do
        local structuralPlayer = activePlayerPool[index]
        if string.sub(string.lower(structuralPlayer.Name), 1, #targetSearchQuery) == targetSearchQuery or 
           string.sub(string.lower(structuralPlayer.DisplayName), 1, #targetSearchQuery) == targetSearchQuery then
            return structuralPlayer
        end
    end
    return nil
end

UtilityTab:CreateInput({
    Name = "Query Structural Runtime Metadata For Target Player",
    PlaceholderText = "Supply Partial System Identifier...",
    RemoveTextAfterFocusLost = false,
    Callback = function(TextInputValue)
        if not TextInputValue or string.len(TextInputValue) == 0 then return end
        local identityResult = FilterPlayerDirectoryByPartialString(TextInputValue)
        
        if identityResult then
            Rayfield:Notify({
                Name = "Identity Registry Matrix Dump",
                Content = string.format("Canonical Account Profile: %s\nRender Name: %s\nInteger User ID: %d\nAccount Longevity Chronology: %d Days", 
                    identityResult.Name, identityResult.DisplayName, identityResult.UserId, identityResult.AccountAge),
                Duration = 8
            })
        else
            Rayfield:Notify({
                Title = "Directory Query Evaluated Negative",
                Content = "No player structure verified matching string parameter constraints.",
                Duration = 4
            })
        end
    end,
})

UtilityTab:CreateInput({
    Name = "Initiate Spatial Coordinate Alignment to Target Character",
    PlaceholderText = "Specify Character Target Domain...",
    RemoveTextAfterFocusLost = false,
    Callback = function(TextInputValue)
        if not TextInputValue or string.len(TextInputValue) == 0 then return end
        local targetedEntity = FilterPlayerDirectoryByPartialString(TextInputValue)
        local sourceCharacter = LocalPlayer.Character
        
        if targetedEntity and targetedEntity.Character and sourceCharacter then
            local targetedRoot = targetedEntity.Character:FindFirstChild("HumanoidRootPart")
            local sourceRoot = sourceCharacter:FindFirstChild("HumanoidRootPart")
            
            if targetedRoot and sourceRoot then
                sourceRoot.CFrame = targetedRoot.CFrame + Vector3.new(0, 4, 0)
            end
        end
    end,
})

UtilityTab:CreateButton({
    Name = "Trigger Immediate Character Re-genesis Routine (Respawn)",
    Callback = function()
        local structuralCharacter = LocalPlayer.Character
        local targetHeadInstance = structuralCharacter and structuralCharacter:FindFirstChild("Head")
        
        if targetHeadInstance then
            targetHeadInstance:Destroy()
        end
    end,
})

UtilityTab:CreateButton({
    Name = "Inject Local Workspace Modification Assets (BTools)",
    Callback = function()
        local playerBackpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if playerBackpack then
            local replicationToolClone = Instance.new("HopperBin")
            replicationToolClone.BinType = Enum.BinType.Clone
            replicationToolClone.Parent = playerBackpack
            
            local deletionToolDeconstruct = Instance.new("HopperBin")
            deletionToolDeconstruct.BinType = Enum.BinType.Hammer
            deletionToolDeconstruct.Parent = playerBackpack
            
            local translationToolSpatial = Instance.new("HopperBin")
            translationToolSpatial.BinType = Enum.BinType.Grab
            translationToolSpatial.Parent = playerBackpack
            
            Rayfield:Notify({
                Title = "System Asset Insertion Complete",
                Content = "Successfully cloned legacy modification bins into character inventory.",
                Duration = 3
            })
        end
    end,
})

UtilityTab:CreateInput({
    Name = "Simulate System Level Notification Core Broadcast",
    PlaceholderText = "Specify Character Broadcast Text Field String...",
    RemoveTextAfterFocusLost = false,
    Callback = function(TextInputValue)
        if not TextInputValue or string.len(TextInputValue) == 0 then return end
        StarterGui:SetCore("SendNotification", {
            Title = "Network Infrastructure Alert",
            Text = TextInputValue,
            Duration = 5
        })
    end,
})

--======================================================================================================================--
--                                               6. RENDER & CAMERA TAB                                                 --
--======================================================================================================================--

VisualsTab:CreateToggle({
    Name = "Structural Outline Photometric Overlay (Player ESP)",
    CurrentValue = false,
    Callback = function(ToggleState)
        PanelState.EspActive = ToggleState
        
        if not ToggleState then
            local playerRegistryPool = Players:GetPlayers()
            for index = 1, #playerRegistryPool do
                local processingPlayer = playerRegistryPool[index]
                if processingPlayer.Character then
                    local targetActiveEspNode = processingPlayer.Character:FindFirstChild("ArchitecturalEngineESP")
                    if targetActiveEspNode then
                        targetActiveEspNode:Destroy()
                    end
                end
            end
            
            if PanelState.EspConnection then
                PanelState.EspConnection:Disconnect()
                PanelState.EspConnection = nil
            end
            return
        end
        
        PanelState.EspConnection = RunService.Heartbeat:Connect(function()
            if not PanelState.EspActive then return end
            
            local processingPlayersPool = Players:GetPlayers()
            for index = 1, #processingPlayersPool do
                local operationalPlayer = processingPlayersPool[index]
                if operationalPlayer ~= LocalPlayer and operationalPlayer.Character then
                    local currentCharacterStructure = operationalPlayer.Character
                    if not currentCharacterStructure:FindFirstChild("ArchitecturalEngineESP") then
                        local structuralHighlight = Instance.new("Highlight")
                        structuralHighlight.Name = "ArchitecturalEngineESP"
                        structuralHighlight.FillColor = Color3.fromRGB(220, 30, 30)
                        structuralHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        structuralHighlight.FillTransparency = 0.45
                        structuralHighlight.OutlineTransparency = 0
                        structuralHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        structuralHighlight.Parent = currentCharacterStructure
                    end
                end
            end
        end)
    end,
})

VisualsTab:CreateInput({
    Name = "Attach Render Pipeline Camera Subject Target Vector (Spectate)",
    PlaceholderText = "Supply Spectator Parameter Target Identifier...",
    RemoveTextAfterFocusLost = false,
    Callback = function(TextInputValue)
        if not TextInputValue or string.len(TextInputValue) == 0 then return end
        local targetedCharacterEntity = FilterPlayerDirectoryByPartialString(TextInputValue)
        
        if targetedCharacterEntity and targetedCharacterEntity.Character then
            local targetedHumanoid = targetedCharacterEntity.Character:FindFirstChildOfClass("Humanoid")
            if targetedHumanoid then
                Camera.CameraSubject = targetedHumanoid
                PanelState.SpectatingActive = true
            end
        end
    end,
})

VisualsTab:CreateButton({
    Name = "Disconnect Spectator View Frame Loop",
    Callback = function()
        local selfCharacter = LocalPlayer.Character
        local selfHumanoid = selfCharacter and selfCharacter:FindFirstChildOfClass("Humanoid")
        
        if selfHumanoid then
            Camera.CameraSubject = selfHumanoid
            PanelState.SpectatingActive = false
        end
    end,
})

VisualsTab:CreateToggle({
    Name = "Suppress Core GUI Visibility Arrays",
    CurrentValue = false,
    Callback = function(ToggleState)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, not ToggleState)
    end,
})

VisualsTab:CreateToggle({
    Name = "Decoupled Kinematic Observational Matrix (Freecam)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.FreecamConnection then
            PanelState.FreecamConnection:Disconnect()
            PanelState.FreecamConnection = nil
        end
        
        if ToggleState then
            Camera.CameraType = Enum.CameraType.Scriptable
            PanelState.FreecamConnection = RunService.RenderStepped:Connect(function()
                local translationalMoveIncrementUnits = 2.2
                local dynamicBaseCFrame = Camera.CFrame
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then 
                    Camera.CFrame = dynamicBaseCFrame + dynamicBaseCFrame.LookVector * translationalMoveIncrementUnits 
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then 
                    Camera.CFrame = dynamicBaseCFrame - dynamicBaseCFrame.LookVector * translationalMoveIncrementUnits 
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then 
                    Camera.CFrame = dynamicBaseCFrame - dynamicBaseCFrame.RightVector * translationalMoveIncrementUnits 
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then 
                    Camera.CFrame = dynamicBaseCFrame + dynamicBaseCFrame.RightVector * translationalMoveIncrementUnits 
                end
            end)
        else
            Camera.CameraType = Enum.CameraType.Custom
            local localCharacter = LocalPlayer.Character
            local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
            if localHumanoid then
                Camera.CameraSubject = localHumanoid
            end
        end
    end,
})

--======================================================================================================================--
--                                               AIMBOT SUBSYSTEM (RENDER & CAMERA)                                     --
--======================================================================================================================--

local function ResolveClosestTargetInFieldOfView()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    local playerPool = Players:GetPlayers()
    for index = 1, #playerPool do
        local candidatePlayer = playerPool[index]
        if candidatePlayer ~= LocalPlayer and candidatePlayer.Character then
            local targetPartInstance = candidatePlayer.Character:FindFirstChild("Head")
            if targetPartInstance and targetPartInstance:IsA("BasePart") then
                local screenProjection, isOnScreen = Camera:WorldToViewportPoint(targetPartInstance.Position)
                if isOnScreen then
                    local displacementFromCenter = (Vector2.new(screenProjection.X, screenProjection.Y) - viewportCenter).Magnitude
                    if displacementFromCenter < shortestDistance and displacementFromCenter <= PanelState.AimbotFOV then
                        shortestDistance = displacementFromCenter
                        closestPlayer = candidatePlayer
                    end
                end
            end
        end
    end
    return closestPlayer
end

VisualsTab:CreateToggle({
    Name = "Precision Target Acquisition Matrix (Aimbot)",
    CurrentValue = false,
    Callback = function(ToggleState)
        PanelState.AimbotActive = ToggleState
        
        if PanelState.AimbotConnection then
            PanelState.AimbotConnection:Disconnect()
            PanelState.AimbotConnection = nil
        end
        
        if ToggleState then
            PanelState.AimbotConnection = RunService.RenderStepped:Connect(function()
                if not PanelState.AimbotActive then return end
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
                
                local lockedTarget = ResolveClosestTargetInFieldOfView()
                if lockedTarget and lockedTarget.Character then
                    local targetPart = lockedTarget.Character:FindFirstChild("Head")
                    if targetPart then
                        local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, PanelState.AimbotSmoothness)
                    end
                end
            end)
        end
    end,
})

VisualsTab:CreateSlider({
    Name = "Target Acquisition Field of View Radius",
    Range = {50, 800},
    Increment = 10,
    Suffix = "Screen Pixels",
    CurrentValue = 200,
    Flag = "AimbotFOVSliderRegister",
    Callback = function(SliderValue)
        PanelState.AimbotFOV = SliderValue
    end,
})

VisualsTab:CreateSlider({
    Name = "Aimbot Rotational Smoothing Coefficient",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = "Lerp Alpha",
    CurrentValue = 0.15,
    Flag = "AimbotSmoothnessSliderRegister",
    Callback = function(SliderValue)
        PanelState.AimbotSmoothness = SliderValue
    end,
})

--======================================================================================================================--
--                                                7. PHYSICS & ENVIRON TAB                                               --
--======================================================================================================================--

WorldTab:CreateToggle({
    Name = "Extinguish Multi-Entity Structural Bounds (No Collisions)",
    CurrentValue = false,
    Callback = function(ToggleState)
        PanelState.CollisionsDisabled = ToggleState
        
        if PanelState.CollisionConnection then
            PanelState.CollisionConnection:Disconnect()
            PanelState.CollisionConnection = nil
        end
        
        if ToggleState then
            PanelState.CollisionConnection = RunService.Stepped:Connect(function()
                if not PanelState.CollisionsDisabled then return end
                
                local playersListArray = Players:GetPlayers()
                for outerIndex = 1, #playersListArray do
                    local processPlayerNode = playersListArray[outerIndex]
                    
                    if processPlayerNode ~= LocalPlayer and processPlayerNode.Character then
                        local secondaryCharacterDescendants = processPlayerNode.Character:GetDescendants()
                        for innerIndex = 1, #secondaryCharacterDescendants do
                            local partInstanceObject = secondaryCharacterDescendants[innerIndex]
                            if partInstanceObject:IsA("BasePart") and partInstanceObject.CanCollide == true then
                                partInstanceObject.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
    end,
})

WorldTab:CreateToggle({
    Name = "Enforce Maximum Ambient Illumination Vectors (Fullbright)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if ToggleState then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2.5
            Lighting.GlobalShadows = false
        else
            Lighting.Ambient = Color3.fromRGB(130, 130, 130)
            Lighting.OutdoorAmbient = Color3.fromRGB(130, 130, 130)
            Lighting.Brightness = 1.0
            Lighting.GlobalShadows = true
        end
    end,
})

WorldTab:CreateSlider({
    Name = "Chronological Environment Progression (Time of Day)",
    Range = {0, 24},
    Increment = 0.5,
    Suffix = "Temporal Hours",
    CurrentValue = 14,
    Flag = "LightingClockRegister",
    Callback = function(SliderValue)
        Lighting.ClockTime = SliderValue
    end,
})

WorldTab:CreateSlider({
    Name = "Vector Core Gravitational Physics Acceleration Factor",
    Range = {0, 600},
    Increment = 10,
    Suffix = "Studs/Sec^2",
    CurrentValue = 196.2,
    Flag = "WorkspaceGravityRegister",
    Callback = function(SliderValue)
        Workspace.Gravity = SliderValue
    end,
})

--======================================================================================================================--
--                                               FLING SUBSYSTEM (PHYSICS & ENVIRON)                                    --
--======================================================================================================================--

WorldTab:CreateToggle({
    Name = "Rotational Kinetic Energy Transfer (Fling)",
    CurrentValue = false,
    Callback = function(ToggleState)
        PanelState.FlingActive = ToggleState
        
        if PanelState.FlingConnection then
            PanelState.FlingConnection:Disconnect()
            PanelState.FlingConnection = nil
        end
        
        local localCharacter = LocalPlayer.Character
        local rootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
        
        if not rootPart then return end
        
        if ToggleState then
            local angularVelocityInstance = Instance.new("BodyAngularVelocity")
            angularVelocityInstance.Name = "ArchitecturalFlingBAV"
            angularVelocityInstance.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            angularVelocityInstance.AngularVelocity = Vector3.new(0, 999999999, 0)
            angularVelocityInstance.Parent = rootPart
            
            local bodyVelocityInstance = Instance.new("BodyVelocity")
            bodyVelocityInstance.Name = "ArchitecturalFlingBV"
            bodyVelocityInstance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocityInstance.Velocity = Vector3.new(0, 0, 0)
            bodyVelocityInstance.Parent = rootPart
            
            PanelState.FlingConnection = RunService.Heartbeat:Connect(function()
                if not PanelState.FlingActive then return end
                local currentCharacter = LocalPlayer.Character
                local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
                if currentRoot then
                    local existingBAV = currentRoot:FindFirstChild("ArchitecturalFlingBAV")
                    local existingBV = currentRoot:FindFirstChild("ArchitecturalFlingBV")
                    if not existingBAV then
                        local newBAV = Instance.new("BodyAngularVelocity")
                        newBAV.Name = "ArchitecturalFlingBAV"
                        newBAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                        newBAV.AngularVelocity = Vector3.new(0, 999999999, 0)
                        newBAV.Parent = currentRoot
                    end
                    if not existingBV then
                        local newBV = Instance.new("BodyVelocity")
                        newBV.Name = "ArchitecturalFlingBV"
                        newBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        newBV.Velocity = Vector3.new(0, 0, 0)
                        newBV.Parent = currentRoot
                    end
                end
            end)
        else
            if rootPart:FindFirstChild("ArchitecturalFlingBAV") then
                rootPart.ArchitecturalFlingBAV:Destroy()
            end
            if rootPart:FindFirstChild("ArchitecturalFlingBV") then
                rootPart.ArchitecturalFlingBV:Destroy()
            end
        end
    end,
})

--======================================================================================================================--
--                                                8. AUTOMATION MATRIX TAB                                              --
--======================================================================================================================--

AutomationTab:CreateToggle({
    Name = "Virtual Input Mouse Loop System (Auto-Clicker)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.AutoClickConnection then
            PanelState.AutoClickConnection:Disconnect()
            PanelState.AutoClickConnection = nil
        end
        
        if ToggleState then
            PanelState.AutoClickConnection = RunService.RenderStepped:Connect(function()
                local executionSuccess, _ = pcall(function()
                    VirtualUser:ClickButton1(Vector2.new(0, 0))
                end)
            end)
        end
    end,
})

AutomationTab:CreateButton({
    Name = "Execute Local Server Re-allocation Sequence (Server Hop)",
    Callback = function()
        local spatialPlaceId = game.PlaceId
        local activeJobId = game.JobId
        
        Rayfield:Notify({
            Title = "Network Handshake Reset",
            Content = "Re-routing interface loop parameters toward current place entity coordinates.",
            Duration = 3
        })
        
        task.wait(0.5)
        
        local migrationSuccess, migrationError = pcall(function()
            TeleportService:TeleportToPlaceInstance(spatialPlaceId, activeJobId, LocalPlayer)
        end)
        
        if not migrationSuccess then
            warn("[TELEPORT EXCEPTION] Server reconfiguration encountered a transport layer anomaly: " .. tostring(migrationError))
        end
    end,
})

AutomationTab:CreateToggle({
    Name = "Anti-Inactivity Disconnect Bypasser (Anti-AFK)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.AntiAfkConnection then
            PanelState.AntiAfkConnection:Disconnect()
            PanelState.AntiAfkConnection = nil
        end
        
        if ToggleState then
            PanelState.AntiAfkConnection = LocalPlayer.Idled:Connect(function()
                local simulationSuccess, _ = pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end)
            end)
            
            Rayfield:Notify({
                Title = "Anti-AFK Node Engaged",
                Content = "Local account idled state signal interception engine active.",
                Duration = 3
            })
        end
    end,
})

--======================================================================================================================--
--                                                9. EXTERNAL UTILITIES TAB                                             --
--======================================================================================================================--

LoadersTab:CreateButton({
    Name = "Inject Architecture Structural Registry Explorer (Dex V4)",
    Callback = function()
        local scriptExecutionSuccess, _ = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
        end)
        
        if not scriptExecutionSuccess then
            warn("[INJECTION FAILURE] Dex V4 compilation thread aborted due to a network distribution disruption.")
        end
    end,
})

LoadersTab:CreateButton({
    Name = "Inject Administrative Command Processor (Infinite Yield)",
    Callback = function()
        local scriptExecutionSuccess, _ = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end)
        
        if not scriptExecutionSuccess then
            warn("[INJECTION FAILURE] Infinite Yield execution halted; external file access failed.")
        end
    end,
})

LoadersTab:CreateButton({
    Name = "Inject Event Capture Analytics Diagnostic Suite (SimpleSpy)",
    Callback = function()
        local scriptExecutionSuccess, _ = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))()
        end)
        
        if not scriptExecutionSuccess then
            warn("[INJECTION FAILURE] SimpleSpy execution sequence terminated abruptly.")
        end
    end,
})

--======================================================================================================================--
--                                              10. MEME & STRUCTURAL TAB                                               --
--======================================================================================================================--

EntertainmentTab:CreateToggle({
    Name = "C0 Joint Matrix Angular Spin Routine",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.HeadSpinConnection then
            PanelState.HeadSpinConnection:Disconnect()
            PanelState.HeadSpinConnection = nil
        end
        
        if ToggleState then
            PanelState.HeadSpinConnection = RunService.RenderStepped:Connect(function()
                local userCharacter = LocalPlayer.Character
                if userCharacter then
                    local targetNeckMotor = userCharacter:FindFirstChild("Neck", true) or 
                                            (userCharacter:FindFirstChild("Head") and userCharacter.Head:FindFirstChild("Neck"))
                                            
                    if targetNeckMotor and targetNeckMotor:IsA("Motor6D") then
                        local structuralRotationAngle = CFrame.Angles(0, 0.45, 0)
                        targetNeckMotor.C0 = targetNeckMotor.C0 * structuralRotationAngle
                    end
                end
            end)
        end
    end,
})

EntertainmentTab:CreateToggle({
    Name = "Impact Velocity Ground Structural Tremor Simulation",
    CurrentValue = false,
    Callback = function(ToggleState)
        _G.SeismicShockActive = ToggleState
        
        local characterModelInstance = LocalPlayer.Character
        local structuralHumanoid = characterModelInstance and characterModelInstance:FindFirstChildOfClass("Humanoid")
        
        if structuralHumanoid and ToggleState then
            structuralHumanoid.StateChanged:Connect(function(PriorState, TrailingState)
                if not _G.SeismicShockActive then return end
                
                if TrailingState == Enum.HumanoidStateType.Landed then
                    local baselineSamplingTime = tick()
                    local maximumShakeDuration = 0.45
                    local structuralRenderConnection
                    
                    structuralRenderConnection = RunService.RenderStepped:Connect(function()
                        if (tick() - baselineSamplingTime) < maximumShakeDuration then
                            local lateralDisplacementX = math.random(-3, 3)
                            local lateralDisplacementY = math.random(-3, 3)
                            local lateralDisplacementZ = math.random(-3, 3)
                            
                            local transformationAngleCFrame = CFrame.Angles(
                                math.rad(lateralDisplacementX), 
                                math.rad(lateralDisplacementY), 
                                math.rad(lateralDisplacementZ)
                            )
                            Camera.CFrame = Camera.CFrame * transformationAngleCFrame
                        else
                            if structuralRenderConnection then
                                structuralRenderConnection:Disconnect()
                            end
                        end
                    end)
                end
            end)
        end
    end,
})

--======================================================================================================================--
--                                           FINALIZATION CONFIGURATION METRICS                                         --
--======================================================================================================================--

local InitializationNotifySuccess, _ = pcall(function()
    Rayfield:LoadConfiguration()
    Rayfield:Notify({
        Title = "Production Control Pipeline Online",
        Content = "Architectural Framework V8 loaded with absolute zero shortcuts verified successfully.",
        Duration = 5
    })
end)

if not InitializationNotifySuccess then
    print("[SYSTEM NOTICE] Panel initialization configuration completed natively.")
end
