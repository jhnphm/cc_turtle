-- Turtle follows named entity (currently "jhnphm")
-- Using self to initialize heading, substitute with own username as needed
-- Should be trivially modifiable to kill enemies
-- Does not really work w/ obstructing terrain; this needs to be implemented. 
-- Requires openccsensors, with a proximity sensor in 16th slot

-- load the API
os.loadAPI("ocs/apis/sensor")
-- wrap the sensor
prox = sensor.wrap("right")



local NORTH, EAST, SOUTH, WEST = 0, 1, 2, 3
facing = -1

-- Determine initial facing
function initFacing()
    if turtle.detect() then
        turtle.dig()
    end
    local me = prox.getTargetDetails("jhnphm")
    local pos = me.Position
    local x = pos.X
    local z = pos.Z
    turtle.forward()
    me = prox.getTargetDetails("jhnphm")
    pos = me.Position
    x = pos.X-x
    z = pos.Z-z

    if math.abs(x) > math.abs(z) then
        if x < 0 then
            facing = EAST
            print("Facing East")
        else
            facing = WEST
            print("Facing West")
        end
    else
        if z < 0 then
        print( "Facing Sourth")
            facing = SOUTH
        else
        print("Facing North")
            facing = NORTH
        end
    end
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
    turtle.turnLeft()
end
function turnLeft()
    facing = (facing - 1) % 4
    turtle.turnLeft()
end
function turnRight()
    facing = (facing + 1) % 4
    turtle.turnRight()
end
function turnTo(heading)
    if heading == NORTH then
        if facing == EAST then
            turnLeft()
        elseif facing == SOUTH then
            turnLeft()
            turnLeft()
        elseif facing == WEST then
            turnRight()
        end
    elseif heading == EAST then
        if facing == SOUTH then
            turnLeft()
        elseif facing == WEST then
            turnLeft()
            turnLeft()
        elseif facing == NORTH then
            turnRight()
        end
    elseif heading == SOUTH then
        if facing == WEST then
            turnLeft()
        elseif facing == NORTH then
            turnLeft()
            turnLeft()
        elseif facing == EAST then
            turnRight()
        end
    elseif heading == WEST then
        if facing == NORTH then
            turnLeft()
        elseif facing == EAST then
            turnLeft()
            turnLeft()
        elseif facing == SOUTH then
            turnRight()
        end
    end
end


-- Move closer to entity. Needs to be made more efficient for diagonal moves. 
function go(x,y,z)
    print("Going to: "..x..","..y..","..z)
    local i
    if math.abs(x) > math.abs(z) then
        if math.floor(x) > 0 then
            turnTo(EAST)
            print("Turning East")
        elseif math.floor(x) < 0 then
            print("Turning West")
            turnTo(WEST)
        end
        print("Moving...")
        turtle.forward()
    else
        if math.floor(z) > 0 then
            print("Turning South")
            turnTo(SOUTH)
        elseif math.floor(z) < 0 then
            print("Turning North")
            turnTo(NORTH)
        end
        if turtle.detect() then 
            return 
        end
        print("Moving...")
        turtle.forward()
    end
    if math.floor(y) > 0 then
        if turtle.detectUp() then 
           return 
        end
        print("Moving up...")
        turtle.up()
    elseif math.floor(y) < 0 then
        if turtle.detectDown() then 
            return 
        end
        print("Moving down...")
        turtle.down()
    end
end


function distance(pos)
  local xd = pos.X
  local yd = pos.Y
  local zd = pos.Z
  return math.sqrt(xd*xd + yd*yd + zd*zd)
end

initFacing()

while true do
    local me = prox.getTargetDetails("jhnphm")
    local pos = me.Position
    local dist = distance(pos)
     print("Position:" ..me.Position.X..','..me.Position.Y..","..me.Position.Z)
    if dist > 4 then 
        print("Dist: "..dist)
        --Add one to prevent turtle from being stuck in grass
        go(pos.X, pos.Y+1, pos.Z)
        dist = distance(pos) 
    end
    if dist > 30 then  --Give up after distance of 30
        break
    end
end
