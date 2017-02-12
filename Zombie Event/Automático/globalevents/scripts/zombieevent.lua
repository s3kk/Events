local config = { semana_mes = "semana",
	days = {1,2,3,4,5,6,7}, -- Dia das semanas que ir� acontecer o evento
	goblet = 5805, -- Trof�u que vai pro vencedor do evento
	rewards = {7440}, -- Recompensas. 
moneyReward = {9971, 10, 1},-- {moneyId, quantidade, usar}1 pra usar 0 pra n�o usar}
playerCount = 2001, -- Storage dos players que entram e sai do evento
zombieCount = 2002, -- Storage do zombie do event
teleportActionId = 2008, -- Action ID do teleport
teleportPosition = {x = 10160, y = 10054, z = 7, stackpos = 1}, -- Onde o teleport � criado
teleportToPosition = {x = 9930, y = 10105, z = 7}, -- Pra onde ser� teleportado
teleportId = 1387, -- ID do teleporte
timeToStartEvent = 2, -- Minutos que o portal ir� ficar aberto at� os player entrarem
timeBetweenSpawns = 20, -- Segundos dps do evento ser startado come�arem a aparecer os zombie
zombieName = "Zombie Event", -- Nome do zombie sumonado
playersNeededToStartEvent = 2, -- Players necess�rios pro evento ser iniciado
fromPosition = {x = 9896, y = 10074, z = 7}, -- top de fromPosition at�
toPosition = {x = 9970, y = 10142, z = 7} -- -- em baixo toPostion
}
function onTime()
	local time = os.date("*t")
	if (config.semana_mes == "semana" and isInArray(config.days,time.wday)) or (config.semana_mes == "mes" and isInArray(config.days,time.day)) or config.semana_mes == "" then
		local tp = doCreateTeleport(config.teleportId, config.teleportToPosition, config.teleportPosition)
		doItemSetAttribute(tp, "aid", config.teleportActionId)
		doBroadcastMessage("Zombie event starting in " .. config.timeToStartEvent .. " minutes! The teleport will be closed when the event start!", MESSAGE_STATUS_WARNING)
		setGlobalStorageValue(config.playerCount, 0)
		setGlobalStorageValue(config.zombieCount, 0)
		addEvent(startEvent, config.timeToStartEvent * 1000 * 60)
	end
	return TRUE
end
function startEvent() 
	local fromp, top = config.fromPosition, config.toPosition
	if getGlobalStorageValue(config.playerCount) >= config.playersNeededToStartEvent then
		addEvent(spawnZombie, config.timeBetweenSpawns * 1000)
		doBroadcastMessage("Good luck in the zombie event people! The teleport has closed!", MESSAGE_STATUS_WARNING)
		for x = fromp.x, top.x do
			for y = fromp.y, top.y do
				for z = fromp.z, top.z do
					areapos = {x = x, y = y, z = z}
					local m = getTopCreature(areapos).uid
					if isPlayer(m) then
						doPlayerSendTextMessage(m, MESSAGE_EVENT_ADVANCE, "The first zombie will spawn in " .. config.timeBetweenSpawns .. " seconds! Good luck!")
						pvgaylord()
					end
				end
			end
		end
	else
		doBroadcastMessage("The Zombie event could not start because of to few players participating.\n At least " .. config.playersNeededToStartEvent .. " players is needed!", MESSAGE_STATUS_WARNING)
		for x = fromp.x, top.x do
			for y = fromp.y, top.y do
				for z = fromp.z, top.z do
					areapos = {x = x, y = y, z = z}
					local m = getTopCreature(areapos).uid
					if isPlayer(m) then
						doTeleportThing(m, getTownTemplePosition(getPlayerTown(m)), false)
						doSendMagicEffect(getPlayerPosition(m), CONST_ME_TELEPORT)
					end
				end
			end
		end
	end
end


function spawnZombie()
	if getGlobalStorageValue(config.playerCount) >= 2 then
		pos = {x = math.random(config.fromPosition.x, config.toPosition.x), y = math.random(config.fromPosition.y, config.toPosition.y), z = math.random(config.fromPosition.z, config.toPosition.z)}
		local var = doCreateMonster(config.zombieName, pos, false)
		if var == false then return LUA_ERROR end
		doSendMagicEffect(pos, CONST_ME_MORTAREA)
		setGlobalStorageValue(config.zombieCount, getGlobalStorageValue(config.zombieCount)+1)
		doBroadcastMessage("A zombie has spawned! There is currently " .. getGlobalStorageValue(config.zombieCount) .. " zombies in the zombie event!", MESSAGE_STATUS_CONSOLE_RED)
		addEvent(spawnZombie, config.timeBetweenSpawns * 1000)
	else
		local fromp, top = config.fromPosition, config.toPosition
		for x = fromp.x, top.x do
			for y = fromp.y, top.y do
				for z = fromp.z, top.z do
					areapos = {x = x, y = y, z = z}
					local cid = getTopCreature(areapos).uid
					if isPlayer(cid) then
						doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)), false)
						doBroadcastMessage(getCreatureName(cid)..' has survived at zombie event!')
						for _,items in ipairs(config.rewards) do
							doPlayerAddItem(cid, items, 1)
							doPlayerAddItem(cid, 8306, 4)
						end
						if config.moneyReward[3] == 1 then
							doPlayerAddItem(cid, config.moneyReward[1], config.moneyReward[2])
						end
						doBroadcastMessage(getPlayerName(cid) .. " won the Zombie event! Congratulations!", MESSAGE_STATUS_WARNING)
						local goblet = doPlayerAddItem(cid, config.goblet, 1)
						doItemSetAttribute(goblet, "description", "Awarded to " .. getPlayerName(cid) .. " for winning the Zombie event.")
					elseif isMonster(cid) then
						doRemoveCreature(cid)
					end
				end
			end
		end
	end
end
function pvgaylord()
	local fromp, top, p, m = config.fromPosition, config.toPosition, 0, 0
	for x = fromp.x, top.x do
		for y = fromp.y, top.y do
			for z = fromp.z, top.z do
				areapos = {x = x, y = y, z = z}
				local m = getTopCreature(areapos).uid
				if isPlayer(m) then
					p = p+1
				elseif isMonster(m) then
					m = m+1
				end
			end
		end
	end
	if p ~= getGlobalStorageValue(config.playerCount) then
		setGlobalStorageValue(config.playerCount, p)
	end
	if p < 2 then
		return true
	end
	addEvent(pvgaylord,100,nil)
end