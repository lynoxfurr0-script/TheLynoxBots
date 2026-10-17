--Find Lua scripts online and paste them here!
print("Hello world!")--[[
    TheLynoxBot Admin Panel (v4 - interface par catégories)
    LocalScript à placer dans StarterPlayerScripts ou StarterGui
    Touche RightShift = afficher / masquer le panel
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ===== THÈME =====
local BG_COLOR = Color3.fromRGB(30, 30, 46)
local HEADER_COLOR = Color3.fromRGB(24, 24, 38)
local SIDEBAR_COLOR = Color3.fromRGB(26, 26, 40)
local CARD_COLOR = Color3.fromRGB(42, 42, 62)
local ACCENT_COLOR = Color3.fromRGB(139, 92, 246)
local ACCENT_ON = Color3.fromRGB(34, 211, 238)
local TEXT_COLOR = Color3.fromRGB(235, 235, 245)
local SUBTEXT_COLOR = Color3.fromRGB(170, 170, 190)

local flyAlertGui = nil
local flyAlertSerial = 0
local currentOptionToast = nil
local suppressOptionAlert = false

-- Notification globale en bas à droite, assortie au thème violet/cyan.
-- Le trait inférieur se vide pendant 5 secondes avant la disparition.
local function showOptionAlert(optionName, stateText)
    local playerGui = player:WaitForChild("PlayerGui")

    if not flyAlertGui or not flyAlertGui.Parent then
        flyAlertGui = Instance.new("ScreenGui")
        flyAlertGui.Name = "TheLynoxOptionAlerts"
        flyAlertGui.ResetOnSpawn = false
        flyAlertGui.IgnoreGuiInset = true
        flyAlertGui.DisplayOrder = 10000
        flyAlertGui.Parent = playerGui
    end

    flyAlertSerial += 1
    local thisAlert = flyAlertSerial
    if currentOptionToast and currentOptionToast.Parent then
        currentOptionToast:Destroy()
    end

    local toast = Instance.new("Frame")
    currentOptionToast = toast
    toast.Name = "OptionNotification"
    toast.AnchorPoint = Vector2.new(1, 1)
    toast.Position = UDim2.new(1, 300, 1, -22)
    toast.Size = UDim2.fromOffset(290, 58)
    toast.BackgroundColor3 = BG_COLOR
    toast.BackgroundTransparency = 0.05
    toast.BorderSizePixel = 0
    toast.Parent = flyAlertGui

    local toastCorner = Instance.new("UICorner")
    toastCorner.CornerRadius = UDim.new(0, 10)
    toastCorner.Parent = toast

    local toastStroke = Instance.new("UIStroke")
    toastStroke.Color = ACCENT_COLOR
    toastStroke.Thickness = 1.5
    toastStroke.Transparency = 0.1
    toastStroke.Parent = toast

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, -18)
    accentBar.Position = UDim2.new(0, 7, 0, 7)
    accentBar.BackgroundColor3 = (stateText == "ON") and ACCENT_ON or ACCENT_COLOR
    accentBar.BorderSizePixel = 0
    accentBar.Parent = toast
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = accentBar

    local message = Instance.new("TextLabel")
    message.BackgroundTransparency = 1
    message.Position = UDim2.new(0, 20, 0, 2)
    message.Size = UDim2.new(1, -28, 1, -14)
    message.Font = Enum.Font.GothamBold
    message.Text = stateText and (optionName .. "  •  " .. stateText) or optionName
    message.TextColor3 = (stateText == "ON") and ACCENT_ON or TEXT_COLOR
    message.TextSize = 13
    message.TextWrapped = true
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.Parent = toast

    local progressTrack = Instance.new("Frame")
    progressTrack.Name = "ProgressTrack"
    progressTrack.AnchorPoint = Vector2.new(0, 1)
    progressTrack.Position = UDim2.new(0, 12, 1, -6)
    progressTrack.Size = UDim2.new(1, -24, 0, 3)
    progressTrack.BackgroundColor3 = HEADER_COLOR
    progressTrack.BorderSizePixel = 0
    progressTrack.ClipsDescendants = true
    progressTrack.Parent = toast
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = progressTrack

    local progress = Instance.new("Frame")
    progress.Size = UDim2.new(1, 0, 1, 0)
    progress.BackgroundColor3 = ACCENT_ON
    progress.BorderSizePixel = 0
    progress.Parent = progressTrack
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(1, 0)
    progressCorner.Parent = progress

    TweenService:Create(toast, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -18, 1, -22)
    }):Play()
    TweenService:Create(progress, TweenInfo.new(5, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()

    task.delay(5, function()
        if thisAlert ~= flyAlertSerial or not toast.Parent then return end
        TweenService:Create(toast, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 300, 1, -22),
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(message, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(accentBar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(progressTrack, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(progress, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(toastStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        task.delay(0.24, function()
            if toast.Parent then toast:Destroy() end
            if currentOptionToast == toast then currentOptionToast = nil end
        end)
    end)
end

-- ===== ÉTAT =====
local flying = false
local flySpeed = 50
local walkSpeed = 16
local gravityValue = workspace.Gravity
local infiniteJumpEnabled = false
local floatEnabled = false
local floatAirborne = false
local floatHolding = false
local floatHeight = nil
local freeCamEnabled = false
local espEnabled = false
local antiAfkEnabled = false
local noclipEnabled = false
local checkpointData = {
    points = {},
    activeName = nil,
    activeCFrame = nil,
    refresh = nil,
    jumpPower = 50,
}
local fullbrightEnabled = false
local vehicleFlyEnabled = false
local vehicleFlySpeed = 60
local crawlEnabled = false
local autoMessageEnabled = false
local ceilingWalkEnabled = false
local ceilingWalkOffset = 3
local sitEnabled = false
local ceilingWasAnchored = false
local sessionStartClock = os.clock() -- début de la session (pour le chrono du temps passé dans le jeu)
local lastFireAttempt = 0
local FIRE_COOLDOWN_CLIENT = 4 -- juste pour l'affichage du bouton ; le vrai cooldown est côté serveur
local activeEmoteTrack = nil
local activeEmoteButton = nil
local shotsHit = 0
local totalDamageDealt = 0
local statsLabel -- assigné plus bas dans l'interface

local bodyVelocity, flyConnection, jumpConnection, floatConnection, floatJumpConnection, freeCamConnection
local floatAttachment, floatForce
local floatFreefallEnabled = true
local flyGyro
local vehicleBodyVelocity, vehicleFlyConnection, vehicleSeatConnection
local crawlConnection, noclipConnection
local ceilingWalkConnection
local pressedKeys = {}
local espTags = {}

-- ===== VISUEL : CHEAT LINES + TRACKER =====
local cheatLinesEnabled = false
local trackerEnabled = false
local visualOverlayGui = nil
local cheatLineObjects = {}
local trackerHighlights = {}
local trackerTags = {}

function getVisualOverlay()
    if visualOverlayGui and visualOverlayGui.Parent then
        return visualOverlayGui
    end

    local playerGui = player:WaitForChild("PlayerGui")
    visualOverlayGui = Instance.new("ScreenGui")
    visualOverlayGui.Name = "LynoxVisualOverlay"
    visualOverlayGui.ResetOnSpawn = false
    visualOverlayGui.IgnoreGuiInset = true
    visualOverlayGui.DisplayOrder = 1000
    visualOverlayGui.Parent = playerGui
    return visualOverlayGui
end

function removeCheatLine(otherPlayer)
    local line = cheatLineObjects[otherPlayer]
    if line then
        line:Destroy()
        cheatLineObjects[otherPlayer] = nil
    end
end

function createCheatLine(otherPlayer)
    if otherPlayer == player then return end
    if cheatLineObjects[otherPlayer] and cheatLineObjects[otherPlayer].Parent then return cheatLineObjects[otherPlayer] end

    local line = Instance.new("Frame")
    line.Name = "CheatLine_" .. otherPlayer.Name
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = ACCENT_ON
    line.BorderSizePixel = 0
    line.Size = UDim2.fromOffset(2, 10)
    line.ZIndex = 20
    line.Parent = getVisualOverlay()

    local lineCorner = Instance.new("UICorner")
    lineCorner.CornerRadius = UDim.new(1, 0)
    lineCorner.Parent = line

    cheatLineObjects[otherPlayer] = line
    return line
end

function updateCheatLine(otherPlayer, line)
    local character = otherPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    if not root or not camera then
        line.Visible = false
        return
    end

    local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
    if not onScreen or screenPos.Z <= 0 then
        line.Visible = false
        return
    end

    local viewport = camera.ViewportSize
    local startPoint = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
    local endPoint = Vector2.new(screenPos.X, screenPos.Y)
    local delta = endPoint - startPoint
    local length = delta.Magnitude

    if length < 2 then
        line.Visible = false
        return
    end

    line.Visible = true
    line.Position = UDim2.fromOffset((startPoint.X + endPoint.X) * 0.5, (startPoint.Y + endPoint.Y) * 0.5)
    line.Size = UDim2.fromOffset(2, length)
    line.Rotation = math.deg(math.atan2(delta.Y, delta.X)) + 90
end

function clearCheatLines()
    for otherPlayer in pairs(cheatLineObjects) do
        removeCheatLine(otherPlayer)
    end
end

function enableCheatLines()
    cheatLinesEnabled = true
    getVisualOverlay()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            createCheatLine(otherPlayer)
        end
    end
end

function disableCheatLines()
    cheatLinesEnabled = false
    clearCheatLines()
end

function toggleCheatLines(setActive)
    if cheatLinesEnabled then disableCheatLines() else enableCheatLines() end
    setActive(cheatLinesEnabled)
end

function removeTracker(otherPlayer)
    local highlight = trackerHighlights[otherPlayer]
    if highlight then
        highlight:Destroy()
        trackerHighlights[otherPlayer] = nil
    end

    local tag = trackerTags[otherPlayer]
    if tag then
        tag:Destroy()
        trackerTags[otherPlayer] = nil
    end
end

function createTracker(otherPlayer)
    if otherPlayer == player then return end
    local character = otherPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local head = character and character:FindFirstChild("Head")
    if not character or not root or not head then return end

    removeTracker(otherPlayer)

    local highlight = Instance.new("Highlight")
    highlight.Name = "LynoxTracker"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255, 70, 70)
    highlight.FillTransparency = 0.82
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    trackerHighlights[otherPlayer] = highlight

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "LynoxTrackerTag"
    billboard.Adornee = head
    billboard.Size = UDim2.fromOffset(150, 34)
    billboard.StudsOffset = Vector3.new(0, 3.1, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = "TRACKER  •  " .. otherPlayer.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.15
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Parent = billboard

    trackerTags[otherPlayer] = billboard
end

function enableTracker()
    trackerEnabled = true
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then createTracker(otherPlayer) end
    end
end

function disableTracker()
    trackerEnabled = false
    for otherPlayer in pairs(trackerHighlights) do
        removeTracker(otherPlayer)
    end
    for otherPlayer in pairs(trackerTags) do
        removeTracker(otherPlayer)
    end
end

function toggleTracker(setActive)
    if trackerEnabled then disableTracker() else enableTracker() end
    setActive(trackerEnabled)
end

local clickTeleportEnabled = false
local clickTeleportConnection = nil

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Space peut être intercepté par le saut Roblox lorsque le joueur
    -- est assis dans un VehicleSeat. On l'enregistre quand même pour le fly.
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local inVehicle = humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat")

    if gameProcessed and not (inVehicle and (
        input.KeyCode == Enum.KeyCode.Space or
        input.KeyCode == Enum.KeyCode.LeftShift or
        input.KeyCode == Enum.KeyCode.RightShift or
        input.KeyCode == Enum.KeyCode.E or
        input.KeyCode == Enum.KeyCode.Q
    )) then
        return
    end

    pressedKeys[input.KeyCode] = true

    -- T active/désactive le mode « tomber dans le vide ».
    if input.KeyCode == Enum.KeyCode.T and not gameProcessed then
        crawlEnabled = not crawlEnabled
        if crawlEnabled then
            startCrawl()
        else
            stopCrawl()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    pressedKeys[input.KeyCode] = false
end)

function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

function getMoveDirection()
    local dir = Vector3.new(0, 0, 0)
    local cf = camera.CFrame
    if pressedKeys[Enum.KeyCode.W] then dir += cf.LookVector end
    if pressedKeys[Enum.KeyCode.S] then dir -= cf.LookVector end
    if pressedKeys[Enum.KeyCode.A] then dir -= cf.RightVector end
    if pressedKeys[Enum.KeyCode.D] then dir += cf.RightVector end
    if pressedKeys[Enum.KeyCode.Space] then dir += Vector3.new(0, 1, 0) end
    if pressedKeys[Enum.KeyCode.LeftShift] then dir -= Vector3.new(0, 1, 0) end
    return dir
end

-- =====================================================================
-- ============================  FONCTIONS  ============================
-- =====================================================================

-- ===== FLY =====
function startFly(character)
    character = character or getCharacter()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Empêche le personnage de faire des pirouettes/roulades pendant le vol.
    -- Le BodyGyro maintient une orientation stable et garde le personnage droit.
    if flyGyro then
        flyGyro:Destroy()
        flyGyro = nil
    end

    humanoid.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    flyGyro = Instance.new("BodyGyro")
    flyGyro.Name = "TheLynoxFlyGyro"
    flyGyro.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
    flyGyro.P = 50000
    flyGyro.D = 1000

    -- Le personnage reste droit, mais suit maintenant la rotation horizontale de la caméra.
    flyGyro.Parent = rootPart

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying or not bodyVelocity then return end

        local dir = getMoveDirection()
        bodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.new(0, 0, 0)

        -- Fais regarder le personnage dans la même direction horizontale que la caméra.
        if flyGyro and flyGyro.Parent then
            local camera = workspace.CurrentCamera
            if camera then
                local look = camera.CFrame.LookVector
                local flatLook = Vector3.new(look.X, 0, look.Z)

                if flatLook.Magnitude > 0.001 then
                    flyGyro.CFrame = CFrame.lookAt(
                        rootPart.Position,
                        rootPart.Position + flatLook.Unit,
                        Vector3.new(0, 1, 0)
                    )
                end
            end
        end
    end)
end

function stopFly()
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
end

function toggleFly(setActive)
    flying = not flying
    if flying then
        startFly()
    else
        stopFly()
    end
    setActive(flying)
end

-- ===== VEHICLE FLY (STABILISÉ / ORIENTATION CORRIGÉE) =====
-- Le véhicule reste toujours à l'endroit et suit le sens horizontal de la caméra.
-- WASD = déplacement, Espace = monter, Shift = descendre.
function getVehiclePart(seat)
    if not seat or not seat:IsA("BasePart") then
        return nil
    end

    local root = seat.AssemblyRootPart
    if root and root:IsA("BasePart") then
        return root
    end

    local model = seat:FindFirstAncestorOfClass("Model")
    if model and model.PrimaryPart then
        return model.PrimaryPart
    end

    return seat
end

function startVehicleFly()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local seat = humanoid.SeatPart
    if not seat or not seat:IsA("VehicleSeat") then return end

    local root = getVehiclePart(seat)
    if not root then return end

    if vehicleFlyConnection then
        vehicleFlyConnection:Disconnect()
        vehicleFlyConnection = nil
    end

    vehicleBodyVelocity = root

    -- On mémorise une direction horizontale stable pour éviter les rotations folles.
    local currentYaw = math.atan2(-root.CFrame.LookVector.X, -root.CFrame.LookVector.Z)

    vehicleFlyConnection = RunService.RenderStepped:Connect(function(dt)
        if not vehicleFlyEnabled then return end

        local currentCharacter = player.Character
        local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
        local currentSeat = currentHumanoid and currentHumanoid.SeatPart

        if not currentSeat or not currentSeat:IsA("VehicleSeat") then
            stopVehicleFly()
            return
        end

        local currentRoot = getVehiclePart(currentSeat)
        if not currentRoot or not currentRoot.Parent then
            stopVehicleFly()
            return
        end

        root = currentRoot
        vehicleBodyVelocity = currentRoot

        local cf = camera.CFrame

        -- Le véhicule suit maintenant l'inclinaison verticale de la caméra.
        -- Donc W + caméra vers le haut = montée, W + caméra vers le bas = descente.
        local cameraForward = cf.LookVector
        local cameraRight = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z)

        if cameraForward.Magnitude > 0.001 then
            cameraForward = cameraForward.Unit
        end
        if cameraRight.Magnitude > 0.001 then
            cameraRight = cameraRight.Unit
        end

        local moveDir = Vector3.new(0, 0, 0)

        if pressedKeys[Enum.KeyCode.W] then moveDir += cameraForward end
        if pressedKeys[Enum.KeyCode.S] then moveDir -= cameraForward end
        if pressedKeys[Enum.KeyCode.A] then moveDir += Vector3.new(-cameraRight.X, 0, -cameraRight.Z) end
        if pressedKeys[Enum.KeyCode.D] then moveDir += cameraRight end

        -- Space / Shift restent disponibles pour monter / descendre directement.
        -- E = monter, Q = descendre.
        local vertical = 0
        if pressedKeys[Enum.KeyCode.Space] or pressedKeys[Enum.KeyCode.E] then
            vertical += 1
        end
        if pressedKeys[Enum.KeyCode.LeftShift] or pressedKeys[Enum.KeyCode.RightShift] or pressedKeys[Enum.KeyCode.Q] then
            vertical -= 1
        end

        if moveDir.Magnitude > 0.001 then
            moveDir = moveDir.Unit

            -- Le véhicule tourne progressivement vers la direction de déplacement.
            currentYaw = math.atan2(-moveDir.X, -moveDir.Z)
        end

        -- Vitesse de vol.
        local velocity = moveDir * vehicleFlySpeed
        velocity += Vector3.new(0, vertical * vehicleFlySpeed, 0)
        currentRoot.AssemblyLinearVelocity = velocity

        -- Stabilisation : aucune inclinaison avant/arrière ou gauche/droite.
        -- Le véhicule peut tourner sur son axe Y, mais ne peut plus se retrouver à l'envers.
        local targetCFrame =
            CFrame.new(currentRoot.Position) *
            CFrame.Angles(0, currentYaw, 0)

        currentRoot.CFrame = currentRoot.CFrame:Lerp(
            targetCFrame,
            math.clamp(dt * 10, 0, 1)
        )

        currentRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)
end

function stopVehicleFly()
    if vehicleFlyConnection then
        vehicleFlyConnection:Disconnect()
        vehicleFlyConnection = nil
    end

    if vehicleBodyVelocity and vehicleBodyVelocity:IsA("BasePart") then
        vehicleBodyVelocity.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        vehicleBodyVelocity.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end

    vehicleBodyVelocity = nil
end

function watchVehicleSeat(character)
    local humanoid = character:WaitForChild("Humanoid")

    if vehicleSeatConnection then
        vehicleSeatConnection:Disconnect()
        vehicleSeatConnection = nil
    end

    vehicleSeatConnection = humanoid.Seated:Connect(function(active, seatPart)
        if not vehicleFlyEnabled then
            stopVehicleFly()
            return
        end

        if active and seatPart and seatPart:IsA("VehicleSeat") then
            task.defer(startVehicleFly)
        else
            stopVehicleFly()
        end
    end)
end

function toggleVehicleFly(setActive)
    vehicleFlyEnabled = not vehicleFlyEnabled

    if vehicleFlyEnabled then
        startVehicleFly()
    else
        stopVehicleFly()
    end

    setActive(vehicleFlyEnabled)
end

-- ===== RAMPER =====
function startCrawl()
    local character = getCharacter()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.AutoRotate = false

    crawlConnection = RunService.Heartbeat:Connect(function()
        if not crawlEnabled then return end
        local char = player.Character
        if not char then return end
        local rp = char:FindFirstChild("HumanoidRootPart")
        if not rp then return end

        local vel = rp.AssemblyLinearVelocity
        local _, yRot, _ = rp.CFrame:ToEulerAnglesYXZ()
        local lowerPos = rp.Position - Vector3.new(0, 2, 0)

        rp.CFrame = CFrame.new(lowerPos) * CFrame.Angles(math.rad(-90), yRot, 0)
        rp.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
    end)
end

function stopCrawl()
    if crawlConnection then crawlConnection:Disconnect(); crawlConnection = nil end
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.AutoRotate = true end
        local rp = character:FindFirstChild("HumanoidRootPart")
        if rp then
            local _, yRot, _ = rp.CFrame:ToEulerAnglesYXZ()
            rp.CFrame = CFrame.new(rp.Position + Vector3.new(0, 2, 0)) * CFrame.Angles(0, yRot, 0)
        end
    end
end

function toggleCrawl(setActive)
    crawlEnabled = not crawlEnabled
    if crawlEnabled then startCrawl() else stopCrawl() end
    setActive(crawlEnabled)
end

-- ===== MARCHER AU PLAFOND =====
-- Colle le personnage au plafond (tête en bas) et le laisse se déplacer avec WASD.
-- Le Humanoid perd son autopilote (PlatformStand) car il ne comprend plus "en haut/en bas"
-- une fois retourné, donc on gère nous-même le déplacement horizontal.
function getFlatMoveDirection()
    local camCF = camera.CFrame
    local flatLook = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
    if flatLook.Magnitude > 0 then flatLook = flatLook.Unit end
    local flatRight = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z)
    if flatRight.Magnitude > 0 then flatRight = flatRight.Unit end

    local dir = Vector3.new(0, 0, 0)
    if pressedKeys[Enum.KeyCode.W] then dir += flatLook end
    if pressedKeys[Enum.KeyCode.S] then dir -= flatLook end
    if pressedKeys[Enum.KeyCode.A] then dir -= flatRight end
    if pressedKeys[Enum.KeyCode.D] then dir += flatRight end
    return dir
end

function getSurfaceY(character, origin, direction, fallbackY)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, direction, rayParams)
    return result and result.Position.Y or fallbackY
end

function startCeilingWalk()
    local character = getCharacter()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Le mode plafond ne doit pas se battre avec une animation assise.
    sitEnabled = false
    humanoid.Sit = false
    humanoid.AutoRotate = false
    humanoid.PlatformStand = true
    ceilingWasAnchored = rootPart.Anchored
    rootPart.Anchored = true

    -- Laisse la caméra Roblox gérer la souris normalement : aucun CFrame caméra forcé ici.

    if ceilingWalkConnection then
        ceilingWalkConnection:Disconnect()
        ceilingWalkConnection = nil
    end

    ceilingWalkConnection = RunService.Heartbeat:Connect(function(dt)
        if not ceilingWalkEnabled then return end
        local char = player.Character
        if not char or not char.Parent then return end
        local rp = char:FindFirstChild("HumanoidRootPart")
        if not rp then return end

        local moveDir = getFlatMoveDirection()
        local currentPos = rp.Position
        local newX, newZ = currentPos.X, currentPos.Z

        -- Le corps suit l'orientation horizontale de la caméra, même à l'arrêt.
        local camLook = camera.CFrame.LookVector
        local flatLook = Vector3.new(camLook.X, 0, camLook.Z)
        local yRot = nil
        if flatLook.Magnitude > 0.001 then
            flatLook = flatLook.Unit
            yRot = math.atan2(-flatLook.X, -flatLook.Z)
        else
            local _, currentYRot, _ = rp.CFrame:ToEulerAnglesYXZ()
            yRot = currentYRot
        end

        if moveDir.Magnitude > 0.05 then
            moveDir = moveDir.Unit
            newX += moveDir.X * walkSpeed * math.min(dt, 1 / 30)
            newZ += moveDir.Z * walkSpeed * math.min(dt, 1 / 30)
        end

        -- Suit le plafond à chaque frame et tourne avec la caméra sans bloquer la souris.
        local rayOrigin = Vector3.new(newX, currentPos.Y + 2, newZ)
        local ceilingY = getSurfaceY(char, rayOrigin, Vector3.new(0, 100, 0), currentPos.Y + ceilingWalkOffset)
        local targetPos = Vector3.new(newX, ceilingY - ceilingWalkOffset, newZ)
        rp.CFrame = CFrame.new(targetPos) * CFrame.Angles(math.rad(180), yRot, 0)

        -- Empêche l'accumulation de vitesse physique, sans déplacer le personnage à l'arrêt.
        rp.AssemblyLinearVelocity = Vector3.zero
        rp.AssemblyAngularVelocity = Vector3.zero
    end)
end

function stopCeilingWalk()
    if ceilingWalkConnection then
        ceilingWalkConnection:Disconnect()
        ceilingWalkConnection = nil
    end
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        local rp = character:FindFirstChild("HumanoidRootPart")
        if rp then
            rp.Anchored = ceilingWasAnchored
            local _, yRot, _ = rp.CFrame:ToEulerAnglesYXZ()
            local rayOrigin = Vector3.new(rp.Position.X, rp.Position.Y + 5, rp.Position.Z)
            local groundY = getSurfaceY(character, rayOrigin, Vector3.new(0, -100, 0), rp.Position.Y - ceilingWalkOffset)
            rp.CFrame = CFrame.new(rp.Position.X, groundY + 3, rp.Position.Z) * CFrame.Angles(0, yRot, 0)
            rp.AssemblyLinearVelocity = Vector3.zero
            rp.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

function toggleSit(setActive)
    sitEnabled = not sitEnabled
    local character = getCharacter()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if sitEnabled then
        if ceilingWalkEnabled then
            ceilingWalkEnabled = false
            stopCeilingWalk()
        end
        if activeEmoteTrack then
            activeEmoteTrack:Stop()
            activeEmoteTrack = nil
            activeEmoteButton = nil
        end
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.AutoRotate = true
            humanoid.Sit = true
            humanoid:ChangeState(Enum.HumanoidStateType.Seated)
        end
    elseif humanoid then
        humanoid.Sit = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    setActive(sitEnabled)
end

function toggleCeilingWalk(setActive)
    ceilingWalkEnabled = not ceilingWalkEnabled
    if ceilingWalkEnabled then startCeilingWalk() else stopCeilingWalk() end
    setActive(ceilingWalkEnabled)
end

-- ===== MARCHER SUR LE CÔTÉ (MAIN GAUCHE + TORSE GAUCHE + JAMBE GAUCHE) =====
-- Garde le corps couché sur le côté gauche, tout en laissant le Humanoid sauter.
-- La caméra est redressée après la caméra Roblox pour éviter qu'elle parte de travers.
local sideWalkEnabled = false
local sideWalkConnection = nil
local sideWalkTrack = nil
local sideWalkYaw = 0
local SIDE_WALK_ROLL = math.rad(-90)
local SIDE_WALK_HEIGHT = 1.4
local SIDE_WALK_ANIM_R15 = 507777826
local SIDE_WALK_ANIM_R6 = 180426354
local SIDE_WALK_CAMERA_BIND = "LynGUI_SideWalkCameraUpright"

function startSideWalk()
    local character = getCharacter()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    humanoid.AutoRotate = false
    humanoid.PlatformStand = false
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

    local _, startYaw, _ = rootPart.CFrame:ToEulerAnglesYXZ()
    sideWalkYaw = startYaw

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. tostring(
        humanoid.RigType == Enum.HumanoidRigType.R15 and SIDE_WALK_ANIM_R15 or SIDE_WALK_ANIM_R6
    )
    local ok, track = pcall(function()
        return humanoid:LoadAnimation(animation)
    end)
    if ok and track then
        track.Priority = Enum.AnimationPriority.Action
        track.Looped = true
        sideWalkTrack = track
    end

    -- Corrige uniquement le roulis de la caméra ; sa rotation à la souris reste libre.
    RunService:UnbindFromRenderStep(SIDE_WALK_CAMERA_BIND)
    RunService:BindToRenderStep(SIDE_WALK_CAMERA_BIND, Enum.RenderPriority.Camera.Value + 1, function()
        if not sideWalkEnabled then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local look = cam.CFrame.LookVector
        if look.Magnitude > 0.001 then
            cam.CFrame = CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position + look, Vector3.yAxis)
        end
    end)

    sideWalkConnection = RunService.Heartbeat:Connect(function(dt)
        if not sideWalkEnabled then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local rp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not rp then return end

        local moveDir = getFlatMoveDirection()
        local moving = moveDir.Magnitude > 0.05
        local newX, newZ = rp.Position.X, rp.Position.Z
        if moving then
            moveDir = moveDir.Unit
            newX += moveDir.X * walkSpeed * dt
            newZ += moveDir.Z * walkSpeed * dt
            sideWalkYaw = math.atan2(-moveDir.X, -moveDir.Z)
        end

        local velocity = rp.AssemblyLinearVelocity
        local rayOrigin = Vector3.new(newX, rp.Position.Y + 3, newZ)
        local groundY = getSurfaceY(char, rayOrigin, Vector3.new(0, -100, 0), rp.Position.Y - SIDE_WALK_HEIGHT)
        local grounded = hum.FloorMaterial ~= Enum.Material.Air
        local targetY = rp.Position.Y

        -- Au sol, garde la hauteur correcte. En saut/chute, laisse la physique gérer l'axe Y.
        if grounded and velocity.Y <= 1 then
            targetY = groundY + SIDE_WALK_HEIGHT
        end

        local targetPos = Vector3.new(newX, targetY, newZ)
        rp.CFrame = CFrame.new(targetPos)
            * CFrame.Angles(0, sideWalkYaw, 0)
            * CFrame.Angles(math.rad(-90), 0, 0)
            * CFrame.Angles(0, SIDE_WALK_ROLL, 0)

        -- Déplacement latéral contrôlé, sans annuler la vitesse verticale du saut.
        rp.AssemblyLinearVelocity = Vector3.new(moveDir.X * walkSpeed, velocity.Y, moveDir.Z * walkSpeed)
        rp.AssemblyAngularVelocity = Vector3.zero

        if sideWalkTrack then
            if moving and not sideWalkTrack.IsPlaying then
                sideWalkTrack:Play(0.1, 1, 1.2)
            elseif not moving and sideWalkTrack.IsPlaying then
                sideWalkTrack:Stop(0.1)
            end
        end
    end)
end

function stopSideWalk()
    if sideWalkConnection then sideWalkConnection:Disconnect(); sideWalkConnection = nil end
    RunService:UnbindFromRenderStep(SIDE_WALK_CAMERA_BIND)
    if sideWalkTrack then sideWalkTrack:Stop(); sideWalkTrack:Destroy(); sideWalkTrack = nil end

    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
            humanoid.PlatformStand = false
        end
        local rp = character:FindFirstChild("HumanoidRootPart")
        if rp then
            rp.CFrame = CFrame.new(rp.Position + Vector3.new(0, 2, 0)) * CFrame.Angles(0, sideWalkYaw, 0)
            rp.AssemblyLinearVelocity = Vector3.zero
            rp.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

function toggleSideWalk(setActive)
    sideWalkEnabled = not sideWalkEnabled
    if sideWalkEnabled then startSideWalk() else stopSideWalk() end
    setActive(sideWalkEnabled)
end

-- Après une mort / un respawn, on relance le mode s'il était activé.
player.CharacterAdded:Connect(function()
    if sideWalkEnabled then
        task.wait(0.5)
        if sideWalkConnection then sideWalkConnection:Disconnect(); sideWalkConnection = nil end
        RunService:UnbindFromRenderStep(SIDE_WALK_CAMERA_BIND)
        sideWalkTrack = nil
        startSideWalk()
    end
end)

-- ===== CAPACITÉ : TIR (dégâts limités, cooldown géré côté serveur) =====
-- Ce LocalScript ne fait que DEMANDER le tir au serveur (TheLynoxBot_ServerDamage.lua,
-- à placer dans ServerScriptService). Le serveur valide tout (cooldown, portée, ligne
-- de vue) avant d'appliquer les dégâts, donc impossible de tricher depuis le client.
-- On l'attend en arrière-plan (task.spawn) pour ne PAS retarder l'affichage du panneau
-- si le script serveur met du temps à démarrer (ou n'est pas encore installé).
local fireRemote = nil

function playFireEffect(fromPosition, toPosition)
    local beam = Instance.new("Part")
    beam.Anchored = true
    beam.CanCollide = false
    beam.CanQuery = false
    beam.Material = Enum.Material.Neon
    beam.Color = Color3.fromRGB(34, 211, 238)
    local distance = (toPosition - fromPosition).Magnitude
    beam.Size = Vector3.new(0.3, 0.3, distance)
    beam.CFrame = CFrame.new(fromPosition, toPosition) * CFrame.new(0, 0, -distance / 2)
    beam.Parent = workspace

    TweenService:Create(beam, TweenInfo.new(0.25), {Transparency = 1}):Play()
    task.delay(0.25, function()
        beam:Destroy()
    end)
end

function updateStatsLabel()
    if statsLabel then
        statsLabel.Text = string.format("Tirs réussis: %d\nDégâts totaux: %d", shotsHit, totalDamageDealt)
    end
end

task.spawn(function()
    fireRemote = ReplicatedStorage:WaitForChild("TheLynoxFireAbility", 15)
    if fireRemote then
        fireRemote.OnClientEvent:Connect(function(kind, a, b, fromPosition, toPosition)
            if kind == "hit" then
                -- a = dégâts infligés, b = joueur touché
                shotsHit += 1
                totalDamageDealt += a
                updateStatsLabel()
                playFireEffect(fromPosition, toPosition)
            elseif kind == "hurt" then
                -- a = dégâts reçus, b = joueur attaquant
                playFireEffect(fromPosition, toPosition)
            end
        end)
    end
end)

function fireAtPlayer(targetPlayer)
    if not fireRemote then return end
    local now = os.clock()
    if now - lastFireAttempt < FIRE_COOLDOWN_CLIENT then
        return -- évite le spam visuel côté client ; le serveur bloquerait de toute façon
    end
    lastFireAttempt = now
    fireRemote:FireServer(targetPlayer)
end

-- ===== KILL AURA =====
-- Dès qu'un joueur vivant entre dans la portée, ton arme (Tool) est équipée si besoin,
-- le personnage se tourne vers lui et l'arme tire automatiquement (Tool:Activate()).
-- Le joueur le plus proche est visé en premier. L'outil TPLynox est ignoré.
local killAuraEnabled = false
local killAuraRange = 30
local killAuraConnection = nil
local killAuraTimer = 0

function getNearestPlayerInRange(range)
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local nearest = nil
    local nearestDistance = range

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local otherCharacter = otherPlayer.Character
            local otherRoot = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")
            local otherHumanoid = otherCharacter and otherCharacter:FindFirstChildOfClass("Humanoid")
            if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
                local distance = (otherRoot.Position - root.Position).Magnitude
                if distance <= nearestDistance then
                    nearest = otherPlayer
                    nearestDistance = distance
                end
            end
        end
    end

    return nearest
end

-- Cherche l'arme : l'outil déjà équipé, sinon le premier outil du sac (sauf TPLynox).
function getWeaponTool()
    local character = player.Character
    if not character then return nil end

    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") and child.Name ~= "TPLynox" then
            return child
        end
    end

    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and child.Name ~= "TPLynox" then
                return child
            end
        end
    end

    return nil
end

function killAuraShoot(target)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local targetCharacter = target.Character
    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root or not targetRoot or humanoid.Health <= 0 then return end

    local tool = getWeaponTool()
    if not tool then return end

    -- Équipe l'arme si elle n'est pas en main (le tir part au prochain tour).
    if tool.Parent ~= character then
        humanoid:EquipTool(tool)
        return
    end

    -- Se tourne vers la cible (horizontalement) puis tire.
    local lookAtPosition = Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z)
    if (lookAtPosition - root.Position).Magnitude > 0.1 then
        root.CFrame = CFrame.lookAt(root.Position, lookAtPosition)
    end

    tool:Activate()
end

function stopKillAura()
    if killAuraConnection then
        killAuraConnection:Disconnect()
        killAuraConnection = nil
    end
end

function startKillAura()
    stopKillAura()
    killAuraTimer = 0

    killAuraConnection = RunService.Heartbeat:Connect(function(dt)
        if not killAuraEnabled then return end

        -- Vérifie 4 fois par seconde (pas besoin de plus)
        killAuraTimer += dt
        if killAuraTimer < 0.25 then return end
        killAuraTimer = 0

        local target = getNearestPlayerInRange(killAuraRange)
        if target then
            killAuraShoot(target)
        end
    end)
end

function toggleKillAura(setActive)
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then startKillAura() else stopKillAura() end
    setActive(killAuraEnabled)
end

-- ===== ANIMATIONS / ÉMOTES (fusionné depuis TheLynoxBot Script) =====
-- Joue une émote en boucle. Reclique sur le bouton actif pour l'arrêter,
-- ou clique sur un autre bouton pour changer d'émote.
function playEmote(emote, button, idleColor, activeColor)
    local character = getCharacter()
    local humanoid = character:WaitForChild("Humanoid")

    if activeEmoteTrack then
        activeEmoteTrack:Stop()
    end
    if activeEmoteButton then
        activeEmoteButton.BackgroundColor3 = idleColor
    end

    if activeEmoteButton == button then
        activeEmoteTrack = nil
        activeEmoteButton = nil
        return
    end

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. emote.id

    local ok, track = pcall(function()
        return humanoid:LoadAnimation(animation)
    end)
    if not ok or not track then return end

    track.Priority = Enum.AnimationPriority.Action
    track.Looped = emote.looped ~= false
    track:Play(0.1, 1, emote.speed)

    activeEmoteTrack = track
    activeEmoteButton = button
    button.BackgroundColor3 = activeColor
end

-- ===== SPEED =====
function setWalkSpeed(value)
    walkSpeed = math.clamp(value, 1, 200)
    return walkSpeed
end

-- ===== GRAVITY =====
function setGravity(value)
    gravityValue = math.clamp(value, 0, 500)
    workspace.Gravity = gravityValue
    return gravityValue
end

RunService.Heartbeat:Connect(function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid.WalkSpeed ~= walkSpeed then
            humanoid.WalkSpeed = walkSpeed
        end
        humanoid.UseJumpPower = true
        if humanoid.JumpPower ~= checkpointData.jumpPower then
            humanoid.JumpPower = checkpointData.jumpPower
        end
    end
end)

-- ===== INFINITE JUMP =====
function toggleInfiniteJump(setActive)
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infiniteJumpEnabled then
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end
    end
    setActive(infiniteJumpEnabled)
end

-- ===== FLOAT =====
-- Float : saute normalement, puis se maintient à la hauteur atteinte.
-- Le joueur peut relancer un saut depuis cette hauteur.
-- Utilise une force verticale + l'état Running pour éviter la pose "bras en l'air".
-- CORRECTION : en état Running sans sol, le Humanoid n'avance plus tout seul.
-- On déplace donc le personnage nous-mêmes avec Humanoid.MoveDirection (WASD / joystick).
local floatRotateLocked = false

function stopFloatForce()
    if floatForce then
        floatForce:Destroy()
        floatForce = nil
    end
    if floatAttachment then
        floatAttachment:Destroy()
        floatAttachment = nil
    end
    -- Rend la rotation automatique au Humanoid quand le Float lâche le personnage.
    if floatRotateLocked then
        floatRotateLocked = false
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.AutoRotate = true end
    end
end

function startFloatHold(humanoid, rootPart)
    if floatHolding or not floatEnabled then return end

    floatHeight = rootPart.Position.Y
    floatHolding = true
    stopFloatForce()

    floatAttachment = Instance.new("Attachment")
    floatAttachment.Name = "TheLynoxFloatAttachment"
    floatAttachment.Parent = rootPart

    floatForce = Instance.new("VectorForce")
    floatForce.Name = "TheLynoxFloatForce"
    floatForce.Attachment0 = floatAttachment
    floatForce.RelativeTo = Enum.ActuatorRelativeTo.World
    floatForce.ApplyAtCenterOfMass = true
    floatForce.Parent = rootPart

    -- Évite que le moteur joue la pose Freefall pendant le maintien.
    floatFreefallEnabled = humanoid:GetStateEnabled(Enum.HumanoidStateType.Freefall)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    humanoid:ChangeState(Enum.HumanoidStateType.Running)

    -- Empêche le Humanoid de faire tourner le personnage tout seul pendant le Float.
    humanoid.AutoRotate = false
    floatRotateLocked = true

    local velocity = rootPart.AssemblyLinearVelocity
    rootPart.AssemblyLinearVelocity = Vector3.new(velocity.X, 0, velocity.Z)
end

function stopFloat()
    if floatJumpConnection then
        floatJumpConnection:Disconnect()
        floatJumpConnection = nil
    end

    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end

    stopFloatForce()

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, floatFreefallEnabled)
    end

    floatAirborne = false
    floatHolding = false
    floatHeight = nil
