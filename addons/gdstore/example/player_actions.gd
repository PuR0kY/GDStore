extends Node3D
class_name PlayerActions

static func hit(amount: int) -> Action:
	return Action.new("PLAYER_HIT", amount)

static func heal(amount: int) -> Action:
	return Action.new("PLAYER_HEAL", amount)
