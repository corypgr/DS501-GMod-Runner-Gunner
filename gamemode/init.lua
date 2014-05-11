AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player_class/player_custom.lua" )

include("shared.lua")

DEFINE_BASECLASS( "gamemode_base" )

local function initSpawn( ply ) 
	if (p1 == nil) then
		p1 = ply:UserID()
		print("p1 " .. p1)
	elseif (p2 == nil) then
		p2 = ply:UserID()
		print("p2 " .. p2)
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

	for i = 0,5,1 do
		for k = 0,5,1 do
			local npc_c = ents.Create( npc_type )
			if (npc_model != nill and npc_model != '') then
				npc_c:SetModel( npc_model )
			end
			npc_c:SetPos( Vector(60*i, 60*k, 0 ) )
			npc_c:Spawn()
			-- Make the npc ignore the players and other NPCs
			npc_c:AddRelationship( "player D_NU 10" )
			npc_c:AddRelationship( "npc D_NU 10" )
			if( npc_weapon != nil and npc_weapon != '') then
				npc_c:Give( npc_weapon )
			end
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
	elseif( button == KEY_P ) then
		local allNPCs = ents.FindByClass("npc_*")
		local nonTeamNPCs = {}
		for k, v in pairs(allNPCs) do
			if(v:IsValid() and onTeam(v) == false) then
				table.insert(nonTeamNPCs, v)
			end
		end
		
		-- all npcs not on teams hate all npcs on teams and vice versa
		for k, v in pairs(nonTeamNPCs) do
			for a, b in pairs(p1NPCList) do
				if(b:IsValid()) then
					v:AddEntityRelationship(b, D_HT, 99 )
					b:AddEntityRelationship(v, D_HT, 99 )
				end
			end
			for a, b in pairs(p2NPCList) do
				if(b:IsValid()) then
					v:AddEntityRelationship(b, D_HT, 99 )
					b:AddEntityRelationship(v, D_HT, 99 )
				end
			end
		end
		
		-- the two teams hate each other
		for k, v in pairs(p1NPCList) do
			if(v:IsValid()) then
				for a, b in pairs(p2NPCList) do
					if(b:IsValid()) then
						v:AddEntityRelationship(b, D_HT, 99 )
						b:AddEntityRelationship(v, D_HT, 99 )
					end
				end
			end
		end
	end
end

function GM:EntityTakeDamage( ent, dmgInfo )
    local attacker = dmgInfo:GetAttacker()
	if ent:IsNPC() and dmgInfo:GetDamageType() == DMG_CLUB then -- dmgInfo:GetAmmoType() == -1 then
		if(attacker:UserID() == p1) then
			p1NPCList[p1First] = ent
			p1First = p1First + 1
			if((p1First - p1Last) > MaxNPCPerTeam) then
				p1Last = p1Last + 1
				print("p1 list full")
			end
			removeNPCFromP2List(0, ent)
			-- for when you hit the same npc twice
			removeNPCFromP1List(-1, ent)
		elseif(attacker:UserID() == p2) then
			p2NPCList[p2First] = ent
			p2First = p2First + 1
			if((p2First - p2Last) > MaxNPCPerTeam) then
				p2Last = p2Last + 1
				print("p2 list full")
			end
			removeNPCFromP1List(0,ent)
			-- For when you hit the same npc twice
			removeNPCFromP2List(-1, ent)
		end
	end
end

--endmodifier determines where we stop in the list. 0 is search whole list.
function removeNPCFromP1List(endModifier, npc) 
	for i = p1Last, (p1First-1+endModifier), 1 do
		if(p1NPCList[i] == npc) then
			p1NPCList[i] = p1NPCList[p1Last]
			p1Last = p1Last + 1
			print("NPC STOLEN!")
		end
	end
end

--endmodifier determines where we stop in the list. 0 is search whole list.
function removeNPCFromP2List(endModifier, npc) 
	for i = p2Last, p2First-1+endModifier, 1 do
		if(p2NPCList[i] == npc) then
			p2NPCList[i] = p2NPCList[p2Last]
			p2Last = p2Last + 1
			print("NPC STOLEN!")
		end
	end
end

function onTeam(npc)
	for i = p1Last, p1First-1, 1 do
		if(p1NPCList[i] == npc) then
			return true
		end
	end
	for i = p2Last, p2First-1, 1 do
		if(p2NPCList[i] == npc) then
			return true
		end
	end
	return false
end