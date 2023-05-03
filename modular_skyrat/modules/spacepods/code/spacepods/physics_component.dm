/**atom
 * Physics Component
 *
 * This component will give whatever it is attached to 2D physics.
 */
/datum/component/physics
	/// A reference to our parent, in movable atom form.
	var/atom/movable/parent_atom
	/// Bounce factor, how much we bounce off walls
	var/bump_impulse = 0.6
	/// how much of our velocity to keep on collision
	var/bounce_factor = 0.2
	/// mostly there to slow you down when you drive (pilot?) down a 2x2 corridor
	var/lateral_bounce_factor = 0.95
	/// X-axis velocity of the atom (in tiles per second)
	var/velocity_x = 0
	/// Y-axis velocity of the atom (in tiles per second)
	var/velocity_y = 0
	/// X-axis tile offset (similar to pixel_x/y, but in tiles)
	var/offset_x = 0
	/// Y-axis tile offset (similar to pixel_x/y, but in tiles)
	var/offset_y = 0
	/// atom's angle in degrees (clockwise)
	var/angle = 0
	/// Angular velocity of the atom (in degrees per second)
	var/angular_velocity = 0
	/// Our icon direction number.
	var/icon_dir_num = 1
	/// Physics control vars
	var/desired_thrust_dir = 0
	/// Max forward thrust, in tiles per second
	var/forward_maxthrust = 6
	/// Max reverse thrust, in tiles per second
	var/backward_maxthrust = 3
	/// Max side thrust, in tiles per second
	var/side_maxthrust = 1
	/// Desired angle for the atom, set by pilot moving their mouse
	var/desired_angle = null
	/// Maximum angular acceleration of the atom (in degrees per second per second)
	var/max_angular_acceleration = 360
	/// Last forward thrust value for the atom
	var/last_thrust_forward = 0
	/// Last right thrust value for the atom
	var/last_thrust_right = 0
	/// Last rotation value for the atom
	var/last_rotate = 0
	/// Our maximum velocity_x in tiles per second
	var/max_velocity_x = DEFAULT_MAX_VELOCITY
	/// Our maximum velocity_y in tiles per second
<<<<<<< HEAD:modular_skyrat/modules/spacepods/code/spacepods/physics_component.dm
	var/max_velocity_y = INFINITY


=======
	var/max_velocity_y = DEFAULT_MAX_VELOCITY
	/// The maximum velocity the thrusters can push us to, this does not prevent the atom going faster through other means though.
	var/max_thrust_velocity = DEFAULT_MAX_THRUST_VELOCITY
	/// Do we require a thrust check?
	var/thrust_check_required = TRUE
	/// Do we require a stabilistaion check?
	var/stabilisation_check_required = TRUE
	/// Do we reset thrust dir each cycle?
	var/reset_thrust_dir = TRUE
	/// Do we skip angular momentum calculations and just set the angle?
	var/skip_angular_calculations = FALSE
	/// What directions did we fail to move in last cycle?
	var/last_failed_dirs = NONE
	/// Is the component currently sleeping, and not processing?
	var/sleeping = FALSE
	/// DO we take damage while in an atmosphere?
	var/takes_atmos_damage = TRUE


/datum/component/physics/Initialize(
	_forward_maxthrust,
	_backward_maxthrust,
	_side_maxthrust,
	_max_angular_acceleration,
	_max_velocity_x,
	_max_velocity_y,
	_thrust_check_required = TRUE,
	_stabilisation_check_required = TRUE,
	_reset_thrust_dir = TRUE,
	_skip_angular_calculations = FALSE,
	starting_angle,
	starting_velocity_x,
	starting_velocity_y,
	_takes_atmos_damage = TRUE,
	_max_thrust_velocity,
	)
>>>>>>> spaceballs:modular_skyrat/modules/spacepods/code/physics/physics_component.dm

