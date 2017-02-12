local teleportPos = {x = 10160, y = 10054, z = 7, stackpos = 1} -- Posição em que se abre o teleport
local teleportId = 1387

function onTime()
    for i = 1, 255 do
        teleportPos.stackpos = i


        if getThingFromPos(teleportPos).itemid == teleportId then


            doRemoveItem(getThingFromPos(teleportPos).uid, 1)
        end
    end
    return true
end

--[[local teleportPos = {x = 10160, y = 10054, z = 7} -- Posição em que se abre o teleport
function removeZombieTp()
	local t = getTileItemById(teleportPos, 1387).uid
	return t > 0 and doRemoveItem(t) and doSendMagicEffect(teleportPos, CONST_ME_POFF)
end
function onTime()
	removeZombieTp()
	return true
end]]