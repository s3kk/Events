function loseOnZombieArena(cid)
	kickPlayerFromZombiesArea(cid)
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voce perdeu.")
	local players = getZombiesEventPlayers()
	if(#players <= 1) then
		local winner = players[1]
		if(winner) then
			doPlayerAddItem(winner, 2157, 5, true)
            doPlayerAddItem(winner, 6119, 1, true)
			doPlayerSendTextMessage(winner, MESSAGE_STATUS_CONSOLE_BLUE, "Voce ganhou o Zombie Event.")
			doBroadcastMessage("Depois de " .. os.time() - getPlayerZombiesEventStatus(winner) .. " segundos, o jogador " .. getCreatureName(winner) .. " ganhou o Zombie Arena Event com " .. getStorage(ZE_ZOMBIES_SPAWNED) .. " zumbis!")
			kickPlayerFromZombiesArea(winner)
		else
			doBroadcastMessage("O evento acabou, infelizmente ninguém ganhou!")
		end
		doSetStorage(ZE_STATUS, 0)
		doSetStorage(ZE_PLAYERS_NUMBER, ZE_DEFAULT_NUMBER_OF_PLAYERS)
		doSetStorage(ZE_ZOMBIES_TO_SPAWN, 0)
		doSetStorage(ZE_ZOMBIES_SPAWNED, 0)
		local width = (math.max(ZE_spawnFromPosition.x, ZE_spawnToPosition.x) - math.min(ZE_spawnFromPosition.x, ZE_spawnToPosition.x)) / 2 + 1
		local height = (math.max(ZE_spawnFromPosition.y, ZE_spawnToPosition.y) - math.min(ZE_spawnFromPosition.y, ZE_spawnToPosition.y)) / 2 + 1
		local centerPos = {x=math.min(ZE_spawnFromPosition.x, ZE_spawnToPosition.x)+width,y=math.min(ZE_spawnFromPosition.y, ZE_spawnToPosition.y)+height,z=ZE_spawnFromPosition.z}
		for z = math.min(ZE_spawnFromPosition.z, ZE_spawnToPosition.z), math.max(ZE_spawnFromPosition.z, ZE_spawnToPosition.z) do
			centerPos.z = z
			for i, uid in pairs(getSpectators(centerPos, width, height, false)) do
				if(isMonster(uid)) then
					doRemoveCreature(uid)
				end
			end
		end
	end
end
function onStatsChange(target, cid, changetype, combat, value)
	if((cid and isMonster(cid) and getCreatureName(cid) == "Zombie Event") or (isInRange(getThingPos(target), ZE_spawnFromPosition, ZE_spawnToPosition) and changetype == STATSCHANGE_HEALTHLOSS and math.abs(value) >= getCreatureHealth(target))) then
		doCreatureAddHealth(target, getCreatureMaxHealth(target))
		loseOnZombieArena(target)
		return false
	end
	return true
end 