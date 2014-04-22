AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

DEFINE_BASECLASS( "gamemode_base" )

function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_gunner" )
	BaseClass.PlayerSpawn( self, ply )
end

function GM:InitPostEntity()
	for i = 0,200,1 do
		local zombie = ents.Create( "npc_zombie" )
		zombie:SetPos( Vector(math.random(-1000,1000), math.random(-1000,1000), 500 ) )
		zombie:Spawn()
		-- Make the zombie ignore the players
		zombie:AddRelationship( "player D_NU 10" )
	end
	print( "All Entities have initialized\n" )
end

hook.Add( "InitPostEntity", "zombie_spawn", function()
	print( "Initialization hook called" )
end )

function GM:EntityTakeDamage( ent, dmgInfo )

    local attacker = dmgInfo:GetAttacker()
	if ent:IsNPC() and ent:GetEnemy() != attacker then
		-- The zombie will now only attack the player that shot it
		ent:AddEntityRelationship(attacker, D_HT, 99 )
		ent:SetEnemy(attacker)
		-- This lets the zombie find you faster
		ent:UpdateEnemyMemory( attacker, attacker:GetPos() )
		print("relationship changed")
	end
end