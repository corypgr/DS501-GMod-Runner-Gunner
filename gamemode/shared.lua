include("resources.lua")
include( "player_class/player_custom.lua" )
GM.StartTime = SysTime()
GM.Name = "Runner Gunner"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

pause = true

priority = 1

seeker = nil

util.PrecacheModel( ply_model )
--util.PrecacheModel( npc_model )
function GM:Initialize()

end 