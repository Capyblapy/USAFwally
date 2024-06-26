-- Packages
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local ServerScriptService = game:GetService("ServerScriptService")

-- Knit Services
Knit.AddServices(ServerScriptService.Server.Services)

-- Knit Start
Knit.Start({ServicePromises = true}):andThen(function()
    print("Knit Started")
end):catch(warn)