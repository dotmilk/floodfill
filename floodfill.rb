
# NilClass message eating as per http://stackoverflow.com/questions/9766980/is-rubys-multidimensional-array-out-of-bounds-behaviour-consistent
class NilClass
    def method_missing(*)
        nil
    end
end

class Node
    attr_reader :x, :y, :name 
    def initialize( x, y, name = '' )
        @name = name
        @x = x
        @y = y
    end
end



# simple test aray we want our code to ignore 1's and turn 0's to 2's
def make_field_array
    return [
        [1,0,0,0,1],
        [1,0,0,0,1],
        [1,0,0,0,1] ]
end
#              ^ this is the stating point [4,3]

def flood_fill( field, node, target_number, replacement_number )
    return if target_number == replacement_number
    # create an array to keep track of nodes looked at 
    # -1 unprocessed -2 processed 
    processed = field.map { |row| row.map { |e| -1 } }
    q = []
    q.push node
    puts "ONCE"
    until q.empty?
        n = q.pop
        if field[n.y-1][n.x-1] != nil && field[n.y-1][n.x-1] == target_number
            field[n.y-1][n.x-1] = replacement_number
            processed[n.y-1][n.x-1] = -2 
            to_check = get_four_directions(n)
            for direction in to_check
                if processed[direction.y-1][direction.x-1] != nil && processed[direction.y-1][direction.x-1] == -1
                    q.push(direction)
                end
            end
        end
    end
end

def get_four_directions(start)
    x = start.x
    y = start.y
    directions = []
    directions.push Node.new(x-1, y,'west')
    directions.push Node.new(x+1, y,'east')
    directions.push Node.new(x,y+1,'south')
    directions.push Node.new(x,y-1,'north')
    directions
end

# node [x,y]

field = make_field_array
flood_fill field, Node.new(3,2), 0, 9
pp field
