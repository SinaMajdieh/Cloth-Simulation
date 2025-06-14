class_name Cloth
extends Node2D

# ======================
# CLOTH SIMULATION SYSTEM:
# ----------------------
# This class simulates a flexible cloth structure using particles and constraints.
# It applies physics-based interactions such as elasticity, drag, and forces.
# ======================

# === PHYSICS PARAMETERS ===
# Defines external forces, damping effects, and cloth elasticity.
@export var force: Vector2 = Vector2(0.0, 50.0)  # Gravity-like force
@export var drag: float = 0.01  # Resistance factor to prevent excessive movement
@export var elasticity: float = 10.0  # Stiffness of the cloth constraints

# === CLOTH COMPONENTS ===
# Stores particles (cloth points) and constraints (connections between points).
var points: Array[Particle] = []
var constraints: Array[Constraint] = []

# === CLOTH STRUCTURE CONFIGURATION ===
# Defines cloth dimensions, spacing, starting position, and rendering style.
@export_category("Cloth Values")
@export var cloth_width: float  # Number of horizontal points
@export var cloth_height: float  # Number of vertical points
@export var cloth_spacing: float  # Distance between points
@export var cloth_start_position: Vector2  # Initial cloth placement
@export var pin_intervals: int = 2
@export var fill_cloth: bool = false  # Determines whether the cloth is drawn as solid or wireframe

# ======================
# INITIALIZE CLOTH STRUCTURE
# ----------------------
# Generates particles in a grid layout and links them with constraints.
# Pins alternating top-row particles to stabilize the cloth.
# ======================
func init(width: float, height: float, spacing: float, start_position: Vector2) -> void:
    for y: int in height+1:
        for x: int in width+1:
            var point: Particle = Particle.new(start_position + Vector2(x, y) * spacing)

            # Connect to left neighbor if available
            if x != 0:
                var left_point: Particle = points[points.size() - 1]
                var constraint: Constraint = Constraint.new(point, left_point, spacing)
                left_point.add_constraint(constraint, 0)
                point.add_constraint(constraint, 0)
                constraints.append(constraint)

            # Connect to upper neighbor if available
            if y != 0:
                var up_point: Particle = points[x + (y-1) * (width + 1)]
                var constraint: Constraint = Constraint.new(point, up_point, spacing)
                up_point.add_constraint(constraint, 1)
                point.add_constraint(constraint, 1)
                constraints.append(constraint)

            # Pin alternating top-row particles for stability
            if y == 0 and x % pin_intervals == 0:
                point.pin()

            # Store particle in the array
            points.append(point)

# ======================
# INITIALIZE CLOTH ON LOAD
# ----------------------
# Creates the cloth structure when the node is ready.
# ======================
func _ready() -> void:
    init(cloth_width, cloth_height, cloth_spacing, cloth_start_position)

# ======================
# UPDATE CLOTH PHYSICS
# ----------------------
# Applies forces, drag, and elasticity to particles, then updates constraints.
# ======================
func _physics_process(delta: float) -> void:
    for point: Particle in points:
        point.update(delta, drag, force, elasticity, get_viewport_rect().size)
    for constraint: Constraint in constraints:
        constraint.update()
    queue_redraw()

# ======================
# RENDER CLOTH STRUCTURE
# ----------------------
# Draws constraints between particles for visualization.
# Supports solid fill or wireframe mode.
# ======================
func _draw() -> void:
    for constraint: Constraint in constraints:
        constraint.draw(self, cloth_spacing if fill_cloth else 1.0)
