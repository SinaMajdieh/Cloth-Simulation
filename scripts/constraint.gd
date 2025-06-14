class_name Constraint

# ======================
# PARTICLE CONSTRAINT SYSTEM:
# ----------------------
# This class defines a connection between two particles.
# It maintains a fixed distance between them, ensuring structural integrity in simulations.
# ======================

# === PARTICLE REFERENCES ===
# Stores the two connected particles.
var particle_1: Particle
var particle_2: Particle

# === CONSTRAINT LENGTH ===
# Defines the fixed distance between the two particles.
var length: float

# ======================
# INITIALIZE CONSTRAINT
# ----------------------
# Establishes a constraint between two particles with a predefined length.
# ======================
func _init(p1: Particle, p2: Particle, length_: float) -> void:
    particle_1 = p1
    particle_2 = p2
    length = length_
