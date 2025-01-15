--[[if getgenv().dustyhub then warn("DustyHub : Already executed thug rejoin to execute again") return end
getgenv().dustyhub = true--]]

-- // // // Services // // // --
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local CoreGui = game:GetService('StarterGui')
local ContextActionService = game:GetService('ContextActionService')
local UserInputService = game:GetService('UserInputService')
-- // // // Locals // // // --
local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart")
local UserPlayer = HumanoidRootPart:WaitForChild("user")
local ActiveFolder = Workspace:FindFirstChild("active")
local FishingZonesFolder = Workspace:FindFirstChild("zones"):WaitForChild("fishing")
local TpSpotsFolder = Workspace:FindFirstChild("world"):WaitForChild("spawns"):WaitForChild("TpSpots")
local NpcFolder = Workspace:FindFirstChild("world"):WaitForChild("npcs")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RenderStepped = RunService.RenderStepped
local WaitForSomeone = RenderStepped.Wait
if not game:IsLoaded() then
    game.Loaded:Wait()
end
--Gui Load
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/PapaDusty/Fluent/refs/heads/main/Knuxy92"))()
--loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()


local Window = Fluent:CreateWindow({
    Title = "Skibidi Client V6.1.0",
    SubTitle = "Fisch",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Reaper",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})


-- // // // Tabs Gui // // // --

local Tabs = { -- https://lucide.dev/icons/
    Update = Window:AddTab({ Title = "Updates", Icon = "party-popper" }),
    Home = Window:AddTab({ Title = "Fishing", Icon = "box" }),
    Auto = Window:AddTab({ Title = "Automatic", Icon = "repeat" }),
    Teleports = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Performance = Window:AddTab({ Title = "Performance", Icon = "hammer" }),
    Random = Window:AddTab({ Title = "Miscellaneous", Icon = "star" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "cog" })
}




-- // // // Teleports // // // --
local itemSpots = {
    BaitCrate = CFrame.new(384.57513427734375, 135.3519287109375, 337.5340270996094),
    QualityBaitCrate = CFrame.new(-177.876, 144.472, 1932.844),
    CrabCage = CFrame.new(474.803589, 149.664566, 229.49469, -0.721874595, 0, 0.692023814, 0, 1, 0, -0.692023814, 0, -0.721874595),
    GPS = CFrame.new(517.896729, 149.217636, 284.856842, 7.39097595e-06, -0.719539165, -0.694451928, -1, -7.39097595e-06, -3.01003456e-06, -3.01003456e-06, 0.694451928, -0.719539165),
    BasicDiving_Gear = CFrame.new(369.174774, 132.508835, 248.705368, 0.228398502, -0.158300221, -0.96061182, 1.58026814e-05, 0.986692965, -0.162594408, 0.973567724, 0.037121132, 0.225361705),
    FishRadar = CFrame.new(365.75177, 134.50499, 274.105804, 0.704499543, -0.111681774, -0.70086211, 1.32396817e-05, 0.987542748, -0.157350808, 0.709704578, 0.110844307, 0.695724905)
}
local rodSpots = {
    TrainingRod = CFrame.new(457.693848, 148.357529, 230.414307, 1, -0, 0, 0, 0.975410998, 0.220393807, -0, -0.220393807, 0.975410998),
    PlasticRod = CFrame.new(454.425385, 148.169739, 229.172424, 0.951755166, 0.0709736273, -0.298537821, -3.42726707e-07, 0.972884834, 0.231290117, 0.306858391, -0.220131472, 0.925948203),
    LuckyRod = CFrame.new(446.085999, 148.253006, 222.160004, 0.974526405, -0.22305499, 0.0233404674, 0.196993902, 0.901088715, 0.386306256, -0.107199371, -0.371867687, 0.922075212),
    KingsRod = CFrame.new(1375.57642, -810.201721, -303.509247, -0.7490201, 0.662445903, -0.0116144121, -0.0837960541, -0.0773290396, 0.993478119, 0.657227278, 0.745108068, 0.113431036),
    FlimsyRod = CFrame.new(471.107697, 148.36171, 229.642441, 0.841614008, 0.0774728209, -0.534493923, 0.00678436086, 0.988063335, 0.153898612, 0.540036798, -0.13314943, 0.831042409),
    NocturnalRod = CFrame.new(-141.874237, -515.313538, 1139.04529, 0.161644459, -0.98684907, 1.87754631e-05, 1.87754631e-05, 2.21133232e-05, 1, -0.98684907, -0.161644459, 2.21133232e-05),
    FastRod = CFrame.new(447.183563, 148.225739, 220.187454, 0.981104493, 1.26492232e-05, 0.193478703, -0.0522461236, 0.962867677, 0.264870107, -0.186291039, -0.269973755, 0.944674432),
    CarbonRod = CFrame.new(454.083618, 150.590073, 225.328827, 0.985374212, -0.170404434, 1.41561031e-07, 1.41561031e-07, 1.7285347e-06, 1, -0.170404434, -0.985374212, 1.7285347e-06),
    LongRod = CFrame.new(485.695038, 171.656326, 145.746109, -0.630167365, -0.776459217, -5.33461571e-06, 5.33461571e-06, -1.12056732e-05, 1, -0.776459217, 0.630167365, 1.12056732e-05),
    SteadyRod = CFrame.new(-1512.819580078125, 141.8529052734375, 761.9188842773438),
    MythicalRod = CFrame.new(389.716705, 132.588821, 314.042847, 0, 1, 0, 0, 0, -1, -1, 0, 0),
    MidasRod = CFrame.new(401.981659, 133.258316, 326.325745, 0.16456604, 0.986365497, 0.00103566051, 0.00017541647, 0.00102066994, -0.999999464, -0.986366034, 0.1645661, -5.00679016e-06),
    TridentRod = CFrame.new(-1479.2567138671875, -226.02633666992188, -2238.373291015625),
    RodOfTheDepths = CFrame.new(1689.80419921875, -902.5269775390625, 1413.22119140625),
    HeavensRod = CFrame.new(20017.70703125, -467.66497802734375, 7020.87744140625),
}

-- // // // Variables // // // --
local CastMode = "Perfect"
local ShakeMode = "Vector"
local ReelMode = "Blatant"
local teleportSpots = {}
local FreezeChar = false
local BypassGpsLoop = nil
local Noclip = false
local AntiAfk = false




-- // // // Updates Tab // // // --

local section = Tabs.Update:AddSection("1/14/25")
Tabs.Update:AddParagraph({
    Title = "Fixing stuff + adding better stuff",
    Content = "Added - New Performace Tab\nAdded - 2 New UI colors (Naoki + Reaper)\nAdded - New Fastest Auto Shake (Vector)\nFixed   - Autocast randomly stopping\nFixed   - Navigation mode randomly slowing down"
})



local section = Tabs.Update:AddSection("1/12/25")
Tabs.Update:AddParagraph({
    Title = "Finally updated dusty hub bro omfg it was so butt",
    Content = "Added - 4 New Totem Teleports\nAdded - Disable Temperature\nAdded - 3 New Rod Teleports"
})






-- // // // Auto Cast // // // --
--[[
local autoCastEnabled = false
local function autoCast()
    if LocalCharacter then
        local tool = LocalCharacter:FindFirstChildOfClass("Tool")
        if tool then
            local hasBobber = tool:FindFirstChild("bobber")
            if not hasBobber then
                if CastMode == "Legit" then
print("works but doiesnt")
                elseif CastMode == "Blatant - broken :(" then
                    local rod = LocalCharacter and LocalCharacter:FindFirstChildOfClass("Tool")
                    if rod and rod:FindFirstChild("values") and string.find(rod.Name, "Rod") then
                        task.wait(0.8)
                        local Random = math.random(90, 99)
                        rod.events.cast:FireServer(Random)
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
]]--

-- // // // Auto Shake // // // --
local autoShakeEnabled = false
local autoShakeConnection
local function autoShake()
    if ShakeMode == "Navigation" then
        task.wait()
        xpcall(function()
            local shakeui = PlayerGui:FindFirstChild("shakeui")
            if not shakeui then return end
            local safezone = shakeui:FindFirstChild("safezone")
            local button = safezone and safezone:FindFirstChild("button")
            task.wait(autoShakeDelay)
            GuiService.SelectedObject = button
            if GuiService.SelectedObject == button then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
            task.wait(0.1)
            GuiService.SelectedObject = nil
        end,function (err)
        end)
    elseif ShakeMode == "Mouse" then
        task.wait()
        xpcall(function()
            local shakeui = PlayerGui:FindFirstChild("shakeui")
            if not shakeui then return end
            local safezone = shakeui:FindFirstChild("safezone")
            local button = safezone and safezone:FindFirstChild("button")
            local pos = button.AbsolutePosition
            local size = button.AbsoluteSize
            VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, true, LocalPlayer, 0)
            VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, LocalPlayer, 0)
        end,function (err)
        end)
    elseif ShakeMode == "Vector" then
        task.wait()
        xpcall(function()
                PlayerGui:FindFirstChild("shakeui").safezone:FindFirstChild("button").Size = UDim2.new(1001, 0, 1001, 0)
                game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                game:GetService("VirtualUser"):Button1Up(Vector2.new(1, 1))
                task.wait(autoShakeDelay)
        end,function (err)
        end)
        
    end
