AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

function GM:PlayerLoadout( pl )
 
    pl:Give( "weapon_pistol" )
    pl:Give( "weapon_smg1" )
    pl:Give( "weapon_crowbar" )
 
    pl:GiveAmmo( 999, "pistol" )
    pl:GiveAmmo( 999, "smg1" )
 
end