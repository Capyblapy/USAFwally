-- Packages
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local ClickerService = Knit.CreateService {
    Name = "ClickerService",
    Client = {},
}

function ClickerService.Client:UpdateClicks(player: Player)
    self.Server:UpdateClicks(player)
end

function ClickerService:UpdateClicks(player: Player)
    local profile = self.ProfileService:Get(player)
    if profile ~= nil then
        player.PlayerGui.ClickerGUI.Frame.number.Text = tostring(profile.Data.Clicks) -- ui update
    end
end

function ClickerService.Client:AddClick(player: Player)
    self.Server:AddClick(player)
end

function ClickerService:AddClick(player: Player)
    local profile = self.ProfileService:Get(player)

    if profile ~= nil then
        self.ProfileService:Set(player, {["Clicks"] = profile.Data.Clicks+1})
        self:UpdateClicks(player)
    end
end

function ClickerService:KnitStart()
    self.ProfileService = Knit.GetService("DataService")
end

return ClickerService