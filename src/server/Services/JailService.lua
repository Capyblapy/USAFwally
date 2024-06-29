local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local JailService = Knit.CreateService {
    Name = "JailService",
    Client = {},
    Jailed = {}, -- {[player] = time,}
}

function JailService:Arrest(player:Player, time)
    print(player)
    print(time)
end

function JailService:KnitStart()
    self.ProfileService = Knit.GetService("DataService")
    local Players = game:GetService("Players")

    Players.PlayerAdded:Connect(function(player)
        local profile = self.ProfileService:Get(player)

        if profile ~= nil then
            if profile.data.Arrested == true then
                JailService:Arrest(player, profile.data.ArrestTime)
            end
        end
    end)
end

return JailService