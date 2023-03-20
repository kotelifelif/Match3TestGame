function mix()
    math.randomseed(os.time())
    for i = 1, size, 1 do
        for j = 1, size, 1 do
            row = math.random(1, size)
            column = math.random(1, size)
            position_from = {}
            position_from.x = j
            position_from.y = i
            position_to = {}
            position_to.x = column
            position_to.y = row
            move(position_from, position_to)
        end
    end
end

function clear()
    if not os.execute("cls") then
        os.execute("clear")
    end
    print("\n")
end

function init()
    -- create empty field
    field = {}
    for i = 0, size, 1 do
        field[i] = {}
        for j = 0, size, 1 do
            field[i][j] = stones[1]
        end
    end
    local previous_below_stone = nil
    local previous_left_stone = nil
    math.randomseed(os.time())
    for i = 1, size, 1 do
        row = ""
        for j = 1, size, 1 do
            if field[i - 1][j] ~= nil then
                previous_below_stone = field[i - 1][j]
            end
            if field[i][j - 1] ~= nil then
                previous_left_stone = field[i][j - 1]
            end
            while field[i][j] == previous_below_stone or field[i][j] == previous_left_stone do
                field[i][j] = stones[math.random(1, table.getn(stones))]            
            end
        end
    end
    dump()
end

function dump()
    clear()
    row = "  "
    for i = 1, size, 1 do
        row = row .. tostring(i - 1) 
    end
    print(row)
    
    row = "  "
    for i = 1, size, 1 do
        row = row .. "_" 
    end
    print(row)
    
    row = ""
    for i = 1, size, 1 do
      row = ""
      row = tostring(i - 1) .. "|"
        for j = 1, size, 1 do
            row = row .. field[i][j]
        end
      print(row)
    end
    
    print("your score: " .. score)
    -- wait for 2 seconds
    local start = os.clock()
    while os.clock() - start < 2 do end
end

function input()
    correct_move = false
    command = io.read()
    words = {}
    for word in command:gmatch("%w+") do table.insert(words, word) end
    if words[1] == "m" then
        if tonumber(words[2]) == nil or tonumber(words[3]) == nil or
        tostring(words[4]) == nil then
            return 2
        end
        
        position = {}
        position.x = tonumber(words[2])
        position.y = tonumber(words[3])
        position.x = position.x + 1
        position.y = position.y + 1
        if position.x < 1 then
            position.x = 1
        elseif position.x > size then
            position.x = size
        elseif position.y < 1 then
            position.y = 1
        elseif position.y > size then
            position.y = size
        end
        
        position_from = {}
        position_to = {}
        position_from.x = position.x
        position_from.y = position.y
        position_to.x = position.x
        position_to.y = position.y
        movement = words[4]
        if movement == "l" then
            position_to.x = position_to.x - 1
        elseif movement == "r" then
            position_to.x = position_to.x + 1
        elseif movement == "u" then
            position_to.y = position_to.y - 1
        elseif movement == "d" then
            position_to.y = position_to.y + 1
        else
            return 2
        end
        
        if position_to.x < 1 or position_to.x > size or 
           position_to.y < 1 or position_to.y > size then
            return 2
        end
        
        return 0, position_from, position_to
    elseif words[1] == "q" then
        return 1
    else
       return 2 
    end
end