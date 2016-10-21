function onPrepareDeath(cid, lastHitKiller, mostDamageKiller)

if isInRange(getCreaturePosition(cid), configCW.topleftPos, configCW.botrightPos) then
	setPlayerStorageValue(cid, configCW.death, getPlayerStorageValue(cid, configCW.death) +1)
	setPlayerStorageValue(lastHitKiller[1], configCW.kill, getPlayerStorageValue(lastHitKiller[1], configCW.kill) +1)
end

return true
end