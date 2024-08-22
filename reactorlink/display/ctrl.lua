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
      term.clear()

      local w, h = term.getSize()
      
      term.setCursorPos(0, 3)
      if api.getScram() then
        term.setBackgroundColor(colors.gray)
      else
        term.setBackgroundColor(colors.white)
      end

      term.setTextColor(colors.black)
      local button
      if adapter.getStatus() then
        btn = utils.cwrite(' disable ')
      else
        btn = utils.cwrite(' activate ')
      end

      if api.getScram() then
        term.setCursorPos(0, 5)
        paintutils.drawLine(1, 5, w, 5, colors.red)
        term.setBackgroundColor(colors.red)
        term.setTextColor(colors.white)
        utils.cwrite('Safety checks failed')
      end
      
      if press_ev and press_ev.xPos >= btn.startX and press_ev.xPos <= btn.endX and press_ev.yPos == btn.y then
        if api.getScram() then return end
        if adapter.getStatus() then
          adapter.scram()
        else
          adapter.activate()
        end
      end
    end
  }
end