function move(from, to)
    local temp = field[from.y][from.x]
    field[from.y][from.x] = field[to.y][to.x]
    field[to.y][to.x] = temp
end

function find_possible_moves()
    adjesent_stones = {{0, 1}, {0, 2}, {1, 0}, {2, 0}}    
    around_stones = {{{0, -2}, {-1, -1}, {1, -1}, {-1, 2}, {1, 2}, {0,3}},
      {{-1, 1}, {1, 1}},
      {{-2, 0}, {-1, -1}, {-1, 1}, {2, -1}, {2, 1}, {3,0}},
      {{1, -1}, {1, 1}}}
    for i = 1, size, 1 do
        for j = 1, size, 1 do
            for k = 1,  table.getn(around_stones), 1 do
                if find_pattern(i, j, adjesent_stones[k], around_stones[k]) then
                    return true
                end
            end
        end
    end
    return false
end

function find_pattern(row, column, adjesent_stone, around_stones)
    for i = 1, table.getn(around_stones) do
        if match_type(row + around_stones[i][1], column + around_stones[i][2], field[row][column]) == false then
            return false
        end
    end
    
    if match_type(row + adjesent_stone[1], column + adjesent_stone[2], field[row][column]) == true then
      return true
    end
    
    return false
end

function match_type(row, column, stone_type)
    if column < 1 or column > size or row < 1 or row > size then 
        return false 
    end
    return field[row][column] == stone_type
end

function add_new_stones()
    math.randomseed(os.time())
    for i = 1, size, 1 do
        for j = 1, size, 1 do
            if field[i][j] == " " then
                field[i][j] = stones[math.random(1, table.getn(stones))]
            end
        end
    end
end

function remove_matches(matches)
   matches_size  = table.getn(matches)
   for i = 1, matches_size, 1 do
       match_size = table.getn(matches[i])
       score = score + match_size
       for j = 1, match_size, 1 do
           -- remove matches write latter
           local position = {}
           position.x = matches[i][j].x
           position.y = matches[i][j].y
           field[position.y][position.x] = " "
           move_stones_down(position)
       end
    end
end

function look_for_matches()
    match_list = {}
    -- find horizontal lines
    for i = 1, size, 1 do
        for j = 1, size, 1 do
            match = find_horizontal_lines(i, j)
            if table.getn(match) > 2 then
                table.insert(match_list, match)
            end
        end
    end
    
    -- find vertical lines
    for i = 1, size, 1 do
        for j = 1, size, 1 do
            match = find_vertical_lines(i, j)
            if table.getn(match) > 2 then
                table.insert(match_list, match)
            end
        end
    end
    return match_list
end

function find_horizontal_lines(row, column)
    match = {}
    local position = {}
    position.x = column
    position.y = row
    
    
    i = 1
    table.insert(match, position)
    while column + i < size do
        if field[row][column] == field[row][column + i] then
            local position = {}
            position.x = column + i
            position.y = row
            table.insert(match, position)
        else
            return match
        end  
        i = i + 1
    end
    return match
end

function find_vertical_lines(row, column)
    match = {}
    local position = {}
    position.x = column
    position.y = row
    
    i = 1
    table.insert(match, position)
    while row + i < size do
        if field[row][column] == field[row + i][column] then
            local position = {}
            position.x = column
            position.y = row + i
            table.insert(match, position)
        else
            return match
        end  
        i = i + 1
    end
    return match
end


function move_stones_down(position)
  for row = position.y, 1, -1 do
      if field[row][position.x] ~= " " then
          position_from = {}
          position_from.x = position.x
          position_from.y = row
          position_to = {}
          position_to.x = position.x
          position_to.y = row + 1
          move(position_from, position_to)
      end
  end
end


function tick()
    matches = {}
    if correct_move == false then
        -- find combinations
        dump()
        matches = look_for_matches()
        if table.getn(matches) == 0 then
            move(to, from)
            dump()
            return
        end
        correct_move = true
    end
    while table.getn(matches) ~= 0 do
        remove_matches(matches)
        dump()
        add_new_stones()
        dump()
        matches = look_for_matches()
    end
end