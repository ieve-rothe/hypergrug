# examples/Simple_1.cr
# Copyright (C) 2026 Cam Carroll
# Licensed under the AGPL-3.0. See LICENSE for details.

require "../src/hypergrug"

# 1. Setup
vec_size = 50
memory = Hypergrug::Memory.new

hearth = memory.register("hearth", vec_size)
fire = memory.register("fire", vec_size)
floor = memory.register("floor", vec_size)
bed = memory.register("bed", vec_size)

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
