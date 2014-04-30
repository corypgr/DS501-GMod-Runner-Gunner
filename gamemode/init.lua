AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")


<<<<<<< HEAD
DEFINE_BASECLASS( "gamemode_base" )

function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_gunner" )
=======
function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_custom" )
>>>>>>> master
	BaseClass.PlayerSpawn( self, ply )
end

function GM:PlayerSetModel( ply )
    ply:SetModel( ply_model )
end

function GM:InitPostEntity()
<<<<<<< HEAD

	local base = ents.Create("base")
	base:SetPos( Vector(366, -588, -333 ) )
	base:Spawn()

	for i = 0,10,1 do
		for k = 0,10,1 do
			local zombie = ents.Create( "npc_alyx" )
			zombie:SetPos( Vector(60*i, 60*k, 0 ) )
			zombie:Spawn()
			-- Make the zombie ignore the players
			zombie:AddRelationship( "player D_NU 10" )
			zombie:Give("weapon_alyxgun")
=======
	for i = 0,3,1 do
		for k = 0,3,1 do
			local npc_c = ents.Create( npc_model )
			npc_c:SetPos( Vector(60*i, 60*k, 0 ) )
			npc_c:Spawn()
			-- Make the npc ignore the players
			npc_c:AddRelationship( "player D_NU 10" )
			
			-- Think is a function that is called every few frames.
			hook.Add("Think", "NPCThink " .. tostring(npc_c), function()
				-- Below can be used to figure out how fast the NPC walks/runs
				--print(tostring(npc_c:GetGroundSpeedVelocity( ):Length()))
				
				-- Only do something new when the npc is not moving. Also, if the schedule
				-- is set to SCHED_NONE, randomly decide when to start a new schedule
				if(npc_c:GetMovementActivity() == -1 and 
				  (not npc_c:IsCurrentSchedule(SCHED_NONE) or math.random(1,stand_weight) == 1)) then
					
					--Randomly choose the next action
					local actionList = {SCHED_NONE, SCHED_FORCED_GO, SCHED_FORCED_GO_RUN}
					local newSched = actionList[math.random(1,3)]
					
					if(newSched != SCHED_NONE) then
						-- This sets a new location for the NPC to a random position near the npc
						local npc_pos = npc_c:GetPos()
						npc_pos:Add(Vector(math.random(-1*walk_weight,walk_weight), math.random(-1*walk_weight,walk_weight), 0))
						npc_c:SetLastPosition(npc_pos) 
					end
					
					-- Use the Randomly chosen schedule to either stand still, 
					-- walk to the new location, or run to the new location.
					npc_c:SetSchedule( newSched )
				end
			end);
>>>>>>> master
		end
	end

	print( "All Entities have initialized\n" )
end

<<<<<<< HEAD
hook.Add( "InitPostEntity", "zombie_spawn", function()
	print( "Initialization hook called" )
end )
=======
function GM:KeyPress( ply, key )
	--IN_USE is mapped to e
    if ( key == IN_USE) then
		if(table.Count( ply:GetWeapons()) == 0) then
			ply:Give( ply_weapon )
			--ply:GiveAmmo( ply_ammo_amount,	ply_weapon_short )
		else
			ply:StripWeapons()
		end
    end
end
>>>>>>> master

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