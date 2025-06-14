class_name Particle

# ======================
# PARTICLE SIMULATION SYSTEM:
# ----------------------
# This class represents a physics-driven particle.
# It handles movement, constraints, selection, and boundary enforcement.
# ======================

# === PARTICLE STATE VARIABLES ===
# Stores references to constraints and position data.
var constraints: Array[Constraint] = [null, null]  # Holds two constraint references
var position: Vector2  # Current position of the particle
var previous_position: Vector2  # Tracks the previous position for smooth movement
var initial_position: Vector2  # Stores the original position (used for pinning)

# === STATE FLAGS ===
# Determines whether the particle is pinned or selected.
var is_pinned: bool = false
var is_selected: bool = false

# ======================
# KEEP PARTICLE WITHIN VIEW BOUNDARIES
# ----------------------
# Ensures particles remain inside the viewport constraints.
# ======================
func keep_inside_view(view_size: Vector2) -> void:
    if position.y >= view_size.y:
        position.y = view_size.y
    elif position.y < 0:
        position.y = 0

    if position.x >= view_size.x:
        position.x = view_size.x  
    elif position.x < 0:
        position.x = 0

# ======================
# INITIALIZE PARTICLE
# ----------------------
# Sets the particle's initial position, preserving previous state.
# ======================
func _init(init_pos: Vector2) -> void:
    position = init_pos
    previous_position = init_pos
    initial_position = init_pos

# ======================
# ADD CONSTRAINT TO PARTICLE
# ----------------------
# Links a constraint to the particle, ensuring valid index selection.
# ======================
func add_constraint(constraint: Constraint, index: int) -> void:
    if index >= constraints.size() or index < 0:
        return
    constraints[index] = constraint

# ======================
# PIN PARTICLE TO FIXED POSITION
# ----------------------
# Prevents movement by locking the particle at its initial position.
# ======================
func pin() -> void:
    is_pinned = true

# ======================
# UPDATE PARTICLE POSITION
# ----------------------
# Applies physics updates, user interactions, and viewport constraints.
# ======================
func update(delta: float, drag: float, acceleration: Vector2, elasticity: float, view_size: Vector2) -> void:
    # Check cursor proximity to determine selection state
    var cursor_to_position: Vector2 = position - Cursor.position
    var cursor_to_position_distance: float = cursor_to_position.length()
    is_selected = cursor_to_position_distance < Cursor.size 

    # Update constraint selection state
    for constraint: Constraint in constraints:
        if constraint:
            constraint.set_is_selected(is_selected)

    # Handle left-click dragging interaction
    if Input.is_action_pressed("left_click") and is_selected:
        var difference: Vector2 = Cursor.position - Cursor.previous_position

        # Apply elasticity limits to movement
        difference.x = clamp(difference.x, -elasticity, elasticity)
        difference.y = clamp(difference.y, -elasticity, elasticity)

        previous_position = position - difference

    # Handle right-click interaction to break constraints
    if Input.is_action_pressed("right_click") and is_selected:
        for constraint: Constraint in constraints:
            if constraint:
                constraint.break_constrained()

    # Maintain pinned particles at their initial position
    if is_pinned:
        position = initial_position
        return

    # Apply physics updates using Verlet integration
    var new_position: Vector2 = position + (position - previous_position) * (1.0 - drag) + acceleration * (1.0 - drag) * delta * delta

    previous_position = position
    position = new_position

    # Ensure the particle remains within viewport constraints
    keep_inside_view(view_size)
