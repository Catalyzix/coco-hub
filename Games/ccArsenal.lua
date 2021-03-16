local lib = loadstring(game:HttpGet("https://pastebin.com/raw/V1ca2q9s"))()

local MainUI = lib.Load("Coco Hub | Arsenal")

local GuiInset = game:GetService("GuiService"):GetGuiInset()
local players = game:GetService("Players")
local plr = players.LocalPlayer
local mouse = plr:GetMouse()
local camera = game.Workspace.CurrentCamera
local settings = {
	keybind = Enum.UserInputType.MouseButton2,
	keybind2 = Enum.KeyCode.E
}
local UIS = game:GetService("UserInputService")
local fov = {
    component = Drawing.new("Circle");
    size = 300;
}
local aiming = false
local RightClickAim = false
local TeamCheck = false
_G.aimbot = false
_G.silentaim = false
_G.recoil = false
_G.currentspread = false
_G.infiniteammo = false
_G.alwaysauto = false
_G.firerate = false
function ClosestPlayerToMouseHook()
    if not _G.silentaim then return end
    local target = nil
    local dist = math.huge
    for i,v in pairs(players:GetPlayers()) do
        if v.Name ~= plr.Name then
            if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
                local screenpoint = camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local check = (Vector2.new(mouse.X,mouse.Y)-Vector2.new(screenpoint.X,screenpoint.Y)).magnitude
                if check < dist then
                    target  = v
                    dist = check
                end
            end
        end
    end
    return target 
end
function ClosestPlayerToMouse()
    if not _G._aimbot then return end
    local target = nil
    local dist = math.huge
    local sp = nil
    for i,v in next, game:GetService("Players"):GetPlayers() do
        if i ~= 1 and v.Character then
            local character = v.Character
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if rootPart and humanoid and humanoid.Health > 0 and (not TeamCheck or v.Team ~= plr.Team) then
                local screenpoint, inview = camera:WorldToScreenPoint(rootPart.Position)
                local check = (Vector2.new(mouse.X,mouse.Y)-Vector2.new(screenpoint.X,screenpoint.Y)).magnitude

                if inview and check < dist then
                    dist = check
                    target  = v
                    sp = screenpoint
                end
            end
        end
    end
    return target, sp
end

local Welcome = MainUI.AddPage("Welcome", true)
local Discord = Welcome.AddButton("CC Central Discord (copy to clipboard)", function()
   setclipboard("https://discord.gg/8BvRc4R")
end)

local Main = MainUI.AddPage("Main", true)

local SilentLabel = Main.AddLabel("-=Silent Aim=-")
local SilentToggle = Main.AddToggle("Silent Aim", false, function(Value)
    _G.silentaim = Value
end)

local AimbotLabel = Main.AddLabel("-=Aimbot=-")
local AimbotToggle = Main.AddToggle("Aimbot", false, function(Value)
    _G.aimbot = Value
end)

local TeamCheckToggle = Main.AddToggle("Team Check", false, function(Value)
    TeamCheck = Value
end)

local RightClickAimingToggle = Main.AddToggle("Right Click Aim", false, function(Value)
    RightClickAim = Value
end)

local GunModLabel = Main.AddLabel("Gun Mod")
local NoRecoilToggle = Main.AddToggle("No Recoil", false, function(Value)
    _G.recoil = Value
end)

local NoSpread = Main.AddToggle("No Spread", false, function(Value)
    _G.currentspread = Value
end)

spawn(function()
    local renderStepped = game:GetService("RunService").RenderStepped
    fov.component.Thickness = 3
    fov.component.NumSides = 15
    fov.component.Color = Color3.fromRGB(255, 105, 180)
    fov.component.Visible = false
    fov.component.Position = Vector2.new(mouse.X, mouse.Y+36)
    while running do
        if aiming and ClosestPlayerToMouse then
            local player, screenpoint = ClosestPlayerToMouse()
            if type(player) == "userdata" and player.Character and type(screenpoint) == "userdata" then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local pos = Vector2.new(screenpoint.X, screenpoint.Y)-Vector2.new(mouse.X,mouse.Y)
                    pos = pos - Vector2.new(GuiInset.X, GuiInset.Y) -- offset stuff
                    mousemoverel(pos.X * .05, pos.Y * .05)
                end
            end
        end

        fov.component.Position = Vector2.new(mouse.X, mouse.Y+36)
        fov.component.Color = ESP.Color
        fov.component.Radius = fov.size
        renderStepped:wait()
    end
    for i,v in pairs(getgc(true)) do
        if type(v) == "table" then
            if rawget(v, "getammo") and rawget(v, "updateInventory") and rawget(v, "firebullet") then
                local env = getfenv(v.updateInventory)
                local cmain = v.firebullet
                local mods = v.updateInventory
                table.foreach(v, warn)
                while wait() do
                    if _G.recoil then
                        v.recoil = 0
                    end
                    if _G.currentspread then
                        v.currentspread = 0
                    end
                    if _G.alwaysauto then
                        env.mode = "automatic"
                    end
                    if _G.infiniteammo then
                        debug.setupvalue(mods, 3, 70)
                    end
                    if _G.firerate then
                        env.DISABLED = false
                        env.DISABLED2 = false
                    end
                end
            end
        end
    end
end)
local mt = getrawmetatable(game)
local namecall = mt.__namecall
setreadonly(mt,false)

mt.__namecall = function(self,...)
	local args = {...}
	local method = getnamecallmethod()

	if tostring(self) == "HitPart" and method == "FireServer" then
        if _G.silentaim == true then
            args[1] = ClosestPlayerToMouseHook().Character.Head
            args[2] = ClosestPlayerToMouseHook().Character.Head.Position
        else
            args[1] = args[1]
		    args[2] = args[2]
        end
		return self.FireServer(self, unpack(args))
	end
	return namecall(self,...)
end
UIS.InputBegan:Connect(function(inp)
	if inp.UserInputType == settings.keybind then
	    if RightClickAim then
		    aiming = true
	    end
    end
	if inp.KeyCode == settings.keybind2 then
	    aiming = true
	end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == settings.keybind then
		if RightClickAim then
            aiming = false
		end
	end
	if inp.KeyCode == settings.keybind2 then
	    aiming = false
	end
end)

local Visuals = MainUI.AddPage("Visuals", true)
local ESPLabel = Main.AddLabel("-=ESP=-")

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/VaultGitos/Alantic-LUA/main/KiriotESP.lua"))()
ESP.Color = Color3.fromRGB(255, 255, 255)
ESP.TeamMates = false
local ESPToggle = Visuals.AddToggle("ESP Enabled", false, function(Value)
    ESP:Toggle(Value)
end)

local BoxToggle = Visuals.AddToggle("Box ESP", false, function(Value)
    ESP.Boxes = Value
end)

local TracerToggle = Visuals.AddToggle("Tracer ESP", false, function(Value)
    ESP.Tracers = Value
end)

local NamesToggle = Visuals.AddToggle("Names ESP", false, function(Value)
    ESP.Names = Value
end)

local TeamCheckESPToggle = Visuals.AddToggle("Team Check", false, function(Value)
    ESP.TeamMates = Value
end)

local FOVToggle = Visuals.AddToggle("FOV Enabled", false, function(Value)
    ESP.FOV = Value
    fov.component.Visible = Value
end)

local FOVSlider = Visuals.AddSlider("FOV Size", {Min = 0, Max = 600, Def = 0}, function(Value)
    fov.size = Value
end)

