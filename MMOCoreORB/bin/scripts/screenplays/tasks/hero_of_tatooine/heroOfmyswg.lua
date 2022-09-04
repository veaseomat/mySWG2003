local ObjectManager = require("managers.object.object_manager")

HeroOfmyswgScreenPlay = ScreenPlay:new {

}

registerScreenPlay("HeroOfmyswgScreenPlay", true)

function HeroOfmyswgScreenPlay:start()
	self:doIntellectSpawn()
end

function HeroOfmyswgScreenPlay:doIntellectSpawn()
	--self:doDespawn()
	
	deleteData("hero_of_myswg:intellect_mob_loc")	
		
	local location = getRandomNumber(1, 3)

	writeData("hero_of_myswg:intellect_mob_loc", location)

	if (location == 1) then
		self:spawnLocationONE()
	end
	if (location == 2) then
		self:spawnLocationTWO()
	end
	if (location == 3) then
		self:spawnLocationTHREE()
	end
	
	createEvent(getRandomNumber(10, 20) * 60 * 1000, "HeroOfmyswgScreenPlay", "doDespawn", nil, "")

end

function HeroOfmyswgScreenPlay:spawnLocationONE()
				--cnet

local onex = -112
local oney = -4676

	local pReb1 = spawnMobile("corellia", "pvpreb", 15, onex + getRandomNumber(-5, 5), 28.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("hero_of_myswg:pReb1", SceneObject(pReb1):getObjectID())

	local pReb2 = spawnMobile("corellia", "pvpreb", 15, onex + getRandomNumber(-5, 5), 28.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("hero_of_myswg:pReb2", SceneObject(pReb2):getObjectID())
	
	local pReb3 = spawnMobile("corellia", "pvpreb", 15, onex + getRandomNumber(-5, 5), 28.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("hero_of_myswg:pReb3", SceneObject(pReb3):getObjectID())

--	local pReb4 = spawnMobile("corellia", "pvpreb", 5, -99.3, 28.0, -4659.8, -26, 0)
--
--	local pReb5 = spawnMobile("corellia", "pvpreb", 5, -100.3, 28.0, -4656.8, -26, 0)

	

	local pImp1 = spawnMobile("corellia", "pvpimp", 15, onex + getRandomNumber(-5, 5), 28.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("hero_of_myswg:pImp1", SceneObject(pImp1):getObjectID())

	local pImp2 = spawnMobile("corellia", "pvpimp", 15, onex + getRandomNumber(-5, 5), 28.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("hero_of_myswg:pImp2", SceneObject(pImp2):getObjectID())

	local pImp3 = spawnMobile("corellia", "pvpimp", 15, onex + getRandomNumber(-5, 5), 28.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("hero_of_myswg:pImp3", SceneObject(pImp3):getObjectID())

--	local pImp4 = spawnMobile("corellia", "pvpimp", 5, -111.8, 28.0, -4667.7, -104, 0)
--
--	local pImp5 = spawnMobile("corellia", "pvpimp", 5, -106.7, 28.0, -4672.5, -100, 0)

	
end

function HeroOfmyswgScreenPlay:spawnLocationTWO()
local onex = -1324   --bestine
local oney = -3678

	local pReb1 = spawnMobile("tatooine", "pvpreb", 15, onex + getRandomNumber(-5, 5), 12.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("hero_of_myswg:pReb1", SceneObject(pReb1):getObjectID())

	local pReb2 = spawnMobile("tatooine", "pvpreb", 15, onex + getRandomNumber(-5, 5), 12.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("hero_of_myswg:pReb2", SceneObject(pReb2):getObjectID())
	
	local pReb3 = spawnMobile("tatooine", "pvpreb", 15, onex + getRandomNumber(-5, 5), 12.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("hero_of_myswg:pReb3", SceneObject(pReb3):getObjectID())

--	local pReb4 = spawnMobile("corellia", "pvpreb", 5, -99.3, 28.0, -4659.8, -26, 0)
--
--	local pReb5 = spawnMobile("corellia", "pvpreb", 5, -100.3, 28.0, -4656.8, -26, 0)

	

	local pImp1 = spawnMobile("tatooine", "pvpimp", 15, onex + getRandomNumber(-5, 5), 12.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("hero_of_myswg:pImp1", SceneObject(pImp1):getObjectID())

	local pImp2 = spawnMobile("tatooine", "pvpimp", 15, onex + getRandomNumber(-5, 5), 12.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("hero_of_myswg:pImp2", SceneObject(pImp2):getObjectID())

	local pImp3 = spawnMobile("tatooine", "pvpimp", 15, onex + getRandomNumber(-5, 5), 12.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("hero_of_myswg:pImp3", SceneObject(pImp3):getObjectID())

--	local pImp4 = spawnMobile("corellia", "pvpimp", 5, -111.8, 28.0, -4667.7, -104, 0)
--
--	local pImp5 = spawnMobile("corellia", "pvpimp", 5, -106.7, 28.0, -4672.5, -100, 0)

end

function HeroOfmyswgScreenPlay:spawnLocationTHREE()
local onex = -4946   --theed
local oney = 4105

	local pReb1 = spawnMobile("naboo", "pvpreb", 15, onex + getRandomNumber(-5, 5), 6.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("hero_of_myswg:pReb1", SceneObject(pReb1):getObjectID())

	local pReb2 = spawnMobile("naboo", "pvpreb", 15, onex + getRandomNumber(-5, 5), 6.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("hero_of_myswg:pReb2", SceneObject(pReb2):getObjectID())
	
	local pReb3 = spawnMobile("naboo", "pvpreb", 15, onex + getRandomNumber(-5, 5), 6.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("hero_of_myswg:pReb3", SceneObject(pReb3):getObjectID())

--	local pReb4 = spawnMobile("corellia", "pvpreb", 5, -99.3, 28.0, -4659.8, -26, 0)
--
--	local pReb5 = spawnMobile("corellia", "pvpreb", 5, -100.3, 28.0, -4656.8, -26, 0)

	

	local pImp1 = spawnMobile("naboo", "pvpimp", 15, onex + getRandomNumber(-5, 5), 6.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("hero_of_myswg:pImp1", SceneObject(pImp1):getObjectID())

	local pImp2 = spawnMobile("naboo", "pvpimp", 15, onex + getRandomNumber(-5, 5), 6.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("hero_of_myswg:pImp2", SceneObject(pImp2):getObjectID())

	local pImp3 = spawnMobile("naboo", "pvpimp", 15, onex + getRandomNumber(-5, 5), 6.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("hero_of_myswg:pImp3", SceneObject(pImp3):getObjectID())

--	local pImp4 = spawnMobile("corellia", "pvpimp", 5, -111.8, 28.0, -4667.7, -104, 0)
--
--	local pImp5 = spawnMobile("corellia", "pvpimp", 5, -106.7, 28.0, -4672.5, -100, 0)
end

function HeroOfmyswgScreenPlay:doDespawn()

	local pReb1 = getSceneObject(readData("hero_of_myswg:pReb1"))
	--if (pReb1 ~= nil) then
		SceneObject(pReb1):destroyObjectFromWorld()
		deleteData("hero_of_myswg:pReb1")
	--end
	
	local pReb2 = getSceneObject(readData("hero_of_myswg:pReb2"))
	--if (pReb2 ~= nil) then
		SceneObject(pReb2):destroyObjectFromWorld()
		deleteData("hero_of_myswg:pReb2")
	--end
	
	local pReb3 = getSceneObject(readData("hero_of_myswg:pReb3"))
	--if (pReb3 ~= nil) then
		SceneObject(pReb3):destroyObjectFromWorld()
		deleteData("hero_of_myswg:pReb3")
	--end
	
	local pImp1 = getSceneObject(readData("hero_of_myswg:pImp1"))
	--if (pImp1 ~= nil) then
		SceneObject(pImp1):destroyObjectFromWorld()
		deleteData("hero_of_myswg:pImp1")
	--end

	local pImp2 = getSceneObject(readData("hero_of_myswg:pImp2"))
--	if (pImp2 ~= nil) then
		SceneObject(pImp2):destroyObjectFromWorld()
		deleteData("hero_of_myswg:pImp2")
--	end
	
	local pImp3 = getSceneObject(readData("hero_of_myswg:pImp3"))
--	if (pImp3 ~= nil) then
		SceneObject(pImp3):destroyObjectFromWorld()
		deleteData("hero_of_myswg:pImp3")
	--end
		createEvent(getRandomNumber(20, 40) * 60 * 1000, "HeroOfmyswgScreenPlay", "doIntellectSpawn", nil, "")
	
end
