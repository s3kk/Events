local config = {
    playerCount = 2001, -- Global storage for counting the players left/entered in the event
    zombieCount = 2002, -- Global storage for counting the zombies in the event
    teleportActionId = 2000, -- Action id of the teleport needed for the movement script
    teleportPosition = {x = 1135, y = 1077, z = 3, stackpos = 1}, -- Where the teleport will be created
    teleportToPosition = {x = 1190, y = 1076, z = 7}, -- Where the teleport will take you
    teleportId = 1387, -- Id of the teleport
    timeToStartEvent = 5, -- Minutes, after these minutes the teleport will be removed and the event will be declared started
    timeBetweenSpawns = 20, -- Seconds between each spawn of zombie
    zombieName = "event zombie", -- Name of the zombie that should be summoned
    playersNeededToStartEvent = 5, -- Players needed before the zombies can spawn.
    
    -- Should be the same as in the creaturescript!
    -- The zombies will spawn randomly inside this area
    fromPosition = {x = 1186, y = 1072, z = 7}, -- top left cornor of the playground
    toPosition = {x = 1195, y = 1081, z = 7}, -- bottom right cornor of the playground
    }

function onTimer()
    local tp = doCreateTeleport(config.teleportId, config.teleportToPosition, config.teleportPosition)
    doItemSetAttribute(tp, "aid", config.teleportActionId)
    doBroadcastMessage("Zombie event starting in " .. config.timeToStartEvent .. " minutes! The teleport will be closed when the event start!", MESSAGE_STATUS_WARNING)
    setGlobalStorageValue(config.playerCount, 0)
    setGlobalStorageValue(config.zombieCount, 0)
    addEvent(startEvent, config.timeToStartEvent * 1000 * 60)
    print(getGlobalStorageValue(2001))
end

function startEvent()
    local get = getThingfromPos(config.teleportPosition)
    if get.itemid == config.teleportId then
        doRemoveItem(get.uid, 1)
    end
    
    local fromp, top = config.fromPosition, config.toPosition

    if getGlobalStorageValue(config.playerCount) >= config.playersNeededToStartEvent then
        addEvent(spawnZombie, config.timeBetweenSpawns * 1000)
        doBroadcastMessage("Good luck in the zombie event people! The teleport has closed!", MESSAGE_STATUS_WARNING)
        
        for x = fromp.x, top.x do
            for y = fromp.y, top.y do
                for z = fromp.z, top.z do
                    areapos = {x = x, y = y, z = z, stackpos = 253}
                    getPlayers = getThingfromPos(areapos)
                    if isPlayer(getPlayers.uid) then
                        doPlayerSendTextMessage(getPlayers.uid, MESSAGE_EVENT_ADVANCE, "The first zombie will spawn in " .. config.timeBetweenSpawns .. " seconds! Good luck!")
                    end
                end
            end
        end
    else
        doBroadcastMessage("The Zombie event could not start because of to few players participating.\n At least " .. config.playersNeededToStartEvent .. " players is needed!", MESSAGE_STATUS_WARNING)
        for x = fromp.x, top.x do
            for y = fromp.y, top.y do
                for z = fromp.z, top.z do
                    areapos = {x = x, y = y, z = z, stackpos = 253}
                    getPlayers = getThingfromPos(areapos)
                    if isPlayer(getPlayers.uid) then
                        doTeleportThing(getPlayers.uid, getTownTemplePosition(getPlayerTown(getPlayers.uid)), false)
                        doSendMagicEffect(getPlayerPosition(getPlayers.uid), CONST_ME_TELEPORT)
                    end
                end
            end
        end
    end
end

function spawnZombie()
    if getGlobalStorageValue(config.playerCount) >= 2 then
        pos = {x = math.random(config.fromPosition.x, config.toPosition.x), y = math.random(config.fromPosition.y, config.toPosition.y), z = math.random(config.fromPosition.z, config.toPosition.z)}
        doSummonCreature(config.zombieName, pos)
        doSendMagicEffect(pos, CONST_ME_MORTAREA)
        setGlobalStorageValue(config.zombieCount, getGlobalStorageValue(config.zombieCount)+1)
        doBroadcastMessage("A zombie has spawned! There is currently " .. getGlobalStorageValue(config.zombieCount) .. " zombies in the zombie event!", MESSAGE_STATUS_CONSOLE_RED)
        addEvent(spawnZombie, config.timeBetweenSpawns * 1000)
    end
end