end

function startFloat()
    stopFloat()
    if not floatEnabled then return end

    floatAirborne = false
    floatHolding = false
    floatHeight = nil

    -- Permet un nouveau saut depuis la hauteur de Float.
    floatJumpConnection = UserInputService.JumpRequest:Connect(function()
        if not floatEnabled or flying or vehicleFlyEnabled then return end

        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end

        if floatHolding then
            floatHolding = false
            floatAirborne = true
            floatHeight = nil
            stopFloatForce()

            -- Réactive Freefall pendant le nouveau saut.
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, floatFreefallEnabled)

            local velocity = rootPart.AssemblyLinearVelocity
            rootPart.AssemblyLinearVelocity = Vector3.new(
                velocity.X,
                math.max(checkpointData.jumpPower, 1),
                velocity.Z
            )
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        else
            -- Le saut normal est laissé au Humanoid.
            floatAirborne = true
        end
    end)

    floatConnection = RunService.Heartbeat:Connect(function()
        if not floatEnabled then return end

        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end

        -- Ne gêne pas le Fly / Vehicle Fly.
        if flying or vehicleFlyEnabled then
            floatAirborne = false
            floatHolding = false
            floatHeight = nil
            stopFloatForce()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, floatFreefallEnabled)
            return
        end

        local state = humanoid:GetState()
        local velocity = rootPart.AssemblyLinearVelocity

        -- Quand le saut arrive à son sommet, on mémorise la hauteur et on bloque
        -- uniquement l'axe vertical.
        if floatAirborne and not floatHolding and velocity.Y <= 0
            and state ~= Enum.HumanoidStateType.Landed
            and state ~= Enum.HumanoidStateType.Running then
            startFloatHold(humanoid, rootPart)
            return
        end

        if floatHolding then
            if not floatForce or not floatForce.Parent then
                startFloatHold(humanoid, rootPart)
                return
            end

            -- Compensation exacte de la gravité, sans CFrame forcé.
            floatForce.Force = Vector3.new(0, rootPart.AssemblyMass * workspace.Gravity, 0)

            -- Garde une animation/état normal au lieu de la pose de vol.
            if humanoid:GetState() ~= Enum.HumanoidStateType.Running then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end

            -- Hauteur stable + déplacement manuel.
            -- (le Humanoid ne marche plus tout seul en l'air quand il est en état Running)
            local moveDir = humanoid.MoveDirection
            local heightError = floatHeight - rootPart.Position.Y
            local correctionY = 0
            if math.abs(heightError) > 0.15 then
                correctionY = math.clamp(heightError * 8, -6, 6)
            end

            rootPart.AssemblyLinearVelocity = Vector3.new(
                moveDir.X * humanoid.WalkSpeed,
                correctionY,
                moveDir.Z * humanoid.WalkSpeed
            )

            -- Stoppe toute rotation résiduelle (sinon le perso tourne sur lui-même à l'arrêt).
            rootPart.AssemblyAngularVelocity = Vector3.zero

            -- Tourne le personnage dans le sens où il marche (face à la direction, plus de dos tourné).
            local flatDir = Vector3.new(moveDir.X, 0, moveDir.Z)
            if flatDir.Magnitude > 0.1 then
                local targetCFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + flatDir.Unit)
                rootPart.CFrame = rootPart.CFrame:Lerp(targetCFrame, 0.25)
            end

        elseif state == Enum.HumanoidStateType.Landed then
            floatAirborne = false
            floatHeight = nil
            stopFloatForce()
        end
    end)
end

function toggleFloat(setActive)
    floatEnabled = not floatEnabled
    if floatEnabled then
        startFloat()
    else
        stopFloat()
    end
    setActive(floatEnabled)
end

-- ===== NOCLIP =====
function setNoclipOnCharacter(character, state)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

function startNoclip()
    local character = getCharacter()
    setNoclipOnCharacter(character, true)
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        local char = player.Character
        if char then setNoclipOnCharacter(char, true) end
    end)
end

function stopNoclip()
    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
    local character = player.Character
    if character then setNoclipOnCharacter(character, false) end
end

function toggleNoclip(setActive)
    noclipEnabled = not noclipEnabled
    if noclipEnabled then startNoclip() else stopNoclip() end
    setActive(noclipEnabled)
end

-- ===== TÉLÉPORTATION =====
function teleportToPlayer(targetPlayer)
    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local targetCharacter = targetPlayer.Character
    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
    if targetRoot then
        rootPart.CFrame = targetRoot.CFrame + Vector3.new(3, 0, 0)
    end
end

function teleportToCoordinates(x, y, z)
    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    rootPart.CFrame = CFrame.new(x, y, z)
end

-- ===== TÉLÉPORTATION AU CLIC =====
-- Quand l'option est active, clique n'importe où dans le monde (porte, mur, sol,
-- objet, etc.) pour téléporter TON personnage juste devant la surface cliquée.
-- Le décalage évite de rester coincé directement dans le mur ou la porte.
function stopClickTeleport()
    if clickTeleportConnection then
        clickTeleportConnection:Disconnect()
        clickTeleportConnection = nil
    end
end

function startClickTeleport()
    stopClickTeleport()

    clickTeleportConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not clickTeleportEnabled then return end
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

        local mouse = player:GetMouse()
        local unitRay = mouse.UnitRay

        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {character}

        local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 5000, rayParams)
        if not result then return end

        -- Téléporte juste à l'extérieur de la surface cliquée : porte, mur, sol, etc.
        local targetPosition = result.Position + result.Normal * 3
        rootPart.CFrame = CFrame.lookAt(targetPosition, result.Position)
        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.AssemblyAngularVelocity = Vector3.zero
    end)
end

function toggleClickTeleport(setActive)
    clickTeleportEnabled = not clickTeleportEnabled
    if clickTeleportEnabled then
        startClickTeleport()
    else
        stopClickTeleport()
    end
    setActive(clickTeleportEnabled)
end

-- ===== TROLL : arrêts prédéclarés (pour que chaque troll puisse couper les autres) =====
local stopJumpOnPlayer, stopBlockAndDance, stopCircle, stopShadow, stopMirror, stopTpSpam, stopCage, stopRandomWave, stopJumper, stopFakeDeath, stopBackRide, stopSpin

-- ===== TROLL : SAUTER SUR LA TÊTE =====
-- Fait rebondir TON perso sur la tête du joueur ciblé pendant quelques secondes.
-- Ça déplace uniquement ton propre personnage (donc ça se réplique normalement
-- pour tout le monde, aucune astuce "FE" nécessaire) : impossible de bouger
-- le perso de quelqu'un d'autre sans un vrai script serveur.
local bounceConnection = nil

function jumpOnPlayer(targetPlayer)
    stopSpin()
    if bounceConnection then bounceConnection:Disconnect(); bounceConnection = nil end
    stopBackRide()
    stopTpSpam()
    stopCage()
    stopRandomWave()
    stopJumper()
    stopFakeDeath()

    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.AutoRotate = true

    local startTime = os.clock()
    local duration = 2 -- secondes
    local bounceHeight = 3
    local bounceSpeed = 8 -- rebonds par seconde

    bounceConnection = RunService.RenderStepped:Connect(function()
        if os.clock() - startTime > duration then
            if bounceConnection then bounceConnection:Disconnect(); bounceConnection = nil end
            return
        end

        local targetCharacter = targetPlayer.Character
        local targetHead = targetCharacter and targetCharacter:FindFirstChild("Head")
        if not targetHead then
            if bounceConnection then bounceConnection:Disconnect(); bounceConnection = nil end
            return
        end

        local bounce = math.abs(math.sin((os.clock() - startTime) * bounceSpeed)) * bounceHeight
        rootPart.CFrame = CFrame.new(targetHead.Position + Vector3.new(0, 4 + bounce, 0))
    end)
end

stopJumpOnPlayer = function()
    if bounceConnection then bounceConnection:Disconnect(); bounceConnection = nil end
end

-- ===== TROLL : BLOQUER LA VUE + DANSE =====
-- Se positionne en permanence juste devant le visage du joueur ciblé (peu importe
-- où il regarde), en jouant une émote de danse. Ne déplace que TON perso, donc ça
-- se réplique normalement.
local DANCE_ANIMATION_ID = 507771019 -- émote "Dance" officielle Roblox, compatible R6 et R15

