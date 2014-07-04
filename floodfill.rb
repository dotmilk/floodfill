
# NilClass message eating as per http://stackoverflow.com/questions/9766980/is-rubys-multidimensional-array-out-of-bounds-behaviour-consistent
class NilClass
    def method_missing(*)
        nil
    end
end

# better to base N as per http://stackoverflow.com/questions/2894325/an-algorithm-for-converting-a-base-10-number-to-a-base-n-number
class Integer
    def to_base(base=10)
        return [0] if zero?
        raise ArgumentError, 'base must be greater than zero' unless base > 0
        num = abs
        return [1] * num if base == 1
        [].tap do |digits|
          while num > 0
            digits.unshift num % base
            num /= base
          end
        end
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

def get_large_number
    rand(2**32..2**640-1)**24
end

# simple test aray we want our code to ignore 1's and turn 0's to 2's
def make_field_array( dimension )
    binary = get_large_number.to_base 2
    field = []
    dimension.times do
        row = []
        dimension.times do
            row.push binary.pop
        end
        field.push row
    end
    field
end



def flood_fill( field, node, target_number, replacement_number )
    return if target_number == replacement_number
    # create an array to keep track of nodes looked at 
    # -1 unprocessed -2 processed 
    processed = field.map { |row| row.map { |e| -1 } }
    q = []
    q.push node
    until q.empty?
        # Get a node
        n = q.pop
        # Filter out negative indexes
        next if n.y-1 < 0 || n.x-1 < 0
        # Check if this node is what we are looking for
        if field[n.y-1][n.x-1] == target_number
            # if so set it = to what we want
            field[n.y-1][n.x-1] = replacement_number
            # update proccessed so we know we've seen it
            processed[n.y-1][n.x-1] = -2 
            # get directions to check
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

field = make_field_array 20

pp "Before"
pp field
flood_fill field, Node.new(3,2), 0, 9
pp "After"
pp field