end

local function startAutoShake()
    if autoShakeConnection or not autoShakeEnabled then return end
    autoShakeConnection = RunService.RenderStepped:Connect(autoShake)
end

local function stopAutoShake()
    if autoShakeConnection then
        autoShakeConnection:Disconnect()
        autoShakeConnection = nil
    end
end

PlayerGui.DescendantAdded:Connect(function(descendant)
    if autoShakeEnabled and descendant.Name == "button" and descendant.Parent and descendant.Parent.Name == "safezone" then
        startAutoShake()
    end
end)

PlayerGui.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "playerbar" and descendant.Parent and descendant.Parent.Name == "bar" then
        stopAutoShake()
    end
end)

if autoShakeEnabled and PlayerGui:FindFirstChild("shakeui") and PlayerGui.shakeui:FindFirstChild("safezone") and PlayerGui.shakeui.safezone:FindFirstChild("button") then
    startAutoShake()
end

-- // // // Auto Reel // // // --
local autoReelEnabled = false
local PerfectCatchEnabled = false
local autoReelConnection
local function autoReel()
    local reel = PlayerGui:FindFirstChild("reel")
    if not reel then return end
    local bar = reel:FindFirstChild("bar")
    local playerbar = bar and bar:FindFirstChild("playerbar")
    local fish = bar and bar:FindFirstChild("fish")
    if playerbar and fish then
        playerbar.Position = fish.Position
    end