/datum/component/physics/Initialize(_forward_maxthrust, _backward_maxthrust, _side_maxthrust, _max_angular_acceleration, _max_velocity_x, _max_velocity_y)
	// We can only control movable atoms.
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

	if(_forward_maxthrust)
		forward_maxthrust = _forward_maxthrust
	if(_backward_maxthrust)
		backward_maxthrust = _backward_maxthrust
	if(_side_maxthrust)
		side_maxthrust = _side_maxthrust
	if(_max_angular_acceleration)
		max_angular_acceleration = _max_angular_acceleration
	if(_max_velocity_x)
		max_velocity_x = max_velocity_x
	if(_max_velocity_y)
		max_velocity_y = _max_velocity_y
	if(_max_thrust_velocity)
		max_thrust_velocity = _max_thrust_velocity

	parent_atom = parent

	// We animate our own movement
	parent_atom.animate_movement = NO_STEPS

	START_PROCESSING(SSphysics, src)

/datum/component/physics/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_PHYSICS_SET_THRUST_DIR, PROC_REF(set_thrust_dir))
	RegisterSignal(parent, COMSIG_PHYSICS_SET_DESIRED_ANGLE, PROC_REF(set_desired_angle))
	RegisterSignal(parent, COMSIG_PHYSICS_SET_ANGLE, PROC_REF(set_angle))
	RegisterSignal(parent, COMSIG_PHYSICS_SET_VELOCITY, PROC_REF(set_velocity))
<<<<<<< HEAD:modular_skyrat/modules/spacepods/code/spacepods/physics_component.dm
=======
	RegisterSignal(parent, COMSIG_PHYSICS_SET_MAX_VELOCITY, PROC_REF(set_max_velocity))
	RegisterSignal(parent, COMSIG_PHYSICS_SET_MAX_THRUST, PROC_REF(set_max_thrust))
	RegisterSignal(parent, COMSIG_PHYSICS_SET_MAX_THRUST_VELOCITY, PROC_REF(set_max_thrust_velocity))
>>>>>>> spaceballs:modular_skyrat/modules/spacepods/code/physics/physics_component.dm
	RegisterSignal(parent, COMSIG_ATOM_BUMPED, PROC_REF(process_bumped))
	RegisterSignal(parent, COMSIG_MOVABLE_BUMP, PROC_REF(process_bump))

/datum/component/physics/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_PHYSICS_SET_THRUST_DIR,
		COMSIG_PHYSICS_SET_DESIRED_ANGLE,
		COMSIG_PHYSICS_SET_ANGLE,
		COMSIG_PHYSICS_SET_VELOCITY,
<<<<<<< HEAD:modular_skyrat/modules/spacepods/code/spacepods/physics_component.dm
=======
		COMSIG_PHYSICS_SET_MAX_VELOCITY,
		COMSIG_PHYSICS_SET_MAX_THRUST,
		COMSIG_PHYSICS_SET_MAX_THRUST_VELOCITY,
>>>>>>> spaceballs:modular_skyrat/modules/spacepods/code/physics/physics_component.dm
		COMSIG_ATOM_BUMPED,
		COMSIG_MOVABLE_BUMP,
		))

/datum/component/physics/Destroy(force, silent)
	parent_atom.animate_movement = initial(parent_atom.animate_movement)
	parent_atom = null
	return ..()

/datum/component/physics/process(delta_time)

<<<<<<< HEAD:modular_skyrat/modules/spacepods/code/spacepods/physics_component.dm
=======
/obj/effect/temp_visual/turf_visual
	icon = 'modular_skyrat/modules/spacepods/icons/objects.dmi'
	icon_state = "turf_test"
	duration = 0.5 SECONDS

/datum/component/physics/process(seconds_per_tick)
	if(QDELETED(parent_atom))
		STOP_PROCESSING(SSphysics, src)
		return
	if(sleeping)
		return
