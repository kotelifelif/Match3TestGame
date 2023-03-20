size = 10
field = {}
stones = {"A", "B", "C", "D", "E", "F"}
correct_move = false
from, to = {}
score = 0

require("ui")
require("game")

init()
while true do
    find_move = false
    repeat
        code_result, from, to = input()
    until code_result ~= 2
    
    if code_result == 1 then
        break
    end
    
    move(from, to)
    tick()
    
    while find_possible_moves() == false do
        find_move = true
        repeat
            mix()
        until table.getn(look_for_matches()) < 3
    end
    
    if find_move == true then
        dump()
    end
end