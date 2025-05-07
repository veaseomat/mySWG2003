function setBankLimit(creature, cmdString)
	if creature == nil then
		return
	end

	local args = LuaSplit(cmdString, " ")
	if #args < 2 then
		creature:sendSystemMessage("Usage: /setBankLimit <number> [target]")
		return
	end

	local limit = tonumber(args[2])
	if limit == nil or limit <= 0 then
		creature:sendSystemMessage("Invalid bank size.")
		return
	end

	local target = creature
	if args[3] == "target" then
		local selected = creature:getSlottedObject("selected")
		if selected ~= nil and selected:isPlayerCreature() then
			target = selected
		else
			creature:sendSystemMessage("No valid player target selected.")
			return
		end
	end

	local player = target:getPlayerObject()
	if player == nil then
		creature:sendSystemMessage("Player object not found.")
		return
	end

	player:setBankMax(limit)
	if target == creature then
		creature:sendSystemMessage("Your bank limit is now " .. limit)
	else
		creature:sendSystemMessage("Set bank limit of target to " .. limit)
		target:sendSystemMessage("Your bank limit has been set to " .. limit)
	end
end