local blockDanceConnection = nil
local blockDanceTrack = nil

stopBlockAndDance = function()
    if blockDanceConnection then blockDanceConnection:Disconnect(); blockDanceConnection = nil end
    if blockDanceTrack then blockDanceTrack:Stop(); blockDanceTrack = nil end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
end

function blockAndDance(targetPlayer)
    stopSpin()
    stopBlockAndDance()
    stopBackRide()
    stopJumpOnPlayer()
    stopTpSpam()
    stopCage()
    stopRandomWave()
    stopJumper()
    stopFakeDeath()

    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.AutoRotate = false

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. DANCE_ANIMATION_ID
    local ok, track = pcall(function()
        return humanoid:LoadAnimation(animation)
    end)
    if ok and track then
        track.Priority = Enum.AnimationPriority.Action
        track.Looped = true
        track:Play()
        blockDanceTrack = track
    end

    local startTime = os.clock()
    local duration = 20 -- secondes

    blockDanceConnection = RunService.RenderStepped:Connect(function()
        if os.clock() - startTime > duration then
            stopBlockAndDance()
            return
        end

        local targetCharacter = targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            stopBlockAndDance()
            return
        end

        -- Se place juste devant son visage, tourné vers lui
        local frontPosition = (targetRoot.CFrame * CFrame.new(0, 0.5, -2.5)).Position
        rootPart.CFrame = CFrame.new(frontPosition, targetRoot.Position)
    end)
end

-- ===== TROLL : SPIN RAPIDE (3S) =====
-- Se place autour du joueur ciblé et tourne rapidement autour de lui pendant 3 secondes.
-- Ne déplace que TON personnage.
local spinConnection = nil

stopSpin = function()
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
end

function spinAroundPlayer(targetPlayer)
    stopSpin()
    stopJumpOnPlayer()
    stopBackRide()
    stopBlockAndDance()
    stopCircle()
    stopShadow()
    stopMirror()
    stopTpSpam()
    stopCage()
    stopRandomWave()
    stopJumper()
    stopFakeDeath()

    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.AutoRotate = false

    local startTime = os.clock()
    local duration = 3 -- secondes
    local radius = 4
    local rotationsPerSecond = 5

    spinConnection = RunService.RenderStepped:Connect(function()
        if os.clock() - startTime > duration then
            stopSpin()
            return
        end

        local targetCharacter = targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            stopSpin()
            return
        end

        local elapsed = os.clock() - startTime
        local angle = elapsed * rotationsPerSecond * math.pi * 2
        local offset = Vector3.new(math.cos(angle) * radius, 1.5, math.sin(angle) * radius)
        local spinPosition = targetRoot.Position + offset

        rootPart.CFrame = CFrame.new(spinPosition, targetRoot.Position)
    end)
end

-- ===== TROLL : CERCLE AUTOUR D'EUX =====
-- Tourne très vite autour du joueur ciblé façon derviche tourneur. Ne déplace
-- que TON perso, donc ça se réplique normalement pour tout le monde.
local circleConnection = nil

stopCircle = function()
    if circleConnection then circleConnection:Disconnect(); circleConnection = nil end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
end

function circleAroundPlayer(targetPlayer)
    stopSpin()
    stopCircle()
    stopBackRide()
    stopJumpOnPlayer()
    stopBlockAndDance()
    stopTpSpam()
    stopCage()
    stopRandomWave()
    stopJumper()
    stopFakeDeath()

    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.AutoRotate = false

    local startTime = os.clock()
    local duration = 20 -- secondes
    local radius = 6
    local rotationsPerSecond = 1.2

    circleConnection = RunService.RenderStepped:Connect(function()
        if os.clock() - startTime > duration then
            stopCircle()
            return
        end

        local targetCharacter = targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            stopCircle()
            return
        end

        local elapsed = os.clock() - startTime
        local angle = elapsed * rotationsPerSecond * math.pi * 2
        local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        local orbitPosition = targetRoot.Position + offset

        rootPart.CFrame = CFrame.new(orbitPosition, targetRoot.Position)
    end)
end

-- ===== TROLL : OMBRE (SUIVRE À DISTANCE) =====
-- Suit le joueur ciblé partout où il va, en gardant une distance fixe derrière lui.
-- Ne déplace que TON perso, donc ça se réplique normalement pour tout le monde.
local shadowConnection = nil

stopShadow = function()
    if shadowConnection then shadowConnection:Disconnect(); shadowConnection = nil end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
end

function shadowPlayer(targetPlayer)
    stopSpin()
    stopShadow()
    stopBackRide()
    stopJumpOnPlayer()
    stopBlockAndDance()
    stopCircle()
    stopTpSpam()
    stopCage()
    stopRandomWave()
    stopJumper()
    stopFakeDeath()

    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.AutoRotate = false

    local startTime = os.clock()
    local duration = 20 -- secondes
    local followDistance = 6
    local followSpeed = 22 -- vitesse de rattrapage (studs/seconde)

    shadowConnection = RunService.RenderStepped:Connect(function(dt)
        if os.clock() - startTime > duration then
            stopShadow()
            return
        end

        local targetCharacter = targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            stopShadow()
            return
        end

        -- Position visée : juste derrière lui, dans le sens opposé à sa direction actuelle
        local behindOffset = targetRoot.CFrame.LookVector * -followDistance
        local desiredPosition = targetRoot.Position + behindOffset

        -- Se rapproche progressivement de la position visée (pas de téléport brut,
        -- pour un mouvement de "poursuite" plus fluide)
        local currentPosition = rootPart.Position
        local toDesired = desiredPosition - currentPosition
        local step = math.min(followSpeed * dt, toDesired.Magnitude)
        local newPosition = toDesired.Magnitude > 0.01
            and currentPosition + toDesired.Unit * step
            or currentPosition

        rootPart.CFrame = CFrame.new(newPosition, targetRoot.Position)
    end)
end

-- ===== TROLL : SE TÉLÉPORTER SUR LE DOS =====
-- Place ton personnage derrière et légèrement au-dessus du joueur ciblé,
-- puis le suit en temps réel pour donner un effet "sur son dos".
-- Ne déplace que TON personnage.
local backRideConnection = nil

stopBackRide = function()
    if backRideConnection then
        backRideConnection:Disconnect()
        backRideConnection = nil
    end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.AutoRotate = true
    end
end

function backRidePlayer(targetPlayer)
    stopSpin()
    stopBackRide()
    stopJumpOnPlayer()
    stopBlockAndDance()
    stopCircle()
    stopShadow()
    stopMirror()
    stopTpSpam()
    stopCage()
    stopRandomWave()
    stopJumper()
    stopFakeDeath()

    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.AutoRotate = false

    local startTime = os.clock()
    local duration = 20 -- secondes
    local backOffset = CFrame.new(0, 1.8, 1.35)

    backRideConnection = RunService.RenderStepped:Connect(function()
        if os.clock() - startTime > duration then
            stopBackRide()
            return
        end

        local targetCharacter = targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            stopBackRide()
            return
        end

        -- Derrière lui (+Z) et légèrement au-dessus, en gardant sa direction.
        rootPart.CFrame = targetRoot.CFrame * backOffset
    end)
end

-- ===== TROLL : MIROIR (COPIER SES MOUVEMENTS) =====
-- Se colle juste à côté du joueur ciblé et copie sa position/orientation en
-- temps réel, sans limite de temps. Ne déplace que TON perso.
local mirrorConnection = nil

stopMirror = function()
    if mirrorConnection then mirrorConnection:Disconnect(); mirrorConnection = nil end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
end

function mirrorPlayer(targetPlayer)
    stopSpin()
    stopMirror()
    stopBackRide()
    stopJumpOnPlayer()
    stopBlockAndDance()
    stopCircle()
    stopShadow()
    stopTpSpam()
    stopCage()
    stopRandomWave()
    stopJumper()
    stopFakeDeath()

    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.AutoRotate = false

    local sideOffset = 5 -- distance à laquelle tu te colles à côté de lui

    mirrorConnection = RunService.RenderStepped:Connect(function()
        local targetCharacter = targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            stopMirror()
            return
        end

        -- Même orientation que lui, juste décalé sur le côté
        rootPart.CFrame = targetRoot.CFrame * CFrame.new(sideOffset, 0, 0)
    end)
end

-- ===== TROLL : TP SPAM (TÉLÉPORTATION ALÉATOIRE AUTOUR DE LUI) =====
-- Se téléporte très vite à des positions aléatoires tout autour du joueur ciblé,
-- façon "flash" chaotique. Ne déplace que TON perso, donc ça se réplique normalement.
local tpSpamConnection = nil

stopTpSpam = function()
    if tpSpamConnection then tpSpamConnection:Disconnect(); tpSpamConnection = nil end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
end

function tpSpamAroundPlayer(targetPlayer)
    stopSpin()
    stopTpSpam()
    stopBackRide()
    stopJumpOnPlayer()
    stopBlockAndDance()
    stopCircle()
    stopShadow()
    stopMirror()
    stopCage()
    stopRandomWave()
    stopJumper()
    stopFakeDeath()

    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.AutoRotate = false

    local startTime = os.clock()
    local duration = 15 -- secondes
    local radius = 7
    local tpInterval = 0.08 -- toutes les 80ms = effet de flash rapide
    local lastTp = 0

    tpSpamConnection = RunService.RenderStepped:Connect(function()
        if os.clock() - startTime > duration then
            stopTpSpam()
            return
        end

        local targetCharacter = targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            stopTpSpam()
            return
        end

        if os.clock() - lastTp < tpInterval then return end
        lastTp = os.clock()

        -- Position aléatoire sur une sphère autour du joueur ciblé
        local randomAngleXZ = math.random() * math.pi * 2
        local randomHeight = (math.random() - 0.5) * 4 -- entre -2 et +2 studs de hauteur
        local offset = Vector3.new(
            math.cos(randomAngleXZ) * radius,
            randomHeight,
            math.sin(randomAngleXZ) * radius
        )
        local newPosition = targetRoot.Position + offset

        rootPart.CFrame = CFrame.new(newPosition, targetRoot.Position)
    end)
end

-- ===== TROLL : CAGE (4 BLOCS QUI L'ENTOURENT EN PERMANENCE) =====
-- Crée 4 blocs décoratifs (sans collision, visibles seulement sur ton écran) qui
-- restent positionnés en carré tout autour du joueur ciblé et le suivent partout.
local cageParts = {}
local cageConnection = nil

function buildCagePart()
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 6, 1)
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(139, 92, 246)
    part.Transparency = 0.15
    part.Name = "TheLynoxCageBar"
    part.Parent = workspace
    return part
end

stopCage = function()
    if cageConnection then cageConnection:Disconnect(); cageConnection = nil end
    for _, part in ipairs(cageParts) do
        if part and part.Parent then part:Destroy() end
    end
    cageParts = {}
end

function cageAroundPlayer(targetPlayer)
    stopSpin()
    stopCage()
    stopBackRide()
    stopJumpOnPlayer()
    stopBlockAndDance()
    stopCircle()
    stopShadow()
    stopMirror()
    stopTpSpam()
    stopRandomWave()
    stopJumper()
    stopFakeDeath()

    for i = 1, 4 do
        cageParts[i] = buildCagePart()
    end

    local startTime = os.clock()
    local duration = 25 -- secondes
    local radius = 5

    cageConnection = RunService.RenderStepped:Connect(function()
        if os.clock() - startTime > duration then
            stopCage()
            return
        end

        local targetCharacter = targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            stopCage()
            return
        end

        -- Une légère rotation lente pour un effet plus vivant
        local spin = (os.clock() - startTime) * 0.5

        for i, part in ipairs(cageParts) do
            local angle = spin + (i - 1) * (math.pi / 2) -- 0°, 90°, 180°, 270°
            local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
            part.CFrame = CFrame.new(targetRoot.Position + offset)
        end
    end)
end

-- ===== TROLL : SALUEUR RANDOM (WAVE TOUTES LES 5-10S) =====
-- Se téléporte devant le joueur ciblé toutes les 5 à 10 secondes, fait un petit
-- signe de la main (émote Wave), puis repart. Ne déplace que TON perso.
local WAVE_ANIMATION_ID = 128777973 -- émote "Wave" officielle Roblox
local randomWaveThread = nil
local randomWaveActive = false
local randomWaveTrack = nil

stopRandomWave = function()
    randomWaveActive = false
    if randomWaveTrack then randomWaveTrack:Stop(); randomWaveTrack = nil end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
end

function randomWaveAtPlayer(targetPlayer)
    stopSpin()
    stopRandomWave()
    stopBackRide()
    stopJumpOnPlayer()
    stopBlockAndDance()
    stopCircle()
    stopShadow()
    stopMirror()
    stopTpSpam()
    stopCage()
    stopJumper()
    stopFakeDeath()

    randomWaveActive = true

    randomWaveThread = task.spawn(function()
        while randomWaveActive do
            task.wait(math.random(5, 10))
            if not randomWaveActive then break end

            local character = getCharacter()
            local rootPart = character:WaitForChild("HumanoidRootPart")
            local humanoid = character:WaitForChild("Humanoid")

            local targetCharacter = targetPlayer.Character
            local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
            if not targetRoot then
                stopRandomWave()
                break
            end

            humanoid.AutoRotate = false
            local frontPosition = (targetRoot.CFrame * CFrame.new(0, 0, -3)).Position
            rootPart.CFrame = CFrame.new(frontPosition, targetRoot.Position)

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://" .. WAVE_ANIMATION_ID
            local ok, track = pcall(function()
                return humanoid:LoadAnimation(animation)
            end)
            if ok and track then
                track.Priority = Enum.AnimationPriority.Action
                randomWaveTrack = track
                track:Play()
                track.Stopped:Wait()
                randomWaveTrack = nil
            else
                task.wait(1.5)
            end

            if randomWaveActive then humanoid.AutoRotate = true end
        end
    end)
end

-- ===== TROLL : SAUTEUR (SAUTE À CÔTÉ DE LUI EN LE FIXANT) =====
-- Se colle juste à côté du joueur ciblé et fait des petits sauts sur place en
-- continu, tout en le regardant fixement. Ne déplace que TON perso.
local jumperConnection = nil

stopJumper = function()
    if jumperConnection then jumperConnection:Disconnect(); jumperConnection = nil end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
end

function jumpBesidePlayer(targetPlayer)
    stopSpin()
    stopJumper()
    stopBackRide()
    stopFakeDeath()
    stopJumpOnPlayer()
    stopBlockAndDance()
    stopCircle()
    stopShadow()
    stopMirror()
    stopTpSpam()
    stopCage()
    stopRandomWave()

    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.AutoRotate = false

    local startTime = os.clock()
    local duration = 20 -- secondes
    local sideOffset = 3.5
    local jumpHeight = 2.5
    local jumpSpeed = 3.5 -- sauts par seconde

    jumperConnection = RunService.RenderStepped:Connect(function()
        if os.clock() - startTime > duration then
            stopJumper()
            return
        end

        local targetCharacter = targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            stopJumper()
            return
        end

        local bounce = math.max(0, math.sin((os.clock() - startTime) * jumpSpeed * math.pi)) * jumpHeight
        local sidePosition = (targetRoot.CFrame * CFrame.new(sideOffset, 0, 0)).Position
        local jumpingPosition = sidePosition + Vector3.new(0, bounce, 0)

        rootPart.CFrame = CFrame.new(jumpingPosition, targetRoot.Position)
    end)
end

-- ===== TROLL : FAUX MORT (S'ÉCROULE AU SOL DEVANT LUI) =====
-- Se téléporte devant le joueur ciblé et "s'écroule" au sol quelques secondes,
-- façon ragdoll. Ne déplace que TON perso (position + rotation + animation),
-- donc ça se réplique normalement pour tout le monde, comme n'importe quel
-- mouvement de personnage classique.
local FAINT_ANIMATION_ID = 181526230 -- émote "Faint" officielle Roblox
local fakeDeathTrack = nil

stopFakeDeath = function()
    if fakeDeathTrack then fakeDeathTrack:Stop(); fakeDeathTrack = nil end
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.AutoRotate = true end
    end
end

function fakeDeathInFrontOf(targetPlayer)
    stopSpin()
    stopFakeDeath()
    stopBackRide()
    stopJumpOnPlayer()
    stopBlockAndDance()
    stopCircle()
    stopShadow()
    stopMirror()
    stopTpSpam()
    stopCage()
    stopRandomWave()
    stopJumper()

    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    local targetCharacter = targetPlayer.Character
    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    -- Se téléporte juste devant lui, au sol
    local frontPosition = (targetRoot.CFrame * CFrame.new(0, -2, -3)).Position
    local _, yRot, _ = targetRoot.CFrame:ToEulerAnglesYXZ()
    humanoid.AutoRotate = false
    rootPart.CFrame = CFrame.new(frontPosition) * CFrame.Angles(math.rad(-90), yRot, 0)

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. FAINT_ANIMATION_ID
    local ok, track = pcall(function()
        return humanoid:LoadAnimation(animation)
    end)
    if ok and track then
        track.Priority = Enum.AnimationPriority.Action
        track:Play()
        fakeDeathTrack = track
    end

    task.delay(8, function()
        if fakeDeathTrack == track then
            stopFakeDeath()
            local _, yRotNow, _ = rootPart.CFrame:ToEulerAnglesYXZ()
            rootPart.CFrame = CFrame.new(rootPart.Position + Vector3.new(0, 2, 0)) * CFrame.Angles(0, yRotNow, 0)
        end
    end)
end

-- ===== BACKSTAB : MARCHER DERRIÈRE LA TÊTE D'UN JOUEUR (EFFET GLITCH, 2 S) =====
-- Ton personnage monte derrière la tête du joueur choisi et "marche" dessus (les jambes bougent)
-- en glitchant (tremblements, sauts brusques, rotations) pendant 2 secondes, puis retombe juste
-- derrière son dos. Ne déplace que TON personnage, donc ça se réplique normalement.
local BACKSTAB_DURATION = 2 -- secondes
local BACKSTAB_WALK_R15 = 507777826 -- animation de marche R15 officielle Roblox
local BACKSTAB_WALK_R6 = 180426354  -- animation de marche R6 officielle Roblox
local backstabConnection = nil
local backstabTrack = nil
local backstabHighlight = nil

function stopBackstab()
    if backstabConnection then backstabConnection:Disconnect(); backstabConnection = nil end
    if backstabTrack then backstabTrack:Stop(); backstabTrack = nil end
    if backstabHighlight then backstabHighlight:Destroy(); backstabHighlight = nil end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
end

function backstabPlayer(targetPlayer)
    -- Coupe les autres actions troll en cours
    stopSpin()
    stopBackstab()
    stopBackRide()
    stopJumpOnPlayer()
    stopBlockAndDance()
    stopCircle()
    stopShadow()
    stopMirror()
    stopTpSpam()
    stopCage()
    stopRandomWave()
    stopJumper()
    stopFakeDeath()

    local character = getCharacter()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.AutoRotate = false

    -- Animation de marche : les pieds bougent pendant tout l'effet (visible par les autres joueurs)
    local walkAnimation = Instance.new("Animation")
    walkAnimation.AnimationId = "rbxassetid://" .. tostring(
        humanoid.RigType == Enum.HumanoidRigType.R15 and BACKSTAB_WALK_R15 or BACKSTAB_WALK_R6
    )
    local ok, track = pcall(function()
        return humanoid:LoadAnimation(walkAnimation)
    end)
    if ok and track then
        track.Priority = Enum.AnimationPriority.Action
        track.Looped = true
        track:Play(0.05, 1, 2.2) -- vitesse x2.2 : des petits pas rapides
        backstabTrack = track
    end

    -- Surbrillance qui change de couleur à chaque "image" du glitch (visible seulement chez toi)
    local glitchColors = {
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 0, 200),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 60, 60),
    }
    local highlight = Instance.new("Highlight")
    highlight.Name = "BackstabGlitch"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.45
    highlight.OutlineTransparency = 0
    highlight.FillColor = glitchColors[1]
    highlight.OutlineColor = glitchColors[3]
    highlight.Parent = character
    backstabHighlight = highlight

    local startTime = os.clock()
    local lastGlitchTime = 0
    local glitchOffset = Vector3.zero
    local glitchRotation = CFrame.new()

    backstabConnection = RunService.RenderStepped:Connect(function()
        local targetCharacter = targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        local targetHead = targetCharacter and targetCharacter:FindFirstChild("Head")
        local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
        if not targetRoot or not targetHead or not targetHumanoid or targetHumanoid.Health <= 0 then
            stopBackstab()
            return
        end

        local now = os.clock()
        local elapsed = now - startTime

        -- Fin des 2 secondes : on se pose juste derrière son dos, face à lui
        if elapsed >= BACKSTAB_DURATION then
            local behindPosition = targetRoot.Position + targetRoot.CFrame.LookVector * -2.5 + Vector3.new(0, 1, 0)
            rootPart.CFrame = CFrame.lookAt(
                behindPosition,
                Vector3.new(targetRoot.Position.X, behindPosition.Y, targetRoot.Position.Z)
            )
            rootPart.AssemblyLinearVelocity = Vector3.zero
            rootPart.AssemblyAngularVelocity = Vector3.zero
            stopBackstab()
            return
        end

        -- Une "image" de glitch toutes les ~45 ms : ça saccade au lieu de trembler en continu
        if now - lastGlitchTime > 0.045 then
            lastGlitchTime = now

            glitchOffset = Vector3.new(
                (math.random() - 0.5) * 1.4,
                (math.random() - 0.5) * 1.2,
                (math.random() - 0.5) * 1.4
            )
            if math.random() < 0.15 then
                glitchOffset *= 3 -- de temps en temps, un gros saut de glitch
            end

            glitchRotation = CFrame.Angles(
                (math.random() - 0.5) * 0.8,
                math.random() < 0.2 and math.random() * math.pi * 2 or 0, -- parfois un demi-tour brutal
                (math.random() - 0.5) * 0.8
            )

            highlight.FillColor = glitchColors[math.random(1, #glitchColors)]
            highlight.FillTransparency = 0.25 + math.random() * 0.5
        end

        local targetCFrame = targetRoot.CFrame
        local lookVector = targetCFrame.LookVector
        local rightVector = targetCFrame.RightVector
        local facing = targetCFrame - targetCFrame.Position -- même orientation que lui

        -- Pas sur sa tête : va-et-vient avant/arrière + léger balancement gauche/droite
        local stepForward = math.sin(elapsed * 9) * 0.55
        local stepSide = math.cos(elapsed * 4.5) * 0.25

        -- Position de base : derrière sa tête, les pieds posés dessus
        local basePosition = targetHead.Position + lookVector * -0.6 + Vector3.new(0, 3.3, 0)
        local walkPosition = basePosition + lookVector * stepForward + rightVector * stepSide

        rootPart.CFrame = CFrame.new(walkPosition + glitchOffset) * facing * glitchRotation
        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.AssemblyAngularVelocity = Vector3.zero
    end)
end

-- ===== BACKSTAB EN DOUBLE-CLIC DANS LE MONDE DU JEU =====
-- Double-clique directement sur le personnage visible à l'écran (pas dans la liste du GUI).
-- Le clic est ignoré si Roblox indique qu'il a été utilisé par une interface.
local lastBackstabWorldClickTime = 0
local lastBackstabWorldTarget = nil
local BACKSTAB_DOUBLE_CLICK_WINDOW = 0.35

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if gameProcessed then return end

    local mouse = player:GetMouse()
    local hit = mouse.Target
    if not hit then
        lastBackstabWorldTarget = nil
        lastBackstabWorldClickTime = 0
        return
    end

    local targetModel = hit:FindFirstAncestorOfClass("Model")
    local targetPlayer = targetModel and Players:GetPlayerFromCharacter(targetModel)
    if not targetPlayer or targetPlayer == player then
        lastBackstabWorldTarget = nil
        lastBackstabWorldClickTime = 0
        return
    end

    local now = os.clock()
    if lastBackstabWorldTarget == targetPlayer
        and (now - lastBackstabWorldClickTime) <= BACKSTAB_DOUBLE_CLICK_WINDOW then
        lastBackstabWorldTarget = nil
        lastBackstabWorldClickTime = 0
        task.spawn(backstabPlayer, targetPlayer)
    else
        lastBackstabWorldTarget = targetPlayer
        lastBackstabWorldClickTime = now
    end
end)

-- ===== OUTIL TPLYNOX =====
local hasTPTool = false

function buildTPTool()
    local backpack = player:WaitForChild("Backpack")
    if backpack:FindFirstChild("TPLynox") then return end
    local character = player.Character
    if character and character:FindFirstChild("TPLynox") then return end

    local tool = Instance.new("Tool")
    tool.Name = "TPLynox"
    tool.RequiresHandle = false
    tool.CanBeDropped = false

    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local hitPosition = mouse.Hit and mouse.Hit.Position
        if not hitPosition then return end
        local char = getCharacter()
        local rootPart = char:WaitForChild("HumanoidRootPart")
        rootPart.CFrame = CFrame.new(hitPosition + Vector3.new(0, 3, 0))
    end)

    tool.Parent = backpack