end

local function noperfect()
    local reel = PlayerGui:FindFirstChild("reel")
    if not reel then return end
    local bar = reel:FindFirstChild("bar")
    local playerbar = bar and bar:FindFirstChild("playerbar")
    if playerbar then
        playerbar.Position = UDim2.new(0, 0, -35, 0)
        wait(0.2)
    end
end

local function startAutoReel()
    if ReelMode == "Legit" then
        if autoReelConnection or not autoReelEnabled then return end
        noperfect()
        task.wait(2)
        autoReelConnection = RunService.RenderStepped:Connect(autoReel)
    elseif ReelMode == "Blatant" then
        local reel = PlayerGui:FindFirstChild("reel")
        if not reel then return end
        local bar = reel:FindFirstChild("bar")
        local playerbar = bar and bar:FindFirstChild("playerbar")
        playerbar:GetPropertyChangedSignal('Position'):Wait()
        game.ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100, false)
    end
end

local function stopAutoReel()
    if autoReelConnection then
        autoReelConnection:Disconnect()
        autoReelConnection = nil
    end
end

PlayerGui.DescendantAdded:Connect(function(descendant)
    if autoReelEnabled and descendant.Name == "playerbar" and descendant.Parent and descendant.Parent.Name == "bar" then
        startAutoReel()
    end
end)

--[[
PlayerGui.DescendantRemoving:Connect(function(descendant)
    if descendant.Name == "playerbar" and descendant.Parent and descendant.Parent.Name == "bar" then
        stopAutoReel()
        if autoCastEnabled then
            task.wait(1)
            autoCast()
        end
    end
end)
]]
if autoReelEnabled and PlayerGui:FindFirstChild("reel") and 
    PlayerGui.reel:FindFirstChild("bar") and 
    PlayerGui.reel.bar:FindFirstChild("playerbar") then
    startAutoReel()
end

-- // // // Zone Cast // // // --
ZoneConnection = LocalCharacter.ChildAdded:Connect(function(child)
    if ZoneCast and child:IsA("Tool") and FishingZonesFolder:FindFirstChild(Zone) ~= nil then
        child.ChildAdded:Connect(function(blehh)
            if blehh.Name == "bobber" then
                local RopeConstraint = blehh:FindFirstChildOfClass("RopeConstraint")
                if ZoneCast and RopeConstraint ~= nil then
                    RopeConstraint.Changed:Connect(function(property)
                        if property == "Length" then
                            RopeConstraint.Length = math.huge
                        end
                    end)
                    RopeConstraint.Length = math.huge
                end
                task.wait(1)
                while WaitForSomeone(RenderStepped) do
                    if ZoneCast and blehh.Parent ~= nil then
                        task.wait()
                        blehh.CFrame = FishingZonesFolder[Zone].CFrame
                    else
                        break
                    end
                end
            end
        end)
    end
end)

-- // Find TpSpots // --
local TpSpotsFolder = Workspace:FindFirstChild("world"):WaitForChild("spawns"):WaitForChild("TpSpots")
for i, v in pairs(TpSpotsFolder:GetChildren()) do
    if table.find(teleportSpots, v.Name) == nil then
        table.insert(teleportSpots, v.Name)
    end
end

-- // // // Get Position // // // --
function GetPosition()
	if not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return {
			Vector3.new(0,0,0),
			Vector3.new(0,0,0),
			Vector3.new(0,0,0)
		}
	end
	return {
		game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.X,
		game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y,
		game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Z
	}
