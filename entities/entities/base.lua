AddCSLuaFile()

ENT.Type			= "anim"

ENT.Spawnable		= true

function ENT:Initialize()

	self:SetModel("models/Cranes/crane_frame.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	
end

function ENT:Touch( hitEnt )
 	if ( hitEnt:IsValid() and hitEnt:IsPlayer() ) then
 		print(hitEnt +"is touching the base inapproriately")
	end
 end