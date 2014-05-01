AddCSLuaFile( "cl_init.lua" ) AddCSLuaFile( "shared.lua" )

include("shared.lua")

DEFINE_BASECLASS( "gamemode_base" )

function GM:PlayerSpawn( ply )
    player_manager.SetPlayerClass( ply, "player_gunner" )
    BaseClass.PlayerSpawn( self, ply )
end

function GM:InitPostEntity()
    for i = 0,10,1 do
        for k = 0,10,1 do
            local zombie = ents.Create( "npc_zombie" )
            zombie:SetPos( Vector(60*i, 60*k, 0 ) )
            zombie:Spawn()
            -- Make the zombie ignore the players
            zombie:AddRelationship( "player D_NU 10" )
            zombie:AddRelationship( "npc_zombie D_NU 10" )
          zombie:Give("weapon_crowbar")
          --  zombie:Give("weapon_alyxgun")
--            zombie:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_POOR);
        end
    end

    local ent = ents.Create("weapon_crowbar") 
    ent:SetPos(Vector(-10,-10, 0)) 
    ent:Spawn()

    local ent = ents.Create("npc_helicopter") 
    ent:SetPos(Vector(-50,-50, 200)) 
    ent:Spawn()

    local ent = ents.Create("npc_ichthyosaur") 
    ent:SetPos(Vector(-100,-100, 500)) 
    ent:Spawn()

    local ent = ents.Create("npc_combinegunship") 
    ent:SetPos(Vector(-150,-150, 750)) 
    ent:Spawn()


    print( "All Entities have initialized\n" )

end

hook.Add( "InitPostEntity", "zombie_spawn", function()
        print( "Initialization hook called" )
        end )

function GM:EntityTakeDamage( ent, dmgInfo )

local attacker = dmgInfo:GetAttacker()
        print(dmgInfo:GetAmmoType())

    if dmgInfo:GetAmmoType() == -1 then
         ent:AddEntityRelationship(attacker, D_LI, 99 )
    elseif ent:IsNPC() and ent:GetEnemy() != attacker then
        -- The zombie will now only attack the player that shot it
        ent:AddEntityRelationship(attacker, D_HT, 99 )
        ent:SetEnemy(attacker)
        -- This lets the zombie find you faster
        ent:UpdateEnemyMemory( attacker, attacker:GetPos() )
        print("relationship changed")
    end
end

local AmmoList = {
    "item_ammo_pistol",
    "item_ammo_smg1",
    "item_ammo_ar2",
    "item_ammo_357",
    "item_ammo_crossbow",
    "item_box_buckshot",
    "item_rpg_round"
}

local LowList = {
    "item_battery",
    "item_healthkit",
    "item_healthvial",
    "weapon_pistol",
    "weapon_smg1",
    "weapon_frag",
    "weapon_annabelle",
    "weapon_extinguisher",
    "weapon_citizensuitcase",
    "weapon_citizenpackage",
    "weapon_brickbat"
}

local MedList = {
    "weapon_ar2",
    "weapon_shotgun",
    "item_ammo_ar2_altfire",
    "item_ammo_smg1_grenade"
}

local HighList = {
    "weapon_357",
    "weapon_crossbow",
    "weapon_rpg",
    "weapon_physcannon",
    "weapon_physgun"
}

hook.Add("OnNPCKilled", "DropWeaponOnNPCKilled", function(npc, killer)
        local rndweapon = nil
        chance = math.random(1,100)
        if chance < 50 then return
        elseif chance > 51 && chance < 70 then rndweapon = table.Random(AmmoList)
        elseif chance > 71 && chance < 85 then rndweapon = table.Random(LowList)
        elseif chance > 86 && chance < 95 then rndweapon = table.Random(MedList)
        else rndweapon = table.Random(HighList) end
        print("Chance: " .. chance .. " Weapon: " .. rndweapon);
        weapon = ents.Create(rndweapon)
        weapon:SetPos(npc:LocalToWorld(npc:OBBCenter())) 
        weapon:Spawn()
        end)