end

function ExportValue(arg1, arg2)
	return tonumber(string.format("%."..(arg2 or 1)..'f', arg1))
end


-- // // // Noclip Stepped // // // --
NoclipConnection = RunService.Stepped:Connect(function()
    if Noclip == true then
        if LocalCharacter ~= nil then
            for i, v in pairs(LocalCharacter:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
    end
end)

PlayerGui.DescendantAdded:Connect(function(descendant)
    if DupeEnabled and descendant.Name == "confirm" and descendant.Parent and descendant.Parent.Name == "offer" then
        local hud = LocalPlayer.PlayerGui:FindFirstChild("hud")
        if hud then
            local safezone = hud:FindFirstChild("safezone")
            if safezone then
                local bodyAnnouncements = safezone:FindFirstChild("bodyannouncements")
                if bodyAnnouncements then
                    local offerFrame = bodyAnnouncements:FindFirstChild("offer")
                    if offerFrame and offerFrame:FindFirstChild("confirm") then
                        firesignal(offerFrame.confirm.MouseButton1Click)
                    end
                end
            end
        end
    end
end)




local Options = Fluent.Options

do

    -- // Main Tab // --
    local section = Tabs.Home:AddSection("Auto Fishing")
    local autoCast = Tabs.Home:AddToggle("autoCast", {Title = "Auto Cast", Default = false })
    autoCast:OnChanged(function()
        local RodName = ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.rod.Value
        if Options.autoCast.Value == true then
            autoCastEnabled = true
            if LocalPlayer.Backpack:FindFirstChild(RodName) then
                LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(RodName))
            end
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    local hasBobber = tool:FindFirstChild("bobber")
                    if not hasBobber then
                        if CastMode == "Perfect" then
                            getgenv().AutoCastTest = true
                            task.spawn(function()
                                while task.wait(1) do
                                    if getgenv().AutoCastTest then
                            local castEvent = tool:FindFirstChild("events") and tool.events:FindFirstChild("cast")
                            task.wait(1)
                            if castEvent then
                                local Random = math.random() * (99 - 90) + 90
                                local FRandom = string.format("%.4f", Random)
                                local Random2 = math.random(90, 99)
                                castEvent:FireServer(Random2)
                            end
                        end
                    end
                    end)
                        elseif CastMode == "Blatant - broken :(" then
                            local rod = LocalCharacter and LocalCharacter:FindFirstChildOfClass("Tool")
                            if rod and rod:FindFirstChild("values") and string.find(rod.Name, "Rod") then
                                task.wait(5)
                                local Random = math.random(90, 99)
                                rod.events.cast:FireServer(Random)
                            end
                        end
                    end
                end
                task.wait(1)
            end
        else
            getgenv().AutoCastTest = false
        end
    end)













    local autoShake = Tabs.Home:AddToggle("autoShake", {Title = "Auto Shake", Default = false })
    autoShake:OnChanged(function()
        if Options.autoShake.Value == true then
            autoShakeEnabled = true
            startAutoShake()
        else
            autoShakeEnabled = false
            stopAutoShake()
        end
    end)
    local shakeDelay = Tabs.Home:AddSlider("Slider", {
        Title = "Auto Shake Delay",
        Default = 2,
        Min = 0.02,
        Max = 0.25,
        Rounding = 2,
        Callback = function(Value)
            autoShakeDelay = Value
        end
    })
    shakeDelay:OnChanged(function(Value)
        autoShakeDelay = Value
    end)
    shakeDelay:SetValue(0.5)
    local autoReel = Tabs.Home:AddToggle("autoReel", {Title = "Auto Reel", Default = false })
    autoReel:OnChanged(function()
        if Options.autoReel.Value == true then
            autoReelEnabled = true
            startAutoReel()
        else
            autoReelEnabled = false
            stopAutoReel()
        end
    end)
    local FreezeCharacter = Tabs.Home:AddToggle("FreezeCharacter", {Title = "Freeze Character", Default = false })
    FreezeCharacter:OnChanged(function()
        local oldpos = HumanoidRootPart.CFrame
        FreezeChar = Options.FreezeCharacter.Value
        task.wait()
        while WaitForSomeone(RenderStepped) do
            if FreezeChar and HumanoidRootPart ~= nil then
                task.wait()
                HumanoidRootPart.CFrame = oldpos
            else
                break
            end
        end
    end)

    -- // Modes Tab // --

    local autoShakeMode = Tabs.Home:AddDropdown("autoShakeMode", {
        Title = "Auto Shake Mode",
        Values = {"Navigation", "Mouse", "Vector"},
        Multi = false,
        Default = ShakeMode,
    })
    autoShakeMode:OnChanged(function(Value)
        ShakeMode = Value
    end)
    local autoReelMode = Tabs.Home:AddDropdown("autoReelMode", {
        Title = "Auto Reel Mode",
        Values = {"Blatant", "Legit"},
        Multi = false,
        Default = ReelMode,
    })
    autoReelMode:OnChanged(function(Value)
        ReelMode = Value
    end)



    -- // Automatic Tab // --
    local section = Tabs.Auto:AddSection("Meteor")
    Tabs.Auto:AddButton({
        Title = "Teleport to Meteor",
        Callback = function()
            HumanoidRootPart.CFrame = CFrame.new(5692.46728515625, 173.22482299804688, 629.6260986328125)
        end
    })
    local AutoMeteor = Tabs.Auto:AddToggle("AutoMeteor", {Title = "AutoCollect Meteor", Default = false})
    AutoMeteor:OnChanged(function(state)
        autoMeteor = state
        if autoMeteor == true then
            -- Teleport to the initial position
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5692.46728515625, 173.22482299804688, 629.6260986328125)
            task.wait(0.5)
            
            -- Look for ProximityPrompt objects in the workspace
            for i, v in ipairs(game:GetService("Workspace"):GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0  -- Set hold duration to zero to activate immediately
                end
            end
            for i, v in pairs(workspace.MeteorItems:GetDescendants()) do
                if v:IsA("Part") and v:FindFirstChild("MeteorItems") then 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                    for _, prompt in pairs(v:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") then
                            -- Fire the proximity prompt
                            local success, errorMessage = pcall(function()
                                prompt:InputBegan(Enum.UserInputType.MouseButton1)
                                fireproximityprompt(v)
                            end)
                            
                            if not success then
                                warn("Error firing ProximityPrompt: " .. errorMessage)
                            end
                        end
                    end
                    task.wait(1)
                end
            end
        end
    end)
    



    local section = Tabs.Auto:AddSection("Treasure")
    Tabs.Auto:AddButton({
        Title = "Repair Map/s",
        Description = "Must teleport and talk to Jack Marrow.",
        Callback = function()
            HumanoidRootPart.CFrame = CFrame.new(261.623291015625, 135.7983856201172, 59.286502838134766)
            task.wait(0.5)
            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do 
                if v.Name == "Treasure Map" then
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                    workspace.world.npcs["Jack Marrow"].treasure.repairmap:InvokeServer()
                end
            end
        end
    })
    Tabs.Auto:AddButton({
        Title = "Collect Treasure/s",
        Callback = function()
            for i, v in ipairs(game:GetService("Workspace"):GetDescendants()) do
                if v.ClassName == "ProximityPrompt" then
                    v.HoldDuration = 0
                end
            end
            for i, v in pairs(workspace.world.chests:GetDescendants()) do
                if v:IsA("Part") and v:FindFirstChild("ChestSetup") then 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                    for _, v in pairs(workspace.world.chests:GetDescendants()) do
                        if v.Name == "ProximityPrompt" then
                            fireproximityprompt(v)
                        end
                    end
                    task.wait(1)
                end 
            end
        end
    })

    -- // Teleports Tab // --
    local IslandTPDropdownUI = Tabs.Teleports:AddDropdown("IslandTPDropdownUI", {
        Title = "Area Teleport",
        Values = teleportSpots,
        Multi = false,
        Default = nil,
    })
    IslandTPDropdownUI:OnChanged(function(Value)
        if teleportSpots ~= nil and HumanoidRootPart ~= nil then
            xpcall(function()
                HumanoidRootPart.CFrame = TpSpotsFolder:FindFirstChild(Value).CFrame + Vector3.new(0, 5, 0)
                IslandTPDropdownUI:SetValue(nil)
            end,function (err)
            end)
        end
    end)






    local ItemTeleport = Tabs.Teleports:AddDropdown("ItemTeleport", {
        Title = "Item Teleport",
        Values = {"BasicDivingGear", "FishRadar", "BaitCrate", "QualityBaitCrate", "CrabCage", "GPS"},
        Multi = false,
        Default = nil,
    })
    ItemTeleport:OnChanged(function(Value)
        if itemSpots ~= nil and HumanoidRootPart ~= nil then
            local item = itemSpots[Value]
            if typeof(item) == "CFrame" then
                HumanoidRootPart.CFrame = item
            else
                print("1")
            end
        end
    end)
    local RodTeleport = Tabs.Teleports:AddDropdown("ItemTeleport", {
        Title = "Rod Teleport",
        Values = {"TrainingRod", "PlasticRod", "LuckyRod", "NocturnalRod", "KingsRod", "FlimsyRod", "FastRod", "CarbonRod", "LongRod", "SteadyRod", "MythicalRod", "MidasRod", "TridentRod", "RodOfTheDepths", "HeavensRod"},
        Multi = false,
        Default = nil,
    })
    RodTeleport:OnChanged(function(Value)
        if rodSpots ~= nil and HumanoidRootPart ~= nil then
            local rods = rodSpots[Value]
            if typeof(rods) == "CFrame" then
                HumanoidRootPart.CFrame = rods
            else
                print("2")
            end
        end
    end)



    local TotemTeleport = Tabs.Teleports:AddDropdown("TotemTPDropdownUI", {
        Title = "Select Totem",
        Values = {"Aurora", "Smokescreen", "Windset", "Tempest", "Sundial", "Eclipse", "Meteor", "Blizzard", "Avalanche"},
        Multi = false,
        Default = nil,
    })
    TotemTeleport:OnChanged(function(Value)
        TotemSpot = Value
        if TotemSpot == "Aurora" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1811.221435546875, -136.92794799804688, -3281.392333984375)
        elseif TotemSpot == "Smokescreen" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2788.803466796875, 139.8431396484375, -625.8352661132812)
        elseif TotemSpot == "Windset" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2849, 178.33323669433594, 2702)
        elseif TotemSpot == "Tempest" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(34.999916076660156, 132.5, 1943)
        elseif TotemSpot == "Sundial" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1148, 134.49998474121094, -1075)
        elseif TotemSpot == "Eclipse" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5967.275390625, 274.1084899902344, 842.9871826171875)
        elseif TotemSpot == "Meteor" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1950.4515380859375, 275.3567199707031, 228.5755615234375)
        elseif TotemSpot == "Blizzard" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(20145, 742.9527587890625, 5805)
        elseif TotemSpot == "Avalanche" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(19709.763671875, 467.6305847167969, 6061.97998046875)
        end
    end)
    --[[
    local WorldEventTPDropdownUI = Tabs.Teleports:AddDropdown("WorldEventTPDropdownUI", {
        Title = "Select World Event",
        Values = {"Ancient Megalodon", "Megalodon", "Strange Whirlpool", "Great Hammerhead Shark", "Great White Shark", "Whale Shark", "The Depths - Serpent"},
        Multi = false,
        Default = nil,
    })
    WorldEventTPDropdownUI:OnChanged(function(Value)
        SelectedWorldEvent = Value
        if SelectedWorldEvent == "Ancient Megalodon" then
            local offset = Vector3.new(25, 135, 25)
            local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("Ancient Megalodon")
            if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Cant find Ancient Megalodon") end
            HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing.Isonade.Position + offset)                           -- Strange Whirlpool
            WorldEventTPDropdownUI:SetValue(nil)
        elseif SelectedWorldEvent == "Megalodon" then
            local offset = Vector3.new(25, 135, 25)
            local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("Megalodon")
            if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Cant find Strange Whirlpool") end
            HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing.Isonade.Position + offset)                           -- Strange Whirlpool
            WorldEventTPDropdownUI:SetValue(nil)
        elseif SelectedWorldEvent == "Strange Whirlpool" then
            local offset = Vector3.new(25, 135, 25)
            local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("Isonade")
            if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Cant find Strange Whirlpool") end
            HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing.Isonade.Position + offset)                           -- Strange Whirlpool
            WorldEventTPDropdownUI:SetValue(nil)
        elseif SelectedWorldEvent == "Great Hammerhead Shark" then
            local offset = Vector3.new(0, 135, 0)
            local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("Great Hammerhead Shark")
            if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Cant find Great Hammerhead Shark") end
            HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing["Great Hammerhead Shark"].Position + offset)         -- Great Hammerhead Shark
            WorldEventTPDropdownUI:SetValue(nil)
        elseif SelectedWorldEvent == "Great White Shark" then
            local offset = Vector3.new(0, 135, 0)
            local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("Great White Shark")
            if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Cant find Great White Shark") end
            HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing["Great White Shark"].Position + offset)               -- Great White Shark
            WorldEventTPDropdownUI:SetValue(nil)
        elseif SelectedWorldEvent == "Whale Shark" then
            local offset = Vector3.new(0, 135, 0)
            local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("Whale Shark")
            if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Cant find Whale Shark") end
            HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing["Whale Shark"].Position + offset)                     -- Whale Shark
            WorldEventTPDropdownUI:SetValue(nil)
        elseif SelectedWorldEvent == "The Depths - Serpent" then
            local offset = Vector3.new(0, 50, 0)
            local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("The Depths - Serpent")
            if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Cant find The Depths - Serpent") end
            HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing["The Depths - Serpent"].Position + offset)            -- The Depths - Serpent
            WorldEventTPDropdownUI:SetValue(nil)
        end
    end)]]

    Tabs.Teleports:AddButton({
        Title = "Teleport to Traveler Merchant",
        Description = "Teleports to the Traveler Merchant.",
        Callback = function()
            local Merchant = game.Workspace.active:FindFirstChild("Merchant Boat")
            if not Merchant then return ShowNotification("Not found Merchant") end
            HumanoidRootPart.CFrame = CFrame.new(game.Workspace.active["Merchant Boat"].Boat["Merchant Boat"].r.HandlesR.Position)
        end
    })


    -- // Character Tab // --
    local DisableTemp = Tabs.Player:AddToggle("DisableTemp", {Title = "Disable Temperature", Default = false})
    DisableTemp:OnChanged(function()
        LocalPlayer.Character.client.temperature.Disabled = Options.DisableTemp.Value
    end)
 

    local DisableOxygen = Tabs.Player:AddToggle("DisableOxygen", {Title = "Disable Oxygen", Default = false })
    DisableOxygen:OnChanged(function()
        LocalPlayer.Character.client.oxygen.Disabled = Options.DisableOxygen.Value
    end)

    local WalkOnWater = Tabs.Player:AddToggle("WalkOnWater", {Title = "Walk On Water", Default = false })
    WalkOnWater:OnChanged(function()
        for i,v in pairs(workspace.zones.fishing:GetChildren()) do
			if v.Name == WalkZone then
				v.CanCollide = Options.WalkOnWater.Value
                if v.Name == "Ocean" then
                    for i,v in pairs(workspace.zones.fishing:GetChildren()) do
                        if v.Name == "Deep Ocean" then
                            v.CanCollide = Options.WalkOnWater.Value
                        end
                    end
                end
			end
		end
    end)
    local WalkOnWaterZone = Tabs.Player:AddDropdown("WalkOnWaterZone", {
        Title = "Walk On Water Area",
        Values = {"Ocean", "Desolate Deep", "The Depths"},
        Multi = false,
        Default = "Ocean",
    })
    WalkOnWaterZone:OnChanged(function(Value)
        WalkZone = Value
    end)
    local WalkSpeedSliderUI = Tabs.Player:AddSlider("WalkSpeedSliderUI", {
        Title = "Walk Speed",
        Min = 16,
        Max = 500,
        Default = 16,
        Rounding = 1,
    })
    WalkSpeedSliderUI:OnChanged(function(value)
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end)
    local JumpHeightSliderUI = Tabs.Player:AddSlider("JumpHeightSliderUI", {
        Title = "Jump Height",
        Min = 50,
        Max = 200,
        Default = 50,
        Rounding = 1,
    })
    JumpHeightSliderUI:OnChanged(function(value)
        LocalPlayer.Character.Humanoid.JumpPower = value
    end)

    local ToggleNoclip = Tabs.Player:AddToggle("ToggleNoclip", {Title = "Noclip", Default = false })
    ToggleNoclip:OnChanged(function()
        Noclip = Options.ToggleNoclip.Value
    end)

    -- // Visual Tab // --
    local AntiAfk = Tabs.Visual:AddToggle("AntiAfk", {Title = "Remove AFK Title (Server)", Default = false })
    AntiAfk:OnChanged(function()
        spawn(function()
            while true do
                game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("afk"):FireServer(false)
                task.wait(0.01)
            end
        end)
    end)


    local BypassRadar = Tabs.Visual:AddToggle("BypassRadar", {Title = "Activate Fish Radar", Default = false })
    BypassRadar:OnChanged(function()
        for _, v in pairs(game:GetService("CollectionService"):GetTagged("radarTag")) do
			if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
				v.Enabled = Options.BypassRadar.Value
			end
		end
    end)
    local BypassGPS = Tabs.Visual:AddToggle("BypassGPS", {Title = "Activate GPS", Default = false })
    BypassGPS:OnChanged(function()
        if Options.BypassGPS.Value == true then
            local XyzClone = game:GetService("ReplicatedStorage").resources.items.items.GPS.GPS.gpsMain.xyz:Clone()
			XyzClone.Parent = game.Players.LocalPlayer.PlayerGui:WaitForChild("hud"):WaitForChild("safezone"):WaitForChild("backpack")
			local Pos = GetPosition()
			local StringInput = string.format("%s, %s, %s", ExportValue(Pos[1]), ExportValue(Pos[2]), ExportValue(Pos[3]))
			XyzClone.Text = "<font color='#ff4949'>X</font><font color = '#a3ff81'>Y</font><font color = '#626aff'>Z</font>: "..StringInput
			BypassGpsLoop = game:GetService("RunService").Heartbeat:Connect(function()
				local Pos = GetPosition()
				StringInput = string.format("%s, %s, %s", ExportValue(Pos[1]), ExportValue(Pos[2]), ExportValue(Pos[3]))
				XyzClone.Text = "<font color='#ff4949'>X</font><font color = '#a3ff81'>Y</font><font color = '#626aff'>Z</font> : "..StringInput
			end)
		else
			if PlayerGui.hud.safezone.backpack:FindFirstChild("xyz") then
				PlayerGui.hud.safezone.backpack:FindFirstChild("xyz"):Destroy()
			end
			if BypassGpsLoop then
				BypassGpsLoop:Disconnect()
				BypassGpsLoop = nil
			end
        end
    end)
    local RemoveFog = Tabs.Visual:AddToggle("RemoveFog", {Title = "Clear Fog", Default = false })
    RemoveFog:OnChanged(function()
        if Options.RemoveFog.Value == true then
            if game:GetService("Lighting"):FindFirstChild("Sky") then
                game:GetService("Lighting"):FindFirstChild("Sky").Parent = game:GetService("Lighting").bloom
            end
        else
            if game:GetService("Lighting").bloom:FindFirstChild("Sky") then
                game:GetService("Lighting").bloom:FindFirstChild("Sky").Parent = game:GetService("Lighting")
            end
        end
    end)