>>>>>>> spaceballs:modular_skyrat/modules/spacepods/code/physics/physics_component.dm
	// Initialization of variables for position and angle calculations
	var/last_offset_x = offset_x
	var/last_offset_y = offset_y

	var/last_angle = angular_calculations(delta_time)

	drag_calculations(delta_time)

	thrust_calculations(delta_time)

	// velocity limiters
	velocity_x = clamp(velocity_x, -max_velocity_x, max_velocity_x)
	velocity_y = clamp(velocity_y, -max_velocity_y, max_velocity_y)

	offset_x += velocity_x * delta_time
	offset_y += velocity_y * delta_time
	// alright so now we reconcile the offsets with the in-world position.
	while((offset_x > 0 && velocity_x > 0) || (offset_y > 0 && velocity_y > 0) || (offset_x < 0 && velocity_x < 0) || (offset_y < 0 && velocity_y < 0))
		var/failed_x = FALSE
		var/failed_y = FALSE
		if(offset_x > 0 && velocity_x > 0)
			parent_atom.dir = EAST
			if(!parent_atom.Move(get_step(parent_atom, EAST)))
				offset_x = 0
				failed_x = TRUE
				velocity_x *= -bounce_factor
				velocity_y *= lateral_bounce_factor
			else
				offset_x--
				last_offset_x--
		else if(offset_x < 0 && velocity_x < 0)
			parent_atom.dir = WEST
			if(!parent_atom.Move(get_step(parent_atom, WEST)))
				offset_x = 0
				failed_x = TRUE
				velocity_x *= -bounce_factor
				velocity_y *= lateral_bounce_factor
			else
				offset_x++
				last_offset_x++
		else
			failed_x = TRUE
		if(offset_y > 0 && velocity_y > 0)
			parent_atom.dir = NORTH
			if(!parent_atom.Move(get_step(parent_atom, NORTH)))
				offset_y = 0
				failed_y = TRUE
				velocity_y *= -bounce_factor
				velocity_x *= lateral_bounce_factor
			else
				offset_y--
				last_offset_y--
		else if(offset_y < 0 && velocity_y < 0)
			parent_atom.dir = SOUTH
			if(!parent_atom.Move(get_step(parent_atom, SOUTH)))
				offset_y = 0
				failed_y = TRUE
				velocity_y *= -bounce_factor
				velocity_x *= lateral_bounce_factor
			else
				offset_y++
				last_offset_y++
		else
			failed_y = TRUE
		if(failed_x && failed_y)
			break
	// prevents situations where you go "wtf I'm clearly right next to it" as you enter a stationary atom
	if(velocity_x == 0)
		if(offset_x > 0.5)
			if(parent_atom.Move(get_step(parent_atom, EAST)))
				offset_x--
				last_offset_x--
			else
				offset_x = 0
		if(offset_x < -0.5)
			if(parent_atom.Move(get_step(parent_atom, WEST)))
				offset_x++
				last_offset_x++
			else
				offset_x = 0
	if(velocity_y == 0)
		if(offset_y > 0.5)
			if(parent_atom.Move(get_step(parent_atom, NORTH)))
				offset_y--
				last_offset_y--
			else
				offset_y = 0
		if(offset_y < -0.5)
			if(parent_atom.Move(get_step(parent_atom, SOUTH)))
				offset_y++
				last_offset_y++
			else
				offset_y = 0
	parent_atom.dir = NORTH

<<<<<<< HEAD:modular_skyrat/modules/spacepods/code/spacepods/physics_component.dm
=======
	update_sprite(seconds_per_tick, last_angle, last_offset_x, last_offset_y)

	if(reset_thrust_dir)
		desired_thrust_dir = 0

	if(!velocity_x && !velocity_y && !angular_velocity)
		last_thrust_forward = 0
		last_thrust_right = 0
		pause()

	SEND_SIGNAL(src, COMSIG_PHYSICS_UPDATE_MOVEMENT, angle, velocity_x, velocity_y, offset_x, offset_y, last_rotate, last_thrust_forward, last_thrust_right)


/**
 * update_sprite
 *
 * Updates the controlled atoms sprite according to specification of the current physics cycle.
 */