end

function createTPTool()
    hasTPTool = true
    buildTPTool()
end

-- ===== CHECKPOINTS NOMMÉS =====
-- Plusieurs checkpoints peuvent être enregistrés. Le checkpoint sélectionné
-- est utilisé automatiquement lors du respawn.
function setCheckpoint(name)
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end

    name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then return false end

    checkpointData.points[name] = rootPart.CFrame
    checkpointData.activeName = name
    checkpointData.activeCFrame = rootPart.CFrame

    if checkpointData.refresh then
        checkpointData.refresh()
    end
    return true
end

function teleportToCheckpoint(name)
    local cf = checkpointData.points[name]
    if not cf then return end

    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    rootPart.CFrame = cf
    rootPart.AssemblyLinearVelocity = Vector3.zero
    rootPart.AssemblyAngularVelocity = Vector3.zero
end

-- Fait réellement réapparaître le personnage au checkpoint sélectionné.
-- Le CharacterAdded ci-dessous replacera le nouveau personnage au bon endroit.
function respawnAtCheckpoint()
    if not checkpointData.activeCFrame then return end

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end

function selectCheckpoint(name)
    local cf = checkpointData.points[name]
    if not cf then return end

    -- Un clic sur le checkpoint actif le désactive.
    -- Un clic sur un autre checkpoint l'active à la place.
    if checkpointData.activeName == name then
        checkpointData.activeName = nil
        checkpointData.activeCFrame = nil
    else
        checkpointData.activeName = name
        checkpointData.activeCFrame = cf
    end

    if checkpointData.refresh then
        checkpointData.refresh()
    end
end

function deleteCheckpoint(name)
    checkpointData.points[name] = nil

    if checkpointData.activeName == name then
        checkpointData.activeName = nil
        checkpointData.activeCFrame = nil
    end

    if checkpointData.refresh then
        checkpointData.refresh()
    end
end

function clearCheckpoints()
    table.clear(checkpointData.points)
    checkpointData.activeName = nil
    checkpointData.activeCFrame = nil

    if checkpointData.refresh then
        checkpointData.refresh()
    end
end

-- ===== FREE CAM =====
local FREECAM_SENSITIVITY = 0.003
local freeCamYaw = 0
local freeCamPitch = 0
local freeCamPosition = Vector3.new()
local freeCamLooking = false
local freeCamInputBeganConn, freeCamInputEndedConn
local freeCamSpeed = 60
local followTarget = nil
local followOffset = Vector3.new(0, 5, 15)
local followLabel -- assigné plus bas dans l'interface

function setFollowTarget(targetPlayer)
    followTarget = targetPlayer
    if followLabel then
        followLabel.Text = targetPlayer and ("Suivi : " .. targetPlayer.Name) or "Suivi : aucun"
    end
end

function onFreeCamInputBegan(input)
    if not freeCamEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        freeCamLooking = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end

function onFreeCamInputEnded(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        freeCamLooking = false
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end

function startFreeCam()
    camera.CameraType = Enum.CameraType.Scriptable

    local rx, ry, _ = camera.CFrame:ToEulerAnglesYXZ()
    freeCamPitch = rx
    freeCamYaw = ry
    freeCamPosition = camera.CFrame.Position

    freeCamInputBeganConn = UserInputService.InputBegan:Connect(onFreeCamInputBegan)
    freeCamInputEndedConn = UserInputService.InputEnded:Connect(onFreeCamInputEnded)

    freeCamConnection = RunService.RenderStepped:Connect(function(dt)
        if not freeCamEnabled then return end
        camera.CameraType = Enum.CameraType.Scriptable

        if freeCamLooking and not followTarget then
            local delta = UserInputService:GetMouseDelta()
            freeCamYaw = freeCamYaw - delta.X * FREECAM_SENSITIVITY
            freeCamPitch = math.clamp(freeCamPitch - delta.Y * FREECAM_SENSITIVITY, math.rad(-89), math.rad(89))
        end

        local dir = getMoveDirection()

        if followTarget then
            local targetChar = followTarget.Character
            local tRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            if tRoot then
                -- WASD/Espace/Shift déplacent la caméra autour du joueur suivi
                if dir.Magnitude > 0 then
                    followOffset = followOffset + dir.Unit * freeCamSpeed * dt
                end
                freeCamPosition = tRoot.Position + followOffset

                local toTarget = tRoot.Position - freeCamPosition
                if toTarget.Magnitude > 0.1 then
                    local d = toTarget.Unit
                    freeCamPitch = math.asin(d.Y)
                    freeCamYaw = math.atan2(-d.X, -d.Z)
                end
            elseif not followTarget.Parent then
                setFollowTarget(nil) -- le joueur a quitté le serveur
            end
        elseif dir.Magnitude > 0 then
            freeCamPosition = freeCamPosition + dir.Unit * freeCamSpeed * dt
        end

        local rotationCFrame = CFrame.Angles(0, freeCamYaw, 0) * CFrame.Angles(freeCamPitch, 0, 0)

        camera.CFrame = CFrame.new(freeCamPosition) * rotationCFrame
    end)
end

function stopFreeCam()
    setFollowTarget(nil)
    camera.CameraType = Enum.CameraType.Custom
    if freeCamConnection then freeCamConnection:Disconnect(); freeCamConnection = nil end
    if freeCamInputBeganConn then freeCamInputBeganConn:Disconnect(); freeCamInputBeganConn = nil end
    if freeCamInputEndedConn then freeCamInputEndedConn:Disconnect(); freeCamInputEndedConn = nil end
    freeCamLooking = false
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

function focusFreeCamOnPlayer(targetPlayer)
    if not freeCamEnabled then return end
    local targetCharacter = targetPlayer.Character
    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    followOffset = Vector3.new(0, 5, 15)
    setFollowTarget(targetPlayer)
end

function toggleFreeCam(setActive)
    freeCamEnabled = not freeCamEnabled
    if freeCamEnabled then startFreeCam() else stopFreeCam() end
    setActive(freeCamEnabled)
end

-- ===== ESP =====
function createESPTag(otherPlayer)
    local character = otherPlayer.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    if espTags[otherPlayer] and espTags[otherPlayer].Parent then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPTag"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 120, 0, 48)
    billboard.StudsOffset = Vector3.new(0, 1.2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = otherPlayer.Name
    nameLabel.TextColor3 = ACCENT_ON
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0, 16)
    distanceLabel.Position = UDim2.new(0, 0, 0, 20)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = ""
    distanceLabel.TextColor3 = SUBTEXT_COLOR
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Parent = billboard

    local healthBack = Instance.new("Frame")
    healthBack.Name = "HealthBack"
    healthBack.Position = UDim2.new(0.1, 0, 0, 38)
    healthBack.Size = UDim2.new(0.8, 0, 0, 6)
    healthBack.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    healthBack.BorderSizePixel = 0
    healthBack.Parent = billboard

    local backCorner = Instance.new("UICorner")
    backCorner.CornerRadius = UDim.new(0, 3)
    backCorner.Parent = healthBack

    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(80, 220, 100)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBack

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = healthFill

    espTags[otherPlayer] = billboard
end

function removeESPTag(otherPlayer)
    local billboard = espTags[otherPlayer]
    if billboard then
        billboard:Destroy()
        espTags[otherPlayer] = nil
    end
end

function enableESP()
    espEnabled = true
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then createESPTag(otherPlayer) end
    end
end

function disableESP()
    espEnabled = false
    for otherPlayer in pairs(espTags) do
        removeESPTag(otherPlayer)
    end
end

function toggleESP(setActive)
    if espEnabled then disableESP() else enableESP() end
    setActive(espEnabled)
end

-- ===== SKELETON ESP =====
local skeletonESP = {enabled = false, objects = {}}

local skeletonBonesR6 = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"},
}

local skeletonBonesR15 = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"},
}

function destroySkeleton(otherPlayer)
    local objects = skeletonESP.objects[otherPlayer]
    if objects then
        for _, data in ipairs(objects) do
            if data.adornment then
                data.adornment:Destroy()
            end
        end
        skeletonESP.objects[otherPlayer] = nil
    end
end

function createSkeleton(otherPlayer)
    if otherPlayer == player then return end
    local character = otherPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    destroySkeleton(otherPlayer)

    local bones = humanoid.RigType == Enum.HumanoidRigType.R15 and skeletonBonesR15 or skeletonBonesR6
    local objects = {}

    for _, bone in ipairs(bones) do
        local partA = character:FindFirstChild(bone[1])
        local partB = character:FindFirstChild(bone[2])
        if partA and partB and partA:IsA("BasePart") and partB:IsA("BasePart") then
            local adornment = Instance.new("BoxHandleAdornment")
            adornment.Name = "TheLynoxSkeleton"
            adornment.Adornee = partA
            adornment.AlwaysOnTop = true
            adornment.ZIndex = 10
            adornment.Color3 = ACCENT_ON
            adornment.Transparency = 0.15
            adornment.Size = Vector3.new(0.09, 0.09, 0.1)
            adornment.Parent = partA

            table.insert(objects, {
                adornment = adornment,
                partA = partA,
                partB = partB,
            })
        end
    end

    skeletonESP.objects[otherPlayer] = objects
end

function enableSkeletonESP()
    skeletonESP.enabled = true
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            createSkeleton(otherPlayer)
        end
    end
end

function disableSkeletonESP()
    skeletonESP.enabled = false
    for otherPlayer in pairs(skeletonESP.objects) do
        destroySkeleton(otherPlayer)
    end
end

function toggleSkeletonESP(setActive)
    if skeletonESP.enabled then
        disableSkeletonESP()
    else
        enableSkeletonESP()
    end
    setActive(skeletonESP.enabled)
end

function hookSkeletonRespawn(otherPlayer)
    otherPlayer.CharacterAdded:Connect(function()
        if skeletonESP.enabled then
            task.wait(0.5)
            createSkeleton(otherPlayer)
        end
    end)
end

Players.PlayerAdded:Connect(hookSkeletonRespawn)
for _, otherPlayer in ipairs(Players:GetPlayers()) do
    if otherPlayer ~= player then hookSkeletonRespawn(otherPlayer) end
end
Players.PlayerRemoving:Connect(function(otherPlayer)
    destroySkeleton(otherPlayer)
end)

RunService.RenderStepped:Connect(function()
    if not skeletonESP.enabled then return end

    for otherPlayer, objects in pairs(skeletonESP.objects) do
        for _, data in ipairs(objects) do
            local adornment = data.adornment
            local partA = data.partA
            local partB = data.partB

            if not adornment or not adornment.Parent or not partA or not partA.Parent or not partB or not partB.Parent then
                continue
            end

            local delta = partB.Position - partA.Position
            local length = delta.Magnitude
            if length > 0.01 then
                local worldCFrame = CFrame.lookAt((partA.Position + partB.Position) * 0.5, partB.Position)
                adornment.CFrame = partA.CFrame:ToObjectSpace(worldCFrame)
                adornment.Size = Vector3.new(0.09, 0.09, length)
            end
        end
    end
end)

function hookESPRespawn(otherPlayer)
    otherPlayer.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(0.5)
            createESPTag(otherPlayer)
        end
    end)
end

Players.PlayerAdded:Connect(hookESPRespawn)
for _, otherPlayer in ipairs(Players:GetPlayers()) do
    if otherPlayer ~= player then hookESPRespawn(otherPlayer) end
end
Players.PlayerRemoving:Connect(removeESPTag)

RunService.Heartbeat:Connect(function()
    if not espEnabled then return end
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    for otherPlayer, billboard in pairs(espTags) do
        local otherCharacter = otherPlayer.Character
        local otherRoot = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")
        local distanceLabel = billboard:FindFirstChild("DistanceLabel")
        local otherHumanoid = otherCharacter and otherCharacter:FindFirstChildOfClass("Humanoid")
        local healthBack = billboard:FindFirstChild("HealthBack")
        local healthFill = healthBack and healthBack:FindFirstChild("HealthFill")

        local hpText = ""
        if otherHumanoid and healthFill and otherHumanoid.MaxHealth > 0 then
            local ratio = math.clamp(otherHumanoid.Health / otherHumanoid.MaxHealth, 0, 1)
            healthFill.Size = UDim2.new(ratio, 0, 1, 0)
            healthFill.BackgroundColor3 = Color3.fromHSV(ratio * 0.33, 0.85, 0.95) -- vert -> rouge
            hpText = string.format(" | %d HP", math.floor(otherHumanoid.Health))
        end

        if otherRoot and distanceLabel then
            local distance = math.floor((rootPart.Position - otherRoot.Position).Magnitude)
            distanceLabel.Text = string.format("%d studs%s", distance, hpText)
        end
    end
end)

-- ===== FULLBRIGHT =====
local originalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Ambient = Lighting.Ambient,
}

local function applyFullbright()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    Lighting.Ambient = Color3.fromRGB(200, 200, 200)
end

function toggleFullbright(setActive)
    fullbrightEnabled = not fullbrightEnabled
    if fullbrightEnabled then
        applyFullbright()
    else
        for prop, value in pairs(originalLighting) do
            Lighting[prop] = value
        end
    end
    setActive(fullbrightEnabled)
end

-- Conserve le Fullbright après la mort et le respawn du personnage.
player.CharacterAdded:Connect(function()
    if fullbrightEnabled then
        task.defer(function()
            if fullbrightEnabled then applyFullbright() end
        end)
        task.delay(0.5, function()
            if fullbrightEnabled then applyFullbright() end
        end)
    end
end)

-- Certains jeux réinitialisent Lighting après le respawn : on maintient
-- les réglages tant que l'option reste activée, sans toucher au mode OFF.
task.spawn(function()
    while true do
        task.wait(0.5)
        if fullbrightEnabled then
            applyFullbright()
        end
    end
end)

-- ===== ANTI FLING =====
-- Protection basée sur le système Anti-Fling fourni par l'utilisateur.
-- Intégrée au GUI principal : aucun ScreenGui séparé n'est créé.
local antiFlingEnabled = false
local antiFlingHeartbeat = nil
local antiFlingRender = nil
local antiFlingCharacterConnections = {}
local antiFlingSetupId = 0

local function disconnectAntiFlingConnections()
    if antiFlingHeartbeat then
        antiFlingHeartbeat:Disconnect()
        antiFlingHeartbeat = nil
    end
    if antiFlingRender then
        antiFlingRender:Disconnect()
        antiFlingRender = nil
    end
    for _, connection in ipairs(antiFlingCharacterConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    table.clear(antiFlingCharacterConnections)
end

local function setupAntiFling()
    antiFlingSetupId += 1
    local setupId = antiFlingSetupId

    for _, connection in ipairs(antiFlingCharacterConnections) do
        if connection then connection:Disconnect() end
    end
    table.clear(antiFlingCharacterConnections)

    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    local originalAnchored = rootPart.Anchored

    -- Même logique que le script fourni : limite les vitesses extrêmes.
    antiFlingHeartbeat = antiFlingHeartbeat or RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled or setupId ~= antiFlingSetupId then return end

        local currentCharacter = player.Character
        if not currentCharacter then return end

        local currentRoot = currentCharacter:FindFirstChild("HumanoidRootPart")
        local currentHumanoid = currentCharacter:FindFirstChildOfClass("Humanoid")
        if not currentRoot or not currentHumanoid then return end

        local velocity = currentRoot.AssemblyLinearVelocity
        if velocity.Magnitude > 100 then
            currentRoot.AssemblyLinearVelocity = Vector3.zero
        end

        local angularVelocity = currentRoot.AssemblyAngularVelocity
        if angularVelocity.Magnitude > 50 then
            currentRoot.AssemblyAngularVelocity = Vector3.zero
        end

        local currentPos = currentRoot.Position
        local lastPos = currentRoot:GetAttribute("TheLynoxAntiFlingLastPosition")
        if lastPos then
            local distance = (currentPos - lastPos).Magnitude
            if distance > 50 then
                currentRoot.CFrame = CFrame.new(lastPos)
            end
        end
        currentRoot:SetAttribute("TheLynoxAntiFlingLastPosition", currentRoot.Position)

        if currentRoot.Anchored ~= originalAnchored then
            currentRoot.Anchored = originalAnchored
        end
    end)

    -- Protection renforcée du script fourni.
    antiFlingRender = antiFlingRender or RunService.RenderStepped:Connect(function()
        if not antiFlingEnabled or setupId ~= antiFlingSetupId then return end

        local currentCharacter = player.Character
        local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
        if not currentRoot then return end

        local velocity = currentRoot.AssemblyLinearVelocity
        if velocity.Magnitude > 200 then
            currentRoot.AssemblyLinearVelocity = Vector3.zero
        end

        local angularVelocity = currentRoot.AssemblyAngularVelocity
        if angularVelocity.Magnitude > 100 then
            currentRoot.AssemblyAngularVelocity = Vector3.zero
        end

        local currentPos = currentRoot.Position
        local lastPos = currentRoot:GetAttribute("TheLynoxAntiFlingLastPos")
        if lastPos and (currentPos - lastPos).Magnitude > 100 then
            currentRoot.CFrame = CFrame.new(lastPos)
        end
        currentRoot:SetAttribute("TheLynoxAntiFlingLastPos", currentRoot.Position)
    end)

    -- Conserve les propriétés initiales des pièces, comme dans le script fourni.
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part:SetAttribute("TheLynoxOriginalAnchored", part.Anchored)
            part:SetAttribute("TheLynoxOriginalCanCollide", part.CanCollide)
            part:SetAttribute("TheLynoxOriginalMass", part.AssemblyMass)

            table.insert(antiFlingCharacterConnections, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                if antiFlingEnabled and part.Parent then
                    local original = part:GetAttribute("TheLynoxOriginalAnchored")
                    if original ~= nil and part.Anchored ~= original then
                        part.Anchored = original
                    end
                end
            end))

            table.insert(antiFlingCharacterConnections, part:GetPropertyChangedSignal("CanCollide"):Connect(function()
                if antiFlingEnabled and part.Parent then
                    local original = part:GetAttribute("TheLynoxOriginalCanCollide")
                    if original ~= nil and part.CanCollide ~= original then
                        part.CanCollide = original
                    end
                end
            end))
        end
    end

    -- Reproduit aussi la surveillance de l'état du Humanoid, avec l'API correcte.
    table.insert(antiFlingCharacterConnections, humanoid.StateChanged:Connect(function(_, newState)
        if not antiFlingEnabled then return end
        if newState == Enum.HumanoidStateType.Dead and humanoid.Health > 0 then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end))
end

function toggleAntiFling(setActive)
    antiFlingEnabled = not antiFlingEnabled

    if not antiFlingEnabled then
        disconnectAntiFlingConnections()
    else
        setupAntiFling()
    end

    setActive(antiFlingEnabled)
end

-- Réinitialisation propre après respawn.
player.CharacterAdded:Connect(function()
    if antiFlingEnabled then
        task.wait(0.5)
        setupAntiFling()
    end
end)

-- ===== ANTI-AFK =====
player.Idled:Connect(function()
    if not antiAfkEnabled then return end
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

function toggleAntiAfk(setActive)
    antiAfkEnabled = not antiAfkEnabled
    setActive(antiAfkEnabled)
end

-- ===== MESSAGE AUTO (toutes les 20 secondes) =====
function sendChatMessage(text)
    -- Système de chat moderne (TextChatService)
    local generalChannel = TextChatService.TextChannels and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if generalChannel then
        local ok = pcall(function()
            generalChannel:SendAsync(text)
        end)
        if ok then return end
    end
    -- Repli sur l'ancien système de chat si le jeu ne l'a pas migré
    pcall(function()
        player:Chat(text)
    end)
end

local autoMessageThread = nil

function toggleAutoMessage(setActive)
    autoMessageEnabled = not autoMessageEnabled
    setActive(autoMessageEnabled)

    if autoMessageEnabled then
        autoMessageThread = task.spawn(function()
            while autoMessageEnabled do
                sendChatMessage('("Hello, World!") TheLynoxBot')
                task.wait(20)
            end
        end)
    end
end

-- ===== RESET =====
function resetCharacter()
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = 0 end
    end
end

-- ===== RESPAWN =====
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").WalkSpeed = walkSpeed
    watchVehicleSeat(character)

    if flying then
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
        if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
        startFly(character)
    end

    if hasTPTool then task.defer(buildTPTool) end

    if noclipEnabled then
        task.wait(0.2)
        setNoclipOnCharacter(character, true)
    end

    if checkpointData.activeCFrame then
        local rootPart = character:WaitForChild("HumanoidRootPart")
        -- Laisse le temps au personnage de se stabiliser au spawn par défaut
        -- avant de le téléporter, sinon le serveur peut annuler le téléport
        -- ou le perso peut tomber à travers le sol au nouvel endroit.
        task.wait(0.25)
        rootPart.CFrame = checkpointData.activeCFrame
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

        -- Sécurité : réapplique un peu plus tard au cas où un autre script
        -- du jeu (spawn, cinématique, etc.) repositionnerait le perso après nous
        task.delay(0.5, function()
            if checkpointData.activeCFrame and character.Parent and rootPart.Parent then
                rootPart.CFrame = checkpointData.activeCFrame
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end)
    end

    if crawlEnabled then
        stopCrawl()
        crawlEnabled = true
        startCrawl()
    end

    if ceilingWalkEnabled then
        stopCeilingWalk()
        ceilingWalkEnabled = true
        startCeilingWalk()
    end
end)

if player.Character then
    watchVehicleSeat(player.Character)
end

-- =====================================================================
-- ==========================  UI HELPERS  =============================
-- =====================================================================

function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

function padding(parent, px)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, px)
    p.PaddingBottom = UDim.new(0, px)
    p.PaddingLeft = UDim.new(0, px)
    p.PaddingRight = UDim.new(0, px)
    p.Parent = parent
end

function stroke(parent, color, thickness, transparency)
    local st = Instance.new("UIStroke")
    st.Color = color
    st.Thickness = thickness or 1
    st.Transparency = transparency or 0
    st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    st.Parent = parent
    return st
end

-- Carte : se redimensionne automatiquement selon son contenu
function newCard(page, order, titleText)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = CARD_COLOR
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = page
    corner(card, 10)
    stroke(card, Color3.fromRGB(70, 70, 105), 1, 0.4)
    padding(card, 10)

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 7)
    layout.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "CardTitle"
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText
    titleLabel.TextColor3 = SUBTEXT_COLOR
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.LayoutOrder = 0
    titleLabel.Parent = card

    return card
end

function newSwitch(card, order, text, onToggle)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 34)
    button.BackgroundColor3 = ACCENT_COLOR
    button.Text = ""
    button.TextColor3 = TEXT_COLOR
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = false
    button.LayoutOrder = order
    button.Parent = card
    corner(button, 8)

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -24, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = TEXT_COLOR
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button

    -- Indicateur ON/OFF retiré : l'état est maintenant montré uniquement par la couleur du bouton.
    local isActive, hovering = false, false

    local function refreshColor()
        local base = isActive and ACCENT_ON or ACCENT_COLOR
        if hovering then base = base:Lerp(Color3.new(1, 1, 1), 0.18) end
        label.TextColor3 = isActive and HEADER_COLOR or TEXT_COLOR
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = base}):Play()
    end

    local function setActive(active)
        local changed = (isActive ~= active)
        isActive = active
        refreshColor()
        if changed and not suppressOptionAlert then
            showOptionAlert(text, active and "ON" or "OFF")
        end
    end

    button.MouseEnter:Connect(function() hovering = true; refreshColor() end)
    button.MouseLeave:Connect(function() hovering = false; refreshColor() end)

    button.MouseButton1Click:Connect(function()
        onToggle(setActive)
    end)
    return button