--Performance Tab
local FPSSlider = Tabs.Performance:AddSlider("FPSSlider", {
    Title = "FPS Unlocker",
    Description = "Go past Roblox's 240 FPS lock",
    Default = 240,
    Min = 60,
    Max = 1000,
    Rounding = 1,
    Callback = function(Value)
        local fpsCap = tonumber(Value) -- Convert the string to a number
        if fpsCap then
            setfpscap(fpsCap) -- Pass the numeric value to setfpscap
        else
            warn("Invalid FPS value: " .. tostring(Value))
        end
    end
})



    local FullB = ReplicatedStorage.world.weather.Value
    local Fullbright = Tabs.Performance:AddToggle("Fullbright", {Title = "Fulbright", Default = false })
    Fullbright:OnChanged(function()
        if Options.Fullbright.Value == true then
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").ClockTime = 12
            game:GetService("Lighting").FogEnd = 786543
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
		else
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 12
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").Ambient = Color3.fromRGB(1, 1, 1)
        end
    end)

    local OldWEA = ReplicatedStorage.world.weather.Value
    local RemoveWeather = Tabs.Performance:AddToggle("RemoveWeather", {Title = "Clear Weather", Default = false })
    RemoveWeather:OnChanged(function()
        if Options.RemoveWeather.Value == true then
			ReplicatedStorage.world.weather.Value = 'Clear' 
		else
			ReplicatedStorage.world.weather.Value = OldWEA
        end
    end)

    local JustUI = Tabs.Performance:AddToggle("JustUI", {Title = "Show/Hide UI", Default = true })
    JustUI:OnChanged(function()
        local BlackShow = JustUI.Value
        if BlackShow then
            PlayerGui.hud.safezone.Visible = true
        else
            PlayerGui.hud.safezone.Visible = false
        end
    end)













    local IdentityHiderUI = Tabs.Visual:AddToggle("IdentityHiderUI", {Title = "Protect Identity", Default = false })    
    IdentityHiderUI:OnChanged(function()
        while Options.IdentityHiderUI.Value == true do
            if UserPlayer:FindFirstChild("streak") then UserPlayer.streak.Text = "DUSTYHUB" end
            if UserPlayer:FindFirstChild("level") then UserPlayer.level.Text = "Level: DUSTYHUB" end
            if UserPlayer:FindFirstChild("level") then UserPlayer.user.Text = "DUSTYHUB" end
            local hud = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("hud"):WaitForChild("safezone")
            if hud:FindFirstChild("coins") then hud.coins.Text = "DUSTYHUB$" end
            if hud:FindFirstChild("lvl") then hud.lvl.Text = "DUSTYHUB" end
            task.wait(0.01)
        end
    end)

    -- // Load Tab // --
    local section = Tabs.Random:AddSection("made by illegaldusty, UI stolen from Knuxy92")

    Tabs.Random:AddButton({
        Title = "Infinite-Yield",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end
    })
    Tabs.Random:AddButton({
        Title = "RemoteSpy",
        Callback = function()
            loadstring(game:HttpGetAsync("https://github.com/richie0866/remote-spy/releases/latest/download/RemoteSpy.lua"))()
        end
    })
    Tabs.Random:AddButton({
        Title = "Copy XYZ",
        Description = "Copy Clipboard",
        Callback = function()
            local XYZ = tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
            setclipboard("game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(" .. XYZ .. ")")
        end
    })


end

Window:SelectTab(1)
Fluent:Notify({
    Title = "DustyHub",
    Content = "Executed!",
    Duration = 8
})

-- Save Manager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("DustyHub")
SaveManager:SetFolder("DustyHub/Fisch")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()