/datum/component/physics/proc/update_sprite(seconds_per_tick, last_angle, last_offset_x, last_offset_y)
>>>>>>> spaceballs:modular_skyrat/modules/spacepods/code/physics/physics_component.dm
	var/matrix/mat_from = new()
	var/matrix/mat_to = new()
	if(icon_dir_num == 1)
		mat_from.Turn(last_angle)
		mat_to.Turn(angle)
	else
		parent_atom.dir = angle2dir(angle)

	SEND_SIGNAL(src, COMSIG_PHYSICS_UPDATE_MOVEMENT, angle, velocity_x, velocity_y, offset_x, offset_y, last_rotate, last_thrust_forward, last_thrust_right)

	parent_atom.transform = mat_from
	parent_atom.pixel_x = parent_atom.base_pixel_x + last_offset_x * 32
	parent_atom.pixel_y = parent_atom.base_pixel_y + last_offset_y * 32
	animate(parent_atom, transform = mat_to, pixel_x = parent_atom.base_pixel_x + offset_x * 32, pixel_y = parent_atom.base_pixel_y + offset_y * 32, time = delta_time * 10, flags = ANIMATION_END_NOW)
	var/list/possible_smooth_viewers = parent_atom.contents | parent_atom | parent_atom.get_all_orbiters()
	for(var/mob/iterating_mob in possible_smooth_viewers)
		var/client/mob_client = iterating_mob.client
		if(!mob_client)
			continue
		mob_client.pixel_x = last_offset_x * 32
		mob_client.pixel_y = last_offset_y * 32
		animate(mob_client, pixel_x = offset_x * 32, pixel_y = offset_y * 32, time = delta_time * 10, flags = ANIMATION_END_NOW)

	desired_thrust_dir = 0

// PHYSICS CALCULATION PROCS

/datum/component/physics/proc/angular_calculations(delta_time)
	var/last_angle = angle
	var/desired_angular_velocity = 0
	// Calculate desired angular velocity based on desired angle
	if(isnum(desired_angle))
		// Ensure angles rotate the short way
		while(angle > desired_angle + 180)
			angle -= 360
			last_angle -= 360
		while(angle < desired_angle - 180)
			angle += 360
			last_angle += 360

		// Calculate desired angular velocity based on the desired angle and delta_time
		if(abs(desired_angle - angle) < (max_angular_acceleration * delta_time))
			desired_angular_velocity = (desired_angle - angle) / delta_time
		else if(desired_angle > angle)
			desired_angular_velocity = 2 * sqrt((desired_angle - angle) * max_angular_acceleration * 0.25)
		else
			desired_angular_velocity = -2 * sqrt((angle - desired_angle) * max_angular_acceleration * 0.25)

	// Adjust angular velocity
	var/angular_velocity_adjustment = clamp(desired_angular_velocity - angular_velocity, -max_angular_acceleration * delta_time, max_angular_acceleration * delta_time)
	if(angular_velocity_adjustment)
		last_rotate = angular_velocity_adjustment / delta_time
		angular_velocity += angular_velocity_adjustment
	else
		last_rotate = 0
	angle += angular_velocity * delta_time

	return last_angle

