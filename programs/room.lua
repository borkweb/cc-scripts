local tArgs = { ... }

if #tArgs ~= 3 then
  print("Usage: room <length> <width> <height>")
  print("Example: room 9 9 5")
  return
end

local length = tonumber( tArgs[1] )
local width  = tonumber( tArgs[2] )
local height = tonumber( tArgs[3] )

function dig()
  while turtle.detect() do
    turtle.dig()
    sleep(0.5)
  end
end

function digUp()
  while turtle.detectUp() do
    turtle.digUp()
    sleep(0.5)
  end
end

function forward()
  if not turtle.forward() then
    dig()
    turtle.forward()
  end
end

function up()
  if not turtle.up() then
    digUp()
    turtle.up()
  end
end

function digRow(rowLength, digAbove)
  digAbove = digAbove or false
  
  for i = 1, rowLength do
    dig()
    forward()
    if digAbove then digUp() end
  end
end

function digLevel(desiredHeight, currentHeight)
  for i = 1, width do
    -- dig the full length on the first row of the first level
    if i == 1 and currentHeight == 1 then
      -- dig out addiontal level if needed
      if currentHeight == desiredHeight then
        digRow(length)
      else
        digRow(length, true)
      end
      
    -- skip the first block of each lengthwise column on
    -- all subsequent columns; in these instances the
    -- turtle is already positioned at the first block
    -- of the given column.
    else
      -- Position the turtle in the next column,
      -- moving it in a zig-zag pattern as we dig
      -- out the full width of the room
      -- 
      -- If we're digging out an even number of floors,
      -- figure out if half of the current height is even;
      -- otherwise we only care if the current height is even.
      local even = false

      if desiredHeight % 2 == 0 then
        even = ((desiredHeight / 2) % 2 == 0)
      else
        even = (i % 2 == 0)
      end

      if even then
        turtle.turnRight()
        forward()
        turtle.turnRight()
      else
        turtle.turnLeft()
        forward()
        turtle.turnLeft()
      end
      
      -- Dig out an addional level if possible
      if (desiredHeight - currentHeight) == 0 then
        digRow(length - 1)
      else
        digRow(length - 1, true)
      end
    end -- length
  end -- width
end

for j = 1, height do
  digLevel(height, j)

  -- Position turtle to dig out next level
  turtle.turnRight()
  turtle.turnRight()
  up()

  -- Go up two levels if we
  -- haven't hit the ceiling
  if height - j ~= 0 then up() end
end -- height

print("Done!")
