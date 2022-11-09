local ObjectManager = require("managers.object.object_manager")

kraytGYspawnsScreenPlay = ScreenPlay:new {

}

registerScreenPlay("kraytGYspawnsScreenPlay", true)

function kraytGYspawnsScreenPlay:start()
	self:doIntellectSpawn()
end

function kraytGYspawnsScreenPlay:doIntellectSpawn()
	--self:doDespawn()
	
--	deleteData("krayt_gy_sawns:intellect_mob_loc")	
--		
--	local location = getRandomNumber(1, 3)
--
--	writeData("krayt_gy_sawns:intellect_mob_loc", location)
--
--	if (location == 1) then
--		self:spawnLocationONE()
--	end
--	if (location == 2) then
--		self:spawnLocationTWO()
--	end
--	if (location == 3) then
--		self:spawnLocationTHREE()
--	end
	
	self:spawnLocationONE()
	
	createEvent(getRandomNumber(120, 240) * 60 * 1000, "kraytGYspawnsScreenPlay", "doDespawn", nil, "")

end

function kraytGYspawnsScreenPlay:spawnLocationONE()
				--GY

local onex = 6838
local oney = 4319

	local pKrayt1 = spawnMobile("tatooine", "giant_canyon_krayt_dragon", getRandomNumber(60, 600), onex + getRandomNumber(-750, 750), 28.00, oney + getRandomNumber(-750, 750), -40, 0)
	writeData("krayt_gy_sawns:pKrayt1", SceneObject(pKrayt1):getObjectID())

	local pKrayt2 = spawnMobile("tatooine", "giant_canyon_krayt_dragon", getRandomNumber(60, 600), onex + getRandomNumber(-750, 750), 28.00, oney + getRandomNumber(-750, 750), -40, 0)
	writeData("krayt_gy_sawns:pKrayt2", SceneObject(pKrayt2):getObjectID())
	
	local pKrayt3 = spawnMobile("tatooine", "giant_canyon_krayt_dragon", getRandomNumber(60, 600), onex + getRandomNumber(-750, 750), 28.00, oney + getRandomNumber(-750, 750), -40, 0)
	writeData("krayt_gy_sawns:pKrayt3", SceneObject(pKrayt3):getObjectID())


--	local pImp1 = spawnMobile("corellia", "pvpimp", 15, onex + getRandomNumber(-5, 5), 28.0, oney + getRandomNumber(-5, 5), -100, 0)
--	writeData("krayt_gy_sawns:pImp1", SceneObject(pImp1):getObjectID())
--
--	local pImp2 = spawnMobile("corellia", "pvpimp", 15, onex + getRandomNumber(-5, 5), 28.0, oney + getRandomNumber(-5, 5), -100, 0)
--	writeData("krayt_gy_sawns:pImp2", SceneObject(pImp2):getObjectID())
--
--	local pImp3 = spawnMobile("corellia", "pvpimp", 15, onex + getRandomNumber(-5, 5), 28.0, oney + getRandomNumber(-5, 5), -100, 0)
--	writeData("krayt_gy_sawns:pImp3", SceneObject(pImp3):getObjectID())

end