end

-- Bouton "action" : clignote en cyan une seconde puis revient
function newAction(card, order, text, callback)
    return newSwitch(card, order, text, function(setActive)
        callback()
        showOptionAlert(text, nil)
        suppressOptionAlert = true
        setActive(true)
        task.delay(0.8, function()
            setActive(false)
            suppressOptionAlert = false
        end)
    end)
end

function newStepper(card, order, labelText, initialValue, step, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = TEXT_COLOR
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
    valueLabel.Size = UDim2.new(0, 40, 1, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(initialValue)
    valueLabel.TextColor3 = ACCENT_ON
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.Parent = row

    local currentValue = initialValue

    local function makeStepButton(text, xOffset, delta)
        local btn = Instance.new("TextButton")
        btn.Position = UDim2.new(1, xOffset, 0, 2)
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.BackgroundColor3 = ACCENT_COLOR
        btn.Text = text
        btn.TextColor3 = TEXT_COLOR
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.AutoButtonColor = false
        btn.Parent = row
        corner(btn, 8)

        btn.MouseButton1Click:Connect(function()
            currentValue = onChange(currentValue + delta)
            valueLabel.Text = tostring(currentValue)
        end)
    end

    makeStepButton("-", -64, -step)
    makeStepButton("+", -32, step)
end

-- Liste de joueurs cliquable (mise à jour automatique)
function newPlayerList(card, order, onSelect, requireDoubleClick)
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "PlayerSearch"
    searchBox.Size = UDim2.new(1, 0, 0, 30)
    searchBox.BackgroundColor3 = HEADER_COLOR
    searchBox.Text = ""
    searchBox.PlaceholderText = "🔎  Rechercher un joueur..."
    searchBox.TextColor3 = TEXT_COLOR
    searchBox.PlaceholderColor3 = SUBTEXT_COLOR
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 12
    searchBox.ClearTextOnFocus = false
    searchBox.LayoutOrder = order
    searchBox.Parent = card
    corner(searchBox, 8)

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, 0, 0, 120)
    list.BackgroundColor3 = HEADER_COLOR
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.ScrollBarImageColor3 = ACCENT_COLOR
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.LayoutOrder = order + 1
    list.Parent = card
    corner(list, 8)
    padding(list, 4)

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.Name
    layout.Padding = UDim.new(0, 4)
    layout.Parent = list

    local function refresh()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local query = string.lower(searchBox.Text or "")
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local nameMatch = string.find(string.lower(otherPlayer.Name), query, 1, true)
                local displayMatch = string.find(string.lower(otherPlayer.DisplayName), query, 1, true)
                if query == "" or nameMatch or displayMatch then
                    local button = Instance.new("TextButton")
                    button.Name = otherPlayer.Name
                    button.Size = UDim2.new(1, 0, 0, 28)
                    button.BackgroundColor3 = ACCENT_COLOR
                    button.Text = otherPlayer.DisplayName ~= otherPlayer.Name
                        and (otherPlayer.DisplayName .. "  @" .. otherPlayer.Name)
                        or otherPlayer.Name
                    button.TextColor3 = TEXT_COLOR
                    button.Font = Enum.Font.Gotham
                    button.TextSize = 12
                    button.AutoButtonColor = false
                    button.Parent = list
                    corner(button, 6)
                    button.MouseEnter:Connect(function()
                        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = ACCENT_ON}):Play()
                    end)
                    button.MouseLeave:Connect(function()
                        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = ACCENT_COLOR}):Play()
                    end)
                    local lastClickAt = 0
                    button.MouseButton1Click:Connect(function()
                        if requireDoubleClick then
                            local now = os.clock()
                            if now - lastClickAt <= 0.35 then
                                lastClickAt = 0
                                onSelect(otherPlayer)
                                showOptionAlert("Cible : " .. otherPlayer.DisplayName, nil)
                            else
                                lastClickAt = now
                            end
                        else
                            onSelect(otherPlayer)
                            showOptionAlert("Cible : " .. otherPlayer.DisplayName, nil)
                        end
                    end)
                end
            end
        end
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(refresh)
    refresh()
    Players.PlayerAdded:Connect(refresh)
    Players.PlayerRemoving:Connect(function() task.defer(refresh) end)
end

function newInfoLabel(card, order, text, height)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, height or 22)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = ACCENT_ON
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.LayoutOrder = order
    label.Parent = card
    return label
end

-- =====================================================================
-- ==============================  UI  =================================
-- =====================================================================

-- =====================================================================
-- =======================  UI STATE / SETUP  ==========================
-- =====================================================================
local screenGui
local mainFrame
local sidebar
local contentArea
local pages = {}
local tabButtons = {}
local guiConnections = {}
local currentTab = nil

function selectTab(name)
    currentTab = name
    for tabName, page in pairs(pages) do
        local selected = (tabName == name)
        local btn = tabButtons[tabName]
        if page and btn then
            page.Visible = selected
            btn.TextColor3 = selected and TEXT_COLOR or SUBTEXT_COLOR
            local indicator = btn:FindFirstChild("Indicator")
            if indicator then indicator.Visible = selected end
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = selected and ACCENT_COLOR or SIDEBAR_COLOR
            }):Play()
        end
    end
end

-- Ordre personnalise des categories (les autres restent accessibles apres Tuto).
local LYN_CATEGORY_ORDER = {
    ["Recherche"] = 1,
    ["Joueur"] = 2,
    ["SAFETY+"] = 3,
    ["Mouvement"] = 4,
    ["Personnage"] = 5,
    ["Utilitaires"] = 6,
    ["Téléport"] = 7,
    ["Caméra"] = 8,
    ["Visuel"] = 9,
    ["AIM"] = 10,
    ["Backstab"] = 11,
    ["Troll"] = 12,
    ["Animation R6"] = 13,
    ["Animation R15"] = 14,
    ["VEHICLE PRO"] = 15,
    ["KICK Cars"] = 16,
    ["PERFORMANCE"] = 17,
    ["Tuto"] = 18,
}

function newTab(order, name, icon)
    order = LYN_CATEGORY_ORDER[name] or (100 + order)
    -- Evite de creer deux onglets Camera si une extension reutilise le nom.
    if pages[name] and tabButtons[name] then
        tabButtons[name].LayoutOrder = order
        return pages[name]
    end
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 29)
    button.BackgroundColor3 = SIDEBAR_COLOR
    button.Text = icon .. " " .. name
    button.TextColor3 = SUBTEXT_COLOR
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = false
    button.LayoutOrder = order
    button.Parent = sidebar
    corner(button, 8)
    padding(button, 0)
    local pad = button:FindFirstChildOfClass("UIPadding")
    if pad then pad.PaddingLeft = UDim.new(0, 10) end

    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Position = UDim2.new(0, -12, 0.5, -9)
    indicator.Size = UDim2.new(0, 3, 0, 18)
    indicator.BackgroundColor3 = ACCENT_ON
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.Parent = button
    corner(indicator, 2)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = ACCENT_COLOR
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = contentArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page

    pages[name] = page
    tabButtons[name] = button
    button.MouseButton1Click:Connect(function() selectTab(name) end)
    button.MouseEnter:Connect(function()
        if currentTab ~= name then
            TweenService:Create(button, TweenInfo.new(0.12), {BackgroundColor3 = CARD_COLOR}):Play()
        end
    end)
    button.MouseLeave:Connect(function()
        if currentTab ~= name then
            TweenService:Create(button, TweenInfo.new(0.12), {BackgroundColor3 = SIDEBAR_COLOR}):Play()
        end
    end)
    return page
end

function createBaseGUI()
    local playerGui = player:WaitForChild("PlayerGui")

    -- Coupe les anciennes connexions (drag + touche RightShift) pour éviter les doublons au rechargement.
    for _, connection in ipairs(guiConnections) do
        connection:Disconnect()
    end
    table.clear(guiConnections)

    local oldGui = playerGui:FindFirstChild("TheLynoxBotAdminGui")
    if oldGui then oldGui:Destroy() end

    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TheLynoxBotAdminGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 9999
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Enabled = true
    screenGui.Parent = playerGui

    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 530, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -265, 0.5, -210)
    mainFrame.BackgroundColor3 = BG_COLOR
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = true
    mainFrame.Parent = screenGui
    corner(mainFrame, 12)
    stroke(mainFrame, ACCENT_COLOR, 2, 0.35)

    local mainGradient = Instance.new("UIGradient")
    mainGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(195, 195, 215))
    mainGradient.Rotation = 90
    mainGradient.Parent = mainFrame

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.new(1, 1, 1)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    corner(header, 12)

    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new(Color3.fromRGB(88, 56, 170), Color3.fromRGB(24, 24, 38))
    headerGradient.Rotation = 0
    headerGradient.Parent = header

    local headerLine = Instance.new("Frame")
    headerLine.Size = UDim2.new(1, -24, 0, 2)
    headerLine.Position = UDim2.new(0, 12, 0, 41)
    headerLine.BorderSizePixel = 0
    headerLine.BackgroundColor3 = Color3.new(1, 1, 1)
    headerLine.Parent = mainFrame

    local lineGradient = Instance.new("UIGradient")
    lineGradient.Color = ColorSequence.new(ACCENT_COLOR, ACCENT_ON)
    lineGradient.Parent = headerLine

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.RichText = true
    title.Text = 'TheLynox<font color="rgb(34,211,238)">Bot</font> 🐾'
    title.TextColor3 = TEXT_COLOR
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(0, 120, 1, 0)
    hint.Position = UDim2.new(1, -196, 0, 0)
    hint.BackgroundTransparency = 1
    hint.Text = "RightShift ou -"
    hint.TextColor3 = SUBTEXT_COLOR
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 10
    hint.TextXAlignment = Enum.TextXAlignment.Right
    hint.Parent = header

    -- Temps passé dans le jeu (chrono en direct, dans la barre du haut)
    local playtimeLabel = Instance.new("TextLabel")
    playtimeLabel.Name = "PlaytimeLabel"
    playtimeLabel.Size = UDim2.new(0, 130, 1, 0)
    playtimeLabel.Position = UDim2.new(0, 172, 0, 0)
    playtimeLabel.BackgroundTransparency = 1
    playtimeLabel.Text = "⏱ 00:00:00"
    playtimeLabel.TextColor3 = ACCENT_ON
    playtimeLabel.Font = Enum.Font.GothamBold
    playtimeLabel.TextSize = 12
    playtimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    playtimeLabel.Parent = header

    task.spawn(function()
        while playtimeLabel.Parent do
            local elapsed = math.floor(os.clock() - sessionStartClock)
            playtimeLabel.Text = string.format("⏱ %02d:%02d:%02d", elapsed // 3600, (elapsed % 3600) // 60, elapsed % 60)
            task.wait(1)
        end
    end)

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 28, 0, 28)
    closeButton.Position = UDim2.new(1, -36, 0, 6)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "✕"
    closeButton.TextColor3 = SUBTEXT_COLOR
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 15
    closeButton.Parent = header
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 28, 0, 28)
    minimizeButton.Position = UDim2.new(1, -64, 0, 6)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = SUBTEXT_COLOR
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 20
    minimizeButton.Parent = header
    minimizeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    table.insert(guiConnections, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
    table.insert(guiConnections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    table.insert(guiConnections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Minus then
            mainFrame.Visible = not mainFrame.Visible
        end
    end))

    sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = "CategorySidebar"
    sidebar.Size = UDim2.new(0, 142, 1, -58)
    sidebar.Position = UDim2.new(0, 8, 0, 50)
    sidebar.BackgroundColor3 = SIDEBAR_COLOR
    sidebar.BorderSizePixel = 0
    sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
    sidebar.ScrollBarThickness = 3
    sidebar.ScrollBarImageColor3 = ACCENT_COLOR
    sidebar.ClipsDescendants = true
    sidebar.Parent = mainFrame
    corner(sidebar, 10)
    stroke(sidebar, Color3.fromRGB(60, 60, 90), 1, 0.3)
    padding(sidebar, 6)

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 3)
    sidebarLayout.Parent = sidebar

    contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -162, 1, -58)
    contentArea.Position = UDim2.new(0, 154, 0, 50)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    table.clear(pages)
    table.clear(tabButtons)
    currentTab = nil
end

-- Mise à jour continue des éléments visuels (écran + nouveaux personnages).
RunService.RenderStepped:Connect(function()
    if cheatLinesEnabled then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local line = createCheatLine(otherPlayer)
                updateCheatLine(otherPlayer, line)
            end
        end
    end

    if trackerEnabled then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local character = otherPlayer.Character
                local head = character and character:FindFirstChild("Head")
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if character and head and root then
                    if not trackerHighlights[otherPlayer] or not trackerHighlights[otherPlayer].Parent then
                        createTracker(otherPlayer)
                    end

                    local tag = trackerTags[otherPlayer]
                    if tag then
                        local label = tag:FindFirstChildOfClass("TextLabel")
                        if label then
                            local myCharacter = player.Character
                            local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
                            local distance = myRoot and math.floor((root.Position - myRoot.Position).Magnitude) or 0
                            label.Text = string.format("TRACKER  •  %s  •  %dm", otherPlayer.Name, distance)
                        end
                    end
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(otherPlayer)
    removeESPTag(otherPlayer)
    destroySkeleton(otherPlayer)
    removeCheatLine(otherPlayer)
    removeTracker(otherPlayer)
end)

-- ---------------------------------------------------------------------
-- CATÉGORIE : JOUEUR
-- ---------------------------------------------------------------------
function buildPlayerUI()
local playerPage = newTab(1, "Joueur", "👤")

local profileCard = newCard(playerPage, 1, "PROFIL")
profileCard.Size = UDim2.new(1, 0, 0, 116)
profileCard.AutomaticSize = Enum.AutomaticSize.None

-- Place l'avatar, le nom et le pseudo à la main : sans ça, la mise en page automatique de la carte
-- les empilait en dessous et ils passaient derrière la carte suivante (le pseudo n'était pas visible).
local profileLayout = profileCard:FindFirstChildOfClass("UIListLayout")
if profileLayout then profileLayout:Destroy() end

local avatar = Instance.new("ImageLabel")
avatar.Name = "PlayerHead"
avatar.Size = UDim2.new(0, 72, 0, 72)
avatar.Position = UDim2.new(0, 10, 0, 34)
avatar.BackgroundColor3 = HEADER_COLOR
avatar.BorderSizePixel = 0
avatar.Parent = profileCard
corner(avatar, 36)

local ok, avatarUrl = pcall(function()
    return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)
if ok then
    avatar.Image = avatarUrl
end

local displayName = Instance.new("TextLabel")
displayName.Name = "DisplayName"
displayName.Size = UDim2.new(1, -96, 0, 30)
displayName.Position = UDim2.new(0, 94, 0, 38)
displayName.BackgroundTransparency = 1
displayName.Text = player.DisplayName
displayName.TextColor3 = TEXT_COLOR
displayName.Font = Enum.Font.GothamBold
displayName.TextSize = 17
displayName.TextXAlignment = Enum.TextXAlignment.Left
displayName.TextTruncate = Enum.TextTruncate.AtEnd
displayName.Parent = profileCard

local username = Instance.new("TextLabel")
username.Name = "Username"
username.Size = UDim2.new(1, -96, 0, 24)
username.Position = UDim2.new(0, 94, 0, 68)
username.BackgroundTransparency = 1
username.Text = "@" .. player.Name
username.TextColor3 = SUBTEXT_COLOR
username.Font = Enum.Font.Gotham
username.TextSize = 13
username.TextXAlignment = Enum.TextXAlignment.Left
username.TextTruncate = Enum.TextTruncate.AtEnd
username.Parent = profileCard

-- ===== HEURE ET DATE EN DIRECT =====
local clockCard = newCard(playerPage, 2, "HEURE ET DATE")
local timeLabel = newInfoLabel(clockCard, 1, "--:--:--", 30)
timeLabel.TextSize = 24
local dateLabel = newInfoLabel(clockCard, 2, "", 22)
dateLabel.TextColor3 = SUBTEXT_COLOR
dateLabel.Font = Enum.Font.Gotham
dateLabel.TextSize = 14

local joursFr = {"Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"}
local moisFr = {"janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"}

task.spawn(function()
    while timeLabel.Parent do
        local now = os.date("*t")
        timeLabel.Text = string.format("%02d:%02d:%02d", now.hour, now.min, now.sec)
        dateLabel.Text = string.format("%s %d %s %d", joursFr[now.wday], now.day, moisFr[now.month], now.year)
        task.wait(0.5)
    end
end)
end

-- ---------------------------------------------------------------------
-- Marche arriere visuelle : rotation du personnage sans changer les commandes WASD.
backwardVisualEnabled = false
function toggleBackwardVisual(setActive)
    backwardVisualEnabled = not backwardVisualEnabled
    setActive(backwardVisualEnabled)
end
RunService.Heartbeat:Connect(function()
    if not backwardVisualEnabled then return end
    local ch = player.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local root = ch and ch:FindFirstChild("HumanoidRootPart")
    if hum and root and hum.MoveDirection.Magnitude > 0.1 then
        root.CFrame = CFrame.lookAt(root.Position, root.Position - hum.MoveDirection)
    end
end)

-- CATÉGORIE : MOVEMENT
-- ---------------------------------------------------------------------
function buildMovementUI()
local movePage = newTab(2, "Mouvement", "🏃")

local flyCard = newCard(movePage, 1, "FLY")
newSwitch(flyCard, 1, "Activer le vol", toggleFly)
newStepper(flyCard, 2, "Vitesse", flySpeed, 10, function(v)
    flySpeed = math.clamp(v, 10, 300)
    return flySpeed
end)

local speedCard = newCard(movePage, 2, "VITESSE DE MARCHE")
newStepper(speedCard, 1, "WalkSpeed", walkSpeed, 4, setWalkSpeed)

local gravityCard = newCard(movePage, 3, "GRAVITÉ")
newStepper(gravityCard, 1, "Gravity", gravityValue, 10, setGravity)

local jumpCard = newCard(movePage, 4, "SAUT")
newSwitch(jumpCard, 1, "Saut infini", toggleInfiniteJump)
newSwitch(jumpCard, 2, "Float", toggleFloat)
newStepper(jumpCard, 3, "Puissance du saut", checkpointData.jumpPower, 5, function(v)
    checkpointData.jumpPower = math.clamp(v, 0, 300)
    return checkpointData.jumpPower
end)

local noclipCard = newCard(movePage, 5, "COLLISIONS")
newSwitch(noclipCard, 1, "Noclip (traverser les murs)", toggleNoclip)


local ceilingCard = newCard(movePage, 7, "MARCHER AU PLAFOND")
newSwitch(ceilingCard, 1, "Activer (collé au plafond)", toggleCeilingWalk)
newStepper(ceilingCard, 2, "Décalage", ceilingWalkOffset, 0.5, function(v)
    ceilingWalkOffset = math.clamp(v, 0, 8)
    return ceilingWalkOffset
end)

local vehicleCard = newCard(movePage, 8, "VÉHICULE")
newSwitch(vehicleCard, 1, "Vehicle Fly", toggleVehicleFly)
newStepper(vehicleCard, 2, "Vitesse Fly", vehicleFlySpeed, 50, function(v)
    vehicleFlySpeed = math.clamp(v, 10, 1000)
    return vehicleFlySpeed
end)


end


-- CATÉGORIE : PERSONNAGE (postures et déplacements visuels)
function buildPersonnageUI()
    local page = newTab(3, "Personnage", "🧍")
    local ventre = newCard(page, 1, "TOMBER DANS LE VIDE")
    newSwitch(ventre, 1, "Tomber dans le vide (T)", toggleCrawl)
    local cote = newCard(page, 2, "MARCHER SUR LE CÔTÉ (JAMBE / TORSE)")
    newSwitch(cote, 1, "Marcher sur le côté gauche", toggleSideWalk)
    local arriere = newCard(page, 3, "MARCHE ARRIÈRE VISUELLE")
    newSwitch(arriere, 1, "Marcher en arrière (visuel)", toggleBackwardVisual)
    local assis = newCard(page, 4, "S'ASSEOIR / SE RELEVER")
    newSwitch(assis, 1, "S'asseoir / Se relever", toggleSit)
end

-- ---------------------------------------------------------------------
-- CATÉGORIE : TELEPORT
-- ---------------------------------------------------------------------
function buildTeleportUI()
local tpPage = newTab(3, "Téléport", "📍")

local tpPlayerCard = newCard(tpPage, 1, "TÉLÉPORTER VERS UN JOUEUR")
newPlayerList(tpPlayerCard, 1, teleportToPlayer)

local clickTpCard = newCard(tpPage, 2, "TÉLÉPORTATION AU CLIC")
newSwitch(clickTpCard, 1, "Cliquer sur une porte / un mur / un objet = TP", toggleClickTeleport)

local coordCard = newCard(tpPage, 3, "TÉLÉPORTER EN X Y Z")
local coordRow = Instance.new("Frame")
coordRow.Size = UDim2.new(1, 0, 0, 30)
coordRow.BackgroundTransparency = 1
coordRow.LayoutOrder = 1
coordRow.Parent = coordCard

function newCoordBox(xScale, placeholder)
    local box = Instance.new("TextBox")
    box.Position = UDim2.new(xScale, 0, 0, 0)
    box.Size = UDim2.new(0.32, 0, 1, 0)
    box.BackgroundColor3 = HEADER_COLOR
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = TEXT_COLOR
    box.PlaceholderColor3 = SUBTEXT_COLOR
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.ClearTextOnFocus = false
    box.Parent = coordRow
    corner(box, 6)
    return box
end

local xBox = newCoordBox(0, "X")
local yBox = newCoordBox(0.34, "Y")
local zBox = newCoordBox(0.68, "Z")

newAction(coordCard, 2, "Téléporter", function()
    teleportToCoordinates(tonumber(xBox.Text) or 0, tonumber(yBox.Text) or 0, tonumber(zBox.Text) or 0)
end)

local toolCard = newCard(tpPage, 4, "OUTIL TPLYNOX (CLIC = TÉLÉPORTATION)")
newAction(toolCard, 1, "Donner l'outil TPLynox", createTPTool)

checkpointData.buildUI = function(tpPage)
    local card = newCard(tpPage, 5, "CHECKPOINTS NOMMÉS")

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, 0, 0, 32)
    input.BackgroundColor3 = HEADER_COLOR
    input.Text = ""
    input.PlaceholderText = "Nom : Spawn, Boss, Secret..."
    input.TextColor3 = TEXT_COLOR
    input.PlaceholderColor3 = SUBTEXT_COLOR
    input.Font = Enum.Font.Gotham
    input.TextSize = 12
    input.ClearTextOnFocus = false
    input.LayoutOrder = 1
    input.Parent = card
    corner(input, 8)

    newAction(card, 2, "Créer ici", function()
        if setCheckpoint(input.Text) then
            input.Text = ""
        end
    end)

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.AutomaticSize = Enum.AutomaticSize.Y
    list.BackgroundTransparency = 1
    list.LayoutOrder = 3
    list.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.Name = "CheckpointListLayout"
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = list

    checkpointData.refresh = function()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local names = {}
        for name in pairs(checkpointData.points) do
            table.insert(names, name)
        end
        table.sort(names, function(a, b)
            return string.lower(a) < string.lower(b)
        end)

        if #names == 0 then
            local empty = newInfoLabel(list, 1, "Aucun checkpoint sauvegardé.", 22)
            empty.TextColor3 = SUBTEXT_COLOR
            return
        end

        for index, name in ipairs(names) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 34)
            row.BackgroundColor3 = name == checkpointData.activeName and ACCENT_ON or HEADER_COLOR
            row.BorderSizePixel = 0
            row.LayoutOrder = index
            row.Parent = list
            corner(row, 8)

            local nameButton = Instance.new("TextButton")
            nameButton.Size = UDim2.new(1, -140, 1, 0)
            nameButton.BackgroundTransparency = 1
            nameButton.Text = (name == checkpointData.activeName and "✓ " or "📍 ") .. name
            nameButton.TextColor3 = name == checkpointData.activeName and HEADER_COLOR or TEXT_COLOR
            nameButton.Font = Enum.Font.GothamBold
            nameButton.TextSize = 12
            nameButton.TextXAlignment = Enum.TextXAlignment.Left
            nameButton.Parent = row
            padding(nameButton, 8, 0, 0, 0)
            nameButton.MouseButton1Click:Connect(function()
                selectCheckpoint(name)
            end)

            local tpButton = Instance.new("TextButton")
            tpButton.Position = UDim2.new(1, -132, 0, 3)
            tpButton.Size = UDim2.new(0, 58, 0, 28)
            tpButton.BackgroundColor3 = ACCENT_COLOR
            tpButton.Text = "TP"
            tpButton.TextColor3 = TEXT_COLOR
            tpButton.Font = Enum.Font.GothamBold
            tpButton.TextSize = 12
            tpButton.AutoButtonColor = false
            tpButton.Parent = row
            corner(tpButton, 7)
            tpButton.MouseButton1Click:Connect(function()
                teleportToCheckpoint(name)
            end)

            local delButton = Instance.new("TextButton")
            delButton.Position = UDim2.new(1, -68, 0, 3)
            delButton.Size = UDim2.new(0, 62, 0, 28)
            delButton.BackgroundColor3 = Color3.fromRGB(90, 45, 55)
            delButton.Text = "X"
            delButton.TextColor3 = TEXT_COLOR
            delButton.Font = Enum.Font.GothamBold
            delButton.TextSize = 12
            delButton.AutoButtonColor = false
            delButton.Parent = row
            corner(delButton, 7)
            delButton.MouseButton1Click:Connect(function()
                deleteCheckpoint(name)
            end)
        end
    end

    local respawnButton = newAction(card, 4, "RESPAWN AU CHECKPOINT", respawnAtCheckpoint)

    local selectedLabel = newInfoLabel(card, 5, "Checkpoint sélectionné : aucun", 22)

    local oldRefresh = checkpointData.refresh
    checkpointData.refresh = function()
        oldRefresh()
        selectedLabel.Text = "Checkpoint sélectionné : " .. (checkpointData.activeName or "aucun")
    end

    newAction(card, 6, "Effacer tous les checkpoints", clearCheckpoints)
    checkpointData.refresh()
