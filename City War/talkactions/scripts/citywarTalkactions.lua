function onSay(cid, words, param)

if getGlobalStorageValue(configCW.stats) == -1 then
	configCW:new()
else
	doPlayerSendCancel(cid, "The event is already running.")
end

return true
end