AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player_class/player_custom.lua" )

include("shared.lua")

DEFINE_BASECLASS( "gamemode_base" )

local function initSpawn( ply ) 
	if (p1 == nil) then
		p1 = ply
		print("p1 " .. p1:GetName())
	elseif (p2 == nil) then
		p2 = ply
		print("p2 " .. p2:GetName())
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
			if(k%2 == 0) then
				npc_c:SetPos( Vector(60*i, 60*k + 1000, 0 ) )
				npc_c:Spawn()
				p1NPCList[p1First] = npc_c
				p1First = p1First + 1
			else
				npc_c:SetPos( Vector(60*i, 60*k, 0 ) )
				npc_c:Spawn()
				p2NPCList[p2First] = npc_c
				p2First = p2First + 1
			end
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
	elseif( button == KEY_C ) then
		getNPCCounts(ply)
	end
end

function GM:EntityTakeDamage( ent, dmgInfo )
    local attacker = dmgInfo:GetAttacker()
	if ent:IsNPC() and dmgInfo:GetAmmoType() == 3 then -- dmgInfo:GetAmmoType() == -1 then
		if(attacker == p1) then
			p1NPCList[p1First] = ent
			p1First = p1First + 1
			if((p1First - p1Last) > MaxNPCPerTeam) then
				p1Last = p1Last + 1
				print("p1 list full")
			end
			p1:PrintMessage(HUD_PRINTTALK, p1:GetName() .. " recruited an npc")
			if( p2 != nil ) then
				p2:PrintMessage(HUD_PRINTTALK, p1:GetName() .. " recruited an npc")
				removeNPCFromP2List(0, ent, p1)
			end
			-- for when you hit the same npc twice
			removeNPCFromP1List(-1, ent, p1)
		elseif(attacker == p2) then
			p2NPCList[p2First] = ent
			p2First = p2First + 1
			if((p2First - p2Last) > MaxNPCPerTeam) then
				p2Last = p2Last + 1
				print("p2 list full")
			end
			p1:PrintMessage(HUD_PRINTTALK, p2:GetName() .. " recruited an npc")
			p2:PrintMessage(HUD_PRINTTALK, p2:GetName() .. " recruited an npc")
			removeNPCFromP1List(0,ent, p2)
			-- For when you hit the same npc twice
			removeNPCFromP2List(-1, ent, p2)
		end
		
		-- the two teams hate each other
		for k = p1Last, p1First-1, 1 do
			if(p1NPCList[k]:IsValid()) then
				p1NPCList[k]:AddEntityRelationship(p2, D_HT, 99 )
				for i = p2Last, p2First-1, 1 do
					if(p2NPCList[i]:IsValid()) then
						p1NPCList[k]:AddEntityRelationship(p2NPCList[i], D_HT, 99 )
						p2NPCList[i]:AddEntityRelationship(p1NPCList[k], D_HT, 99 )
						p2NPCList[i]:AddEntityRelationship(p1, D_HT, 99 )
					end
				end
			end
		end
		
		for k = p1Last, p1First-1, 1 do
			if(p1NPCList[k]:IsValid()) then
				p1NPCList[k]:AddEntityRelationship(p1, D_NU, 99 )
				for i = p1Last, p1First-1, 1 do
					if(p1NPCList[i]:IsValid()) then
						p1NPCList[k]:AddEntityRelationship(p1NPCList[i], D_NU, 99 )
					end
				end
			end
		end
		
		for k = p2Last, p2First-1, 1 do
			if(p2NPCList[k]:IsValid()) then
				p2NPCList[k]:AddEntityRelationship(p2, D_NU, 99 )
				for i = p2Last, p2First-1, 1 do
					if(p2NPCList[i]:IsValid()) then
						p2NPCList[k]:AddEntityRelationship(p2NPCList[i], D_NU, 99 )
					end
				end
			end
		end
	end
	if (dmgInfo:GetAmmoType() == 3) then
		dmgInfo:ScaleDamage(0)
		return dmgInfo
	end
end

function getNPCCounts(ply) 
	local count = 0
	local allNPCs = ents.FindByClass("npc_*")
	for k, v in pairs(allNPCs) do
		if(v:IsValid() and onTeam(v) == false) then
			count = count + 1
		end
	end
	ply:PrintMessage(HUD_PRINTTALK, "NPC Counts:\nNon-team: ".. count)
	count = 0
	for i = p1Last, p1First-1, 1 do
		if(p1NPCList[i]:IsValid()) then
			count = count + 1
		end
	end
	ply:PrintMessage(HUD_PRINTTALK, p1:GetName() .. ": " .. count)
	count = 0
	if(p2 != nil) then
		for i = p2Last, p2First-1, 1 do
			if(p2NPCList[i]:IsValid()) then
				count = count + 1
			end
		end
		ply:PrintMessage(HUD_PRINTTALK, p2:GetName() ..": " .. count)
	end
end

--endmodifier determines where we stop in the list. 0 is search whole list.
function removeNPCFromP1List(endModifier, npc, ply) 
	for i = p1Last, (p1First-1+endModifier), 1 do
		if(p1NPCList[i] == npc) then
			p1NPCList[i] = p1NPCList[p1Last]
			p1Last = p1Last + 1
			p1:PrintMessage(HUD_PRINTTALK, ply:GetName() .. " stole " .. p1:GetName() .. "s npc")
			if (p2 != nil) then
				p2:PrintMessage(HUD_PRINTTALK, ply:GetName() .. " stole " .. p1:GetName() .. "s npc")
			end
		end
	end
end

--endmodifier determines where we stop in the list. 0 is search whole list.
function removeNPCFromP2List(endModifier, npc, ply) 
	for i = p2Last, p2First-1+endModifier, 1 do
		if(p2NPCList[i] == npc) then
			p2NPCList[i] = p2NPCList[p2Last]
			p2Last = p2Last + 1
			p1:PrintMessage(HUD_PRINTTALK, ply:GetName() .. " stole " .. p2:GetName() .. "s npc")
			p2:PrintMessage(HUD_PRINTTALK, ply:GetName() .. " stole " .. p2:GetName() .. "s npc")
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