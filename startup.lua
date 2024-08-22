term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1, 1)
print('ngx:CC - Fission Reactor')
sleep(0.5)
print('')
print('Scanning for peripherals...')
sleep(0.5)

local adapter = peripheral.find('fissionReactorLogicAdapter')
local mon1, mon2 = peripheral.find('monitor')

local function err(title, desc) 
  term.setBackgroundColor(colors.red)
  print(title)
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.red)
  print(desc)
end

print('')
if adapter then
  print('Found Fission Reactor Logic Adapter')
  print('Fuel Assemblies:', adapter.getFuelAssemblies())
  print('Heat Capacity:', adapter.getHeatCapacity(), 'K')
  print('Fuel Capacity:', adapter.getFuelCapacity(), 'mB')
  print('Coolant Capacity:', adapter.getCoolantCapacity(), 'mB')
  print('Max. Burn Rate:', adapter.getMaxBurnRate(), 'mB/t')
else
  err(
    'Failed to find Fission Reactor Logic Adapter!',
    'Make sure the computer has a cabled connection to a Fission Reactor Logic Adapter using networking cables & wired modems.'
  )
  return
end

local mainMon = nil
local ctrlMon = nil

print('')
if mon1 then
  print('Found Monitor 1')
  local x, y = mon1.getSize()
  print('Size:', x, y)
  if x == 29 and y == 12 then
    print('Monitor 1 categorized as: Main Screen (29x12 chars)')
    mainMon = mon1
  elseif x == 29 and y == 5 then
    print('Monitor 1 categorized as: Control Screen (29x5 chars)')
    ctrlMon = mon1
  else
    err(
      'Invalid monitor size',
      'The computer must have a 3x2 blocks monitor and a 3x1 blocks monitor attached.'
    )
    return
  end
else
  err(
    'Failed to find Monitor 1',
    'Make sure the computer has a cabled connection to a Monitor using networking cables & wired modems.'
  )
  return
end

print('')
if mon2 then
  print('Found Monitor 2')
  local x, y = mon2.getSize()
  print('Size:', x, y)
  if x == 29 and y == 12 and not mainMon then
    print('Monitor 2 categorized as: Main Screen (29x12 chars)')
    mainMon = mon2
  elseif x == 29 and y == 5 and not ctrlMon then
    print('Monitor 2 categorized as: Control Screen (29x5 chars)')
    ctrlMon = mon2
  else
    err(
      'Invalid monitor size',
      'The computer must have a 3x2 blocks monitor and a 3x1 blocks monitor attached.'
    )
    return
  end
else
  err(
    'Failed to find Monitor 2',
    'Make sure the computer has a cabled connection to a Monitor using networking cables & wired modems.'
  )
  return
end

print('')
print('Setup successful!')
print('Starting monitoring systems')
require('/reactorlink/core')({
  reactor = adapter,
  monitors = {
    main = mainMon,
    ctrl = ctrlMon,
  }
})