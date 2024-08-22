local m = {}

function m.cwrite(text, w, offset)
  local _, y = term.getCursorPos()
  if not w then w, _ = term.getSize() end
  if not offset then offset = 0 end
  term.setCursorPos(offset+math.ceil((w-#text)/2), y)
  term.write(text)
  return {
    startX = offset+math.ceil((w-#text)/2),
    endX = offset+math.ceil((w-#text)/2)+#text,
    y = y
  }
end

return m