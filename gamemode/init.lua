AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

DEFINE_BASECLASS( "gamemode_base" )

--Controls the probablility weight for how long an NPC will stand still
stand_weight = 10

--Controls the max distance that an NPC will randomly walk to
walk_weight = 500

util.PrecacheModel( "models/alyx.mdl" )
function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_runner" )
	ply:SetModel("models/alyx.mdl")
	BaseClass.PlayerSpawn( self, ply )
end

function GM:InitPostEntity()
	for i = 0,3,1 do
		for k = 0,3,1 do
			local zombie = ents.Create( "npc_alyx" )
			zombie:SetPos( Vector(60*i, 60*k, 0 ) )
			zombie:Spawn()
			-- Make the zombie ignore the players
			zombie:AddRelationship( "player D_NU 10" )
			hook.Add("Think", "NPCThink " .. tostring(zombie), function()
				if(zombie:GetMovementActivity() == -1 and 
				  (not zombie:IsCurrentSchedule(SCHED_NONE) or math.random(1,stand_weight) == 1)) then
					local poss = zombie:GetPos()
					poss:Add(Vector(math.random(-1*walk_weight,walk_weight),math.random(-1*walk_weight,walk_weight),0))
					zombie:SetLastPosition(poss) 
					-- Note that SCHED_FORCED_GO and SCHED_FORCED_GO_RUN are next to each other.
					local actionList = {SCHED_NONE,SCHED_FORCED_GO, SCHED_FORCED_GO_RUN}
					zombie:SetSchedule( actionList[math.random(1,3)])
				end
			end);
		end
	end
	print( "All Entities have initialized\n" )
end

hook.Add( "InitPostEntity", "zombie_spawn", function()
	print( "Initialization hook called" )
end )

function GM:KeyPress( ply, key )
    if ( key == IN_USE) then
		if(table.Count( ply:GetWeapons()) == 0) then
			ply:Give("weapon_smg1")
			ply:GiveAmmo( 256,	"smg1")
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
		ent:Give("weapon_alyxgun")
		-- The zombie will now only attack the player that shot it
		ent:AddEntityRelationship(attacker, D_HT, 99 )
		ent:SetEnemy(attacker)
		-- This lets the zombie find you faster
		ent:UpdateEnemyMemory( attacker, attacker:GetPos() )
		print("relationship changed")
	end
end