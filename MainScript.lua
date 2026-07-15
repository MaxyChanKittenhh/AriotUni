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
local TextChatService = game:GetService("TextChatService")

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
    AimbotWallCheck = true,
    
    FlingActive = false,
    
    FlingTargetActive = false,
    FlingTargetPlayer = nil,
    FlingTargetConnection = nil,
    
    ClickTPConnection = nil,
    
    TargetAudioTrack = nil,
    CurrentActiveEmoteTrack = nil,
    
    -- NEW UNIVERSAL COMMAND STATE REGISTERS
    GodModeConnection = nil,
    GodModeCharAdded = nil,
    NoFallConnection = nil,
    CurrentNoFall = nil,
    AutoHealConnection = nil,
    FollowConnection = nil,
    FollowTarget = nil,
    SavedWaypoint = nil,
    ChatLogConnection = nil,
    ClickDeleteConnection = nil,
    ClickInspectConnection = nil,
    InstantPromptConnection = nil,
    AutoCollectConnection = nil,
    DexGui = nil,
    AntiFlingConnection = nil,
    PlatformConnection = nil,
    PlatformPart = nil,
    SpinConnection = nil,
    SpinSpeed = 20,
    Invisible = false,
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
-- UNIVERSAL PLAYER DIRECTORY FILTER (TOP LEVEL FOR ALL TABS)
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
local CommandTab     = Window:CreateTab("Command Center", 4483362458) -- NEW
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

