class_name Constraint

# ======================
# PARTICLE CONSTRAINT SYSTEM:
# ----------------------
# This class defines a connection between two particles.
# It maintains a fixed distance while supporting activation, selection, and breaking logic.
# ======================

# === PARTICLE REFERENCES ===
# Stores the two particles connected by this constraint.
var particle_1: Particle
var particle_2: Particle

# === CONSTRAINT LENGTH ===
# Defines the fixed distance between the two particles.
var length: float

# === STATE FLAGS ===
# Controls whether the constraint is active and whether it's visually selected.
var is_active: bool = true
var is_selected: bool = false

# ======================
# INITIALIZE CONSTRAINT
# ----------------------
# Sets up a constraint between two particles with a predefined length.
# ======================
func _init(p1: Particle, p2: Particle, length_: float) -> void:
    particle_1 = p1
    particle_2 = p2
    length = length_

# ======================
# UPDATE CONSTRAINT POSITION
# ----------------------
# Adjusts particle positions to maintain the fixed constraint length.
# ======================
func update() -> void:
    if not is_active:
        return

    var difference: Vector2 = particle_1.position - particle_2.position
    var distance: float = difference.length()
    var difference_factor: float = (length - distance) / distance
    var offset: Vector2 = difference * difference_factor * 0.5

    # TODO: Add constraint threshold if offset exceeds treshold the constraint will break

    # Apply position adjustments to maintain structural integrity
    particle_1.position += offset
    particle_2.position -= offset

# ======================
# DRAW CONSTRAINT VISUALLY
# ----------------------
# Renders a line representing the constraint between particles.
# Adjusts color based on selection status.
# ======================
func draw(canvas: Node2D, width: float) -> void:
    if not is_active:
        return

    var color: Color = Color.DARK_RED if is_selected else Color.ANTIQUE_WHITE
    canvas.draw_line(particle_1.position, particle_2.position, color, width, true)

# ======================
# BREAK CONSTRAINT
# ----------------------
# Deactivates the constraint, allowing connected particles to move freely.
# ======================
func break_constrained() -> void:
    is_active = false

# ======================
# TOGGLE SELECTION STATE
# ----------------------
# Marks the constraint as selected or deselected.
# ======================
func set_is_selected(value: bool) -> void:
    is_selected = value
