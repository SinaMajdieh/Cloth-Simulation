class_name Particle

# ======================
# PARTICLE SIMULATION CLASS:
# ----------------------
# This class represents a particle in a simulation.
# It tracks position, previous movement, and mass while providing utility functions.
# ======================

# === PARTICLE STATE VARIABLES ===
# Stores position and previous position for movement tracking.
var position: Vector2 = Vector2.ZERO
var previous_position: Vector2 = Vector2.ZERO

# === MASS CONFIGURATION ===
# Defines the mass of the particle, affecting simulation calculations.
var mass: float = 1.0

# ======================
# INITIALIZE PARTICLE
# ----------------------
# Sets the initial position and mass, preserving previous state.
# ======================
func _init(init_position: Vector2, init_mass: float) -> void:
    self.position = init_position
    self.previous_position = init_position
    self.mass = init_mass

# ======================
# GET DISTANCE BETWEEN PARTICLES
# ----------------------
# Calculates the Euclidean distance between two particles.
# ======================
static func get_distance(from: Particle, to: Particle) -> float:
    return from.position.distance_to(to.position)

# ======================
# GET DIFFERENCE VECTOR
# ----------------------
# Computes the displacement vector between two particles.
# ======================
static func get_difference(from: Particle, to: Particle) -> Vector2:
    return from.position - to.position

# ======================
# GET PARTICLE VECTOR LENGTH
# ----------------------
# Returns the length of the particle's position vector.
# Useful for magnitude calculations.
# ======================
static func get_length(particle: Particle) -> float:
    return particle.position.length()