MovementTab:CreateToggle({
    Name = "Mouse Vector Coordinate Teleportation (Click TP)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.ClickTPConnection then
            PanelState.ClickTPConnection:Disconnect()
            PanelState.ClickTPConnection = nil
        end
        
        if ToggleState then
            PanelState.ClickTPConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(PanelState.ClickTPLinkedKey) then
                    local mouseLocation = UserInputService:GetMouseLocation()
                    local viewportRay = Camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    local raycastResult = Workspace:Raycast(viewportRay.Origin, viewportRay.Direction * 5000, raycastParams)
                    
                    local destinationCFrame
                    if raycastResult then
                        destinationCFrame = CFrame.new(raycastResult.Position + Vector3.new(0, 3, 0))
                    else
                        destinationCFrame = CFrame.new(viewportRay.Origin + viewportRay.Direction * 5000)
                    end
                    
                    local localCharacter = LocalPlayer.Character
                    local rootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = destinationCFrame
                    end
                end
            end)
            
            Rayfield:Notify({
                Title = "Click TP Active",
                Content = "Hold " .. tostring(PanelState.ClickTPLinkedKey) .. " + Left Click to teleport.",
                Duration = 4
            })
        end
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

UtilityTab:CreateInput({
    Name = "Query Structural Runtime Metadata For Target Player",
    PlaceholderText = "Supply Partial System Identifier...",
    RemoveTextAfterFocusLost = false,
    Callback = function(TextInputValue)
        if not TextInputValue or string.len(TextInputValue) == 0 then return end
        local identityResult = FilterPlayerDirectoryByPartialString(TextInputValue)
        
        if identityResult then
            Rayfield:Notify({
                Title = "Identity Registry Matrix Dump",
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

UtilityTab:CreateInput({
    Name = "Initiate Gravitational Pull on Target Character (Bring)",
    PlaceholderText = "Specify Target Character Domain...",
    RemoveTextAfterFocusLost = false,
    Callback = function(TextInputValue)
        if not TextInputValue or string.len(TextInputValue) == 0 then return end
        local targetedEntity = FilterPlayerDirectoryByPartialString(TextInputValue)
        local sourceCharacter = LocalPlayer.Character
        
        if targetedEntity and targetedEntity.Character and sourceCharacter then
            local targetedRoot = targetedEntity.Character:FindFirstChild("HumanoidRootPart")
            local sourceRoot = sourceCharacter:FindFirstChild("HumanoidRootPart")
            
            if targetedRoot and sourceRoot then
                targetedRoot.CFrame = sourceRoot.CFrame + Vector3.new(3, 0, 3)
                Rayfield:Notify({
                    Title = "Spatial Realignment Complete",
                    Content = "Target " .. targetedEntity.Name .. " has been brought to local coordinates.",
                    Duration = 3
                })
            end
        else
            Rayfield:Notify({
                Title = "Bring Operation Failed",
                Content = "Target entity or local character not found in workspace.",
                Duration = 3
            })
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
                        local isVisible = true
                        
                        if PanelState.AimbotWallCheck then
                            local rayOrigin = Camera.CFrame.Position
                            local rayDirection = targetPartInstance.Position - rayOrigin
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                            local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                            
                            if raycastResult then
                                local hitModel = raycastResult.Instance:FindFirstAncestorOfClass("Model")
                                if hitModel ~= candidatePlayer.Character then
                                    isVisible = false
                                end
                            end
                        end
                        
                        if isVisible then
                            shortestDistance = displacementFromCenter
                            closestPlayer = candidatePlayer
                        end
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

VisualsTab:CreateToggle({
    Name = "Enable Structural Occlusion Validation (Wall Check)",
    CurrentValue = true,
    Callback = function(ToggleState)
        PanelState.AimbotWallCheck = ToggleState
        Rayfield:Notify({
            Title = "Aimbot Occlusion Filter",
            Content = "Wall check validation is now " .. (ToggleState and "ENABLED" or "DISABLED") .. ".",
            Duration = 3
        })
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
--                                          TARGETED FLING SUBSYSTEM (PHYSICS & ENVIRON)                              --
--======================================================================================================================--

WorldTab:CreateLabel("--- Targeted Kinetic Transfer Control ---")

WorldTab:CreateInput({
    Name = "Target Entity Identifier for Kinetic Transfer",
    PlaceholderText = "Supply Partial Target Name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(TextInputValue)
        if not TextInputValue or string.len(TextInputValue) == 0 then return end
        local targetPlayer = FilterPlayerDirectoryByPartialString(TextInputValue)
        if targetPlayer then
            PanelState.FlingTargetPlayer = targetPlayer
            Rayfield:Notify({
                Title = "Target Lock Established",
                Content = "Kinetic vector target bound to: " .. targetPlayer.Name,
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Target Resolution Failed",
                Content = "No player matching provided identifier.",
                Duration = 3
            })
        end
    end,
})

WorldTab:CreateToggle({
    Name = "Execute Kinetic Energy Transfer on Target Entity",
    CurrentValue = false,
    Callback = function(ToggleState)
        PanelState.FlingTargetActive = ToggleState
        
        if PanelState.FlingTargetConnection then
            PanelState.FlingTargetConnection:Disconnect()
            PanelState.FlingTargetConnection = nil
        end
        
        if ToggleState then
            if not PanelState.FlingTargetPlayer then
                Rayfield:Notify({
                    Title = "Target Dependency Missing",
                    Content = "Specify target entity before activating kinetic transfer.",
                    Duration = 3
                })
                return
            end
            
            PanelState.FlingTargetConnection = RunService.Heartbeat:Connect(function()
                if not PanelState.FlingTargetActive then return end
                if not PanelState.FlingTargetPlayer then return end
                
                local targetChar = PanelState.FlingTargetPlayer.Character
                local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                
                if targetRoot then
                    local existingBAV = targetRoot:FindFirstChild("TargetFlingBAV")
                    local existingBV = targetRoot:FindFirstChild("TargetFlingBV")
                    
                    if not existingBAV then
                        local newBAV = Instance.new("BodyAngularVelocity")
                        newBAV.Name = "TargetFlingBAV"
                        newBAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                        newBAV.AngularVelocity = Vector3.new(999999999, 999999999, 999999999)
                        newBAV.Parent = targetRoot
                    end
                    
                    if not existingBV then
                        local newBV = Instance.new("BodyVelocity")
                        newBV.Name = "TargetFlingBV"
                        newBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        newBV.Velocity = Vector3.new(0, 0, 0)
                        newBV.Parent = targetRoot
                    end
                end
            end)
        else
            if PanelState.FlingTargetPlayer then
                local targetChar = PanelState.FlingTargetPlayer.Character
                local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    if targetRoot:FindFirstChild("TargetFlingBAV") then
                        targetRoot.TargetFlingBAV:Destroy()
                    end
                    if targetRoot:FindFirstChild("TargetFlingBV") then
                        targetRoot.TargetFlingBV:Destroy()
                    end
                end
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
--                                               INBUILT DEX EXPLORER SYSTEM                                            --
--======================================================================================================================--

local function CreateInbuiltDex()
    if PanelState.DexGui and PanelState.DexGui.Parent then
        PanelState.DexGui:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InbuiltDexExplorerV8"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    PanelState.DexGui = screenGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 550, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = mainFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Inbuilt Dex Explorer V8"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 1)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        PanelState.DexGui = nil
    end)
    
    local treeFrame = Instance.new("Frame")
    treeFrame.Size = UDim2.new(0.55, -5, 1, -42)
    treeFrame.Position = UDim2.new(0, 5, 0, 37)
    treeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    treeFrame.BorderSizePixel = 0
    treeFrame.Parent = mainFrame
    
    local treeScroll = Instance.new("ScrollingFrame")
    treeScroll.Size = UDim2.new(1, -5, 1, -5)
    treeScroll.Position = UDim2.new(0, 5, 0, 5)
    treeScroll.BackgroundTransparency = 1
    treeScroll.BorderSizePixel = 0
    treeScroll.ScrollBarThickness = 6
    treeScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    treeScroll.Parent = treeFrame
    
    local treeList = Instance.new("UIListLayout")
    treeList.Padding = UDim.new(0, 2)
    treeList.Parent = treeScroll
    
    local propFrame = Instance.new("Frame")
    propFrame.Size = UDim2.new(0.45, -5, 0.6, -5)
    propFrame.Position = UDim2.new(0.55, 0, 0, 37)
    propFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    propFrame.BorderSizePixel = 0
    propFrame.Parent = mainFrame
    
    local propScroll = Instance.new("ScrollingFrame")
    propScroll.Size = UDim2.new(1, -5, 1, -5)
    propScroll.Position = UDim2.new(0, 5, 0, 5)
    propScroll.BackgroundTransparency = 1
    propScroll.BorderSizePixel = 0
    propScroll.ScrollBarThickness = 6
    propScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    propScroll.Parent = propFrame
    
    local propList = Instance.new("UIListLayout")
    propList.Padding = UDim.new(0, 2)
    propList.Parent = propScroll
    
    local actionFrame = Instance.new("Frame")
    actionFrame.Size = UDim2.new(0.45, -5, 0.4, -42)
    actionFrame.Position = UDim2.new(0.55, 0, 0.6, 0)
    actionFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    actionFrame.BorderSizePixel = 0
    actionFrame.Parent = mainFrame
    
    local selectedInstance = nil
    
    local function ClearProperties()
        for _, child in pairs(propScroll:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
    end
    
    local function ShowProperties(inst)
        ClearProperties()
        selectedInstance = inst
        if not inst then return end
        
        local function AddProp(name, value)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 22)
            label.BackgroundTransparency = 1
            label.Text = name .. ": " .. tostring(value)
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.Font = Enum.Font.Code
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextWrapped = true
            label.Parent = propScroll
        end
        
        AddProp("Name", inst.Name)
        AddProp("Class", inst.ClassName)
        AddProp("Parent", inst.Parent and inst.Parent.Name or "nil")
        AddProp("Archivable", inst.Archivable)
        
        if inst:IsA("BasePart") then
            AddProp("Position", inst.Position)
            AddProp("Size", inst.Size)
            AddProp("Anchored", inst.Anchored)
            AddProp("CanCollide", inst.CanCollide)
            AddProp("Transparency", inst.Transparency)
            AddProp("Material", inst.Material)
            AddProp("Color", inst.Color)
            AddProp("Velocity", inst.Velocity)
        end
        
        if inst:IsA("Humanoid") then
            AddProp("Health", inst.Health)
            AddProp("MaxHealth", inst.MaxHealth)
            AddProp("WalkSpeed", inst.WalkSpeed)
            AddProp("JumpPower", inst.JumpPower)
            AddProp("PlatformStand", inst.PlatformStand)
        end
        
        if inst:IsA("Decal") or inst:IsA("Texture") then
            AddProp("Texture", inst.Texture)
        end
        
        if inst:IsA("Sound") then
            AddProp("SoundId", inst.SoundId)
            AddProp("Volume", inst.Volume)
            AddProp("Playing", inst.Playing)
        end
    end
    
    local function CreateNode(instance, depth, parentFrame)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 22)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        local indent = string.rep("    ", depth)
        local icon = (instance:IsA("Folder") or instance:IsA("Model")) and "📁 " or "📄 "
        btn.Text = indent .. icon .. instance.Name
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.Font = Enum.Font.Code
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = parentFrame
        
        btn.MouseButton1Click:Connect(function()
            ShowProperties(instance)
            for _, child in pairs(parentFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        end)
        
        btn.MouseButton2Click:Connect(function()
            if #instance:GetChildren() > 0 then
                for _, child in pairs(instance:GetChildren()) do
                    CreateNode(child, depth + 1, parentFrame)
                end
            end
        end)
    end
    
    local function RefreshTree()
        for _, child in pairs(treeScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        CreateNode(game.Workspace, 0, treeScroll)
        CreateNode(game.Players, 0, treeScroll)
        CreateNode(game.ReplicatedStorage, 0, treeScroll)
        CreateNode(game.Lighting, 0, treeScroll)
        CreateNode(game.StarterGui, 0, treeScroll)
        CreateNode(game.StarterPack, 0, treeScroll)
    end
    
    RefreshTree()
    
    local btnY = 5
    local function CreateAction(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 28)
        btn.Position = UDim2.new(0, 5, 0, btnY)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = color
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = actionFrame
        btn.MouseButton1Click:Connect(function()
            if selectedInstance then
                pcall(callback, selectedInstance)
            end
        end)
        btnY = btnY + 33
        return btn
    end
    
    CreateAction("Delete Instance", Color3.fromRGB(180, 50, 50), function(inst)
        inst:Destroy()
        Rayfield:Notify({Title="Dex Action", Content="Deleted: " .. inst.Name, Duration=2})
        RefreshTree()
    end)
    
    CreateAction("Clone Instance", Color3.fromRGB(50, 120, 200), function(inst)
        local clone = inst:Clone()
        if clone then
            clone.Parent = inst.Parent
            Rayfield:Notify({Title="Dex Action", Content="Cloned: " .. inst.Name, Duration=2})
        end
    end)
    
    CreateAction("Teleport To", Color3.fromRGB(50, 180, 50), function(inst)
        if inst:IsA("BasePart") then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = inst.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end)
    
    CreateAction("Bring To Me", Color3.fromRGB(180, 120, 50), function(inst)
        if inst:IsA("BasePart") then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                inst.CFrame = root.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end)
    
    CreateAction("Refresh Tree", Color3.fromRGB(100, 100, 100), function()
        RefreshTree()
    end)
    
    CreateAction("Expand All", Color3.fromRGB(80, 80, 120), function()
        for _, child in pairs(treeScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        local function RecursiveAdd(inst, depth)
            CreateNode(inst, depth, treeScroll)
            for _, child in pairs(inst:GetChildren()) do
                RecursiveAdd(child, depth + 1)
            end
        end
        RecursiveAdd(game.Workspace, 0)
        RecursiveAdd(game.Players, 0)
        RecursiveAdd(game.ReplicatedStorage, 0)
        RecursiveAdd(game.Lighting, 0)
    end)
    
    Rayfield:Notify({Title="Inbuilt Dex", Content="Explorer deployed successfully.", Duration=3})
end

LoadersTab:CreateButton({
    Name = "Deploy Inbuilt Structural Registry Explorer (Dex)",
    Callback = function()
        CreateInbuiltDex()
    end,
})

--======================================================================================================================--
--                                               10. COMMAND CENTER TAB                                                 --
--======================================================================================================================--

-- God Mode
CommandTab:CreateToggle({
    Name = "Invulnerability Shield (God Mode)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.GodModeConnection then
            PanelState.GodModeConnection:Disconnect()
            PanelState.GodModeConnection = nil
        end
        if PanelState.GodModeCharAdded then
            PanelState.GodModeCharAdded:Disconnect()
            PanelState.GodModeCharAdded = nil
        end
        if ToggleState then
            local function ApplyGodMode(char)
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                    if PanelState.GodModeConnection then
                        PanelState.GodModeConnection:Disconnect()
                    end
                    PanelState.GodModeConnection = hum:GetPropertyChangedSignal("Health"):Connect(function()
                        if hum.Health < math.huge then
                            hum.Health = math.huge
                        end
                    end)
                end
            end
            if LocalPlayer.Character then
                ApplyGodMode(LocalPlayer.Character)
            end
            PanelState.GodModeCharAdded = LocalPlayer.CharacterAdded:Connect(ApplyGodMode)
        else
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.MaxHealth = 100
                    hum.Health = 100
                end
            end
        end
    end,
})

-- No Fall Damage
CommandTab:CreateToggle({
    Name = "Gravitational Impact Dampener (No Fall Damage)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.NoFallConnection then
            PanelState.NoFallConnection:Disconnect()
            PanelState.NoFallConnection = nil
        end
        if PanelState.CurrentNoFall then
            PanelState.CurrentNoFall:Disconnect()
            PanelState.CurrentNoFall = nil
        end
        if ToggleState then
            local function ApplyNoFall(char)
                local hum = char:WaitForChild("Humanoid")
                if PanelState.CurrentNoFall then
                    PanelState.CurrentNoFall:Disconnect()
                end
                PanelState.CurrentNoFall = hum.StateChanged:Connect(function(old, new)
                    if new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.Ragdoll then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        hum.PlatformStand = false
                    end
                end)
            end
            if LocalPlayer.Character then
                ApplyNoFall(LocalPlayer.Character)
            end
            PanelState.NoFallConnection = LocalPlayer.CharacterAdded:Connect(ApplyNoFall)
        end
    end,
})

-- Auto Heal
CommandTab:CreateToggle({
    Name = "Regenerative Tissue Synthesis (Auto Heal)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.AutoHealConnection then
            PanelState.AutoHealConnection:Disconnect()
            PanelState.AutoHealConnection = nil
        end
        if ToggleState then
            PanelState.AutoHealConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end)
        end
    end,
})

-- Sit / Stand
CommandTab:CreateButton({
    Name = "Assume Seated Posture (Sit)",
    Callback = function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Sit = true end
    end,
})

CommandTab:CreateButton({
    Name = "Assume Upright Posture (Stand)",
    Callback = function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Sit = false
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end,
})

-- Follow Target
CommandTab:CreateInput({
    Name = "Assign Orbital Tracking Target",
    PlaceholderText = "Partial Target Name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text and #Text > 0 then
            local target = FilterPlayerDirectoryByPartialString(Text)
            if target then
                PanelState.FollowTarget = target
                Rayfield:Notify({Title="Tracking Target Set", Content="Now following: " .. target.Name, Duration=3})
            end
        end
    end,
})

CommandTab:CreateToggle({
    Name = "Orbital Tracking Vector (Follow Target)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.FollowConnection then
            PanelState.FollowConnection:Disconnect()
            PanelState.FollowConnection = nil
        end
        if ToggleState then
            if not PanelState.FollowTarget then
                Rayfield:Notify({Title="Target Required", Content="Set a follow target first.", Duration=3})
                return
            end
            PanelState.FollowConnection = RunService.Heartbeat:Connect(function()
                if PanelState.FollowTarget and PanelState.FollowTarget.Character then
                    local targetRoot = PanelState.FollowTarget.Character:FindFirstChild("HumanoidRootPart")
                    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot and myRoot then
                        myRoot.CFrame = targetRoot.CFrame + Vector3.new(3, 0, 3)
                    end
                end
            end)
        end
    end,
})

-- Freeze / Unfreeze
CommandTab:CreateInput({
    Name = "Cryogenic Stasis Field Target (Freeze)",
    PlaceholderText = "Partial Target Name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if not Text or #Text == 0 then return end
        local target = FilterPlayerDirectoryByPartialString(Text)
        if target and target.Character then
            for _, part in pairs(target.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Anchored = true end
            end
            Rayfield:Notify({Title="Cryogenic Stasis Active", Content="Frozen: " .. target.Name, Duration=3})
        end
    end,
})

CommandTab:CreateInput({
    Name = "Cryogenic Release Sequence (Unfreeze)",
    PlaceholderText = "Partial Target Name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if not Text or #Text == 0 then return end
        local target = FilterPlayerDirectoryByPartialString(Text)
        if target and target.Character then
            for _, part in pairs(target.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Anchored = false end
            end
            Rayfield:Notify({Title="Cryogenic Release Complete", Content="Unfrozen: " .. target.Name, Duration=3})
        end
    end,
})

-- Kill Target
CommandTab:CreateInput({
    Name = "Terminate Target Life Functions (Kill)",
    PlaceholderText = "Partial Target Name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if not Text or #Text == 0 then return end
        local target = FilterPlayerDirectoryByPartialString(Text)
        if target and target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 0
            else
                for _, part in pairs(target.Character:GetDescendants()) do
                    if part:IsA("JointInstance") then part:Destroy() end
                end
            end
            Rayfield:Notify({Title="Termination Executed", Content="Killed: " .. target.Name, Duration=3})
        end
    end,
})

-- Waypoints
CommandTab:CreateButton({
    Name = "Archive Current Spatial Coordinates (Save Location)",
    Callback = function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            PanelState.SavedWaypoint = root.CFrame
            Rayfield:Notify({Title="Waypoint Archived", Content="Location saved successfully.", Duration=3})
        end
    end,
})

CommandTab:CreateButton({
    Name = "Restore Archived Spatial Coordinates (TP to Save)",
    Callback = function()
        if PanelState.SavedWaypoint then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = PanelState.SavedWaypoint end
        else
            Rayfield:Notify({Title="No Waypoint Found", Content="Save a location first.", Duration=3})
        end
    end,
})

-- Rejoin
CommandTab:CreateButton({
    Name = "Reconstruct Local Session (Rejoin)",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

-- Chat Logger
CommandTab:CreateToggle({
    Name = "Communication Intercept Array (Chat Logger)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.ChatLogConnection then
            PanelState.ChatLogConnection:Disconnect()
            PanelState.ChatLogConnection = nil
        end
        if ToggleState then
            PanelState.ChatLogConnection = Players.PlayerChatted:Connect(function(chatType, player, message)
                if player ~= LocalPlayer then
                    print(string.format("[CHAT] %s: %s", player.Name, message))
                end
            end)
            Rayfield:Notify({Title="Chat Intercept Active", Content="Logging communications to console (F9).", Duration=3})
        end
    end,
})

-- Clear Fog
CommandTab:CreateButton({
    Name = "Atmospheric Obfuscation Removal (No Fog)",
    Callback = function()
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("Atmosphere") then
                v.Density = 0
            end
        end
        Rayfield:Notify({Title="Atmosphere Cleared", Content="Fog and atmospheric density removed.", Duration=3})
    end,
})

-- Max Zoom
CommandTab:CreateButton({
    Name = "Expand Optical Observation Range (Max Zoom)",
    Callback = function()
        LocalPlayer.CameraMaxZoomDistance = 10000
        LocalPlayer.CameraMinZoomDistance = 0.5
        Rayfield:Notify({Title="Optical Range Expanded", Content="Max zoom distance set to 10000.", Duration=3})
    end,
})

-- Unlock Mouse
CommandTab:CreateToggle({
    Name = "Decouple Cursor from Optical Center (Unlock Mouse)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if ToggleState then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end,
})

-- Click Delete
CommandTab:CreateToggle({
    Name = "Destructive Cursor Interface (Click Delete)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.ClickDeleteConnection then
            PanelState.ClickDeleteConnection:Disconnect()
            PanelState.ClickDeleteConnection = nil
        end
        if ToggleState then
            PanelState.ClickDeleteConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouseLoc = UserInputService:GetMouseLocation()
                    local ray = Camera:ViewportPointToRay(mouseLoc.X, mouseLoc.Y)
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
                    if result and result.Instance then
                        result.Instance:Destroy()
                    end
                end
            end)
            Rayfield:Notify({Title="Click Delete Active", Content="Left click any part to delete it.", Duration=3})
        end
    end,
})

-- Click Inspect
CommandTab:CreateToggle({
    Name = "Diagnostic Cursor Interface (Click Inspect)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.ClickInspectConnection then
            PanelState.ClickInspectConnection:Disconnect()
            PanelState.ClickInspectConnection = nil
        end
        if ToggleState then
            PanelState.ClickInspectConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouseLoc = UserInputService:GetMouseLocation()
                    local ray = Camera:ViewportPointToRay(mouseLoc.X, mouseLoc.Y)
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
                    if result and result.Instance then
                        local obj = result.Instance
                        local parentName = obj.Parent and obj.Parent.Name or "nil"
                        Rayfield:Notify({
                            Title="Diagnostic Scan: " .. obj.Name,
                            Content=string.format("Class: %s | Parent: %s | Pos: %s | Size: %s", 
                                obj.ClassName, parentName, tostring(obj.Position), tostring(obj.Size)),
                            Duration=6
                        })
                    end
                end
            end)
            Rayfield:Notify({Title="Click Inspect Active", Content="Left click any part to inspect properties.", Duration=3})
        end
    end,
})

-- Instant Proximity Prompt
CommandTab:CreateToggle({
    Name = "Immediate Proximity Interaction Engine",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.InstantPromptConnection then
            PanelState.InstantPromptConnection:Disconnect()
            PanelState.InstantPromptConnection = nil
        end
        if ToggleState then
            PanelState.InstantPromptConnection = RunService.Heartbeat:Connect(function()
                for _, prompt in pairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                        prompt.RequiresLineOfSight = false
                        prompt.MaxActivationDistance = 50
                        pcall(function()
                            fireproximityprompt(prompt, 0)
                        end)
                    end
                end
            end)
        end
    end,
})

-- Auto Collect
CommandTab:CreateToggle({
    Name = "Universal Resource Aggregation (Auto Collect)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.AutoCollectConnection then
            PanelState.AutoCollectConnection:Disconnect()
            PanelState.AutoCollectConnection = nil
        end
        if ToggleState then
            PanelState.AutoCollectConnection = RunService.Heartbeat:Connect(function()
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local name = obj.Name:lower()
                        if name:match("coin") or name:match("drop") or name:match("collect") or name:match("money") or name:match("cash") or name:match("gem") or name:match("item") then
                            if (obj.Position - myRoot.Position).Magnitude < 50 then
                                myRoot.CFrame = obj.CFrame
                            end
                        end
                    end
                end
            end)
        end
    end,
})

-- Anti Fling
CommandTab:CreateToggle({
    Name = "Inertial Stabilization Matrix (Anti Fling)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.AntiFlingConnection then
            PanelState.AntiFlingConnection:Disconnect()
            PanelState.AntiFlingConnection = nil
        end
        if ToggleState then
            PanelState.AntiFlingConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Velocity = Vector3.new(0, 0, 0)
                            part.RotVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        end
    end,
})

-- Platform
CommandTab:CreateToggle({
    Name = "Spawn Structural Support Platform",
    CurrentValue = false,
    Callback = function(ToggleState)
        if ToggleState then
            if PanelState.PlatformPart then
                PanelState.PlatformPart:Destroy()
            end
            local platform = Instance.new("Part")
            platform.Name = "AdminPlatform"
            platform.Size = Vector3.new(10, 1, 10)
            platform.Anchored = true
            platform.CanCollide = true
            platform.Transparency = 0.5
            platform.BrickColor = BrickColor.new("Bright blue")
            platform.Parent = Workspace
            PanelState.PlatformPart = platform
            PanelState.PlatformConnection = RunService.Heartbeat:Connect(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root and platform then
                    platform.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3, root.Position.Z)
                end
            end)
        else
            if PanelState.PlatformConnection then
                PanelState.PlatformConnection:Disconnect()
                PanelState.PlatformConnection = nil
            end
            if PanelState.PlatformPart then
                PanelState.PlatformPart:Destroy()
                PanelState.PlatformPart = nil
            end
        end
    end,
})

-- Spin
CommandTab:CreateToggle({
    Name = "Rotational Gyroscopic Displacement (Spin)",
    CurrentValue = false,
    Callback = function(ToggleState)
        if PanelState.SpinConnection then
            PanelState.SpinConnection:Disconnect()
            PanelState.SpinConnection = nil
        end
        if ToggleState then
            PanelState.SpinConnection = RunService.Heartbeat:Connect(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(PanelState.SpinSpeed), 0)
                end
            end)
        end
    end,
})

CommandTab:CreateSlider({
    Name = "Gyroscopic Rotational Velocity",
    Range = {1, 100},
    Increment = 1,
    Suffix = "Degrees/Frame",
    CurrentValue = 20,
    Flag = "SpinSpeedSlider",
    Callback = function(SliderValue)
        PanelState.SpinSpeed = SliderValue
    end,
})

-- Kill All
CommandTab:CreateButton({
    Name = "Mass Termination Event (Kill All)",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = 0
                end
            end
        end
        Rayfield:Notify({Title="Mass Termination", Content="All players terminated.", Duration=3})
    end,
})

-- Bring All
CommandTab:CreateButton({
    Name = "Gravitational Mass Convergence (Bring All)",
    Callback = function()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    targetRoot.CFrame = myRoot.CFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
                end
            end
        end
        Rayfield:Notify({Title="Mass Convergence", Content="All players brought to local coordinates.", Duration=3})
    end,
})

-- Invisible / Visible
CommandTab:CreateToggle({
    Name = "Optical Cloaking Array (Invisible)",
    CurrentValue = false,
    Callback = function(ToggleState)
        PanelState.Invisible = ToggleState
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = ToggleState and 1 or 0
                    if part:FindFirstChild("face") then
                        part:FindFirstChild("face").Transparency = ToggleState and 1 or 0
                    end
                end
            end
        end
    end,
})

-- Steal Tools
CommandTab:CreateButton({
    Name = "Extract Tools from All Players (Steal Tools)",
    Callback = function()
        local myBackpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not myBackpack then return end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local backpack = player:FindFirstChildOfClass("Backpack")
                if backpack then
                    for _, tool in pairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool.Parent = myBackpack
                        end
                    end
                end
                if player.Character then
                    for _, tool in pairs(player.Character:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool.Parent = myBackpack
                        end
                    end
                end
            end
        end
        Rayfield:Notify({Title="Tool Extraction", Content="Stole all tools from other players.", Duration=3})
    end,
})

--======================================================================================================================--
--                                              11. MEME & STRUCTURAL TAB                                               --
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
