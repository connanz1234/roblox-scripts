
local function fireproximityprompt(Obj, Amount, Skip)
    if Obj.ClassName == "ProximityPrompt" then 
        Amount = Amount or 1
        local PromptTime = Obj.HoldDuration
        if Skip then 
            Obj.HoldDuration = 0
        end
        for i = 1, Amount do 
            Obj:InputHoldBegin()
            if not Skip then 
                wait(Obj.HoldDuration)
            end
            Obj:InputHoldEnd()
        end
        Obj.HoldDuration = PromptTime
    else 
        error("userdata<ProximityPrompt> expected")
    end
end

local lp = game.Players.LocalPlayer
local char = lp.Character
local plr = game:GetService("Players").LocalPlayer
local humanoid = plr.Character.Humanoid
local UIS = game:GetService("UserInputService")

getgenv().settings = {
    walkSpeed = 40;
    enableWS = false;
}


local OldIndex
OldIndex = hookmetamethod(game, "__index", newcclosure(function(self, property, value)
    if self == humanoid and tostring(property) == "WalkSpeed" then
        return 16
    end
    return OldIndex(self, property, value)
end))


local function getInstance(promptName)
    if promptName == "ButtonPrompt" then
        print("debug #1")
        local old = char.HumanoidRootPart.Position
        
        for i,v in pairs(workspace:WaitForChild("Buttons"):GetDescendants()) do
            if v and v:IsA("ProximityPrompt") and v.Name == promptName and v.Parent:FindFirstChild("PointLight") and v.Parent:FindFirstChild("PointLight").Enabled == true then
                local orgpos = char.HumanoidRootPart.Position
                print("button check")
                char.HumanoidRootPart.CFrame = CFrame.new(v.Parent.Position+Vector3.new(0,1,-1))
                fireproximityprompt(v, 1, true)
                task.wait(1)
            end
        end
        print("finished itterating")
        char.HumanoidRootPart.CFrame = CFrame.new(old) 
    end
    
    if promptName == "GrabPrompt" then
        print("debug #2")
        local old = char.HumanoidRootPart.Position
        for x,y in pairs(workspace:WaitForChild("Items"):GetDescendants()) do
            if y and y:IsA("ProximityPrompt") then
                print("item check")
                char.HumanoidRootPart.CFrame = CFrame.new(y.Parent.Position+Vector3.new(0, 1, -1))
                fireproximityprompt(y, 1, true)
                task.wait(1)
            end
        end
        char.HumanoidRootPart.CFrame = CFrame.new(old)
    end

end



local function playTween(tweenInstance, proximityPrompt)
    print(proxmityPrompt)
    tweenInstance:Play()
    tweenInstance.Completed:wait()
    fireproximityprompt(proximityPrompt, 1, true)
end



local function getGift(giftName)
    local functionals = game:GetService("Workspace").Functionals
    
    if giftName == "Luminility" then
        game:GetService("TweenService"):Create(char.HumanoidRootPart, TweenInfo.new(5), {CFrame = CFrame.new(-567, 5.5, 745)}):Play()      
    elseif giftName == "Time" then
        print("picked time gift")
        for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
            if v and v:IsA("Model") and v.Name == "Clock" and v.Union and v.Union.ProximityPrompt then
                playTween(game:GetService("TweenService"):Create(char.HumanoidRootPart, TweenInfo.new(5), {CFrame = CFrame.new(v.Union.Position)}), v.Union.ProximityPrompt)
            end
        end
        local grandClock = functionals["Grand Clock"].Hitbox
        local endTween = game:GetService("TweenService"):Create(char.HumanoidRootPart, TweenInfo.new(5), {CFrame = CFrame.new(grandClock.Position)})
        endTween:Play()
    end
    
end




local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/insanedude59/UILib/main/source"))();
lib:SetTitle("Minus Elevation")
local main = lib:NewTab("Main", "in game only, not while in lobby")
local lobby = lib:NewTab("Lobby", "functions to get the current gifts from event")
local UI = game:GetService("CoreGui").ScriptedUI

main:NewSlider("WalkSpeed",16,100,16,function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

main:NewDropdown("Grab/Get (Drop down)",{"Buttons","Items drops"},"hi",function(selected)
	print(selected)
    if selected == "Buttons" then
        
        getInstance("ButtonPrompt")
    end
    if selected == "Items" then
        
        getInstance("GrabPrompt")
    end
end)

main:NewButton("Destroy", function()
    UI:Destroy()
end)


lobby:NewDropdown("Get Gifts (Drop down)",{"Luminility", "Time"}, "Gifts", function(selected)
    print(selected)
    task.spawn(getGift, selected)
end)
local status = true
lobby:NewToggle("Auto Snipe Gift Walker (If you want to get it again re-toggle it)", false, function(value) -- value parameter doesn't go to false for some reason though toggled off
    status = not status
    local giftWalker = game:GetService("Workspace"):WaitForChild("Walk")
    
    while status do
        task.wait()
        if not status then break end
        local walkerPos = giftWalker.HumanoidRootPart
        char.HumanoidRootPart.CFrame = walkerPos.CFrame
        fireproximityprompt(giftWalker.HumanoidRootPart.ProximityPrompt, 1, true)
    end
end)

lobby:NewSlider("WalkSpeed",16,100,16,function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)