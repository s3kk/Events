	local config = {
    positions = {
["Saida"] = { x = 412, y = 479, z = 7 },
["Aqui"] = { x = 368, y = 466, z = 7 },
[" >> "] = { x = 395, y = 460, z = 7 },
[" << "] = { x = 397, y = 460, z = 7 },
   
  }
}

function onThink(cid, interval, lastExecution)
    for text, pos in pairs(config.positions) do
        doSendAnimatedText(pos, text, math.random(31, 31))
    end
    
    return TRUE
end  