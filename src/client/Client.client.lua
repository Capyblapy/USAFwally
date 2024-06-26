-- Packages
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

-- Knit Controllers
Knit.AddControllers(game.ReplicatedStorage.Shared.Controllers)

-- Knit Start
Knit.Start():andThen(function()
    print("Knit Started")
end):catch(warn)