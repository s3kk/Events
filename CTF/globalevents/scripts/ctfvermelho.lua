	local config = {
    positions = {
["Saida"] = { x = 375, y = 478, z = 7 },
["Aqui"] = { x = 420, y = 467, z = 7 },
[" >> "] = { x = 390, y = 481, z = 7 },
[" << "] = { x = 392, y = 481, z = 7 }
   
  }
}

function onThink(cid, interval, lastExecution)
    for text, pos in pairs(config.positions) do
        doSendAnimatedText(pos, text, math.random(144, 144))
    end
    
    return TRUE
end  