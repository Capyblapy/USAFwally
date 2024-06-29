-- Packages
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local ProfileService = require(game:GetService("ReplicatedStorage").Packages.ProfileService)

local DataService = Knit.CreateService {
    Name = "DataService",
    Client = {},
    Profiles = {}, -- [player] = profile
}

function DataService:Get(player: Player)
    local profile = self.Profiles[player]

    if profile then
        return profile
    else
        return nil
    end
end

-- This function might be bad need review
function DataService:Set(player: Player, dict) -- Data is a dict of {dataName = data,}
    local profile = self:Get(player)

    if profile then
        for key, data in dict do
            if profile.Data[key] ~=  nil then
                profile.Data[key] = data
            end
        end
    end
end

function DataService:KnitInit()
    -- Profile Service
    local Players = game:GetService("Players")
    local ProfileStore = ProfileService.GetProfileStore(
        "PlayerData",
        {
            Clicks = 0,
            Arrested = false,
            ArrestTime = 0,
        }
    )

    local function PlayerAdded(player) -- modified default code
        local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
        if profile ~= nil then
            profile:AddUserId(player.UserId) -- GDPR compliance
            profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
            profile:ListenToRelease(function()
                self.Profiles[player] = nil
                -- The profile could've been loaded on another Roblox server:
                player:Kick()
            end)
            if player:IsDescendantOf(Players) == true then
                self.Profiles[player] = profile
            else
                -- Player left before the profile loaded:
                profile:Release()
            end
        else
            -- The profile couldn't be loaded possibly due to other
            --   Roblox servers trying to load this profile at the same time:
            player:Kick() 
        end
    end

    -- Profile Init (start of defualt profile service code)
    -- In case Players have joined the server earlier than this script ran:
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(PlayerAdded, player)
    end

    -- Profile Connections
    Players.PlayerAdded:Connect(PlayerAdded)

    Players.PlayerRemoving:Connect(function(player)
        local profile = self.Profiles[player]
        if profile ~= nil then
            profile:Release()
        end
    end)
end

return DataService