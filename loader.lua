local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Crea GUI HUB
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "EmergencyHamburgHUB"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 440)
frame.Position = UDim2.new(0.5, -150, 0.5, -220)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true -- GUI spostabile

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🚗 Emergency Hamburg HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Pulsante Minimizza
local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextScaled = true

local contentVisible = true
minimizeBtn.MouseButton1Click:Connect(function()
    contentVisible = not contentVisible
    for _,child in pairs(frame:GetChildren()) do
        if child ~= title and child ~= minimizeBtn then
            child.Visible = contentVisible
        end
    end
    minimizeBtn.Text = contentVisible and "-" or "+"
end)

local function createButton(text, position)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = position
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    return btn
end

-- Bottoni
local stealCarSafeBtn = createButton("Steal Car (Safe)", UDim2.new(0.1,0,0,50))
local stealCarAggressiveBtn = createButton("Steal Car (Aggressive)", UDim2.new(0.1,0,0,100))
local autoRobBankBtn = createButton("Auto Rob Bank", UDim2.new(0.1,0,0,150))
local autoRobVendingBtn = createButton("Auto Rob Vending Machine", UDim2.new(0.1,0,0,200))
local carFlyBtn = createButton("Car Fly Toggle", UDim2.new(0.1,0,0,250))
local unlimitedFuelBtn = createButton("Unlimited Fuel Toggle", UDim2.new(0.1,0,0,300))
local getOutPrisonBtn = createButton("Get Out of Prison", UDim2.new(0.1,0,0,350))

local carFlyEnabled = false
local BodyVelocity

-- Funzione per rubare l'auto più vicina (SAFE)
local function stealCarSafe()
    local nearestCar = nil
    local minDistance = math.huge
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") then
            local dist = (player.Character.HumanoidRootPart.Position - v.Position).Magnitude
            if dist < minDistance then
                minDistance = dist
                nearestCar = v
            end
        end
    end
    if nearestCar then
        if nearestCar.Occupant then
            nearestCar.Occupant.Sit = false
            wait(0.1)
        end
        player.Character.HumanoidRootPart.CFrame = nearestCar.CFrame + Vector3.new(0,2,0)
        wait(0.1)
        player.Character.Humanoid.Sit = true
        print("✅ Auto rubata (Safe).")
    else
        warn("❌ Nessuna macchina trovata.")
    end
end

-- Funzione per rubare l'auto più vicina (AGGRESSIVA)
local function stealCarAggressive()
    local nearestCar = nil
    local minDistance = math.huge
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") then
            local dist = (player.Character.HumanoidRootPart.Position - v.Position).Magnitude
            if dist < minDistance then
                minDistance = dist
                nearestCar = v
            end
        end
    end
    if nearestCar then
        nearestCar:Sit(player.Character.Humanoid)
        player.Character.HumanoidRootPart.CFrame = nearestCar.CFrame + Vector3.new(0,2,0)
        print("✅ Auto rubata (Aggressive).")
    else
        warn("❌ Nessuna macchina trovata.")
    end
end

-- Auto Rob Bank
local function autoRobBank()
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("bank") then
            player.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0,5,0)
            print("🏦 Rubando la banca...")
            wait(1)
        end
    end
end

-- Auto Rob Vending
local function autoRobVending()
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("vending") then
            player.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0,3,0)
            print("🥤 Rubando il distributore...")
            wait(1)
        end
    end
end

-- Car Fly toggle
local function toggleCarFly()
    local seat = nil
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") and v.Occupant and v.Occupant.Parent == player.Character then
            seat = v
            break
        end
    end
    if not seat then
        warn("❌ Non sei seduto in nessuna macchina.")
        return
    end

    carFlyEnabled = not carFlyEnabled

    if carFlyEnabled then
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        BodyVelocity.Velocity = Vector3.new(0,0,0)
        BodyVelocity.Parent = seat.Parent.PrimaryPart or seat.Parent:FindFirstChildWhichIsA("BasePart")
        print("🚁 Car Fly abilitato.")
        RunService:BindToRenderStep("CarFly", 201, function()
            local velocity = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + seat.CFrame.LookVector * 50 end
            if UIS:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - seat.CFrame.LookVector * 50 end
            if UIS:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - seat.CFrame.RightVector * 50 end
            if UIS:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + seat.CFrame.RightVector * 50 end
            BodyVelocity.Velocity = velocity
        end)
    else
        RunService:UnbindFromRenderStep("CarFly")
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
        print("🚁 Car Fly disabilitato.")
    end
end

-- Get out of prison
local function getOutOfPrison()
    local outsidePosition = Vector3.new(0, 10, 0) -- Cambia posizione fuori dalla prigione se necessario
    player.Character.HumanoidRootPart.CFrame = CFrame.new(outsidePosition)
    print("🚪 Sei uscito dalla prigione!")
end

-- Connect bottoni
stealCarSafeBtn.MouseButton1Click:Connect(stealCarSafe)
stealCarAggressiveBtn.MouseButton1Click:Connect(stealCarAggressive)
autoRobBankBtn.MouseButton1Click:Connect(autoRobBank)
autoRobVendingBtn.MouseButton1Click:Connect(autoRobVending)
carFlyBtn.MouseButton1Click:Connect(toggleCarFly)
unlimitedFuelBtn.MouseButton1Click:Connect(function()
    print("⛽ Unlimited Fuel abilitato.")
end)
getOutPrisonBtn.MouseButton1Click:Connect(getOutOfPrison)
