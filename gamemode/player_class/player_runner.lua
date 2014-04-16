DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.DuckSpeed			= 0.1		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.1		-- How fast to go from ducking, to not ducking

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
-- These are set to twice the gunner speed
PLAYER.WalkSpeed 			= 400
PLAYER.RunSpeed				= 800

function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()
	--Add things?
end

player_manager.RegisterClass( "player_runner", PLAYER, "player_default" )