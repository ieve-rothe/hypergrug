require "big"

# Calculate 2^9999, take its log10
a = (9999 * Math.log10(2))
a_exp = a.floor.to_i
a_frac = a - a_exp

b_base = 10 ** a_frac
b_scale = 10.to_big_f ** a_exp

b = b_base * b_scale

c = (10000 * Math.log10(2))
c_exp = c.floor.to_i
c_frac = c - c_exp

d_base = 10 ** c_frac
d_scale = 10.to_big_f ** c_exp

d = d_base * d_scale

exp_diff = c_exp - a_exp

# Divide b's base by 10 to shift its decimal point to the left
# finagling things to avoid automatic scientific notation from
# forcing it back to 3009
b_base_normalized = b_base / (10 ** exp_diff)

# puts "b: #{b}"
# puts "b (normalized): \n #{b_base_normalized}e+#{c_exp}"
# puts "d: \n #{d_base}e+#{c_exp}"

the_2e10000_number = d # (2¹⁰⁰⁰⁰, previously calculated while playing with big numbers)

protons = 1.57.to_big_f * (10.to_big_f ** 79)
proton_counting_safety_factor = the_2e10000_number / protons

puts "2e10000: \n #{the_2e10000_number}"
puts "Proton Counting Safety Factor: \n #{proton_counting_safety_factor}"