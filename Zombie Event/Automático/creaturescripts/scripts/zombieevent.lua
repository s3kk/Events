local config = {
    playerCount = 2001, -- Storage dos players que entram e sai do evento
    
    goblet = 5805, -- Troféu que vai pro vencedor do evento
    rewards = {2195, 2152, 2160}, -- Recompensas.       
    moneyReward = {2160, 10, 1}, -- {moneyId, quantidade, usar}1 pra usar 0 pra não usar}
    
    -- Area que o zumbi vai spawnar
    fromPosition = {x = 543, y = 578, z = 7}, -- top de fromPosition até
    toPosition = {x = 577, y = 600, z = 7} -- em baixo toPostion
    }


function onStatsChange(cid, attacker, type, combat, value)
    if isPlayer(cid) and isMonster(attacker) then
        if isInArea(getPlayerPosition(cid), config.fromPosition, config.toPosition) then
            if getGlobalStorageValue(config.playerCount) >= 2 then
                doBroadcastMessage(getPlayerName(cid) .. " have been eated by Zombies!", MESSAGE_STATUS_CONSOLE_RED)
                local corpse = doCreateItem(3058, 1, getPlayerPosition(cid))
                doItemSetAttribute(corpse, "description", "You recognize " .. getCreatureName(cid) .. ". He was killed by "..(isMonster(attacker) and "a "..string.lower(getCreatureName(attacker)) or isCreature(attacker) and getCreatureName(attacker) or "a field item")..".")
                doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
                doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)), false)
                doSendMagicEffect(getPlayerPosition(cid), CONST_ME_TELEPORT)
                setGlobalStorageValue(config.playerCount, getGlobalStorageValue(config.playerCount)-1)
            elseif getGlobalStorageValue(config.playerCount) == 1 then
                if isInArea(getPlayerPosition(cid), config.fromPosition, config.toPosition) then
                    doBroadcastMessage(getPlayerName(cid) .. " won the Zombie event! Congratulations!", MESSAGE_STATUS_WARNING)
                    local goblet = doPlayerAddItem(cid, config.goblet, 1)
                    doItemSetAttribute(goblet, "description", "Awarded to " .. getPlayerName(cid) .. " for winning the Zombie event.")
                    local corpse = doCreateItem(3058, 1, getPlayerPosition(cid))
                    doItemSetAttribute(corpse, "description", "You recognize " .. getCreatureName(cid) .. ". He was killed by "..(isMonster(attacker) and "a "..string.lower(getCreatureName(attacker)) or isCreature(attacker) and getCreatureName(attacker) or "a field item")..".")
                    doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
                    doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)), false)
                    doSendMagicEffect(getPlayerPosition(cid), CONST_ME_TELEPORT)
                    for _,items in ipairs(config.rewards) do
                        doPlayerAddItem(cid, items, 1)
                    end
                    if config.moneyReward[3] == 1 then
                        doPlayerAddItem(cid, config.moneyReward[1], config.moneyReward[2])
                    end
                end
                        
                for x = config.fromPosition.x, config.toPosition.x do
                    for y = config.fromPosition.y, config.toPosition.y do
                        for z = config.fromPosition.z, config.toPosition.z do
                            areapos = {x = x, y = y, z = z, stackpos = 253}
                            getMonsters = getThingfromPos(areapos)
                            if isMonster(getMonsters.uid) then
                                doRemoveCreature(getMonsters.uid)
                            end
                        end
                    end
                end
            end
            return false
        end
    end
return true
end