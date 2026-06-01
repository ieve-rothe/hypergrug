# examples/session_tracker.cr
# Copyright (C) 2026 Cam Carroll
# Licensed under the AGPL-3.0. See LICENSE for details.

require "../src/hypergrug"

# ============================================================================
# USE CASE: Episodic Context Tracking for LLM Agents
# Instead of managing complex relational databases or appending massive text
# strings to a prompt window, we compress an entire multi-turn interaction
# history into a single, flat 10,000-bit session hypervector.
# ============================================================================

# 1. Initialize space at production scale (D = 10,000)
# At this dimensionality, quasi-orthogonality ensures independent concepts
# provide clean "acoustic insulation" for each other.
VECTOR_SIZE = 10_000
memory = Hypergrug::Memory.new

puts "=== Initializing Hyperdimensional Semantic Registry ==="

# Register structural structural roles (The Graph Schema)
role_subject   = memory.register("ROLE:SUBJECT", VECTOR_SIZE)
role_action    = memory.register("ROLE:ACTION", VECTOR_SIZE)
role_object    = memory.register("ROLE:OBJECT", VECTOR_SIZE)
role_timestamp = memory.register("ROLE:TIMESTAMP", VECTOR_SIZE)

# Register Entities and Concepts
entity_user    = memory.register("ENTITY:USER_CAM", VECTOR_SIZE)
act_cycling    = memory.register("ACT:CYCLING", VECTOR_SIZE)
obj_kona_rove  = memory.register("OBJ:KONA_ROVE_BIKE", VECTOR_SIZE)

act_learning   = memory.register("ACT:LEARNING", VECTOR_SIZE)
obj_danish     = memory.register("OBJ:DANISH_LANG", VECTOR_SIZE)

# Register Timeline Tokens (Temporal Anchors / "Temporal Yipyap")
turn_1         = memory.register("TIME:TURN_1", VECTOR_SIZE)
turn_2         = memory.register("TIME:TURN_2", VECTOR_SIZE)

puts "Registered structural metadata and entity tokens into Clean-Up Memory."
puts "------------------------------------------------------------------------"

# 2. Simulate Turn 1: "Cam is cycling on a Kona Rove bike."
puts "Processing Turn 1 State..."

# Bind attributes to structural roles to create atomic facts
fact_1_sub = role_subject * entity_user
fact_1_act = role_action * act_cycling
fact_1_obj = role_object * obj_kona_rove

# Bundle the atomic facts into a single structural turn frame
turn_1_frame = fact_1_sub + fact_1_act + fact_1_obj

# Bind the entire frame to the Turn 1 timeline token
episodic_record_1 = turn_1_frame * (role_timestamp * turn_1)


# 3. Simulate Turn 2: "Cam is learning the Danish language."
puts "Processing Turn 2 State..."

fact_2_sub = role_subject * entity_user
fact_2_act = role_action * act_learning
fact_2_obj = role_object * obj_danish

turn_2_frame = fact_2_sub + fact_2_act + fact_2_obj

# Bind this frame to the Turn 2 timeline token
episodic_record_2 = turn_2_frame * (role_timestamp * turn_2)


# 4. Create the Unified Session Vector (The Superposition Stack)
# We pack the entire chronological interaction history into one single vector.
# This represents the "Book" context cache before it hits the Squishifier.
session_history_vector = episodic_record_1 + episodic_record_2

puts "Compressed full multi-turn session graph into one 10,000-bit hypervector."
puts "------------------------------------------------------------------------"


# 5. Querying the Holographic State Without Text Parsing
# The LLM engine or state coordinator can now run associative lookups
# directly on the bit-array by distributing inverse keys.

puts "Executing Hyperdimensional Queries:\n"

# Query A: "What object was the user interacting with during Turn 2?"
# Mathematical projection: Session * Turn_2_Anchor * Object_Role
query_a = session_history_vector * (role_timestamp * turn_2) * role_object
match_a = memory.match(query_a)

if match_a
  puts "Query A Result (Object at Turn 2):"
  puts "  -> Snap Match: #{match_a[:name]}"
  puts "  -> Hamming Distance Noise: #{match_a[:distance]} bits flipped out of #{VECTOR_SIZE}"
else
  puts "Query A failed to resolve."
end

puts ""

# Query B: "What action was the user taking during Turn 1?"
# Mathematical projection: Session * Turn_1_Anchor * Action_Role
query_b = session_history_vector * (role_timestamp * turn_1) * role_action
match_b = memory.match(query_b)

if match_b
  puts "Query B Result (Action at Turn 1):"
  puts "  -> Snap Match: #{match_b[:name]}"
  puts "  -> Hamming Distance Noise: #{match_b[:distance]} bits flipped out of #{VECTOR_SIZE}"
else
  puts "Query B failed to resolve."
end

puts "------------------------------------------------------------------------"
puts "Execution complete. Notice that both distinct historical records were"
puts "extracted cleanly from the exact same combined bit vector space."