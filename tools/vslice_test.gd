## Phase C vertical-slice test (runs in normal main loop so autoloads exist).
## Verifies: language execution, script-driven robot control, graceful errors.
extends Node

func _ready() -> void:
	var fails: int = 0

	# --- T1: language features (print, arithmetic, variables, if, while) ---
	var src1: String = "x = 5\ny = 3\nprint(x + y)\nif x > y:\n    print(\"x bigger\")\ni = 0\nwhile i < 3:\n    print(i)\n    i = i + 1\n"
	var r1: Dictionary = AstroScript.new().execute(src1)
	var out1: Array = r1.get("output", [])
	var joined: String = str(out1)
	print("T1 output=%s errors=%s" % [out1, r1.get("errors", [])])
	if not r1.get("errors", []).is_empty():
		print("  FAIL T1: unexpected errors"); fails += 1
	if not (joined.contains("8") and joined.contains("x bigger") \
			and joined.contains("0") and joined.contains("1") and joined.contains("2")):
		print("  FAIL T1: expected 8 / 'x bigger' / 0 1 2 in output"); fails += 1
	else:
		print("  ok T1: language features execute")

	# --- T2: script-driven robot control ---
	var robot: Node2D = load("res://scenes/robots/robot_base.tscn").instantiate() as Node2D
	add_child(robot)
	await get_tree().process_frame
	if robot.status == "shutdown" and robot.has_method("boot_up"):
		robot.boot_up()
	robot.global_position = Vector2.ZERO
	var r2: Dictionary = AstroScript.new().execute("robot.move(\"right\")", {"robot": robot})
	print("T2 errors=%s status=%s target=%s" % [r2.get("errors", []), robot.status, robot._move_target])
	if not r2.get("errors", []).is_empty():
		print("  FAIL T2: robot.move produced errors"); fails += 1
	elif robot.status != "moving":
		print("  FAIL T2: robot status should be 'moving', got '%s'" % robot.status); fails += 1
	elif robot._move_target.x <= 0.0:
		print("  FAIL T2: move('right') should target +x, got %s" % robot._move_target); fails += 1
	else:
		print("  ok T2: script moved robot right (status=moving, +x target)")

	# --- T3: graceful error handling (undefined function should not crash) ---
	var r3: Dictionary = AstroScript.new().execute("frobnicate(42)")
	print("T3 errors=%s" % [r3.get("errors", [])])
	if r3.get("errors", []).is_empty():
		print("  FAIL T3: expected an error for undefined call, got none"); fails += 1
	else:
		print("  ok T3: undefined call reported as error, no crash")

	print("VSLICE RESULT %d/3 passed" % (3 - fails))
	get_tree().quit(1 if fails > 0 else 0)
