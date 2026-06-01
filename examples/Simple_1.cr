# examples/Simple_1.cr
# Copyright (C) 2026 Cam Carroll
# Licensed under the AGPL-3.0. See LICENSE for details.

require "../src/hypergrug"

# 1. Setup
vec_size = 50 # Tiny vector size compared to what Kanerva recommends,
# which is on the order of D = 10,000 to get the magick properties
# of yuge dimensional vectors. 
# But in this trivial example, D=50 still works consistently

memory = Hypergrug::Memory.new 
# 'Memory' aka 'Clean-Up Memory' aka 'Item Memory' aka 'codebook'
# is a database of concepts. (Apparently nobody can decide on a name...)
# We'll register concepts before binding and bundling, so that when we query
# (aka 'unbind'), we can then take a noisy result and do a 
# nearest-neighbor search to find the actual concept.

hearth = memory.register("hearth", vec_size)
fire = memory.register("fire", vec_size)
floor = memory.register("floor", vec_size)
bed = memory.register("bed", vec_size)
# memory.register is creating a random hypervector (HV) with vec_size
# and stashing that in our registry along with the associated concept name.
# Hypergrug uses a Crystal BitArray. So this is just an array of vec_size 
# full of random 1's and 0's.

# 2. Bind and Bundle
hearthfire = hearth * fire
floorbed = floor * bed
grug_cave = hearthfire + floorbed

# Algebraically...
# grug_cave = (hearth x fire) + (floor x bed)
# "*" operation is a bitwise XOR ("binding")
# "+" operation is a bitewise majority-vote ("bundling")

# 3. Query
puts "Looking for what is at the hearth..."
query_vector = grug_cave * hearth

# Algebraically...
# query = hearth x [(hearth x fire) + (floor x bed)]
# query = hearth(hearth x fire) + hearth(floor x bed)
# query = (hearth x hearth x fire) + (hearth x floor x bed)
#
# (Distribute property holds true for a bitwise XOR over a 
# bitwise majority-vote... given some assumptions about ties/tiebreakers.)
# But pretty sure it's valid here. To be explored later!
#
# Because our "x" / "*" operation is an XOR on these binary vectors, a xor a = 0
# a = Hypergrug::Hypervector.random(100)
# => Hypergrug::Hypervector(@bits=BitArray
# [000110110011110010100111101111100000000101010001110101011000110010011001...
# 1101000111001100100100100101], @dimensions=100)
#
# a*a
# => Hypergrug::Hypervector(@bits=BitArray
# [0000000000000000000000000000000000000000000000000000000000000000000000000...
# 000000000000000000000000000], @dimensions=100)
#
# b = Hypergrug::Hypervector.random(100)
# c = a*a*b
# b == c
# => true
#
# So query becomes...
# query = fire + (hearth x floor x bed)
# query = fire + {some meaningless noise}

# 4. Clean-up Snap
# (I don't think 'snap' is canonical but... I like it. It's descriptive.)

result = memory.match(query_vector)

# memory.match iterates through all items in the registry and finds the concept
# vector with the smallest distance from our query result.
# Because of the magic of high dimensional vectors, any random non-related
# vector will be very far away from our query result / concept vector.
# eg, with D = 10,000, any random non-related vector is almost guaranteed to be
# in the range of ~4700-5300 bits away calculated by Hamming distance.
# This gives a huge buffer for noise, allowing us to easily find the correct
# concept vector from our memory register.
#
# (And it still works even with D=50, just with way less buffer for noise.)

if result
  puts "Concept: #{result[:name]} // Distance: #{result[:distance]}"
else
  puts "Memory is empty."
end
