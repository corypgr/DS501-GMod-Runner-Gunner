AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player_class/player_custom.lua" )

include("shared.lua")

DEFINE_BASECLASS( "gamemode_base" )

local function initSpawn( ply ) 
	if (p1 == nil) 
		p1 = ply:UserID()
		print("p1" .. p1)
	elseif (p2 == nil)
		p2 = ply:UserID()
		print("p2" .. p2)
	end
end
hook.Add("PlayerInitialSpawn", "ply_spawn_init", initSpawn)

function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_custom" )
	ply:SetPlayerColor(ply_color)
	BaseClass.PlayerSpawn( self, ply )
end

function GM:PlayerSetModel( ply )
    ply:SetModel( ply_model )
end

function GM:InitPostEntity()

	for i = 0,3,1 do
		for k = 0,3,1 do
			local npc_c = ents.Create( npc_type )
			if (npc_model != nill and npc_model != '') then
				npc_c:SetModel( npc_model )
			end
			npc_c:SetPos( Vector(60*i, 60*k, 0 ) )
			npc_c:Spawn()
			-- Make the npc ignore the players and other NPCs
			npc_c:AddRelationship( "player D_NU 10" )
			npc_c:AddRelationship( "npc D_NU 10" )
		end
	end
	print( "All Entities have initialized\n" )
end

function GM:PlayerButtonDown( ply, button )

	if( button == KEY_T ) then
		local ent = ply:GetEyeTrace().Entity;
		if (ent:IsNPC()) then
			-- Stops the schedule so the NPC does not walk back to your location
			ent:ClearSchedule()
			
			local npcPos = ent:GetPos()
			ent:SetPos(ply:GetPos())
			ply:SetPos(npcPos)
		end
	elseif( button == KEY_S ) then
		--TODO
	end
end

function GM:EntityTakeDamage( ent, dmgInfo )
    local attacker = dmgInfo:GetAttacker()
	if ent:IsNPC() and dmgInfo:GetDamageType() == DMG_CLUB then -- dmgInfo:GetAmmoType() == -1 then
         print(attacker:UserID())
	end
end