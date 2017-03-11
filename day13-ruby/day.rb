MAX_X = 100
MAX_Y = 100

START_X = 1
START_Y = 1

FAVOURITE_NUMBER = 1362
TRAVERSED_SPACES_ALL = Array.new
Coordinate = Struct.new(:x, :y)

def isOpenSpace(x, y)
    if (x < 0 || y < 0)
        return false
    end
    bin_num = (x*x + 3*x + 2*x*y + y + y*y + FAVOURITE_NUMBER).to_s(2)
    return bin_num.to_str().count('1') % 2 == 0
end

def walkUntil(_start_x, _start_y, _stop_after_step, _inherited_step_count, _traversed_spaces)
    if (!isOpenSpace(_start_x, _start_y) || _stop_after_step < _inherited_step_count || _traversed_spaces.any?{|e| (e.x == _start_x && e.y == _start_y)})
        return 0
    end
    if (!TRAVERSED_SPACES_ALL.any?{|e| (e.x == _start_x && e.y == _start_y)})
        TRAVERSED_SPACES_ALL.push(Coordinate.new(_start_x, _start_y))
    end
    _traversed_spaces.push(Coordinate.new(_start_x, _start_y))
    # Ruby had PASS by REFERENCE for arrays by default, this will mess
    # up our traversing, so we need to pass a clone of the array instead.
    return 1 + walkUntil(_start_x+1, _start_y, _stop_after_step, _inherited_step_count+1, _traversed_spaces.clone) \
        + walkUntil(_start_x-1, _start_y, _stop_after_step, _inherited_step_count+1, _traversed_spaces.clone) \
        + walkUntil(_start_x, _start_y+1, _stop_after_step, _inherited_step_count+1, _traversed_spaces.clone) \
        + walkUntil(_start_x, _start_y-1, _stop_after_step, _inherited_step_count+1, _traversed_spaces.clone)
end

puts walkUntil(START_X, START_Y, 50, 0, Array.new)

# Print room
print '  '
#(0..MAX_X).each { |n| print '%d ' % n }
puts
for row in 0..MAX_Y
    #print '%d ' % row
    for cell in 0..MAX_X
        if (TRAVERSED_SPACES_ALL.any?{|e| (e.x == cell && e.y == row)})
            print 'O'
        else
            print isOpenSpace(cell, row) ? '.' : '#'
        end
    end
    puts ''
end

puts TRAVERSED_SPACES_ALL.length
