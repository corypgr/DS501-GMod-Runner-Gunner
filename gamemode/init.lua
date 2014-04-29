AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

DEFINE_BASECLASS( "gamemode_base" )

--Controls the probablility weight for how long an NPC will stand still
stand_weight = 10
--Controls the max distance that an NPC will randomly walk to
walk_weight = 500
--Type of NPC
npc_model = "npc_alyx"
--Type of NPC weapon
npc_weapon = "weapon_alyxgun"
--Player model location
ply_model = "models/alyx.mdl"
--Type of Player weapon
ply_weapon = "weapon_smg1"
ply_weapon_short = "smg1"
ply_ammo_amount = 256

util.PrecacheModel( ply_model )
function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_runner" )
	ply:SetModel( ply_model )
	BaseClass.PlayerSpawn( self, ply )
end

function GM:InitPostEntity()
	for i = 0,3,1 do
		for k = 0,3,1 do
			local npc_c = ents.Create( npc_model )
			npc_c:SetPos( Vector(60*i, 60*k, 0 ) )
			npc_c:Spawn()
			-- Make the zombie ignore the players
			npc_c:AddRelationship( "player D_NU 10" )
			hook.Add("Think", "NPCThink " .. tostring(npc_c), function()
				if(npc_c:GetMovementActivity() == -1 and 
				  (not npc_c:IsCurrentSchedule(SCHED_NONE) or math.random(1,stand_weight) == 1)) then
					local npc_pos = npc_c:GetPos()
					npc_pos:Add(Vector(math.random(-1*walk_weight,walk_weight), math.random(-1*walk_weight,walk_weight), 0))
					npc_c:SetLastPosition(npc_pos) 
					-- Note that SCHED_FORCED_GO and SCHED_FORCED_GO_RUN are next to each other.
					local actionList = {SCHED_NONE, SCHED_FORCED_GO, SCHED_FORCED_GO_RUN}
					npc_c:SetSchedule( actionList[math.random(1,3)] )
				end
			end);
		end
	end
	print( "All Entities have initialized\n" )
end

function GM:KeyPress( ply, key )
	--IN_USE is mapped to e
    if ( key == IN_USE) then
		if(table.Count( ply:GetWeapons()) == 0) then
			ply:Give( ply_weapon )
			ply:GiveAmmo( ply_ammo_amount,	ply_weapon_short )
		else
			ply:RemoveAllItems()
		end
    end
end

function GM:EntityTakeDamage( ent, dmgInfo )
    local attacker = dmgInfo:GetAttacker()
	if ent:IsNPC() and ent:GetEnemy() != attacker then
		hook.Remove("Think", "NPCThink " .. tostring(ent))
		ent:StopMoving()
		ent:Give( npc_weapon )
		-- The npc will now only attack the entity that attacked it
		ent:AddEntityRelationship(attacker, D_HT, 99 )
		ent:SetEnemy(attacker)
		-- This lets the npc find you faster
		ent:UpdateEnemyMemory( attacker, attacker:GetPos() )
		print("relationship changed")
	end
end