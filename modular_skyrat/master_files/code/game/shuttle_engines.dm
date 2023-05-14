#define ENGINE_UNWRENCHED 0
#define ENGINE_WRENCHED 1
#define ENGINE_WELDED 2
#define ENGINE_WELDTIME (60 SECONDS)

/obj/structure/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	smoothing_groups = list(SMOOTH_GROUP_SHUTTLE_PARTS)
	max_integrity = 500
	armor_type = list(MELEE = 100, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 70) //default + ignores melee
	can_atmos_pass = ATMOS_PASS_DENSITY

/obj/machinery/power/shuttle_engine
	name = "engine"
	desc = "A bluespace engine used to make shuttles move."
	density = TRUE
	anchored = TRUE
	var/engine_power = 1
	var/engine_state = ENGINE_WELDED //welding shmelding
	var/extension_type = /datum/shuttle_extension/engine/burst
	var/datum/shuttle_extension/engine/extension
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/machine/engine

	///The mobile ship we are connected to.
	var/datum/weakref/connected_ship_ref

/obj/machinery/power/shuttle_engine/Initialize()
	. = ..()
	if(extension_type)
		AddComponent(/datum/component/engine_effect)
		extension = new extension_type(src)
		ApplyExtension()

/obj/machinery/power/shuttle_engine/examine(mob/user)
	. = ..()
	. += span_notice("The engine [(engine_state >= ENGINE_WRENCHED) ? "is <b>fastened</b> to the floor" : "could be <b>fastened</b> to the floor"].")
	. += span_notice("The engine [(engine_state >= ENGINE_WELDED) ? "is <b>welded</b> to the floor" : "could be <b>welded</b> to the floor"].")

/obj/machinery/power/shuttle_engine/proc/DrawThrust()
	SEND_SIGNAL(src, COMSIG_ENGINE_DRAWN_POWER)