function kraytGYspawnsScreenPlay:spawnLocationTWO()
local onex = -1324   --bestine
local oney = -3678

	local pKrayt1 = spawnMobile("tatooine", "giant_canyon_krayt_dragon", 15, onex + getRandomNumber(-5, 5), 12.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("krayt_gy_sawns:pKrayt1", SceneObject(pKrayt1):getObjectID())

	local pKrayt2 = spawnMobile("tatooine", "giant_canyon_krayt_dragon", 15, onex + getRandomNumber(-5, 5), 12.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("krayt_gy_sawns:pKrayt2", SceneObject(pKrayt2):getObjectID())
	
	local pKrayt3 = spawnMobile("tatooine", "giant_canyon_krayt_dragon", 15, onex + getRandomNumber(-5, 5), 12.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("krayt_gy_sawns:pKrayt3", SceneObject(pKrayt3):getObjectID())

--	local pReb4 = spawnMobile("corellia", "giant_canyon_krayt_dragon", 5, -99.3, 28.0, -4659.8, -26, 0)
--
--	local pReb5 = spawnMobile("corellia", "giant_canyon_krayt_dragon", 5, -100.3, 28.0, -4656.8, -26, 0)

	

	local pImp1 = spawnMobile("tatooine", "pvpimp", 15, onex + getRandomNumber(-5, 5), 12.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("krayt_gy_sawns:pImp1", SceneObject(pImp1):getObjectID())

	local pImp2 = spawnMobile("tatooine", "pvpimp", 15, onex + getRandomNumber(-5, 5), 12.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("krayt_gy_sawns:pImp2", SceneObject(pImp2):getObjectID())

	local pImp3 = spawnMobile("tatooine", "pvpimp", 15, onex + getRandomNumber(-5, 5), 12.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("krayt_gy_sawns:pImp3", SceneObject(pImp3):getObjectID())

--	local pImp4 = spawnMobile("corellia", "pvpimp", 5, -111.8, 28.0, -4667.7, -104, 0)
--
--	local pImp5 = spawnMobile("corellia", "pvpimp", 5, -106.7, 28.0, -4672.5, -100, 0)

end

function kraytGYspawnsScreenPlay:spawnLocationTHREE()
local onex = -4946   --theed
local oney = 4105

	local pKrayt1 = spawnMobile("naboo", "giant_canyon_krayt_dragon", 15, onex + getRandomNumber(-5, 5), 6.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("krayt_gy_sawns:pKrayt1", SceneObject(pKrayt1):getObjectID())

	local pKrayt2 = spawnMobile("naboo", "giant_canyon_krayt_dragon", 15, onex + getRandomNumber(-5, 5), 6.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("krayt_gy_sawns:pKrayt2", SceneObject(pKrayt2):getObjectID())
	
	local pKrayt3 = spawnMobile("naboo", "giant_canyon_krayt_dragon", 15, onex + getRandomNumber(-5, 5), 6.00, oney + getRandomNumber(-5, 5), -40, 0)
	writeData("krayt_gy_sawns:pKrayt3", SceneObject(pKrayt3):getObjectID())

--	local pReb4 = spawnMobile("corellia", "giant_canyon_krayt_dragon", 5, -99.3, 28.0, -4659.8, -26, 0)
--
--	local pReb5 = spawnMobile("corellia", "giant_canyon_krayt_dragon", 5, -100.3, 28.0, -4656.8, -26, 0)

	

	local pImp1 = spawnMobile("naboo", "pvpimp", 15, onex + getRandomNumber(-5, 5), 6.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("krayt_gy_sawns:pImp1", SceneObject(pImp1):getObjectID())

	local pImp2 = spawnMobile("naboo", "pvpimp", 15, onex + getRandomNumber(-5, 5), 6.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("krayt_gy_sawns:pImp2", SceneObject(pImp2):getObjectID())

	local pImp3 = spawnMobile("naboo", "pvpimp", 15, onex + getRandomNumber(-5, 5), 6.0, oney + getRandomNumber(-5, 5), -100, 0)
	writeData("krayt_gy_sawns:pImp3", SceneObject(pImp3):getObjectID())

--	local pImp4 = spawnMobile("corellia", "pvpimp", 5, -111.8, 28.0, -4667.7, -104, 0)
--
--	local pImp5 = spawnMobile("corellia", "pvpimp", 5, -106.7, 28.0, -4672.5, -100, 0)
end

function kraytGYspawnsScreenPlay:doDespawn()

	local pKrayt1 = getSceneObject(readData("krayt_gy_sawns:pKrayt1"))
	--if (pKrayt1 ~= nil) then
		SceneObject(pKrayt1):destroyObjectFromWorld()
		deleteData("krayt_gy_sawns:pKrayt1")
	--end
	
	local pKrayt2 = getSceneObject(readData("krayt_gy_sawns:pKrayt2"))
	--if (pKrayt2 ~= nil) then
		SceneObject(pKrayt2):destroyObjectFromWorld()
		deleteData("krayt_gy_sawns:pKrayt2")
	--end
	
	local pKrayt3 = getSceneObject(readData("krayt_gy_sawns:pKrayt3"))
	--if (pKrayt3 ~= nil) then
		SceneObject(pKrayt3):destroyObjectFromWorld()
		deleteData("krayt_gy_sawns:pKrayt3")
	--end
	
	--self:spawnLocationONE()
	
	createEvent(getRandomNumber(1, 10) * 60 * 1000, "kraytGYspawnsScreenPlay", "doIntellectSpawn", nil, "")
	
end
