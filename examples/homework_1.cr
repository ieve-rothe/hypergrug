require "../src/hypergrug"
include Hypergrug

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
min_dist = VEC_SIZE+1_i64
max_dist = 0_i64

1000.times do
    bucket << Hypervector.random(VEC_SIZE)
end

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