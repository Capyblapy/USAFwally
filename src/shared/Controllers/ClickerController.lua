local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local plr = game:GetService("Players").LocalPlayer

local ClickerController = Knit.CreateController {
    Name = "ClickerController",
}

function ClickerController:KnitStart()
    local ClickerService = Knit.GetService("ClickerService")
    local ClickerGui = plr.PlayerGui:WaitForChild("ClickerGUI")

    ClickerService:UpdateClicks()

    ClickerGui.Frame.button.MouseButton1Click:Connect(function() -- click is on client controller
        ClickerService:AddClick()
    end)
    print("Clicker Controller Started")
end

function ClickerController:KnitInit()
    print("Clicker Controller Init")
end

return ClickerController