end

checkpointData.buildUI(tpPage)

local posCard = newCard(tpPage, 5, "POSITION ACTUELLE")
local positionLabel = newInfoLabel(posCard, 1, "X: 0 | Y: 0 | Z: 0")

RunService.Heartbeat:Connect(function()
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local pos = rootPart.Position
        positionLabel.Text = string.format("X: %d | Y: %d | Z: %d", pos.X, pos.Y, pos.Z)
    end
end)
end

-- ---------------------------------------------------------------------
-- CATÉGORIE : CAMERA
-- ---------------------------------------------------------------------
function buildCameraUI()
local camPage = newTab(4, "Caméra", "🎥")

local camCard = newCard(camPage, 1, "FREE CAM")
newSwitch(camCard, 1, "Activer (clic droit = regarder)", toggleFreeCam)
newStepper(camCard, 2, "Vitesse", freeCamSpeed, 10, function(v)
    freeCamSpeed = math.clamp(v, 10, 300)
    return freeCamSpeed
end)

local spectateCard = newCard(camPage, 2, "SUIVRE UN JOUEUR (FREE CAM ACTIVE)")
newPlayerList(spectateCard, 1, focusFreeCamOnPlayer)
followLabel = newInfoLabel(spectateCard, 2, "Suivi : aucun")
newAction(spectateCard, 3, "Arrêter le suivi", function()
    setFollowTarget(nil)
end)
end

-- ---------------------------------------------------------------------
-- CATÉGORIE : VISUAL
-- ---------------------------------------------------------------------
function buildVisualUI()
local visualPage = newTab(5, "Visuel", "👁")

local espCard = newCard(visualPage, 1, "ESP (NOMS + DISTANCE)")
newSwitch(espCard, 1, "Activer l'ESP", toggleESP)

local linesCard = newCard(visualPage, 2, "CHEAT LINES")
newSwitch(linesCard, 1, "Lignes vers tous les joueurs", toggleCheatLines)

local trackerCard = newCard(visualPage, 3, "TRACKER")
newSwitch(trackerCard, 1, "Tracker joueurs (surbrillance + distance)", toggleTracker)

local skeletonCard = newCard(visualPage, 4, "SKELETON ESP")
newSwitch(skeletonCard, 1, "Voir le squelette à travers les murs", toggleSkeletonESP)

local fullbrightCard = newCard(visualPage, 5, "LUMINOSITÉ")
newSwitch(fullbrightCard, 1, "Fullbright", toggleFullbright)
end

-- ---------------------------------------------------------------------
-- CATÉGORIE : UTILITIES
-- ---------------------------------------------------------------------
function buildUtilitiesUI()
local utilPage = newTab(6, "Utilitaires", "🛠")

local afkCard = newCard(utilPage, 1, "ANTI-AFK")
newSwitch(afkCard, 1, "Activer l'anti-AFK", toggleAntiAfk)

local antiFlingCard = newCard(utilPage, 2, "ANTI FLING")
newSwitch(antiFlingCard, 1, "ANTI FLING", toggleAntiFling)

local autoMsgCard = newCard(utilPage, 3, "MESSAGE AUTO (TOUTES LES 20S)")
newSwitch(autoMsgCard, 1, 'Envoyer "Hello, World! TheLynoxBot"', toggleAutoMessage)

local resetCard = newCard(utilPage, 4, "PERSONNAGE")
newAction(resetCard, 1, "Se re-spawn", resetCharacter)

local reloadCard = newCard(utilPage, 7, "RECHARGER LE PANEL")
newAction(reloadCard, 1, "Recharger le panel maintenant", function()
    task.defer(reloadGUI)
end)

local killAuraCard = newCard(utilPage, 8, "KILL AURA (ARME AUTO QUAND UN JOUEUR S'APPROCHE)")
newSwitch(killAuraCard, 1, "Activer le Kill Aura", toggleKillAura)
newStepper(killAuraCard, 2, "Portée (studs)", killAuraRange, 5, function(v)
    killAuraRange = math.clamp(v, 5, 200)
    return killAuraRange
end)

local serverCard = newCard(utilPage, 5, "SERVER INFO")
local serverInfoLabel = newInfoLabel(serverCard, 1, "Joueurs: -\nPing: -\nSession: -", 56)
serverInfoLabel.TextSize = 12

local shortcutsCard = newCard(utilPage, 6, "RACCOURCIS CLAVIER")
local shortcutsLabel = newInfoLabel(shortcutsCard, 1,
    "⌨  RightShift / - : afficher ou masquer le panel\n" ..
    "✈  Fly : W A S D + Espace / Shift\n" ..
    "🚗  Vehicle Fly : W A S D + Espace / Shift + E / Q\n" ..
    "🎥  FreeCam : clic droit pour regarder", 78)
shortcutsLabel.TextColor3 = TEXT_COLOR
shortcutsLabel.Font = Enum.Font.Gotham
shortcutsLabel.TextSize = 12

local sessionStartTime = os.clock()
local serverInfoTimer = 0

RunService.Heartbeat:Connect(function(dt)
    serverInfoTimer += dt
    if serverInfoTimer < 1 then return end
    serverInfoTimer = 0

    local pingMs = math.floor(player:GetNetworkPing() * 1000)
    local elapsed = math.floor(os.clock() - sessionStartTime)
    serverInfoLabel.Text = string.format(
        "Joueurs: %d/%d\nPing: %d ms\nSession: %dm %ds",
        #Players:GetPlayers(), Players.MaxPlayers, pingMs, math.floor(elapsed / 60), elapsed % 60
    )
end)
end

-- ---------------------------------------------------------------------
-- CATÉGORIE : TROLL
-- ---------------------------------------------------------------------
function buildTrollUI()
local trollPage = newTab(7, "Troll", "😈")

-- En-tête dédié, cohérent avec le thème violet/cyan du panneau.
local trollHero = newCard(trollPage, 0, "😈  TROLL ZONE  •  THELYNOXBOT")
local trollHeroText = Instance.new("TextLabel")
trollHeroText.Name = "TrollIntroduction"
trollHeroText.Size = UDim2.new(1, 0, 0, 44)
trollHeroText.BackgroundTransparency = 1
trollHeroText.TextColor3 = TEXT_COLOR
trollHeroText.TextWrapped = true
trollHeroText.TextXAlignment = Enum.TextXAlignment.Left
trollHeroText.Font = Enum.Font.GothamMedium
trollHeroText.TextSize = 13
trollHeroText.Text = "✨ Choisis un joueur dans chaque carte pour lancer l'action. Utilise Arrêter pour interrompre un effet."
trollHeroText.LayoutOrder = 1
trollHeroText.Parent = trollHero

local function styleTrollCard(card, index)
    card.BackgroundColor3 = Color3.fromRGB(39, 32, 63)
    local edge = card:FindFirstChildOfClass("UIStroke")
    if edge then
        edge.Color = index % 2 == 0 and ACCENT_ON or ACCENT_COLOR
        edge.Transparency = 0.55
        edge.Thickness = 1.2
    end
    local heading = card:FindFirstChild("CardTitle")
    if heading then
        heading.TextColor3 = index % 2 == 0 and ACCENT_ON or Color3.fromRGB(197, 169, 255)
        heading.TextSize = 13
    end
end
styleTrollCard(trollHero, 0)

local trollCard = newCard(trollPage, 1, "SAUTER SUR LA TÊTE (2S)")
newPlayerList(trollCard, 1, jumpOnPlayer)
newAction(trollCard, 2, "Arrêter", stopJumpOnPlayer)

local trollBackCard = newCard(trollPage, 2, "SE TP SUR SON DOS (20S)")
newPlayerList(trollBackCard, 1, backRidePlayer)
newAction(trollBackCard, 2, "Arrêter", stopBackRide)

local trollBlockCard = newCard(trollPage, 3, "BLOQUER LA VUE + DANSE (20S)")
newPlayerList(trollBlockCard, 1, blockAndDance)
newAction(trollBlockCard, 2, "Arrêter", stopBlockAndDance)

local trollCircleCard = newCard(trollPage, 4, "CERCLE AUTOUR D'EUX (20S)")
newPlayerList(trollCircleCard, 1, circleAroundPlayer)
newAction(trollCircleCard, 2, "Arrêter", stopCircle)

local trollShadowCard = newCard(trollPage, 5, "OMBRE : LE SUIVRE À DISTANCE (20S)")
newPlayerList(trollShadowCard, 1, shadowPlayer)
newAction(trollShadowCard, 2, "Arrêter", stopShadow)

local trollMirrorCard = newCard(trollPage, 6, "MIROIR : COPIER SES MOUVEMENTS")
newPlayerList(trollMirrorCard, 1, mirrorPlayer)
newAction(trollMirrorCard, 2, "Arrêter", stopMirror)

local trollTpSpamCard = newCard(trollPage, 7, "TP SPAM AUTOUR DE LUI (15S)")
newPlayerList(trollTpSpamCard, 1, tpSpamAroundPlayer)
newAction(trollTpSpamCard, 2, "Arrêter", stopTpSpam)

local trollCageCard = newCard(trollPage, 8, "CAGE : 4 BLOCS AUTOUR DE LUI (25S)")
newPlayerList(trollCageCard, 1, cageAroundPlayer)
newAction(trollCageCard, 2, "Arrêter", stopCage)

local trollWaveCard = newCard(trollPage, 9, "SALUEUR RANDOM (WAVE TOUTES LES 5-10S)")
newPlayerList(trollWaveCard, 1, randomWaveAtPlayer)
newAction(trollWaveCard, 2, "Arrêter", stopRandomWave)

local trollJumperCard = newCard(trollPage, 10, "SAUTEUR : SAUTE À CÔTÉ DE LUI (20S)")
newPlayerList(trollJumperCard, 1, jumpBesidePlayer)
newAction(trollJumperCard, 2, "Arrêter", stopJumper)

local trollFakeDeathCard = newCard(trollPage, 11, "FAUX MORT DEVANT LUI (8S)")
newPlayerList(trollFakeDeathCard, 1, fakeDeathInFrontOf)
newAction(trollFakeDeathCard, 2, "Arrêter", stopFakeDeath)

local trollFireCard = newCard(trollPage, 12, "TIR (15 DÉGÂTS, COOLDOWN 4S)")
newPlayerList(trollFireCard, 1, fireAtPlayer)

local trollSpinCard = newCard(trollPage, 13, "SPIN (3S)")
newPlayerList(trollSpinCard, 1, spinAroundPlayer)
newAction(trollSpinCard, 2, "Arrêter", stopSpin)

local statsCard = newCard(trollPage, 14, "STATISTIQUES DE TIR")
statsLabel = newInfoLabel(statsCard, 1, "Tirs réussis: 0\nDégâts totaux: 0", 40)
newAction(statsCard, 2, "Réinitialiser", function()
    shotsHit = 0
    totalDamageDealt = 0
    updateStatsLabel()
end)
for i, card in ipairs({trollCard, trollBackCard, trollBlockCard, trollCircleCard,
    trollShadowCard, trollMirrorCard, trollTpSpamCard, trollCageCard,
    trollWaveCard, trollJumperCard, trollFakeDeathCard, trollFireCard,
    trollSpinCard, statsCard}) do
    styleTrollCard(card, i)
end
end

-- ---------------------------------------------------------------------
-- CATÉGORIE : BACKSTAB
-- ---------------------------------------------------------------------
-- Pas de bouton : un clic sur un joueur de la liste lance directement l'effet (2 secondes).
function buildBackstabUI()
local backstabPage = newTab(8, "Backstab", "🗡")

local backstabCard = newCard(backstabPage, 1, "BACKSTAB (CLIQUE SUR UN JOUEUR = GLITCH 2S)")
newPlayerList(backstabCard, 1, backstabPlayer, true)

local backstabBlockCard = newCard(backstabPage, 2, "BLOQUER LA VUE + DANSE (20S)")
newPlayerList(backstabBlockCard, 1, blockAndDance)
newAction(backstabBlockCard, 2, "Arrêter", stopBlockAndDance)
end

-- ---------------------------------------------------------------------
-- CATÉGORIE : EMOTES
-- ---------------------------------------------------------------------
function buildEmotesUI()
    local emotesR6 = {
        {name = "Head Throw",     id = 35154961,   speed = 1,    looped = true},
        {name = "Floating Head",  id = 121572214,  speed = 1,    looped = true},
        {name = "Crouch",         id = 182724289,  speed = 1,    looped = true},
        {name = "Floor Crawl",    id = 282574440,  speed = 1,    looped = true},
        {name = "Dino Walk",      id = 204328711,  speed = 1,    looped = true},
        {name = "Jumping Jacks",  id = 429681631,  speed = 1,    looped = true},
        {name = "Hero Jump",      id = 184574340,  speed = 1,    looped = true},
        {name = "Faint",          id = 181526230,  speed = 1,    looped = true},
        {name = "Floor Faint",    id = 181525546,  speed = 2,    looped = true},
        {name = "Super Faint",    id = 181525546,  speed = 0.5,  looped = true},
        {name = "Levitate",       id = 313762630,  speed = 1,    looped = true},
        {name = "Goofy Dance",    id = 182491037,  speed = 1,    looped = true}, -- danse classique R6
        {name = "Dab",            id = 183412246,  speed = 1,    looped = true},
        {name = "Spinner",        id = 188632011,  speed = 2,    looped = true},
        {name = "Float Sit",      id = 179224234,  speed = 1,    looped = true},
        {name = "Weird Move",     id = 215384594,  speed = 1,    looped = true},
        {name = "Clone Illusion", id = 215384594,  speed = 1e7,  looped = true},
        {name = "Glitch Levitate",id = 313762630,  speed = 1e7,  looped = true},
        {name = "Spin Dance",     id = 429730430,  speed = 1,    looped = true},
        {name = "Moon Dance",     id = 45834924,   speed = 1,    looped = true},
        {name = "Spin Dance 2",   id = 186934910,  speed = 1,    looped = true},
        {name = "Bow Down",       id = 204292303,  speed = 3,    looped = true},
        {name = "Sword Slam",     id = 204295235,  speed = 1,    looped = true},
        {name = "Loop Slam",      id = 204295235,  speed = 1e4,  looped = true},
        {name = "Mega Insane",    id = 184574340,  speed = 40,   looped = true},
        {name = "Super Punch",    id = 126753849,  speed = 3,    looped = true},
        {name = "Arm Turbine",    id = 259438880,  speed = 1e3,  looped = true},
        {name = "Barrel Roll",    id = 136801964,  speed = 1,    looped = true},
        {name = "Scared",         id = 180612465,  speed = 1,    looped = true},
        {name = "Insane",         id = 33796059,   speed = 1e8,  looped = true},
        {name = "Arm Detach",     id = 33169583,   speed = 1,    looped = true},
        {name = "Sword Slice",    id = 35978879,   speed = 1,    looped = true},
        {name = "Insane Arms",    id = 27432691,   speed = 1,    looped = true},
        {name = "/EdanceOUH",     id = 182435998,  speed = 1,    looped = true},
        {name = "/Edance 2013",   id = 182436842,  speed = 1,    looped = true},
        {name = "/EdanceYAY",     id = 182436935,  speed = 1,    looped = true},
        {name = "Moving Dance\nWARNING | DOUBLE CLICK", id = 429703734, speed = 1, looped = true},
        {name = "Full Punch\nWARNING | DOUBLE CLICK",   id = 204062532, speed = 1, looped = true},
        {name = "Full Swing\nWARNING | DOUBLE CLICK",   id = 218504594, speed = 1, looped = true},
        {name = "Laugh",          id = 129423131,  speed = 1,    looped = true},
        {name = "Cheer",          id = 129423030,  speed = 1,    looped = true},
        {name = "Point",          id = 128853357,  speed = 1,    looped = true},
        {name = "Wave",           id = 128777973,  speed = 1,    looped = true},
    }

    -- R15 : animations R15 complètes restaurées
    local emotesR15 = {
        {name = "Piano Hands", id = 16553163212, speed = 1, looped = true},
        {name = "Wave",        id = 12521004586, speed = 1, looped = true},
        {name = "Point",       id = 12521007694, speed = 1, looped = true},
        {name = "/edanceOUH",  id = 12521009666, speed = 1, looped = true},
        {name = "Laugh",       id = 12521018724, speed = 1, looped = true},
        {name = "Cheer",       id = 12521021991, speed = 1, looped = true},
        {name = "/Edance2013", id = 507776043,   speed = 1, looped = true},
        {name = "Patrol",      id = 1151231493,  speed = 1, looped = true},
        {name = "Cowboy",      id = 1014421541,  speed = 1, looped = true},
        {name = "Sneaky",      id = 1132510133,  speed = 1, looped = true},
        {name = "PopStar",     id = 1212980338,  speed = 1, looped = true},
        {name = "Confident",   id = 1070017263,  speed = 1, looped = true},
        {name = "SuperHero",   id = 567356407,   speed = 1, looped = true},
        {name = "Zombie Attack", id = 708553116, speed = 1, looped = true},
        {name = "Pull",        id = 675025795,   speed = 1, looped = true},
        {name = "Fling Arms",  id = 754656200,   speed = 1, looped = true},
        {name = "Spinner",     id = 754658275,   speed = 1, looped = true},
        {name = "Rotate Slash",id = 675025570,   speed = 1, looped = true},
        {name = "Bend",        id = 696096087,   speed = 1, looped = true},
    }

    local emoteIdleColor = Color3.fromRGB(45, 30, 90)
    local emoteActiveColor = Color3.fromRGB(70, 60, 220)

    local function createEmoteCard(parentPage, title, emotes, layoutOrder)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 0)
        card.AutomaticSize = Enum.AutomaticSize.Y
        card.BackgroundColor3 = CARD_COLOR
        card.BorderSizePixel = 0
        card.LayoutOrder = layoutOrder
        card.Parent = parentPage
        corner(card, 10)
        stroke(card, Color3.fromRGB(70, 70, 105), 1, 0.4)
        padding(card, 10)

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 0, 20)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title .. " (" .. #emotes .. ")"
        titleLabel.TextColor3 = TEXT_COLOR
        titleLabel.Font = Enum.Font.GothamBlack
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.LayoutOrder = 0
        titleLabel.Parent = card

        local grid = Instance.new("Frame")
        grid.Size = UDim2.new(1, 0, 0, 0)
        grid.AutomaticSize = Enum.AutomaticSize.Y
        grid.BackgroundTransparency = 1
        grid.LayoutOrder = 1
        grid.Parent = card

        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.CellSize = UDim2.new(0.30, 0, 0, 38) -- 3 emotes par ligne, largeur responsive
        gridLayout.CellPadding = UDim2.new(0, 6, 0, 7)
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        gridLayout.Parent = grid

        for i, emote in ipairs(emotes) do
            local emoteButton = Instance.new("TextButton")
            emoteButton.Name = emote.name:gsub("%s+", ""):gsub("\n", "") .. "Button"
            emoteButton.BackgroundColor3 = emoteIdleColor
            emoteButton.Text = emote.name
            emoteButton.TextColor3 = TEXT_COLOR
            emoteButton.Font = Enum.Font.GothamBold
            emoteButton.TextSize = 12
            emoteButton.TextWrapped = true
            emoteButton.AutoButtonColor = false
            emoteButton.LayoutOrder = i
            emoteButton.Parent = grid
            corner(emoteButton, 6)

            if emote.name:find("WARNING", 1, true) then
                local lastClickTime = 0
                local DOUBLE_CLICK_WINDOW = 0.45

                emoteButton.MouseButton1Click:Connect(function()
                    local now = os.clock()
                    if now - lastClickTime <= DOUBLE_CLICK_WINDOW then
                        lastClickTime = 0
                        playEmote(emote, emoteButton, emoteIdleColor, emoteActiveColor)
                    else
                        lastClickTime = now
                    end
                end)
            else
                emoteButton.MouseButton1Click:Connect(function()
                    playEmote(emote, emoteButton, emoteIdleColor, emoteActiveColor)
                end)
            end
        end
    end

    -- Deux catégories séparées, comme avant.
    local r6Page = newTab(9, "Animation R6", "🎮")
    createEmoteCard(r6Page, "ANIMATION R6", emotesR6, 1)
    local r15Page = newTab(10, "Animation R15", "🎭")
    createEmoteCard(r15Page, "ANIMATION R15", emotesR15, 1)
end


