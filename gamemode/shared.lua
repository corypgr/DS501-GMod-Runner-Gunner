include("resources.lua")
include( "player_class/player_custom.lua" )
GM.StartTime = SysTime()
GM.Name = "Runner Gunner"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

pause = true

p1 = nil
p1NPCList = {}
p1First = 1
p1Last = 1

p2 = nil
p2NPCList = {}
p2First = 1
p2Last = 1

util.PrecacheModel( ply_model )
util.PrecacheModel( npc_model )
function GM:Initialize()

end 