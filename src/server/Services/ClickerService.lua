-- Packages
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local ProfileService = require(game:GetService("ReplicatedStorage").Packages.ProfileService)

-- Profile Service
local Players = game:GetService("Players")
local ProfileStore = ProfileService.GetProfileStore(
    "PlayerClickData",
    {
        Clicks = 0,
    }
)

local Profiles = {} -- [player] = profile

local function PlayerAdded(player) -- modified default code
    local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
    if profile ~= nil then
        profile:AddUserId(player.UserId) -- GDPR compliance
        profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
        profile:ListenToRelease(function()
            Profiles[player] = nil
            -- The profile could've been loaded on another Roblox server:
            player:Kick()
        end)
        if player:IsDescendantOf(Players) == true then
            Profiles[player] = profile
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
    local profile = Profiles[player]
    if profile ~= nil then
        profile:Release()
    end
end)

-- end of default profile service code

-- Knit
local ClickerService = Knit.CreateService {
    Name = "ClickerService",
    Client = {},
}

function ClickerService.Client:UpdateClicks(player: Player)
    self.Server:UpdateClicks(player)
end

function ClickerService:UpdateClicks(player: Player)
    local profile = Profiles[player]
    if profile ~= nil then
        player.PlayerGui.ClickerGUI.Frame.number.Text = tostring(profile.Data.Clicks) -- ui update
    end
end

function ClickerService.Client:AddClick(player: Player)
    self.Server:AddClick(player)
end

function ClickerService:AddClick(player: Player)
    local profile = Profiles[player]
    if profile ~= nil then
        profile.Data.Clicks += 1
        self:UpdateClicks(player)
    end
end

function ClickerService:KnitStart()
    print("Clicker Service Started")
end

function ClickerService:KnitInit()
    print("Clicker Service Init")
end

return ClickerService