/datum/component/physics/proc/drag_calculations(delta_time)
	// Calculate the magnitude of the atom's velocity
	var/velocity_mag = sqrt(velocity_x * velocity_x + velocity_y * velocity_y)

	if(velocity_mag || angular_velocity)
		var/drag = 0
		var/floating = FALSE

		// Iterate through the turfs the atom is currently in
		for(var/turf/iterating_turf in parent_atom.locs)
			// Ignore space turfs (no drag in space)
			if(isspaceturf(iterating_turf))
				continue

			// Add a small amount of drag for each turf
			drag += 0.001

			// Check if the atom is floating (not auto-stabilized) and has a significant velocity
			if(!floating && iterating_turf.has_gravity() && !auto_stabalisation && velocity_mag > 0.1)
				floating = TRUE // Flying on the station drains the battery

			// Apply drag based on gravity and auto-stabilization
			if((!floating && iterating_turf.has_gravity()) || auto_stabalisation)
				// Adjust drag based on the mining level (less gravity on lavaland)
				drag += is_mining_level(parent_atom.z) ? 0.1 : 0.5

				// If atom is going too fast, make it lose floor tiles and take damage
				if(velocity_mag > 5 && prob(velocity_mag * 4) && isfloorturf(iterating_turf))
					var/turf/open/floor/floor = iterating_turf
					floor.make_plating()
					parent_atom.take_damage(3, BRUTE, "melee", FALSE)

			// Calculate the drag based on the pressure in the environment
			var/datum/gas_mixture/env = iterating_turf.return_air()
			if(env)
				var/pressure = env.return_pressure()
				drag += velocity_mag * pressure * 0.0001 // 1 atmosphere should shave off 1% of velocity per tile

		// Limit the drag at high velocities
		if(velocity_mag > 20)
			drag = max(drag, (velocity_mag - 20) / delta_time)

		// Apply the calculated drag to the atom's velocity and angular velocity
		if(drag)
			if(velocity_mag)
				var/drag_factor = 1 - clamp(drag * delta_time / velocity_mag, 0, 1)
				velocity_x *= drag_factor
				velocity_y *= drag_factor
			if(angular_velocity != 0)
				var/drag_factor_spin = 1 - clamp(drag * 30 * delta_time / abs(angular_velocity), 0, 1)
				angular_velocity *= drag_factor_spin

/datum/component/physics/proc/thrust_calculations(delta_time)
	// Calculate thrust components based on angle
	var/total_thrust_x
	var/total_thrust_y
	var/forward_x = cos(90 - angle)
	var/forward_y = sin(90 - angle)
	var/side_x = forward_y
	var/side_y = -forward_x
	last_thrust_forward = 0
	last_thrust_right = 0


	// Automatic stabilization of the atom
if(SEND_SIGNAL(src, COMSIG_PHYSICS_AUTOSTABALISE_CHECK) & COMPONENT_PHYSICS_AUTO_STABALISATION)
	// Calculate braking thrust based on current velocity and delta_time
	var/braking_thrust_forward = -((forward_x * velocity_x) + (forward_y * velocity_y)) / delta_time
	var/braking_thrust_right = -((side_x * velocity_x) + (side_y * velocity_y)) / delta_time

	// Clamp braking thrust within acceptable limits
	braking_thrust_forward = clamp(braking_thrust_forward, -backward_maxthrust, forward_maxthrust)
	braking_thrust_right = clamp(braking_thrust_right, -side_maxthrust, side_maxthrust)

	// Calculate total thrust by adding braking thrust to current thrust
	total_thrust_x += braking_thrust_forward * forward_x + braking_thrust_right * side_x
	total_thrust_y += braking_thrust_forward * forward_y + braking_thrust_right * side_y

	// Store the last braking thrust values
	last_thrust_forward = braking_thrust_forward
	last_thrust_right = braking_thrust_right

	// Apply thrust based on the desired thrust direction
	if(desired_thrust_dir & NORTH)
		total_thrust_x += forward_x * forward_maxthrust
		total_thrust_y += forward_y * forward_maxthrust
		last_thrust_forward = forward_maxthrust
	if(desired_thrust_dir & SOUTH)
		total_thrust_x -= forward_x * backward_maxthrust
		total_thrust_y -= forward_y * backward_maxthrust
		last_thrust_forward = -backward_maxthrust
	if(desired_thrust_dir & EAST)
		total_thrust_x += side_x * side_maxthrust
		total_thrust_y += side_y * side_maxthrust
		last_thrust_right = side_maxthrust
	if(desired_thrust_dir & WEST)
		total_thrust_x -= side_x * side_maxthrust
		total_thrust_y -= side_y * side_maxthrust
		last_thrust_right = -side_maxthrust

<<<<<<< HEAD:modular_skyrat/modules/spacepods/code/spacepods/physics_component.dm
	if(!(SEND_SIGNAL(src, COMSIG_PHYSICS_THRUST_CHECK, total_thrust_x, total_thrust_y, desired_thrust_dir, delta_time) & COMPONENT_PHYSICS_THRUST))
		return
