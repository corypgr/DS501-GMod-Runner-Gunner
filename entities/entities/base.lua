AddCSLuaFile()

ENT.Type			= "anim"

ENT.Spawnable		= true

function ENT:Initialize()

	self:SetModel('models/props_junk/PlasticCrate01a.mdl');
	--self:SetModelScale(0.3,0)
	self:PhysicsInit(SOLID_VPHYSICS);

end
count = 0
function ENT:Touch( hitEnt )
 	if ( hitEnt:IsValid() and hitEnt:IsPlayer() ) then
 		print(hitEnt)
	end
	if(count < 2) then
		local base = ents.Create("npc_helicopter")
    	base:SetPos( Vector(-169.885, 292.031, 1060 ) )
    	base:Spawn()
    	count = count + 1
    end
 end