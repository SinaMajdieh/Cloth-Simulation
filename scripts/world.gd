extends Node2D

# ======================
# PARTICLE SIMULATION SYSTEM:
# ----------------------
# This class simulates particles connected by constraints in a physics-driven environment.
# It applies forces, maintains positional constraints, and ensures boundary adherence.
# ======================

# === PARTICLE AND CONSTRAINT STORAGE ===
# Arrays storing particles and their connecting constraints.
var particles: Array[Particle] = []
var sticks: Array[Constraint] = []

# === FORCE CONFIGURATION ===
# Defines the constant force applied to all particles (e.g., gravity).
@export var force: Vector2 = Vector2(0.0, 50.0)

# ======================
# INITIALIZE PARTICLE SYSTEM
# ----------------------
# Creates particles, links them with constraints, and prepares the environment.
# ======================
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)

	# Instantiate particles
	var pA: Particle = Particle.new(Vector2(220, 20), 1)
	var pB: Particle = Particle.new(Vector2(280, 20), 1)
	var pC: Particle = Particle.new(Vector2(280, 60), 1)
	var pD: Particle = Particle.new(Vector2(220, 60), 1)

	particles.append_array([pA, pB, pC, pD])

	# Instantiate constraints between particles
	var stickAB: Constraint = Constraint.new(pA, pB, Particle.get_distance(pA, pB))
	var stickBC: Constraint = Constraint.new(pB, pC, Particle.get_distance(pB, pC))
	var stickCD: Constraint = Constraint.new(pC, pD, Particle.get_distance(pC, pD))
	var stickDA: Constraint = Constraint.new(pD, pA, Particle.get_distance(pD, pA))
	var stickAC: Constraint = Constraint.new(pA, pC, Particle.get_distance(pA, pC))
	var stickBD: Constraint = Constraint.new(pB, pD, Particle.get_distance(pB, pD))

	sticks.append_array([stickAB, stickBC, stickCD, stickDA, stickAC, stickBD])

# ======================
# PHYSICS UPDATE CYCLE
# ----------------------
# Calls the update function each frame to apply physics interactions.
# ======================
func _physics_process(delta: float) -> void:
	update(delta)

# ======================
# KEEP PARTICLES WITHIN VIEW BOUNDARIES
# ----------------------
# Ensures particles remain inside the viewport constraints.
# ======================
func keep_inside_view(particle: Particle) -> void:
	if particle.position.y >= get_viewport_rect().size.y:
		particle.position.y = get_viewport_rect().size.y
	elif particle.position.y < 0:
		particle.position.y = 0

	if particle.position.x >= get_viewport_rect().size.x:
		particle.position.x = get_viewport_rect().size.x  
	elif particle.position.x < 0:
		particle.position.x = 0

# ======================
# APPLY PHYSICS UPDATES
# ----------------------
# Executes force application and constraint enforcement for all particles.
# ======================
func update(delta: float) -> void:
	apply_force(delta)
	apply_constraints()

# ======================
# RENDER PARTICLES AND CONSTRAINTS
# ----------------------
# Draws particles as circles and constraints as lines for visualization.
# ======================
func _draw() -> void:
	for particle: Particle in particles:
		draw_circle(particle.position, 10.0, Color.ANTIQUE_WHITE, true, -1, true)

	for stick: Constraint in sticks:
		draw_line(stick.particle_1.position, stick.particle_2.position, Color.ANTIQUE_WHITE, 5, true)

# ======================
# APPLY FORCE TO PARTICLES
# ----------------------
# Calculates new positions based on external forces, previous motion, and constraints.
# ======================
func apply_force(delta: float) -> void:
	for particle: Particle in particles:
		var acceleration: Vector2 = force / particle.mass
		var previous_position: Vector2 = particle.position

		# Verlet integration for smooth motion updates
		particle.position = 2 * particle.position - particle.previous_position + acceleration * delta * delta
		particle.previous_position = previous_position 

		# Ensure particles stay within the viewport
		keep_inside_view(particle)

	# Request a redraw for updated visuals
	queue_redraw()

# ======================
# APPLY CONSTRAINTS TO PARTICLES
# ----------------------
# Enforces structural integrity by adjusting positions based on connected constraints.
# ======================
func apply_constraints() -> void:
	for stick: Constraint in sticks:
		var difference: Vector2 = Particle.get_difference(stick.particle_1, stick.particle_2)
		var difference_factor: float = (stick.length - difference.length()) / difference.length() * 0.5
		var offset: Vector2 = difference * difference_factor

		# Adjust positions to maintain constraints
		stick.particle_1.position += offset
		stick.particle_2.position -= offset