=======
	if(thrust_check_required && !(SEND_SIGNAL(src, COMSIG_PHYSICS_THRUST_CHECK, total_thrust_x, total_thrust_y, desired_thrust_dir, seconds_per_tick) & COMPONENT_PHYSICS_THRUST))
		last_thrust_right = 0
		last_thrust_forward = 0
	else
		// Calculate the adjusted thrust for both X and Y axes and clamp it within the maximum and minimum allowed limits
		velocity_x = min(max(velocity_x + (total_thrust_x * seconds_per_tick), -max_thrust_velocity), max_thrust_velocity)
		velocity_y = min(max(velocity_y + (total_thrust_y * seconds_per_tick), -max_thrust_velocity), max_thrust_velocity)
>>>>>>> spaceballs:modular_skyrat/modules/spacepods/code/physics/physics_component.dm

	// Update velocity based on the calculated thrust and delta_time
	velocity_x += total_thrust_x * delta_time
	velocity_y += total_thrust_y * delta_time


// SET PROCS

/datum/component/physics/proc/set_desired_angle(datum/source, new_angle)
	SIGNAL_HANDLER
	desired_angle = new_angle

/datum/component/physics/proc/set_angle(datum/source, new_angle)
	SIGNAL_HANDLER
	angle = new_angle

/datum/component/physics/proc/set_thrust_dir(datum/source, new_thrust_dir)
	SIGNAL_HANDLER
	desired_thrust_dir = new_thrust_dir

/datum/component/physics/proc/set_velocity(datum/source, new_velocity_x, new_velocity_y)
	SIGNAL_HANDLER
	velocity_x = new_velocity_x
	velocity_y = new_velocity_y

<<<<<<< HEAD:modular_skyrat/modules/spacepods/code/spacepods/physics_component.dm
=======
/datum/component/physics/proc/set_max_velocity(datum/source, new_max_velocity_x, new_max_velocity_y)
	SIGNAL_HANDLER
	wake_up()
	max_velocity_x = new_max_velocity_x
	max_velocity_y = new_max_velocity_y

/datum/component/physics/proc/set_max_thrust(datum/source, new_forward_maxthrust, new_backward_maxthrust, new_side_maxthrust)
	SIGNAL_HANDLER
	wake_up()
	forward_maxthrust = new_forward_maxthrust
	backward_maxthrust = new_backward_maxthrust
	side_maxthrust = new_side_maxthrust

/datum/component/physics/proc/set_max_thrust_velocity(datum/source, new_max_thrust_velocity)
	SIGNAL_HANDLER
	wake_up()
	max_thrust_velocity = new_max_thrust_velocity

>>>>>>> spaceballs:modular_skyrat/modules/spacepods/code/physics/physics_component.dm
/datum/component/physics/proc/process_bumped(datum/source, atom/movable/hit_object)
	SIGNAL_HANDLER
	if(hit_object.dir & NORTH)
		velocity_y += bump_impulse
	if(hit_object.dir & SOUTH)
		velocity_y -= bump_impulse
	if(hit_object.dir & EAST)
		velocity_x += bump_impulse
	if(hit_object.dir & WEST)
		velocity_x -= bump_impulse

/datum/component/physics/proc/process_bump(datum/source, atom/bumped_atom)
	SIGNAL_HANDLER
	var/bump_velocity = 0
	if(parent_atom.dir & (NORTH|SOUTH))
		bump_velocity = abs(velocity_y) + (abs(velocity_x) / 15)
	else
		bump_velocity = abs(velocity_x) + (abs(velocity_y) / 15)

	var/atom/movable/bumped_movable_atom = bumped_atom

	if(istype(bumped_movable_atom) && !bumped_movable_atom.anchored && bump_velocity > 1)
		step(bumped_movable_atom, parent_atom.dir)

	SEND_SIGNAL(src, COMSIG_PHYSICS_PROCESSED_BUMP, bump_velocity, bumped_atom)
