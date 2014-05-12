AddCSLuaFile( "cl_init.lua" ) AddCSLuaFile( "shared.lua" )

include("shared.lua")

DEFINE_BASECLASS( "gamemode_base" )

function GM:PlayerSpawn( ply )
    player_manager.SetPlayerClass( ply, "player_gunner" )
BaseClass.PlayerSpawn( self, ply )
    end

function GM:InitPostEntity()

    local x = 0
    local y = 0
    local z = 0

    for i = 5,10,1 do
    for k = 5,10,1 do
    local zombie
    if k % 4 == 0 then
    zombie= ents.Create( "npc_poisonzombie" )
    elseif k % 2 == 0 then
    zombie= ents.Create( "npc_fastzombie" )
    else  
    zombie= ents.Create( "npc_zombie" )
    end 
    zombie:SetPos( Vector(x + 60*i, y + 60*k, z ) )
    zombie:Spawn()
    zombie:AddRelationship( "player D_HT 99" )
    end
    end

    x = -600
    y = 1600

    for i = 0,5,1 do
    for k = 0,5,1 do
    local zombie
    if k % 4 == 0 then
    zombie= ents.Create( "npc_poisonzombie" )
    elseif k % 2 == 0 then
    zombie= ents.Create( "npc_fastzombie" )
    else  
    zombie= ents.Create( "npc_zombie" )
    end 
    zombie:SetPos( Vector(x + 60*i, y + 60*k, z ) )
    zombie:Spawn()
    zombie:AddRelationship( "player D_HT 99" )
    end
    end

    x = -600
    y = 1000

    for i = 0,5,1 do
    for k = 0,5,1 do
    local zombie
    if k % 4 == 0 then
    zombie= ents.Create( "npc_poisonzombie" )
    elseif k % 2 == 0 then
    zombie= ents.Create( "npc_fastzombie" )
    else  
    zombie= ents.Create( "npc_zombie" )
    end 
    zombie:SetPos( Vector(x + 60*i, y + 60*k, z ) )
    zombie:Spawn()
    zombie:AddRelationship( "player D_HT 99" )
    end
    end

    x = -600
    y = -30
    z = 800

    for i = 0,5,1 do
    for k = 0,5,1 do
    local zombie
    if k % 4 == 0 then
    zombie= ents.Create( "npc_poisonzombie" )
    elseif k % 2 == 0 then
    zombie= ents.Create( "npc_fastzombie" )
    else  
    zombie= ents.Create( "npc_zombie" )
    end 
    zombie:SetPos( Vector(x + 60*i, y + 60*k, z ) )
    zombie:Spawn()
    zombie:AddRelationship( "player D_HT 99" )
    end
    end


    x = 880
    y = -450
    z = 1300

    for i = 0,5,1 do
    for k = 0,5,1 do
    local zombie
    if k % 4 == 0 then
    zombie= ents.Create( "npc_poisonzombie" )
    elseif k % 2 == 0 then
    zombie= ents.Create( "npc_fastzombie" )
    else  
    zombie= ents.Create( "npc_zombie" )
    end 
    zombie:SetPos( Vector(x + 60*i, y + 60*k, z ) )
    zombie:Spawn()
    zombie:AddRelationship( "player D_HT 99" )
    end
    end

    local ent = ents.Create("weapon_crowbar") 
    ent:SetPos(Vector(-20,-20, 0)) 
    ent:Spawn()

    print( "All Entities have initialized\n" )

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

local MedicalList = {
    "item_battery",
    "item_healthkit",
    "item_healthvial"
}

local LowList = {
    "weapon_ar2",
    "weapon_smg1",
    "weapon_pistol"
}

local MedList = {
    "weapon_frag",
    "weapon_shotgun",
    "item_ammo_ar2_altfire",
    "item_ammo_smg1_grenade"
}

local HighList = {
    "weapon_357",
    "weapon_crossbow",
    "weapon_rpg",
}

hook.Add("OnNPCKilled", "DropWeaponOnNPCKilled", function(npc, killer)
        local rndweapon = nil
        local chance = math.random(1,100)
        if chance <= 55 then return
        elseif chance >= 56 && chance <= 70 then rndweapon = table.Random(AmmoList)
        elseif chance >= 71 && chance <= 75 then rndweapon = table.Random(MedicalList)
        elseif chance >= 76 && chance <= 87 then rndweapon = table.Random(LowList)
        elseif chance >= 88 && chance <= 98 then rndweapon = table.Random(MedList)
        else   rndweapon = table.Random(HighList) end
        print("Chance: " .. chance .. " Weapon: " .. rndweapon);
        weapon = ents.Create(rndweapon)
        weapon:SetPos(npc:LocalToWorld(npc:OBBCenter())) 
        weapon:Spawn()
        end)

function getNPCCounts(ply) 
    local count = 0
    local allNPCs = ents.FindByClass("npc_*")
    for k, v in pairs(allNPCs) do
    if(v:IsValid()) then
    count = count + 1
    end
    end
    ply:PrintMessage(HUD_PRINTTALK, "NPC Counts:".. count)
    end

function GM:PlayerButtonDown( ply, button )
    if( button == KEY_C ) then
        getNPCCounts(ply)
    end
end