-- ---------------------------------------------------------------------
-- CATÉGORIE : TUTORIEL / GUIDE D'UTILISATION
-- ---------------------------------------------------------------------
function buildTutorialUI()
    local tutorialPage = newTab(999, "Tuto", "📘")

    local function guideCard(order, titleText, bodyText)
        local card = newCard(tutorialPage, order, titleText)
        local label = newInfoLabel(card, 1, bodyText, 0)
        label.TextColor3 = TEXT_COLOR
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextWrapped = true
        label.AutomaticSize = Enum.AutomaticSize.Y
        label.Size = UDim2.new(1, 0, 0, 0)
        return card
    end

    guideCard(1, "BIENVENUE — COMMENT UTILISER LE PANEL",
        "Le menu à gauche contient toutes les catégories. Clique sur un onglet, puis sur un bouton pour activer une fonction. Les boutons à bascule activent/désactivent une option ; les boutons d'action lancent une action ponctuelle. Les réglages avec + et - changent la valeur. Fais défiler le contenu vers le bas pour voir toutes les options.")

    guideCard(2, "RACCOURCIS CLAVIER — À RETENIR",
        "• RightShift ou - : afficher/masquer le panel.\n" ..
        "• T : activer/désactiver « Tomber dans le vide » (mode ramper). Le bouton correspondant dans Personnage permet aussi de le basculer.\n" ..
        "• Fly : W/A/S/D pour se déplacer, Espace pour monter, Shift gauche pour descendre.\n" ..
        "• Vehicle Fly : W/A/S/D, Espace ou E pour monter, Shift gauche/droite ou Q pour descendre.\n" ..
        "• FreeCam : maintenir le clic droit et déplacer la souris pour regarder. Les déplacements de FreeCam utilisent les commandes de mouvement prévues par le script.")

    guideCard(3, "JOUEUR",
        "• Profil : affiche ton avatar, ton nom et ton pseudo.\n" ..
        "• Heure et date : horloge et date locales.\n" ..
        "• Chronomètre de session : temps écoulé depuis le lancement du script (également dans l'en-tête).")

    guideCard(4, "MOUVEMENT",
        "• Activer le vol (Fly) : active le vol ; règle sa vitesse avec +/-.\n" ..
        "• WalkSpeed : règle la vitesse de marche.\n" ..
        "• Gravity : règle la gravité utilisée par le jeu.\n" ..
        "• Saut infini : permet de relancer un saut en l'air. Float : active le flottement. Puissance du saut : ajuste la valeur.\n" ..
        "• Noclip : tente de traverser les murs.\n" ..
        "• Marcher au plafond : active/désactive le déplacement au plafond ; Décalage règle la distance. La rotation suit la direction de la caméra dans la version corrigée.\n" ..
        "• Vehicle Fly : vol en véhicule ; règle la vitesse avec +/-.\n" ..
        "• Les postures spéciales ont été déplacées dans Personnage.")

    guideCard(19, "PERSONNAGE — POSTURES",
        "• Tomber dans le vide : active le mode anciennement appelé Marcher sur le ventre, également accessible avec T.\n" ..
        "• Marcher sur le côté gauche : utilise le mode couché sur le côté (jambe et torse).\n" ..
        "• Marche arrière visuelle : oriente le personnage à l'opposé du déplacement.\n" ..
        "• S'asseoir / Se relever : alterne la position assise et debout.\n" ..
        "• Évite d'activer plusieurs postures simultanément ; désactive une posture avant de changer.")

    guideCard(5, "TÉLÉPORT",
        "• Téléporter vers un joueur : recherche un joueur puis clique sur son nom.\n" ..
        "• Téléportation au clic : active le mode puis clique sur une surface/objet visé pour tenter de s'y téléporter.\n" ..
        "• Téléporter en X Y Z : saisis les coordonnées puis clique sur Téléporter.\n" ..
        "• Outil TPLynox : crée l'outil de téléportation indiqué.\n" ..
        "• Checkpoints nommés : saisis un nom et crée un checkpoint à ta position ; sélectionne-le, utilise TP pour y aller, X pour le supprimer. Les boutons permettent aussi de respawn au checkpoint ou d'effacer tous les checkpoints.\n" ..
        "• Position actuelle : affiche les coordonnées X/Y/Z du personnage.")

    guideCard(6, "CAMÉRA",
        "• Free Cam : active/désactive la caméra libre ; règle sa vitesse. Le clic droit sert à regarder/déplacer l'orientation.\n" ..
        "• Spectate : sélectionne un joueur dans la liste pour suivre son personnage. « Arrêter spectate » restaure la caméra.\n" ..
        "• Orbite : tourne autour du joueur sélectionné lorsque le suivi est actif.")

    guideCard(7, "VISUEL",
        "• ESP : affiche les noms et distances des autres joueurs.\n" ..
        "• Cheat Lines : affiche des lignes vers les joueurs.\n" ..
        "• Tracker : surbrillance et distance des joueurs.\n" ..
        "• Skeleton ESP : affiche le squelette des personnages.\n" ..
        "• Fullbright : augmente la luminosité visuelle.\n" ..
        "• AIM (après Visuel) : Crosshair, FOV, distance et visée assistée en maintenant le clic droit.\n" ..
        "• AIM : maintiens clic droit pour viser ; ajuste le rayon et la douceur.\n" ..
        "• Le mode AIM déplace seulement la caméra : il ne tire pas automatiquement.")

    guideCard(8, "UTILITAIRES",
        "• Anti-AFK : empêche certaines détections d'inactivité.\n" ..
        "• Anti Fling : tente de protéger le personnage contre les projections physiques.\n" ..
        "• Message auto : active l'envoi périodique du message affiché sur le bouton.\n" ..
        "• Se re-spawn : réinitialise le personnage.\n" ..
        "• Server Info : joueurs connectés, ping et durée de session.\n" ..
        "• Recharger le panel : reconstruit l'interface.\n" ..
        "• Kill Aura : active l'action automatique configurée et règle sa portée avec +/-. Vérifie les règles de ton propre jeu avant de l'utiliser.")

    guideCard(9, "TROLL ET BACKSTAB",
        "• Dans Troll, sélectionne un joueur dans la liste pour lancer l'action associée : saut sur sa tête, se téléporter sur son dos, bloquer la vue/danser, tourner autour, le suivre à distance, copier ses mouvements, TP spam, cage, salut aléatoire, sauter à côté, faux mort, tir ou spin.\n" ..
        "• Quand un bouton « Arrêter » est présent, clique dessus pour arrêter l'effet correspondant. Les durées sont indiquées dans les titres.\n" ..
        "• Backstab : clique deux fois rapidement sur un joueur dans la liste pour lancer l'effet bref. L'autre option permet de bloquer la vue/danser ; utilise Arrêter pour interrompre cet effet.")

    guideCard(10, "ANIMATION R6 / ANIMATION R15",
        "Choisis l'onglet correspondant au rig de ton avatar (R6 ou R15), puis clique sur une animation pour la lancer. Certaines animations spéciales demandent un double-clic ; si une animation ne fonctionne pas, le rig ou les permissions/ressources du jeu peuvent ne pas être compatibles.")

    guideCard(11, "🚗 KICK CARS — COMMENT UTILISER",
        "• Va dans KICK Cars, puis utilise la barre de recherche pour trouver un joueur par son pseudo ou son nom affiché.\n" ..
        "• Clique sur le joueur dans la liste violette pour le sélectionner comme cible.\n" ..
        "• Monte dans une voiture avec un VehicleSeat, puis clique sur DÉMARRER pour lancer les charges vers la cible. La vitesse est fixée à 8000 et n'est pas modifiable.\n" ..
        "• Clique sur ARRÊTER pour stopper KICK Cars. Change de joueur dans la liste pour sélectionner une autre cible.\n" ..
        "• Le bouton SPAWN CARS te téléporte directement aux coordonnées X : 631, Y : 97, Z : 2502, même sans être assis dans une voiture.\n" ..
        "• Attention : les déplacements et collisions de voiture dépendent de la physique et de la propriété réseau Roblox. Les impacts sur les autres joueurs ne sont pas garantis avec un LocalScript seul.")

    guideCard(13, "CAMÉRA — NOUVELLES OPTIONS",
        "• Free Cam : déplace la caméra librement ; règle la vitesse dans la catégorie Caméra.\n" ..
        "• Spectate : sélectionne un joueur pour suivre sa caméra ; Arrêter spectate restaure la caméra du personnage.\n" ..
        "• Orbite : fait tourner le personnage autour du joueur sélectionné lorsque le spectate est actif.\n" ..
        "• Le mode Caméra véhicule se règle séparément dans VEHICLE PRO.")

    guideCard(14, "VEHICLE PRO — CONDUITE",
        "• Compteur vitesse : affiche la vitesse du véhicule dans un petit HUD.\n" ..
        "• Régulateur : active une vitesse cible, ajustable avec le réglage de vitesse.\n" ..
        "• Caméra véhicule : ajuste la caméra pendant la conduite.\n" ..
        "• Limite vitesse locale : configure la limite de vitesse appliquée par l'extension.\n" ..
        "• Les résultats peuvent dépendre du véhicule et de la physique du serveur.")

    guideCard(15, "PERFORMANCE — FPS, PING, JOUEURS",
        "• Afficher FPS / Ping / Joueurs : active le HUD de performances en haut à droite, légèrement décalé vers la gauche.\n" ..
        "• FPS : nombre approximatif d'images par seconde. Ping : latence réseau. Joueurs : effectif du serveur.\n" ..
        "• Mode FPS : réduit localement certains effets de particules et traînées.\n" ..
        "• Diagnostic : indique si le GUI, le Humanoid et la pièce principale du personnage sont présents.")

    guideCard(16, "SAFETY+ — ALERTES ET RÉPARATION",
        "• Alerte joueur proche : affiche une notification quand un joueur entre dans la zone détectée.\n" ..
        "• Alerte forte chute : avertit lors de certaines chutes.\n" ..
        "• Historique des dégâts : enregistre les baisses de PV observées localement ; le bouton affiche les dernières.\n" ..
        "• Rétablir caméra et marche : remet la caméra sur ton personnage et restaure la marche normale.")

    guideCard(17, "ORGANISATION DES ONGLETS",
        "Ordre du menu : Recherche, Joueur, SAFETY+, Mouvement, Personnage, Utilitaires, Téléport, Caméra, Visuel, AIM, Backstab, Troll, Animation R6, Animation R15, VEHICLE PRO, KICK Cars, puis les autres catégories en dessous.\n" ..
        "Les catégories PLAYER+, TP PRO et CUSTOMIZER restent supprimées. Les anciennes fonctions des autres onglets sont conservées.")

    guideCard(18, "SI UNE OPTION NE FONCTIONNE PAS",
        "Certaines fonctions dépendent du type de personnage (R6/R15), des collisions, du serveur et des permissions du jeu. Teste dans ton propre jeu Roblox Studio. Si le personnage reste bloqué après un mode de mouvement, désactive d'abord ce mode, puis réinitialise le personnage si nécessaire. Le tutoriel décrit les fonctions présentes dans cette version ; il ne garantit pas que chaque action soit prise en charge par tous les jeux.")
end

-- =====================================================================
-- ===========================  START GUI  ==============================
-- =====================================================================

-- ===== KICK CARS : physique locale intégrée au panel =====
local kickTarget, kickRunning, kickConnection = nil, false, nil
local kickSpeed = 8000
local KICK_HITS_PER_SECOND = 12
local KICK_TELEPORT_CHANCE = 0.99
local KICK_TURN_CHANCE = 0.80
local KICK_APPROACH_DISTANCE = 20
local KICK_UNDER_OFFSET = -0.9

local function kickRoot(p)
    local character = p and p.Character
    return character and character:FindFirstChild('HumanoidRootPart')
end

local function kickSeat()
    local character = player.Character
    local hum = character and character:FindFirstChildOfClass('Humanoid')
    local seat = hum and hum.SeatPart
    if seat and seat:IsA('VehicleSeat') then return seat end
end

local kickButton, kickStatus
local function stopKickCars()
    kickRunning = false
    if kickConnection then kickConnection:Disconnect(); kickConnection = nil end
    local seat = kickSeat()
    if seat then
        seat.AssemblyLinearVelocity = Vector3.zero
        seat.AssemblyAngularVelocity = Vector3.zero
    end
    if kickButton and kickButton.Parent then
        kickButton.Text = '▶  GO  •  DÉMARRER'
        kickButton.BackgroundColor3 = ACCENT_COLOR
    end
end

local function startKickCars()
    local seat, tr = kickSeat(), kickRoot(kickTarget)
    if not seat then kickStatus.Text = 'Assieds-toi dans un VehicleSeat.'; return end
    if not tr then kickStatus.Text = 'Sélectionne un joueur présent.'; return end
    stopKickCars()
    kickRunning = true
    kickButton.Text = '■  STOP  •  ARRÊTER'
    kickButton.BackgroundColor3 = Color3.fromRGB(112, 55, 170)
    kickStatus.Text = '12 grandes charges/s • puissance 8000'
    local elapsed, charging, chargeUntil = 0, false, 0
    local spinDirection = 1
    kickConnection = RunService.Heartbeat:Connect(function(dt)
        local s, t = kickSeat(), kickRoot(kickTarget)
        if not s or not t then
            stopKickCars()
            if kickStatus and kickStatus.Parent then kickStatus.Text = 'Arrêt : voiture ou cible absente.' end
            return
        end
        elapsed += dt
        local now = os.clock()
        if elapsed >= 1 / KICK_HITS_PER_SECOND then
            elapsed = 0
            local direction = t.CFrame.LookVector
            local desired = t.Position - direction * KICK_APPROACH_DISTANCE + Vector3.new(0, KICK_UNDER_OFFSET, 0)
            if math.random() < KICK_TELEPORT_CHANCE then
                s.AssemblyLinearVelocity = Vector3.zero
                s.AssemblyAngularVelocity = Vector3.zero
                s.CFrame = CFrame.lookAt(desired, t.Position + Vector3.new(0, KICK_UNDER_OFFSET, 0))
            end
            charging = math.random() < KICK_TURN_CHANCE
            spinDirection = math.random(0, 1) == 0 and -1 or 1
            chargeUntil = now + 0.08
        end
        local aim = t.Position + Vector3.new(0, KICK_UNDER_OFFSET, 0) - s.Position
        if aim.Magnitude > 0.1 then
            s.AssemblyLinearVelocity = aim.Unit * kickSpeed
        end
        if charging and now < chargeUntil then
            s.AssemblyAngularVelocity = Vector3.new(0, spinDirection * 28, 0)
        else
            s.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

player.CharacterRemoving:Connect(stopKickCars)
Players.PlayerRemoving:Connect(function(p)
    if kickTarget == p then kickTarget = nil; stopKickCars() end
end)


-- Téléportation directe du personnage, sans véhicule ni activation préalable.
local SPAWN_CARS_POSITION = Vector3.new(631, 97, 2502)
local function teleportToSpawnCars()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not character or not root or not humanoid or humanoid.Health <= 0 then
        showOptionAlert("Personnage indisponible")
        return
    end
    if kickRunning then stopKickCars() end
    humanoid.Sit = false
    character:PivotTo(CFrame.new(SPAWN_CARS_POSITION))
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    showOptionAlert("Téléporté au Spawn Cars")
end

function buildKickCarsUI()
    stopKickCars()
    local page = newTab(11, "KICK Cars", "🚗")
    local card = newCard(page, 1, "KICK CARS")

    local function infoLabel(parent, text, order, height, color)
        local item = Instance.new("TextLabel")
        item.Size = UDim2.new(1, 0, 0, height or 22)
        item.BackgroundTransparency = 1
        item.TextColor3 = color or SUBTEXT_COLOR
        item.Text = text
        item.TextWrapped = true
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.Font = Enum.Font.Gotham
        item.TextSize = 12
        item.LayoutOrder = order
        item.Parent = parent
        return item
    end

    -- Même présentation compacte que la liste de la catégorie Backstab.
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "KickCarsPlayerSearch"
    searchBox.Size = UDim2.new(1, 0, 0, 30)
    searchBox.BackgroundColor3 = HEADER_COLOR
    searchBox.BorderSizePixel = 0
    searchBox.TextColor3 = TEXT_COLOR
    searchBox.PlaceholderColor3 = SUBTEXT_COLOR
    searchBox.PlaceholderText = "🔎  Rechercher un joueur..."
    searchBox.Text = ""
    searchBox.ClearTextOnFocus = false
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 12
    searchBox.LayoutOrder = 1
    searchBox.Parent = card
    corner(searchBox, 8)

    local list = Instance.new("ScrollingFrame")
    list.Name = "KickCarsPlayers"
    list.Size = UDim2.new(1, 0, 0, 120)
    list.BackgroundColor3 = HEADER_COLOR
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.ScrollBarImageColor3 = ACCENT_COLOR
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.LayoutOrder = 2
    list.Parent = card
    corner(list, 8)
    padding(list, 4)
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.Name
    layout.Padding = UDim.new(0, 4)
    layout.Parent = list

    local function refreshKickList()
        if not list.Parent then return end
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") or child.Name == "EmptySearch" then child:Destroy() end
        end
        local query = string.lower(searchBox.Text or "")
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and (query == "" or string.find(string.lower(p.Name), query, 1, true)
                or string.find(string.lower(p.DisplayName), query, 1, true)) then
                local button = Instance.new("TextButton")
                button.Name = p.Name
                button.Size = UDim2.new(1, 0, 0, 28)
                button.BackgroundColor3 = ACCENT_COLOR
                button.BorderSizePixel = 0
                button.TextColor3 = TEXT_COLOR
                button.Text = p.DisplayName ~= p.Name
                    and (p.DisplayName .. "  @" .. p.Name)
                    or p.Name
                button.TextSize = 12
                button.Font = Enum.Font.Gotham
                button.AutoButtonColor = false
                button.Parent = list
                corner(button, 6)
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = ACCENT_ON}):Play()
                end)
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = ACCENT_COLOR}):Play()
                end)
                button.MouseButton1Click:Connect(function()
                    if kickRunning then stopKickCars() end
                    kickTarget = p
                    showOptionAlert("Cible : " .. p.DisplayName, nil)
                end)
            end
        end
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(refreshKickList)
    refreshKickList()
    table.insert(guiConnections, Players.PlayerAdded:Connect(refreshKickList))
    table.insert(guiConnections, Players.PlayerRemoving:Connect(function() task.defer(refreshKickList) end))

    local controls = newCard(page, 2, "CONTRÔLES")
    kickSpeed = 8000
    infoLabel(controls, "Vitesse fixe : 8000  |  12 charges/s", 1, 22)
    kickButton = Instance.new("TextButton")
    kickButton.Name = "KickCarsToggle"
    kickButton.Size = UDim2.new(1, 0, 0, 36)
    kickButton.BackgroundColor3 = ACCENT_COLOR
    kickButton.BorderSizePixel = 0
    kickButton.TextColor3 = TEXT_COLOR
    kickButton.Text = "DÉMARRER"
    kickButton.Font = Enum.Font.GothamBold
    kickButton.TextSize = 13
    kickButton.LayoutOrder = 2
    kickButton.Parent = controls
    corner(kickButton, 7)
    kickStatus = infoLabel(controls, "Prêt - physique locale", 3, 22)

    local spawnCard = newCard(page, 3, "SPAWN CARS")
    infoLabel(spawnCard, "X : 631   Y : 97   Z : 2502", 1, 22)
    local spawnButton = Instance.new("TextButton")
    spawnButton.Name = "SpawnCarsTeleport"
    spawnButton.Size = UDim2.new(1, 0, 0, 36)
    spawnButton.BackgroundColor3 = ACCENT_COLOR
    spawnButton.BorderSizePixel = 0
    spawnButton.TextColor3 = TEXT_COLOR
    spawnButton.Text = "SE TÉLÉPORTER AU SPAWN CARS"
    spawnButton.Font = Enum.Font.GothamBold
    spawnButton.TextSize = 12
    spawnButton.LayoutOrder = 2
    spawnButton.Parent = spawnCard
    corner(spawnButton, 7)
    spawnButton.MouseButton1Click:Connect(teleportToSpawnCars)

    kickButton.MouseButton1Click:Connect(function()
        if kickRunning then
            stopKickCars()
            kickStatus.Text = "Arrêté"
            showOptionAlert("KICK Cars", "OFF")
        else
            kickSpeed = 8000
            startKickCars()
            if kickRunning then showOptionAlert("KICK Cars", "ON") end
        end
    end)
end

