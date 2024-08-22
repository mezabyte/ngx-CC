-- This function will be called by the startup script.
return function(data) 
  local reactor = data.reactor

  local scram = true
  
  local api = {
    setScram = function(value)
      scram = value
    end,
    getScram = function()
      return scram
    end,
  }
  
  local displays = {}
  for _,v in pairs(fs.list('reactorlink/display')) do
    local monitor_id = string.gsub(v, '.lua', '')
    local m = data.monitors[monitor_id]
    displays[peripheral.getName(m)] = require('/reactorlink/display/'..monitor_id)(m, reactor, api)
  end
  
  local old_term = term.current()
  
  local event, event_monitor, xPos, yPos
  
  local function main_loop() 
    while true do
      for monitor_id, display in pairs(displays) do
        term.redirect(display.m)
        local mon_ev = nil
        if event and event_monitor == monitor_id then
          event = nil
          mon_ev = {
            xPos = xPos,
            yPos = yPos
          }
        end
        display.update(mon_ev)
      end
      term.redirect(old_term)
  
      local temp = reactor.getTemperature()
      local integ = 100-reactor.getDamagePercent()
      if temp >= 10000 or integ <= 60 then
        if not scram then
          scram = true
          if reactor.getStatus() then
            reactor.scram()
          end
        end
      else
        if scram then
          scram = false
        end
      end
    end
  end
  
  while true do
    parallel.waitForAny(
      function()
        event, event_monitor, xPos, yPos = os.pullEvent("monitor_touch")
      end,
      main_loop
    )
  end
end