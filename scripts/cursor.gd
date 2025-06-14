extends Node2D

# ======================
# INTERACTIVE NODE CONTROL:
# ----------------------
# This class manages the position and size of an interactive node.
# It responds to mouse movement and scroll wheel input.
# ======================

# === SIZE CONFIGURATION ===
# Defines the minimum, maximum, and current size values.
var size: float = 20.0
var max_size: float = 100.0
var min_size: float = 20.0

# === POSITION TRACKING ===
# Stores the current and previous position of the node.
var previous_position: Vector2

# ======================
# INITIALIZE NODE POSITION
# ----------------------
# Sets the initial node position based on the mouse location.
# ======================
func _ready() -> void:
    position = get_global_mouse_position()
    previous_position = position

# ======================
# ADJUST NODE SIZE
# ----------------------
# Increases or decreases node size while clamping within valid bounds.
# ======================
func increment_size(increment: float) -> void:
    size = clamp(size + increment, min_size, max_size)

# ======================
# HANDLE USER INPUT
# ----------------------
# Detects mouse interactions and adjusts size or position accordingly.
# ======================
func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        # Increase or decrease size based on scroll wheel input
        if event.button_index == MOUSE_BUTTON_WHEEL_UP:
            increment_size(10)
        elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            increment_size(-10)
    elif event is InputEventMouseMotion:
        # Update position tracking on mouse movement
        previous_position = position
        position = get_global_mouse_position()
