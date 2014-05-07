DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.DuckSpeed			= 0.1		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.1		-- How fast to go from ducking, to not ducking

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 400

function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()
 
--    self.Player:GiveAmmo( 999, "smg1", true )
--	self.Player:GiveAmmo( 256,	"Pistol", true )
--	self.Player:Give( "weapon_smg1" )
      self.Player:Give( "weapon_crowbar" )
--	self.Player:Give( "weapon_pistol" )
end

player_manager.RegisterClass( "player_gunner", PLAYER, "player_default" )