-- ===== THELYNOXBOT EXTENSION : 5 CATEGORIES / OUTILS CLIENT =====
-- Isolee dans un bloc pour eviter la limite des 200 locaux Luau.
do
    local P = game:GetService('Players')
    local R = game:GetService('RunService')
    local U = game:GetService('UserInputService')
    local L = game:GetService('Lighting')
    local S = game:GetService('Stats')
    local me = P.LocalPlayer
    local state = {fov=70, crosshair=false, showDistances=false,
        names=false, night=false, day=false, fog=false, lowFx=false, fps=false, proximity=false,
        aimEnabled=false, aimRadius=1200, aimSmooth=85, aimHolding=false,
        fallAlert=false, damageLog=false, spectator=nil, orbit=false, statue=false,
        backward=false, autoDance=false, ghost=false, cameraVehicle=false,
        cruise=false, cruiseSpeed=40, maxVehicleSpeed=110, shortcuts=true,
        positionHistory={}, healthEvents={}, fpsCount=0, fpsTime=0}
    local links = {}
    local overlay = nil
    local status = nil
    local originalLighting = {ClockTime=L.ClockTime, FogEnd=L.FogEnd}
    local function charParts()
        local c=me.Character
        return c, c and c:FindFirstChildOfClass('Humanoid'), c and c:FindFirstChild('HumanoidRootPart')
    end
    local function info(t)
        if status and status.Parent then status.Text=t end
        if type(showOptionAlert)=='function' then showOptionAlert(t,nil) end
    end
    local function btn(card,n,text,callback)
        local b=Instance.new('TextButton')
        b.Name='Extra_'..n
        b.Size=UDim2.new(1,0,0,34)
        b.LayoutOrder=n
        b.BackgroundColor3=ACCENT_COLOR
        b.TextColor3=TEXT_COLOR
        b.Text=text
        b.Font=Enum.Font.GothamBold
        b.TextSize=12
        b.TextWrapped=true
        b.Parent=card
        corner(b,8)
        b.MouseButton1Click:Connect(function()
            local ok,err=pcall(callback,b)
            if not ok then warn('[Lynox Extension] '..tostring(err)); info('Erreur : '..tostring(err)) end
        end)
        return b
    end
    local function toggle(card,n,text,key,callback)
        return btn(card,n,text..' : OFF',function(b)
            state[key]=not state[key]
            b.Text=text..(state[key] and ' : ON' or ' : OFF')
            b.BackgroundColor3=state[key] and ACCENT_ON or ACCENT_COLOR
            if callback then callback(state[key]) end
        end)
    end
    local function step(card,n,text,start,stepSize,low,high,callback)
        local val=start
        newStepper(card,n,text,start,stepSize,function(v)
            val=math.clamp(v,low,high)
            if callback then callback(val) end
            return val
        end)
    end
    local function page(name,icon,order)
        return newTab(order,name,icon)
    end
    local function card(pageRef,order,title)
        return newCard(pageRef,order,title)
    end
    local function hud()
        if overlay and overlay.Parent then return overlay end
        overlay=Instance.new('ScreenGui')
        overlay.Name='TheLynoxExtrasOverlay'
        overlay.ResetOnSpawn=false
        overlay.IgnoreGuiInset=true
        overlay.DisplayOrder=1001
        overlay.Parent=me:WaitForChild('PlayerGui')
        return overlay
    end
    local function hudLabel(name,at,size,text)
        local obj=hud():FindFirstChild(name)
        if not obj then
            obj=Instance.new('TextLabel')
            obj.Name=name
            obj.BackgroundColor3=Color3.fromRGB(20,20,32)
            obj.BackgroundTransparency=0.28
            obj.TextColor3=Color3.fromRGB(245,245,255)
            obj.TextStrokeTransparency=0.6
            obj.Font=Enum.Font.GothamBold
            obj.TextSize=13
            obj.Parent=hud()
            corner(obj,7)
        end
        obj.Position=at
        obj.Size=size
        obj.Text=text
        return obj
    end
    local function teleport(cf)
        local _,_,root=charParts()
        if root then
            table.insert(state.positionHistory,1,root.CFrame)
            if #state.positionHistory>15 then table.remove(state.positionHistory) end
            root.CFrame=cf
        end
    end
    local function choosePlayer(cardRef,order,callback)
        newPlayerList(cardRef,order,function(target)
            if target and target~=me then callback(target) end
        end,false)
    end
    function buildLynoxExtras()
        -- AIM : vise la tete du joueur le plus proche du centre de l'ecran
        -- pendant que le bouton droit est maintenu. Aucun tir automatique.
        p=page('AIM','🎯',111)
        c=card(p,1,'AIM / VISEUR')
        toggle(c,1,'Crosshair','crosshair',function(v)
            local obj=hudLabel('LynoxCrosshair',UDim2.fromScale(0.5,0.5),UDim2.fromOffset(20,20),'+')
            obj.AnchorPoint=Vector2.new(0.5,0.5)
            obj.BackgroundTransparency=1
            obj.TextSize=25
            obj.Visible=v
        end)
        step(c,2,'FOV camera',70,5,40,110,function(v)
            state.fov=v
            if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=v end
        end)
        toggle(c,3,'Distance du joueur vise','showDistances')
        -- Aimbot externe : conserver exactement le theme et la mise en page d'origine.
        -- Un lien loadstring ne fournit pas necessairement de fonction pour arreter l'aimbot.
        local externalAimStop = nil
        local externalAimLoaded = false
        btn(c,4,'Aimbot externe : ACTIVER',function(b)
            if externalAimLoaded then
                if type(externalAimStop) ~= 'function' then
                    info('Desactivation indisponible : aucun stop fourni par le script externe')
                    return
                end
                local ok, err = pcall(externalAimStop)
                if not ok then
                    info('Erreur desactivation : '..tostring(err):sub(1,90))
                    return
                end
                externalAimLoaded = false
                externalAimStop = nil
                b.Text = 'Aimbot externe : ACTIVER'
                info('Desactivation demandee')
                return
            end
            if type(loadstring) ~= 'function' then
                info('loadstring indisponible dans cet environnement')
                return
            end
            local ok, result = pcall(function()
                local source = game:HttpGet('https://obj.wearedevs.net/s/6a71e593ff2048b74c853df4.lua')
                local chunk = loadstring(source)
                if type(chunk) ~= 'function' then error('Script distant non compilable') end
                return chunk()
            end)
            if not ok then
                info('Erreur chargement AIM : '..tostring(result):sub(1,90))
                return
            end
            if type(result) == 'function' then
                externalAimStop = result
            elseif type(result) == 'table' then
                externalAimStop = result.stop or result.Stop or result.disable or result.Disable
            end
            externalAimLoaded = true
            if type(externalAimStop) == 'function' then
                b.Text = 'Aimbot externe : DESACTIVER'
                info('Aimbot charge ; arret disponible')
            else
                b.Text = 'Aimbot externe : CHARGE (OFF indisponible)'
                info('Script charge, mais impossible de garantir son arret')
            end
        end)
        step(c,5,'Rayon AIM (pixels)',1200,20,40,1200,function(v) state.aimRadius=v end)
        step(c,6,'Douceur AIM',85,5,5,100,function(v) state.aimSmooth=v end)
        -- VEHICLE PRO
        p=page('VEHICLE PRO','🚗',113)
        c=card(p,1,'CONDUITE')
        toggle(c,1,'Compteur vitesse','vehicleHud',function(v)
            local obj=hudLabel('LynoxVehicleSpeed',UDim2.new(0.5,-95,1,-110),UDim2.fromOffset(190,35),'Vehicule : --')
            obj.Visible=v
        end)
        toggle(c,2,'Regulateur vitesse','cruise')
        step(c,3,'Vitesse regulateur',40,5,10,150,function(v) state.cruiseSpeed=v end)
        toggle(c,4,'Camera vehicule','cameraVehicle')
        step(c,5,'Limite vitesse locale',110,10,20,250,function(v) state.maxVehicleSpeed=v end)
        -- CAMERA : remplace l'ancien onglet en haut et TROLL FUN.
        p=page('Caméra','🎥',114)
        c=card(p,1,'FREE CAM')
        newSwitch(c,1,'Activer Free Cam (clic droit = regarder)',toggleFreeCam)
        newStepper(c,2,'Vitesse Free Cam',freeCamSpeed,10,function(v)
            freeCamSpeed=math.clamp(v,10,300)
            return freeCamSpeed
        end)
        c=card(p,2,'SPECTATE / ORBITE')
        choosePlayer(c,1,function(target)
            state.spectator=target
            local h=target.Character and target.Character:FindFirstChildOfClass('Humanoid')
            if h and workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject=h end
            info('Spectate : '..target.Name)
        end)
        btn(c,2,'Arreter spectate',function()
            state.spectator=nil
            local _,hum=charParts()
            if hum and workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject=hum end
        end)
        toggle(c,3,'Orbite autour du spectate','orbit')
        -- SAFETY
        p=page('SAFETY+','🛡️',115)
        c=card(p,1,'ALERTES')
        toggle(c,1,'Alerte joueur proche','proximity')
        toggle(c,2,'Alerte forte chute','fallAlert')
        toggle(c,3,'Historique des degats','damageLog')
        btn(c,4,'Afficher derniers degats',function()
            if #state.healthEvents==0 then info('Aucun degat enregistre') return end
            local lines={}
            for i=1,math.min(4,#state.healthEvents) do table.insert(lines,state.healthEvents[i]) end
            info(table.concat(lines,' | '))
        end)
        btn(c,5,'Retablir la camera et la marche',function()
            state.spectator=nil; state.orbit=false
            local _,hum=charParts()
            if hum then hum.WalkSpeed=walkSpeed; hum.AutoRotate=true end
            if hum and workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject=hum end
            info('Camera et marche restaurees')
        end)
        -- PERFORMANCE
        p=page('PERFORMANCE','📊',117)
        c=card(p,1,'STATISTIQUES')
        toggle(c,1,'Afficher FPS / Ping / Joueurs','fps',function(v)
            local obj=hudLabel('LynoxPerformance',UDim2.new(1,-370,0,12),UDim2.fromOffset(230,35),'FPS : --')
            obj.Visible=v
        end)
        toggle(c,2,'Mode FPS (effets reduits)','lowFx',function(v)
            for _,obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA('ParticleEmitter') or obj:IsA('Trail') then
                    if v then obj:SetAttribute('LynoxOldEnabled',obj.Enabled); obj.Enabled=false
                    else
                        local old=obj:GetAttribute('LynoxOldEnabled')
                        if old~=nil then obj.Enabled=old; obj:SetAttribute('LynoxOldEnabled',nil) end
                    end
                end
            end
        end)
        btn(c,3,'Afficher diagnostic',function()
            local _,hum,root=charParts()
            info('GUI : OK | Joueurs : '..#P:GetPlayers()..' | Humanoid : '..tostring(hum~=nil)..' | Root : '..tostring(root~=nil))
        end)
        c=card(p,2,'STATUT EXTENSION')
        status=newInfoLabel(c,1,'Extension chargee : AIM, Caméra, VEHICLE PRO, SAFETY+, PERFORMANCE',42)
        -- Boucle mutualisee (aucun nouveau local dans le scope racine du script)
        local tickAccumulator=0
        local oldHealth=nil
        local proximityClock=0
        local danceClock=0
        table.insert(links,R.Heartbeat:Connect(function(dt)
            state.fpsCount+=1; state.fpsTime+=dt
            local ch,hum,root=charParts()
            if hum then
                if hum.WalkSpeed~=walkSpeed then
                    hum.WalkSpeed=walkSpeed
                end
                if hum.FloorMaterial~=Enum.Material.Air then state.extraJump=true end
                if state.damageLog and oldHealth and hum.Health<oldHealth-0.01 then
                    table.insert(state.healthEvents,1,os.date('%H:%M:%S')..' -'..math.floor(oldHealth-hum.Health+0.5)..' PV')
                    if #state.healthEvents>20 then table.remove(state.healthEvents) end
                end
                oldHealth=hum.Health
            end
            if state.fallAlert and root and root.AssemblyLinearVelocity.Y < -95 and os.clock()-proximityClock>3 then
                proximityClock=os.clock(); info('Attention : chute rapide !')
            end
            tickAccumulator+=dt
            if tickAccumulator<0.35 then return end
            tickAccumulator=0
            if state.fps then
                local obj=hud():FindFirstChild('LynoxPerformance')
                if obj then
                    local ping='--'
                    pcall(function() ping=math.floor(S.Network.ServerStatsItem['Data Ping']:GetValue()) end)
                    local fps=state.fpsTime>0 and math.floor(state.fpsCount/state.fpsTime+0.5) or 0
                    obj.Text='FPS '..fps..' | Ping '..tostring(ping)..' | Joueurs '..#P:GetPlayers()
                end
            end
            state.fpsCount=0; state.fpsTime=0
            if state.vehicleHud or state.cruise or state.cameraVehicle then
                local seat=hum and hum.SeatPart
                local vehicle=seat and seat:IsA('VehicleSeat') and seat or nil
                if state.vehicleHud then
                    local obj=hud():FindFirstChild('LynoxVehicleSpeed')
                    if obj then obj.Text='Vitesse : '..(vehicle and math.floor(vehicle.AssemblyLinearVelocity.Magnitude+0.5) or 0)..' studs/s' end
                end
                if vehicle and state.cruise then
                    local v=vehicle.AssemblyLinearVelocity
                    local flat=Vector3.new(v.X,0,v.Z)
                    if flat.Magnitude>1 then
                        local speed=math.min(state.cruiseSpeed,state.maxVehicleSpeed)
                        vehicle.AssemblyLinearVelocity=flat.Unit*speed+Vector3.new(0,v.Y,0)
                    end
                end
                if vehicle and state.cameraVehicle and workspace.CurrentCamera then
                    workspace.CurrentCamera.FieldOfView=math.clamp(70+vehicle.AssemblyLinearVelocity.Magnitude/8,70,100)
                end
            end
            if state.showDistances or state.names then
                local target=nil; local best=150
                if root then
                    for _,other in ipairs(P:GetPlayers()) do
                        local oroot=other.Character and other.Character:FindFirstChild('HumanoidRootPart')
                        if other~=me and oroot then
                            local d=(root.Position-oroot.Position).Magnitude
                            if d<best then target=other; best=d end
                        end
                    end
                end
                local obj=hudLabel('LynoxNearest',UDim2.new(0.5,-100,0,90),UDim2.fromOffset(200,28),target and ((state.names and target.DisplayName or 'Joueur')..(state.showDistances and (' : '..math.floor(best)..' studs') or '')) or 'Aucun joueur proche')
                obj.Visible=true
            else
                local obj=overlay and overlay:FindFirstChild('LynoxNearest')
                if obj then obj.Visible=false end
            end
            if state.proximity and root and os.clock()-proximityClock>5 then
                for _,other in ipairs(P:GetPlayers()) do
                    local oroot=other.Character and other.Character:FindFirstChild('HumanoidRootPart')
                    if other~=me and oroot and (oroot.Position-root.Position).Magnitude<14 then
                        proximityClock=os.clock(); info('Joueur proche : '..other.Name); break
                    end
                end
            end
            if state.orbit and state.spectator and root then
                local tr=state.spectator.Character and state.spectator.Character:FindFirstChild('HumanoidRootPart')
                if tr then
                    local a=os.clock()*1.5
                    root.CFrame=CFrame.lookAt(tr.Position+Vector3.new(math.cos(a)*8,2,math.sin(a)*8),tr.Position)
                end
            end
        end))
        table.insert(links,me.CharacterAdded:Connect(function()
            state.extraJump=false; oldHealth=nil
        end))
    end
end

function buildAll()
    createBaseGUI()
    -- Creer la vraie categorie Recherche immediatement, avant les extensions.
    -- ===== RECHERCHE GLOBALE (placée en haut de la sidebar) =====
    local searchPage = newTab(0, "Recherche", "🔎")
    local searchHeader = newCard(searchPage, 1, "RECHERCHER UNE OPTION")
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "GlobalOptionSearch"
    searchBox.Size = UDim2.new(1, -4, 0, 38)
    searchBox.Position = UDim2.new(0, 2, 0, 0)
    searchBox.BackgroundColor3 = HEADER_COLOR
    searchBox.BorderSizePixel = 0
    searchBox.ClearTextOnFocus = false
    searchBox.PlaceholderText = "Ex. : noclip, fly, vitesse..."
    searchBox.Text = ""
    searchBox.TextColor3 = TEXT_COLOR
    searchBox.PlaceholderColor3 = SUBTEXT_COLOR
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 13
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchHeader
    corner(searchBox, 9)
    stroke(searchBox, ACCENT_COLOR, 1, 0.25)
    padding(searchBox, 10)

    local searchHint = Instance.new("TextLabel")
    searchHint.Name = "SearchHint"
    searchHint.Size = UDim2.new(1, -4, 0, 28)
    searchHint.BackgroundTransparency = 1
    searchHint.Text = "Tape un nom pour trouver une option dans toutes les catégories."
    searchHint.TextColor3 = SUBTEXT_COLOR
    searchHint.Font = Enum.Font.Gotham
    searchHint.TextSize = 11
    searchHint.TextWrapped = true
    searchHint.TextXAlignment = Enum.TextXAlignment.Left
    searchHint.LayoutOrder = 2
    searchHint.Parent = searchHeader

    local resultsCard = newCard(searchPage, 2, "RÉSULTATS")
    local resultsList = Instance.new("Frame")
    resultsList.Name = "SearchResults"
    resultsList.Size = UDim2.new(1, 0, 0, 0)
    resultsList.AutomaticSize = Enum.AutomaticSize.Y
    resultsList.BackgroundTransparency = 1
    resultsList.LayoutOrder = 1
    resultsList.Parent = resultsCard
    local resultsLayout = Instance.new("UIListLayout")
    resultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    resultsLayout.Padding = UDim.new(0, 6)
    resultsLayout.Parent = resultsList

    local function clearSearchResults()
        for _, child in ipairs(resultsList:GetChildren()) do
            if child:IsA("GuiObject") and child ~= resultsLayout then child:Destroy() end
        end
    end

    local function refreshGlobalSearch()
        clearSearchResults()
        local query = string.lower(string.gsub(searchBox.Text or "", "^%s*(.-)%s*$", "%1"))
        if query == "" then
            searchHint.Text = "Tape un nom pour trouver une option dans toutes les catégories."
            return
        end
        local found, seen = 0, {}
        for tabName, page in pairs(pages) do
            if tabName ~= "Recherche" and page and page.Parent then
                for _, obj in ipairs(page:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        local textValue = obj.Text or ""
                        -- Retire les balises RichText pour éviter les textes de recherche mal formatés.
                        textValue = string.gsub(textValue, "<[^>]->", "")
                        local lowerText = string.lower(textValue)
                        if lowerText ~= "" and string.find(lowerText, query, 1, true) then
                            local top = obj
                            while top.Parent and top.Parent ~= page do top = top.Parent end
                            if top.Parent == page and not seen[top] and top:IsA("GuiObject") then
                                seen[top] = true
                                found += 1
                                local resultButton = Instance.new("TextButton")
                                resultButton.Name = "SearchResult_" .. tostring(found)
                                resultButton.Size = UDim2.new(1, -2, 0, 34)
                                resultButton.BackgroundColor3 = Color3.fromRGB(73, 45, 120)
                                resultButton.BorderSizePixel = 0
                                resultButton.AutoButtonColor = false
                                resultButton.Text = "  " .. tabName .. "   ›   " .. string.sub(textValue, 1, 54)
                                resultButton.TextColor3 = TEXT_COLOR
                                resultButton.TextSize = 11
                                resultButton.Font = Enum.Font.GothamMedium
                                resultButton.TextWrapped = false
                                resultButton.TextXAlignment = Enum.TextXAlignment.Left
                                resultButton.TextTruncate = Enum.TextTruncate.AtEnd
                                resultButton.LayoutOrder = found
                                resultButton.Parent = resultsList
                                corner(resultButton, 8)
                                stroke(resultButton, ACCENT_COLOR, 1.2, 0.05)
                                resultButton.MouseEnter:Connect(function()
                                    TweenService:Create(resultButton, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(96, 61, 153)}):Play()
                                end)
                                resultButton.MouseLeave:Connect(function()
                                    TweenService:Create(resultButton, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(73, 45, 120)}):Play()
                                end)
                                local target = top
                                resultButton.MouseButton1Click:Connect(function()
                                    selectTab(tabName)
                                    task.defer(function()
                                        if target and target.Parent == page then
                                            local y = math.max(0, target.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y - 10)
                                            page.CanvasPosition = Vector2.new(0, y)
                                            local oldColor = target.BackgroundColor3
                                            if target:IsA("Frame") then
                                                target.BackgroundColor3 = ACCENT_COLOR
                                                task.delay(0.45, function()
                                                    if target and target.Parent then target.BackgroundColor3 = oldColor end
                                                end)
                                            end
                                        end
                                    end)
                                end)
                                if found >= 40 then break end
                            end
                        end
                    end
                    if found >= 40 then break end
                end
            end
            if found >= 40 then break end
        end
        searchHint.Text = found > 0 and (tostring(found) .. " résultat(s) trouvé(s) — clique pour ouvrir la catégorie.") or "Aucun résultat. Essaie un autre mot-clé."
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(refreshGlobalSearch)

    selectTab("Recherche")

    buildPlayerUI()
    buildMovementUI()
    buildPersonnageUI()
    buildTeleportUI()
    buildVisualUI()
    buildUtilitiesUI()
    buildTrollUI()
    buildKickCarsUI()
    buildBackstabUI()
    buildEmotesUI()
    buildTutorialUI()
    buildLynoxExtras()
    -- AIM : verrouillage camera au clic droit, avec cible visible et diagnostic.
    local aimTarget = nil
    local aimStatus = Instance.new("TextLabel")
    aimStatus.Name = "TheLynoxAimStatus"
    aimStatus.Size = UDim2.fromOffset(270, 28)
    aimStatus.Position = UDim2.new(0.5, -135, 0, 65)
    aimStatus.BackgroundColor3 = Color3.fromRGB(24, 24, 38)
    aimStatus.BackgroundTransparency = 0.25
    aimStatus.TextColor3 = Color3.fromRGB(34, 211, 238)
    aimStatus.TextSize = 14
    aimStatus.Font = Enum.Font.GothamBold
    aimStatus.Visible = false
    aimStatus.ZIndex = 200
    aimStatus.Parent = me:WaitForChild("PlayerGui"):FindFirstChild("TheLynoxAimOverlay") or (function()
        local g = Instance.new("ScreenGui")
        g.Name = "TheLynoxAimOverlay"
        g.ResetOnSpawn = false
        g.IgnoreGuiInset = true
        g.DisplayOrder = 10002
        g.Parent = me.PlayerGui
        return g
    end)()
    table.insert(links,U.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            state.aimHolding = true
            aimTarget = nil
        end
    end))
    table.insert(links,U.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            state.aimHolding = false
            aimTarget = nil
            aimStatus.Visible = false
        end
    end))
    R:UnbindFromRenderStep('TheLynoxAimHold')
    R:BindToRenderStep('TheLynoxAimHold', Enum.RenderPriority.Camera.Value + 50, function(dt)
        local held = state.aimHolding or U:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        aimStatus.Visible = state.aimEnabled and held and not freeCamEnabled
        if not aimStatus.Visible then return end
        local cam = workspace.CurrentCamera
        local character = me.Character
        local root = character and character:FindFirstChild('HumanoidRootPart')
        if not cam or not root then aimStatus.Text = 'AIM : personnage indisponible'; return end
        local center = cam.ViewportSize * 0.5
        local best, bestDist = nil, math.huge
        for _, other in ipairs(P:GetPlayers()) do
            if other ~= me then
                local model = other.Character
                local hum = model and model:FindFirstChildOfClass('Humanoid')
                local head = model and model:FindFirstChild('Head')
                if head and hum and hum.Health > 0 and (head.Position - root.Position).Magnitude <= 500 then
                    local pos, visible = cam:WorldToViewportPoint(head.Position)
                    if visible and pos.Z > 0 then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < bestDist then best, bestDist = head, dist end
                    end
                end
            end
        end
        -- Tant que la cible existe et reste vivante, la conserver pour eviter les oscillations.
        if aimTarget and aimTarget.Parent then
            local hum = aimTarget.Parent:FindFirstChildOfClass('Humanoid')
            if hum and hum.Health > 0 and (aimTarget.Position-root.Position).Magnitude <= 500 then
                best = aimTarget
            end
        end
        aimTarget = best
        if not best then aimStatus.Text = 'AIM : aucune cible visible'; return end
        aimStatus.Text = 'AIM : ' .. best.Parent.Name
        local cf = cam.CFrame
        local target = CFrame.lookAt(cf.Position, best.Position)
        cam.CFrame = cf:Lerp(target, math.clamp(dt * (state.aimSmooth / 6), 0, 1))
    end)

end

-- ===== AUTO RELOAD =====
-- Recrée tout le panel (garde l'onglet ouvert, la position et si il est affiché ou caché).
-- Les boutons réaffichent l'état OFF après un rechargement : réactive-les si besoin.
function reloadGUI()
    local oldTab = currentTab
    local oldPosition = mainFrame and mainFrame.Position
    local oldVisible = mainFrame and mainFrame.Visible

    buildAll()

    if oldTab and pages[oldTab] then selectTab(oldTab) end
    if oldPosition then mainFrame.Position = oldPosition end
    if oldVisible ~= nil then mainFrame.Visible = oldVisible end
    print("[TheLynoxBot] GUI rechargé")
end

buildAll()

-- Rechargement automatique : si le panel est supprimé (par un autre script, un reset, etc.),
-- il est recréé tout seul.
task.spawn(function()
    while true do
        task.wait(2)
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui and not playerGui:FindFirstChild("TheLynoxBotAdminGui") then
            reloadGUI()
        end
    end
end)



-- ===== SYSTÈME DE SURVIE : ALERTE PV BAS =====
-- Affiche une alerte quand la vie passe à 30 % ou moins, et la masque quand elle remonte.
local LOW_HEALTH_PERCENT = 0.30
local survivalGui, survivalAlert, survivalStroke
local survivalHealthConnection
local lowHealthActive = false

local function buildSurvivalAlert()
    local playerGui = player:WaitForChild("PlayerGui")
    local existing = playerGui:FindFirstChild("TheLynoxBotSurvivalAlert")
    if existing then existing:Destroy() end

    survivalGui = Instance.new("ScreenGui")
    survivalGui.Name = "TheLynoxBotSurvivalAlert"
    survivalGui.ResetOnSpawn = false
    survivalGui.IgnoreGuiInset = true
    survivalGui.Parent = playerGui

    survivalAlert = Instance.new("TextLabel")
    survivalAlert.Name = "LowHealthAlert"
    survivalAlert.AnchorPoint = Vector2.new(0.5, 0)
    survivalAlert.Position = UDim2.new(0.5, 0, 0.08, 0)
    survivalAlert.Size = UDim2.new(0, 330, 0, 54)
    survivalAlert.BackgroundColor3 = CARD_COLOR
    survivalAlert.BackgroundTransparency = 0.08
    survivalAlert.BorderSizePixel = 0
    survivalAlert.Text = "⚠️  PV FAIBLES ! METS-TOI À L'ABRI"
    survivalAlert.TextColor3 = Color3.fromRGB(255, 255, 255)
    survivalAlert.TextStrokeColor3 = HEADER_COLOR
    survivalAlert.TextStrokeTransparency = 0.55
    survivalAlert.TextScaled = true
    survivalAlert.Font = Enum.Font.GothamBold
    survivalAlert.Visible = false
    survivalAlert.Parent = survivalGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = survivalAlert

    survivalStroke = Instance.new("UIStroke")
    survivalStroke.Color = ACCENT_COLOR
    survivalStroke.Thickness = 2
    survivalStroke.Parent = survivalAlert
end

local function updateSurvivalAlert(humanoid)
    if not survivalAlert or not humanoid or humanoid.MaxHealth <= 0 then return end
    local isLow = humanoid.Health > 0 and humanoid.Health <= humanoid.MaxHealth * LOW_HEALTH_PERCENT
    if isLow and not lowHealthActive then
        lowHealthActive = true
        survivalAlert.Text = string.format("⚠️  PV FAIBLES : %d%%  —  FAIS ATTENTION !", math.floor((humanoid.Health / humanoid.MaxHealth) * 100 + 0.5))
        survivalAlert.Visible = true
        survivalAlert.BackgroundTransparency = 0.08
        if survivalStroke then
            survivalStroke.Thickness = 2
            survivalStroke.Color = (humanoid.Health / humanoid.MaxHealth <= 0.1) and ACCENT_ON or ACCENT_COLOR
        end
    elseif isLow and lowHealthActive then
        survivalAlert.Text = string.format("⚠️  PV FAIBLES : %d%%  —  FAIS ATTENTION !", math.floor((humanoid.Health / humanoid.MaxHealth) * 100 + 0.5))
    elseif not isLow and lowHealthActive then
        lowHealthActive = false
        if survivalStroke then survivalStroke.Color = ACCENT_COLOR end
        survivalAlert.Visible = false
    end
end

local function hookSurvivalCharacter(character)
    if survivalHealthConnection then
        survivalHealthConnection:Disconnect()
        survivalHealthConnection = nil
    end
    lowHealthActive = false
    if survivalAlert then survivalAlert.Visible = false end
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then return end
    survivalHealthConnection = humanoid.HealthChanged:Connect(function()
        updateSurvivalAlert(humanoid)
    end)
    updateSurvivalAlert(humanoid)
end

task.spawn(function()
    buildSurvivalAlert()
    if player.Character then hookSurvivalCharacter(player.Character) end
    player.CharacterAdded:Connect(hookSurvivalCharacter)
end)

print("[TheLynoxBot] GUI chargé avec succès")

-- ===== MESSAGE DE BIENVENUE =====
-- Envoie automatiquement un message dans le chat au lancement du GUI.
task.defer(function()
    task.wait(1)
    sendChatMessage("7!")
end)
-- Aimbot externe charge uniquement depuis le bouton AIM.
-- Fin du GUI (chargeur externe retiré pour Roblox Studio).
