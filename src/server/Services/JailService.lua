local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local JailService = Knit.CreateService {
    Name = "JailService",
    Client = {},
    Jailed = {}, -- {[player] = time,}
}

function JailService:Jail(player:Player, timeLeft:number)
    local profile = self.ProfileService:Get(player)

    if profile ~= nil then
        if profile.Data.Arrested == true then
            player.Team = game.Teams:FindFirstChild("Jailed")
            player:LoadCharacter()

            task.delay(timeLeft, function()
                -- Need to add team code?
                player.Team = game.Teams:FindFirstChild("Non-Jailed")
    
                self.ProfileService:Set(player,
                {
                    ["Arrested"] = false,
                })
                player:LoadCharacter()
            end)
        end
    end
end

function JailService.Client:Arrest(player:Player, timeLeft:number)
    self.Server:Arrest(player, timeLeft)
end

function JailService:Arrest(player:Player, timeLeft:number)
    self.ProfileService:Set(player,
    {
        ["Arrested"] = true,
        ["ArrestTime"] = timeLeft,
        ["TimeArrested"] = os.time(),
    })

    self:Jail(player, timeLeft)
end

function JailService:KnitStart()
    self.ProfileService = Knit.GetService("DataService")
    local Players = game:GetService("Players")

    Players.PlayerAdded:Connect(function(player)
        -- Must be better way to do this??
        repeat
            task.wait(1)
        until 
            self.ProfileService:Get(player) ~= nil

        -- actual code
        local profile = self.ProfileService:Get(player)

        if profile ~= nil then
            if profile.Data.Arrested == true then
                JailService:Jail(player, profile.Data.ArrestTime)
            end
        end
    end)
end

return JailService