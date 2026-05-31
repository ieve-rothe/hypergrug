require "../src/hypergrug"
include Hypergrug

# Digression to Problem 1 - To get an idea of the amount of time this naive method takes to do a 'clean up snap' for a single vector.

VEC_SIZE = 10_000
memory = Memory.new
bucket = [] of Hypervector

1000.times do |ii|
    memory.register("#{ii}", VEC_SIZE)
end

hearth = memory.register("hearth", VEC_SIZE)
fire = memory.register("fire", VEC_SIZE)
floor = memory.register("floor", VEC_SIZE)
bed = memory.register("bed", VEC_SIZE)

# 2. Bind and Bundle
# Operator overloads let us write this natively
hearthfire = hearth * fire
floorbed = floor * bed

grug_cave = hearthfire + floorbed

# 3. Query
puts "Looking for what is at the floor..."
query_vector = grug_cave * floor

# 4. Clean-up Snap
result = memory.match(query_vector)

if result
  puts "Concept: #{result[:name]} // Distance: #{result[:distance]}"
else
  puts "Memory is empty."
end