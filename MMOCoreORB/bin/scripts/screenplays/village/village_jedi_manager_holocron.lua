local ObjectManager = require("managers.object.object_manager")

USEDHOLOCRON = "used_holocron"
HOLOCRONCOOLDOWNTIME = 3 * 60 * 60 * 1000--12 * 60 * 60 * 1000

VillageJediManagerHolocron = ScreenPlay:new {}

-- Check if the player can use the holocron.
-- @param pPlayer pointer to the creature object of the player who tries to use the holocron.
-- @return true if the player can use the holocron.
function VillageJediManagerHolocron.canUseHolocron(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return false
	end

	return PlayerObject(pGhost):isJedi() and CreatureObject(pPlayer):checkCooldownRecovery(USEDHOLOCRON)
end

-- Checks if the player can replenish the force or not.
-- @param pPlayer pointer to the creature object of the player who should be checked.
-- @return true if the player can replenish the force.
function VillageJediManagerHolocron.canReplenishForce(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return false
	end

	return PlayerObject(pGhost):getForcePower() < PlayerObject(pGhost):getForcePowerMax()
end

-- Use the holocron on the player.
-- @param pSceneObject pointer to the scene object of the holocron.
-- @param pPlayer pointer to the creature object of the player who is using the holocron.
function VillageJediManagerHolocron.useTheHolocron(pSceneObject, pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	-- The holocrom hums softly as you feel your Force power replenish.
	CreatureObject(pPlayer):sendSystemMessage("@jedi_spam:holocron_force_replenish")
	PlayerObject(pGhost):setForcePower(PlayerObject(pGhost):getForcePower() + ((PlayerObject(pGhost):getForcePowerMax() - PlayerObject(pGhost):getForcePower()) / 2));
	CreatureObject(pPlayer):addCooldown(USEDHOLOCRON, HOLOCRONCOOLDOWNTIME)
	CreatureObject(pPlayer):playEffect("clienteffect/trap_electric_01.cef", "")

	SceneObject(pSceneObject):destroyObjectFromWorld()
	SceneObject(pSceneObject):destroyObjectFromDatabase()
end

-- Send message to the player that he cannot replenish the force.
-- @param pPlayer pointer to the creature object of the player that tries to use the holocron.
function VillageJediManagerHolocron.cannotReplenishForce(pPlayer)
	-- You are already at your maximum Force power.
	CreatureObject(pPlayer):sendSystemMessage("@jedi_spam:holocron_force_max")
end

-- Send message to the player that he cannot use the holocron.
-- @param pPlayer pointer to the creature object of the player that tries to use the holocron.
function VillageJediManagerHolocron.cannotUseHolocron(pPlayer)
	-- The holocron hums briefly, but otherwise does nothing.
	CreatureObject(pPlayer):sendSystemMessage("@jedi_spam:holocron_no_effect")
end

-- Handling of the useHolocron event.
-- @param pSceneObject pointer to the holocron object.
-- @param pPlayer pointer to the creature object that used the holocron.
function VillageJediManagerHolocron.useHolocron(pSceneObject, pPlayer)
	if VillageJediManagerHolocron.canUseHolocron(pPlayer) then
		if VillageJediManagerHolocron.canReplenishForce(pPlayer) then
			VillageJediManagerHolocron.useTheHolocron(pSceneObject, pPlayer)
		else
			VillageJediManagerHolocron.cannotReplenishForce(pPlayer)
		end
	else
		VillageJediManagerHolocron.cannotUseHolocron(pPlayer)
	end
end

return VillageJediManagerHolocron
