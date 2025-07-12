local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Crea GUI HUB
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "EmergencyHamburgHUB"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 370)
frame.Position = UDim2.new(0.5, -150, 0.5, -185)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Visible = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🚗 Emergency Hamburg HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

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

local stealCarBtn = createButton("Steal Car", UDim2.new(0.1,0,0,50))
local autoRobBankBtn = createButton("Auto Rob Bank", UDim2.new(0.1,0,0,100))
local autoRobVendingBtn = createButton("Auto Rob Vending Machine", UDim2.new(0.1,0,0,150))
local carFlyBtn = createButton("Car Fly Toggle", UDim2.new(0.1,0,0,200))
local unlimitedFuelBtn = createButton("Unlimited Fuel Toggle", UDim2.new(0.1,0,0,250))

local carFlyEnabled = false
local unlimitedFuelEnabled = false
local BodyVelocity

-- Steal Car specifico Emergency Hamburg
local function stealCar()
    local seat = nil
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") then
            local distance = (player.Character.HumanoidRootPart.Position - v.Position).Magnitude
            if distance < 10 then
                seat = v
                break
            end
        end
    end
    if seat then
        if seat.Occupant then
            seat.Occupant.Sit = false
            wait(0.1)
        end
        player.Character.Humanoid.Sit = true
        player.Character:SetPrimaryPartCFrame(seat.CFrame)
    else
        warn("❌ Nessuna auto vicina trovata.")
    end
end

-- Auto Rob Bank Emergency Hamburg  
local function autoRobBank()
    local bank = workspace:FindFirstChild("BankBuilding") -- Nome corretto oggetto banca Emergency Hamburg
    if bank and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = bank.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
        print("🏦 Rubando la banca...")
        -- Esegui qui eventuali azioni specifiche (es. attivare prompt, prendere soldi)
    else
        warn("❌ Banca non trovata.")
    end
end

-- Auto Rob Vending Machine Emergency Hamburg
local function autoRobVending()
    for _, vending in pairs(workspace:GetDescendants()) do
        if vending.Name:lower():find("vending") and vending:IsA("Model") then
            if vending.PrimaryPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = vending.PrimaryPart.CFrame + Vector3.new(0,3,0)
                print("🥤 Rubando distributore automatico...")
                wait(2)
                -- Inserisci qui eventuali azioni da eseguire sul distributore
            end
        end
    end
end

-- Car Fly toggle Emergency Hamburg
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

-- Unlimited Fuel toggle Emergency Hamburg
local function toggleUnlimitedFuel()
    unlimitedFuelEnabled = not unlimitedFuelEnabled
    if unlimitedFuelEnabled then
        print("⛽ Unlimited Fuel abilitato.")
        -- Trova e imposta fuel infinito (dipende da come è fatto il gioco)
        local vehicle = nil
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") and v.Occupant and v.Occupant.Parent == player.Character then
                vehicle = v.Parent
                break
            end
        end
        if vehicle and vehicle:FindFirstChild("Fuel") then
            vehicle.Fuel.Value = math.huge
        end
    else
        print("⛽ Unlimited Fuel disabilitato.")
        -- Ripristina valore se vuoi
    end
end

-- Connect bottone
stealCarBtn.MouseButton1Click:Connect(stealCar)
autoRobBankBtn.MouseButton1Click:Connect(autoRobBank)
autoRobVendingBtn.MouseButton1Click:Connect(autoRobVending)
carFlyBtn.MouseButton1Click:Connect(toggleCarFly)
unlimitedFuelBtn.MouseButton1Click:Connect(toggleUnlimitedFuel)
