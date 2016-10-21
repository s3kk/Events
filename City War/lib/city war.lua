configCW = {timetostart = 500, -- tempo para iniciar o evento em segundos
			telpos = {x=32340, y=32213, z=7}, -- onde aparecerá o teleport
			stats = 201201201701,
			kill = 201201201702,
			death = 201201201703,
			ostime =  201201201704,
			evttime = 20, -- quanto tempo irá rolar o evento
			topleftPos = {x=32722, y=31336, z=6}, -- canto esquerdo superior
			botrightPos = {x=32791, y=31384, z=6}, -- canto direito inferior
			templepos = {x=32369, y=32241, z=7}, -- posição do templo principal
			arenapos = {{x=32722, y=31340, z=6}, {x=32786, y=31336, z=6}, {x=32722, y=31380, z=6}, {x=32783, y=31374, z=6}}, -- posição dos 4 tronos
			times = 8, -- não precisa mexer
			finaltime = 300 -- não precisa mexer
}

function configCW:new()

local newevt = {}

setmetatable(newevt, self)
self.__index = self

doBroadcastMessage("The City War will be open in " .. self.timetostart .. " seconds.")
setGlobalStorageValue(self.stats, 0)
addEvent(function () newevt:start() end, self.timetostart*1000)
end

function configCW:start()

if getGlobalStorageValue(self.stats) == 0 then
	setGlobalStorageValue(self.ostime, os.time())
	local teleport = doCreateItem(1387, self.telpos)
	doItemSetAttribute(teleport, "aid", 5540)
	setGlobalStorageValue(self.stats, 1)
	doBroadcastMessage("The City War is starting...")
	for _, posi in pairs(self.arenapos) do
		local item = getTileItemById(posi, 1387)
		if(item.uid ~= 0) then
			doRemoveItem(item.uid)
		end
	end
	addEvent(function () self:preclose() end, self.evttime*1000*60)
	addEvent(function () self:announce(0) end, (self.evttime/self.times)*1000*60)
end

end

function configCW:announce(times)

if times < self.times then
	if #self:getTopFrags(true) >= 1 then 
		doBroadcastMessage("Top City War fraggers: " .. self:getTopFrags())
	end
	addEvent(function () self:announce(times+1) end, (self.evttime/self.times)*1000*60)
end

end

function configCW:preclose()

if getGlobalStorageValue(self.stats) == 1 then
	setGlobalStorageValue(self.stats, 2)
	doBroadcastMessage("The City War will end in " .. self.finaltime .. " seconds.")
	addEvent(function () self:close() end, self.finaltime*1000)
	local item = getTileItemById(self.telpos, 1387)
	if(item.uid ~= 0) then
		doRemoveItem(item.uid)
	end
end

end

function configCW:close()

if getGlobalStorageValue(self.stats) == 2 then
	if #self:getTopFrags(true) >= 1 then
		doBroadcastMessage("The City War has ended. The winners are: " .. self:getTopFrags())
	else
		doBroadcastMessage("The City War has ended. There were no winners.")
	end
	doRemovePlayersFromArea(self.topleftPos, self.botrightPos, self.templepos)
	for _, posi in pairs(self.arenapos) do
		doCreateTeleport(1387, self.templepos, posi)
	end
	for place, info in ipairs(self:getTopFrags(true)) do
		if place > 5 then
			break
		end
		local cid = getPlayerByName(info)
		doPlayerSendTextMessage(cid, 4, "Congratulations, you were the " .. place .. "º place in the City War.")
		doPlayerAddItem(cid, 6571, 1)
	end
	setGlobalStorageValue(self.stats, -1)
end

end

function configCW:isPlayerInEvent(cid)

if getPlayerStorageValue(cid, self.stats) == -1 or getPlayerStorageValue(cid, self.stats) - os.time() <= -5 or getGlobalStorageValue(self.stats) < 1 then
	return false
end

return true
end

function configCW:getTopFrags(tab)

local frag = {}

for _, pid in pairs(getPlayersOnline()) do
	if (getPlayerStorageValue(pid, self.kill) ~= -1 or getPlayerStorageValue(pid, self.death) ~= -1) and self:isPlayerInEvent(pid) then
		local kill =  getPlayerStorageValue(pid, self.kill)+1
		local death =  getPlayerStorageValue(pid, self.death)+1
		print(getCreatureName(pid), kill-death)
		table.insert(frag, {getCreatureName(pid), kill-death})
	end
end

print(#frag)
local frag, str, n = doOrderTab(frag, 0), nil, 5
print(#frag)

if tab then
	return frag
else
	if #frag < 5 then
		n = #frag
	end
	for i = 1, n do
		local cid = getPlayerByName(frag[i])
		local kill =  getPlayerStorageValue(cid, self.kill)+1
		local death =  getPlayerStorageValue(cid, self.death)+1
		str = str and str .. ", " .. frag[i] .. "[" .. kill .. "/" .. death .. "]" or frag[i] .. "[" .. kill .. "/" .. death .. "]"
	end
end

return str
end

function doOrderTab(tabela, value)

local max, index = {}, nil

for i = 1, #tabela do
	valor = value
	for a, b in ipairs(tabela) do
		if b[2] > valor then
			valor = b[2]
			valor2 = b[1]
			index = a
		end
	end
	table.remove(tabela, index)
	if valor ~= value then
		table.insert(max, valor2)
	end
end

return max
end