require "../src/hypergrug"
include Hypergrug

# Compilation note - Make sure to use --release flag when building
# The optimizations reduce the execution time by a lot.

# Problem 1: The "Crust" Distribution (Code)

# Objective: Prove Kanerva's claim about the 4,700-5,300 bit bulge using brute-force statistics.
# Task:

#     Write a script to generate 1,000 random bitstrings, each exactly D=10,000 bits long.

#     Calculate the Hamming distance between every possible pair in that set (this is 21000×999​=499,500 comparisons).

#     Output the Minimum, Maximum, and Mean distances.
#     Expected Result: You should see that out of nearly half a million comparisons, not a single pair falls outside the 4,600 to 5,400 range, physically proving that randomly generated vectors are statistically guaranteed to be orthogonal.

VEC_SIZE = 10_000
bucket = [] of Hypervector

comparisons = 0_i64
total_dist = 0_i64
# Set minimum to be larger than the maximum we ever expect to see
# bc the loop logic looks for smallest. (Can't start with zero or the loop
# won't chooch.)
min_dist = VEC_SIZE+1_i64
# Same for the max. Except backwards.
max_dist = 0_i64

1000.times do
    bucket << Hypervector.random(VEC_SIZE)
end

# Pairwise comparison to look, from every vector in the space, to every other
# vector in the space, calculate the Ham distance, and keep track of the minimum
# and maximum values.
#
# In Crystal, the '...' operator stops 1 element under the stated endpoint.
# And since the inner loop goes all the way up to the last element (index 999),
# the outer loop can stop at the second to last element (index 998).
#
# Inner loop is indexed from (ii+1) for efficiency. Eg on ii = 5, we already
# checked 1, 2, 3 and 4 against every vector in the space, so we don't need
# to check them again.
(0...(bucket.size-1)).each do |ii|
    ((ii+1)...bucket.size).each do |jj|
        dist = bucket[ii].distance_to(bucket[jj])

        min_dist = dist if dist < min_dist
        max_dist = dist if dist > max_dist
        total_dist += dist
        comparisons += 1
    end
end
average = total_dist.to_f / comparisons

puts "Minimum distance: #{min_dist}"
puts "Maximum distance: #{max_dist}"
puts "Average distance: #{average}"