/obj/machinery/power/shuttle_engine/connect_to_shuttle(mapload, obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	. = ..()
	if(!port)
		return FALSE
	connected_ship_ref = WEAKREF(port)
	port.engine_list += src
	port.current_engine_power += engine_power
	if(mapload)
		port.initial_engine_power += engine_power
	if(engine_state == ENGINE_WELDED)
		ApplyExtension()

/**
 * Called on destroy and when we need to unsync an engine from their ship.
 */
/obj/machinery/power/shuttle_engine/proc/unsync_ship()
	var/obj/docking_port/mobile/port = connected_ship_ref?.resolve()
	if(port)
		port.engine_list -= src
		port.current_engine_power -= initial(engine_power)
	connected_ship_ref = null

/obj/machinery/power/shuttle_engine/proc/ApplyExtension()
	if(!extension)
		return
	extension.ApplyToPosition(get_turf(src))

/obj/machinery/power/shuttle_engine/proc/RemoveExtension()
	if(!extension)
		return
	extension.RemoveExtension()

//Ugh this is a lot of copypasta from emitters, welding need some boilerplate reduction
/obj/machinery/power/shuttle_engine/can_be_unfasten_wrench(mob/user, silent)
	if(engine_state == ENGINE_WELDED)
		if(!silent)
			to_chat(user, span_warning("[src] is welded to the floor!"))
		return FAILED_UNFASTEN
	return ..()

/obj/machinery/power/shuttle_engine/default_unfasten_wrench(mob/user, obj/item/I, time = 20)
	. = ..()
	if(. == SUCCESSFUL_UNFASTEN)
		if(anchored)
			connect_to_shuttle(port = SSshuttle.get_containing_shuttle(src)) //connect to a new ship, if needed
			engine_state = ENGINE_WRENCHED
		else
			unsync_ship() //not part of the ship anymore
			engine_state = ENGINE_UNWRENCHED

/obj/machinery/power/shuttle_engine/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/power/shuttle_engine/welder_act(mob/living/user, obj/item/I)
	. = ..()
	switch(engine_state)
		if(ENGINE_UNWRENCHED)
			to_chat(user, span_warning("The [src.name] needs to be wrenched to the floor!"))
		if(ENGINE_WRENCHED)
			if(!I.tool_start_check(user, amount=0))
				return TRUE

			user.visible_message(span_notice("[user.name] starts to weld the [name] to the floor."), \
				span_notice("You start to weld \the [src] to the floor..."), \
				span_hear("You hear welding."))

			if(I.use_tool(src, user, ENGINE_WELDTIME, volume=50))
				engine_state = ENGINE_WELDED
				to_chat(user, span_notice("You weld \the [src] to the floor."))
				alter_engine_power(engine_power)
				ApplyExtension()

		if(ENGINE_WELDED)
			if(!I.tool_start_check(user, amount=0))
				return TRUE

			user.visible_message(span_notice("[user.name] starts to cut the [name] free from the floor."), \
				span_notice("You start to cut \the [src] free from the floor..."), \
				span_hear("You hear welding."))

			if(I.use_tool(src, user, ENGINE_WELDTIME, volume=50))
				engine_state = ENGINE_WRENCHED
				to_chat(user, span_notice("You cut \the [src] free from the floor."))
				alter_engine_power(-engine_power)
				RemoveExtension()
	return TRUE

/obj/machinery/power/shuttle_engine/Destroy()
	if(engine_state == ENGINE_WELDED)
		alter_engine_power(-engine_power)
		RemoveExtension()
	unsync_ship()
	QDEL_NULL(extension)
	return ..()

/obj/machinery/power/shuttle_engine/atom_destruction(damage_flag)
	explosion(src, devastation_range = -1, light_impact_range = 2, flame_range = 3, flash_range = 4)
	return ..()


//Propagates the change to the shuttle.
/obj/machinery/power/shuttle_engine/proc/alter_engine_power(mod)
	if(!mod)
		return
	// if(SSshuttle.is_in_shuttle_bounds(src))
	var/obj/docking_port/mobile/port = connected_ship_ref?.resolve()
	if(port)
		port.alter_engines(mod)

/obj/machinery/power/shuttle_engine/heater
	name = "engine heater"
	icon_state = "heater"
	desc = "Directs energy into compressed particles in order to power engines."
	circuit = /obj/item/circuitboard/machine/engine/heater
	engine_power = 0 // todo make these into 2x1 parts
	extension_type = null

/obj/machinery/power/shuttle_engine/platform
	name = "engine platform"
	icon_state = "platform"
	desc = "A platform for engine components."
	engine_power = 0
	extension_type = null

/obj/machinery/power/shuttle_engine/propulsion
	name = "propulsion engine"
	icon_state = "propulsion"
	desc = "A standard reliable bluespace engine used by many forms of shuttles."
	circuit = /obj/item/circuitboard/machine/engine/propulsion
	opacity = TRUE

/obj/machinery/power/shuttle_engine/propulsion/in_wall
	name = "in-wall propulsion engine"
	icon_state = "propulsion_w"
	density = FALSE
	smoothing_groups = list()

/obj/machinery/power/shuttle_engine/propulsion/left
	name = "left propulsion engine"
	icon_state = "propulsion_l"

/obj/machinery/power/shuttle_engine/propulsion/right
	name = "right propulsion engine"
	icon_state = "propulsion_r"

/obj/machinery/power/shuttle_engine/propulsion/burst
	name = "burst engine"
	desc = "An engine that releases a large bluespace burst to propel it."

/obj/machinery/power/shuttle_engine/propulsion/burst/cargo
	engine_state = ENGINE_UNWRENCHED
	anchored = FALSE

/obj/machinery/power/shuttle_engine/propulsion/burst/left
	name = "left burst engine"
	icon_state = "burst_l"

/obj/machinery/power/shuttle_engine/propulsion/burst/right
	name = "right burst engine"
	icon_state = "burst_r"

/obj/machinery/power/shuttle_engine/router
	name = "engine router"
	icon_state = "router"
	desc = "Redirects around energized particles in engine structures."
	extension_type = null

/obj/machinery/power/shuttle_engine/large
	name = "engine"
	opacity = TRUE
	icon = 'icons/obj/2x2.dmi'
	icon_state = "large_engine"
	desc = "A very large bluespace engine used to propel very large ships."
	bound_width = 64
	bound_height = 64
	appearance_flags = LONG_GLIDE
	circuit = null

/obj/machinery/power/shuttle_engine/large/in_wall
	name = "in-wall engine"
	icon_state = "large_engine_w"
	density = FALSE
	smoothing_groups = list()

/obj/machinery/power/shuttle_engine/huge
	name = "engine"
	opacity = TRUE
	icon = 'icons/obj/3x3.dmi'
	icon_state = "huge_engine"
	desc = "An extremely large bluespace engine used to propel extremely large ships."
	bound_width = 96
	bound_height = 96
	appearance_flags = LONG_GLIDE
	circuit = null

/obj/machinery/power/shuttle_engine/huge/in_wall
	name = "in-wall engine"
	icon_state = "huge_engine_w"
	density = FALSE
	smoothing_groups = list()

#undef ENGINE_UNWRENCHED
#undef ENGINE_WRENCHED
#undef ENGINE_WELDED
#undef ENGINE_WELDTIME
