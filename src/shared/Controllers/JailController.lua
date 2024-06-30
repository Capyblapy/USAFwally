local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local plr = game:GetService("Players").LocalPlayer

local JailController = Knit.CreateController {
    Name = "JailController",
}

function JailController:KnitStart()
    local JailService = Knit.GetService("JailService")
    local ArrestGUI = plr.PlayerGui:WaitForChild("ArrestGUI")

    -- Temp code to be interfaced with cuff code
    ArrestGUI.ArrestButton.MouseButton1Click:Connect(function()
        local player = game.Players:FindFirstChild(ArrestGUI.NameBox.Text)
        local arrestTime = tonumber(ArrestGUI.TimeBox.Text)

        if player ~= nil and arrestTime ~= nil then
            JailService:Arrest(arrestTime)
        end
    end)
end

return JailController