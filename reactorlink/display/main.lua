local utils = require('/reactorlink/utils')

return function(m, adapter, api)
  m.setBackgroundColor(colors.black)
  m.clear()
  
  return {
    m = m,
    update = function(press_ev)
      term.setTextColor(colors.white)
      term.setBackgroundColor(colors.black)
      term.setCursorPos(1, 1)

      local w, h = term.getSize()

      if api.getScram() then
        paintutils.drawLine(1, 1, w, 1, colors.red)
        utils.cwrite("SCRAM", nil, 1)
      elseif adapter.getStatus() then
        paintutils.drawLine(1, 1, w, 1, colors.green)
        utils.cwrite("ONLINE", nil, 1)
      else
        paintutils.drawLine(1, 1, w, 1, colors.gray)
        utils.cwrite("OFFLINE", nil, 1)
      end

      do -- Temp
        term.setBackgroundColor(colors.black)
        term.setCursorPos(2, 3)
        term.write("Temperature")

        paintutils.drawLine(15, 3, 24, 3, colors.gray)
        term.setCursorPos(15, 3)
        local temp = adapter.getTemperature()
        if temp >= 800 and temp < 1200 then
          term.setTextColor(colors.yellow)
        elseif temp >= 1200 then
          term.setTextColor(colors.red)
        else
          term.setTextColor(colors.white)
        end
        utils.cwrite(string.format("%.2f", temp), 24-15, 15)
        term.setTextColor(colors.white)

        term.setCursorPos(26, 3)
        term.setBackgroundColor(colors.black)
        term.write("K")
      end

      do -- Damage
        term.setBackgroundColor(colors.black)
        term.setCursorPos(2, 5)
        term.write("Integrity")

        paintutils.drawLine(15, 5, 24, 5, colors.gray)
        term.setCursorPos(15, 5)
        local integ = 100-adapter.getDamagePercent()
        if integ <= 85 and integ > 70 then
          term.setTextColor(colors.yellow)
        elseif integ <= 70 then
          term.setTextColor(colors.red)
        else
          term.setTextColor(colors.white)
        end
        utils.cwrite(string.format("%.f", integ), 24-15, 15)
        term.setTextColor(colors.white)

        term.setCursorPos(26, 5)
        term.setBackgroundColor(colors.black)
        term.write("%")
      end

      do -- Coolant
        local coolant = adapter.getCoolantFilledPercentage()
        if coolant <= 0.8 and coolant > 0.5 then
          term.setTextColor(colors.yellow)
        elseif coolant <= 0.5 then
          term.setTextColor(colors.red)
        else
          term.setTextColor(colors.white)
        end
        term.setBackgroundColor(colors.black)
        term.setCursorPos(2, 7)
        term.write("Coolant")

        paintutils.drawLine(2, 8, w-1, 8, colors.gray)
        term.setCursorPos(2, 8)
        term.setBackgroundColor(colors.lightBlue)
        term.write(string.rep(' ', (w-2)*coolant))
      end

      do -- Fuel
        term.setTextColor(colors.white)
        term.setBackgroundColor(colors.black)
        term.setCursorPos(2, 10)
        term.write("Fuel")

        paintutils.drawLine(2, 11, w-1, 11, colors.gray)
        term.setCursorPos(2, 11)
        term.setBackgroundColor(colors.brown)
        term.write(string.rep(' ', (w-2)*adapter.getFuelFilledPercentage()))
      end
    end
  }
end