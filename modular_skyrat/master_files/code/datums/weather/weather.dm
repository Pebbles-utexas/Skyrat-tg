#define THUNDER_SOUND pick('modular_skyrat/master_files/sound/effects/thunder/thunder1.ogg', 'modular_skyrat/master_files/sound/effects/thunder/thunder2.ogg', 'modular_skyrat/master_files/sound/effects/thunder/thunder3.ogg', 'modular_skyrat/master_files/sound/effects/thunder/thunder4.ogg', \
			'modular_skyrat/master_files/sound/effects/thunder/thunder5.ogg', 'modular_skyrat/master_files/sound/effects/thunder/thunder6.ogg', 'modular_skyrat/master_files/sound/effects/thunder/thunder7.ogg', 'modular_skyrat/master_files/sound/effects/thunder/thunder8.ogg', 'modular_skyrat/master_files/sound/effects/thunder/thunder9.ogg', \
			'modular_skyrat/master_files/sound/effects/thunder/thunder10.ogg')

/**
 * Causes weather to occur on a z level in certain area types
 *
 * The effects of weather occur across an entire z-level. For instance, lavaland has periodic ash storms that scorch most unprotected creatures.
 * Weather always occurs on different z levels at different times, regardless of weather type.
 * Can have custom durations, targets, and can automatically protect indoor areas.
 *
 */

/datum/weather
	/// name of weather
	var/name = "space wind"
	/// description of weather
	var/desc = "Heavy gusts of wind blanket the area, periodically knocking down anyone caught in the open."
	/// The message displayed in chat to foreshadow the weather's beginning
	var/telegraph_message = span_warning("The wind begins to pick up.")
	/// In deciseconds, how long from the beginning of the telegraph until the weather begins
	var/telegraph_duration = 300
	/// The sound file played to everyone on an affected z-level
	var/telegraph_sound
	/// The overlay applied to all tiles on the z-level
	var/telegraph_overlay
	/// Amount of skyblock during the telegraph. Skyblock makes day/night effects "blocked"
	var/telegraph_skyblock = 0

	/// Displayed in chat once the weather begins in earnest
	var/weather_message = span_userdanger("The wind begins to blow ferociously!")
	/// In deciseconds, how long the weather lasts once it begins
	var/weather_duration = 1200
	/// See above - this is the lowest possible duration
	var/weather_duration_lower = 1200
	/// See above - this is the highest possible duration
	var/weather_duration_upper = 1500
	/// Looping sound while weather is occuring
	var/weather_sound
	/// Area overlay while the weather is occuring
	var/weather_overlay
	/// Color to apply to the area while weather is occuring
	var/weather_color = null
	/// Amount of skyblock during the weather. Skyblock makes day/night effects "blocked"
	var/weather_skyblock = 0

	/// Displayed once the weather is over
	var/end_message = span_danger("The wind relents its assault.")
	/// In deciseconds, how long the "wind-down" graphic will appear before vanishing entirely
	var/end_duration = 300
	/// Sound that plays while weather is ending
	var/end_sound
	/// Area overlay while weather is ending
	var/end_overlay
	/// Amount of skyblock during the end. Skyblock makes day/night effects "blocked"
	var/end_skyblock = 0

	/// Types of area to affect
	var/area_type = /area/space
	/// TRUE value protects areas with outdoors marked as false, regardless of area type
	var/protect_indoors = FALSE
	/// Areas to be affected by the weather, calculated when the weather begins
	var/list/impacted_areas = list()
	/// Areas that were protected by either being outside or underground
	var/list/outside_areas = list()
	/// Areas that are protected and excluded from the affected areas.
	var/list/protected_areas = list()
	/// The list of z-levels that this weather is actively affecting
	var/impacted_z_levels

	/// Since it's above everything else, this is the layer used by default. TURF_LAYER is below mobs and walls if you need to use that.
	var/overlay_layer = AREA_LAYER
	/// Plane for the overlay
	var/overlay_plane = ABOVE_LIGHTING_PLANE
	/// If the weather has no purpose other than looks
	var/aesthetic = FALSE
	/// Used by mobs to prevent them from being affected by the weather
	var/immunity_type = TRAIT_ASHSTORM_IMMUNE

	/// Taken from weather_glow.dmi
	var/use_glow = TRUE
	/// List of all overlays to apply to our turfs
	var/list/overlay_cache

	/// The stage of the weather, from 1-4
	var/stage = END_STAGE

	/// Weight amongst other eligible weather. If zero, will never happen randomly.
	var/probability = 0
	/// The z-level trait to affect when run randomly or when not overridden.
	var/target_trait = ZTRAIT_STATION

	/// Whether a barometer can predict when the weather will happen
	var/barometer_predictable = FALSE
	/// For barometers to know when the next storm will hit
	var/next_hit_time = 0
	/// This causes the weather to only end if forced to
	var/perpetual = FALSE
	/// Whether the weather affects underground areas
	var/affects_underground = TRUE
	/// Whether the weather affects above ground areas
	var/affects_aboveground = TRUE
	/// Reference to the weather controller
	var/datum/weather_controller/my_controller
	/// A type of looping sound to be played for people outside the active weather
	var/datum/looping_sound_skyrat/sound_active_outside
	/// A type of looping sound to be played for people inside the active weather
	var/datum/looping_sound_skyrat/sound_active_inside
	/// A type of looping sound to be played for people outside the winding up/ending weather
	var/datum/looping_sound_skyrat/sound_weak_outside
	/// A type of looping sound to be played for people inside the winding up/ending weather
	var/datum/looping_sound_skyrat/sound_weak_inside
	/// Whether the areas should use a blend multiplication during the main weather, for stuff like fulltile storms
	var/multiply_blend_on_main_stage = FALSE
	/// Whether currently theres a lightning displayed
	var/lightning_in_progress = FALSE
	/// Chance for a thunder to happen
	var/thunder_chance = 0
	/// Whether the main stage will block vision
	var/opacity_in_main_stage = FALSE

/datum/weather/New(datum/weather_controller/passed_controller)
	..()
	my_controller = passed_controller
	my_controller.current_weathers[type] = src
	var/list/z_levels = list()
	for(var/i in my_controller.z_levels)
		var/datum/space_level/level = i
		z_levels += level.z_value
	impacted_z_levels = z_levels
	if(sound_active_outside)
		sound_active_outside = new sound_active_outside(list(), FALSE, TRUE)
	if(sound_active_inside)
		sound_active_inside = new sound_active_inside(list(), FALSE, TRUE)
	if(sound_weak_outside)
		sound_weak_outside = new sound_weak_outside(list(), FALSE, TRUE)
	if(sound_weak_inside)
		sound_weak_inside = new sound_weak_inside(list(), FALSE, TRUE)

/datum/weather/process()
	if(stage != MAIN_STAGE)
		return
	if(prob(thunder_chance))
		do_thunder()
	if(aesthetic)
		return
	for(var/i in GLOB.mob_living_list)
		var/mob/living/L = i
		if(can_weather_act(L))
			weather_act(L)

/datum/weather/Destroy()
	my_controller.current_weathers -= type
	UNSETEMPTY(my_controller.current_weathers)
	my_controller = null
	return ..()

/datum/weather/process()
	if(aesthetic || stage != MAIN_STAGE)
		return
	for(var/i in GLOB.mob_living_list)
		var/mob/living/L = i
		if(can_weather_act(L))
			weather_act(L)

/**
 * Telegraphs the beginning of the weather on the impacted z levels
 *
 * Sends sounds and details to mobs in the area
 * Calculates duration and hit areas, and makes a callback for the actual weather to start
 *
 */
/datum/weather/proc/telegraph()
	if(stage == STARTUP_STAGE)
		return
	stage = STARTUP_STAGE
	my_controller.skyblock += telegraph_skyblock
	my_controller.UpdateSkyblock()
	var/list/affectareas = list()
	for(var/V in get_areas(area_type))
		affectareas += V
	for(var/V in protected_areas)
		affectareas -= get_areas(V)
	for(var/V in affectareas)
		var/area/A = V
		if(!(A.z in impacted_z_levels))
			continue
		if(protect_indoors && !A.outdoors)
			outside_areas |= A
			continue
		if(A.underground && !affects_underground)
			outside_areas |= A
			continue
		if(!A.underground && !affects_aboveground)
			outside_areas |= A
			continue
		impacted_areas |= A
	weather_duration = rand(weather_duration_lower, weather_duration_upper)
	update_areas()
	send_alert(telegraph_message, telegraph_sound)
	addtimer(CALLBACK(src, .proc/start), telegraph_duration)

	if(sound_active_outside)
		sound_active_outside.output_atoms = outside_areas
	if(sound_active_inside)
		sound_active_inside.output_atoms = impacted_areas
	if(sound_weak_outside)
		sound_weak_outside.output_atoms = outside_areas
		sound_weak_outside.start()
	if(sound_weak_inside)
		sound_weak_inside.output_atoms = impacted_areas
		sound_weak_inside.start()

/**
 * Starts the actual weather and effects from it
 *
 * Updates area overlays and sends sounds and messages to mobs to notify them
 * Begins dealing effects from weather to mobs in the area
 *
 */
/datum/weather/proc/start()
	if(stage >= MAIN_STAGE)
		return
	stage = MAIN_STAGE
	my_controller.skyblock -= telegraph_skyblock
	my_controller.skyblock += weather_skyblock
	my_controller.UpdateSkyblock()
	update_areas()
	send_alert(weather_message, weather_sound)
	if(!perpetual)
		addtimer(CALLBACK(src, PROC_REF(wind_down)), weather_duration)

	if(sound_weak_outside)
		sound_weak_outside.stop()
	if(sound_weak_inside)
		sound_weak_inside.stop()
	if(sound_active_outside)
		sound_active_outside.start()
	if(sound_active_inside)
		sound_active_inside.start()

/**
 * Weather enters the winding down phase, stops effects
 *
 * Updates areas to be in the winding down phase
 * Sends sounds and messages to mobs to notify them
 *
 */
/datum/weather/proc/wind_down()
	if(stage >= WIND_DOWN_STAGE)
		return
	stage = WIND_DOWN_STAGE
	my_controller.skyblock += end_skyblock
	my_controller.skyblock -= weather_skyblock
	my_controller.UpdateSkyblock()
	update_areas()
	for(var/M in GLOB.player_list)
		var/turf/mob_turf = get_turf(M)
		if(mob_turf && (mob_turf.z in impacted_z_levels))
			if(end_message)
				to_chat(M, end_message)
			if(end_sound)
				SEND_SOUND(M, sound(end_sound))
	addtimer(CALLBACK(src, PROC_REF(end)), end_duration)

	if(sound_active_outside)
		sound_active_outside.stop()
	if(sound_active_inside)
		sound_active_inside.stop()
	if(sound_weak_outside)
		sound_weak_outside.start()
	if(sound_weak_inside)
		sound_weak_inside.start()

/**
 * Fully ends the weather
 *
 * Effects no longer occur and area overlays are removed
 * Removes weather from processing completely
 *
 */
/datum/weather/proc/end()
	if(stage == END_STAGE)
		return 1
	stage = END_STAGE
	my_controller.skyblock -= end_skyblock
	my_controller.UpdateSkyblock()
	update_areas()
	if(sound_weak_outside)
		sound_weak_outside.start()
	if(sound_weak_inside)
		sound_weak_inside.start()
	if(sound_active_outside)
		qdel(sound_active_outside)
	if(sound_active_inside)
		qdel(sound_active_inside)
	if(sound_weak_outside)
		sound_weak_outside.stop()
		qdel(sound_weak_outside)
	if(sound_weak_inside)
		sound_weak_inside.stop()
		qdel(sound_weak_inside)
	if(lightning_in_progress)
		end_thunder()
	qdel(src)

// handles sending all alerts
/datum/weather/proc/send_alert(alert_msg, alert_sfx)
	for(var/z_level in impacted_z_levels)
		for(var/mob/player as anything in SSmobs.clients_by_zlevel[z_level])
			if(!can_get_alert(player))
				continue
			if(alert_msg)
				to_chat(player, alert_msg)
			if(alert_sfx)
				SEND_SOUND(player, sound(alert_sfx))

// the checks for if a mob should recieve alerts, returns TRUE if can
/datum/weather/proc/can_get_alert(mob/player)
	var/turf/mob_turf = get_turf(player)
	return !isnull(mob_turf)

/**
 * Returns TRUE if the living mob can be affected by the weather
 *
 */
/datum/weather/proc/can_weather_act(mob/living/mob_to_check)
	var/turf/mob_turf = get_turf(mob_to_check)
	if(mob_turf && !(mob_turf.z in impacted_z_levels))
		return
	if((immunity_type && HAS_TRAIT(mob_to_check, immunity_type)) || HAS_TRAIT(mob_to_check, TRAIT_WEATHER_IMMUNE))
		return

	var/atom/loc_to_check = mob_to_check.loc
	while(loc_to_check != mob_turf)
		if((immunity_type && HAS_TRAIT(loc_to_check, immunity_type)) || HAS_TRAIT(loc_to_check, TRAIT_WEATHER_IMMUNE))
			return
		loc_to_check = loc_to_check.loc

	if(!(get_area(mob_to_check) in impacted_areas))
		return
	return TRUE

/**
 * Affects the mob with whatever the weather does
 *
 */
/datum/weather/proc/weather_act(mob/living/L)
	return

/**
 * Updates the overlays on impacted areas
 *
 */
/datum/weather/proc/update_areas()
	var/list/new_overlay_cache = generate_overlay_cache()
	for(var/area/N as anything in impacted_areas)
		if(stage == MAIN_STAGE && multiply_blend_on_main_stage)
			N.blend_mode = BLEND_MULTIPLY
		else
			N.blend_mode = BLEND_OVERLAY

		if(stage == MAIN_STAGE && opacity_in_main_stage)
			N.set_opacity(TRUE)
		else
			N.set_opacity(FALSE)

		// N.layer = overlay_layer
		// N.plane = overlay_plane
		// N.icon = 'modular_skyrat/modules/overmap/icons/weather_effects.dmi'
		// N.color = weather_color
		if(length(overlay_cache))
			N.overlays -= overlay_cache
		if(length(new_overlay_cache))
			N.overlays += new_overlay_cache
		//set_area_icon_state(N)
		if(stage == END_STAGE)
			// N.color = null
			// N.icon = 'icons/turf/areas.dmi'
			// N.layer = initial(N.layer)
			// N.plane = initial(N.plane)
			N.set_opacity(FALSE)

/// Returns a list of visual offset -> overlays to use
/datum/weather/proc/generate_overlay_cache()
	// We're ending, so no overlays at all
	if(stage == END_STAGE)
		return list()

	var/weather_state = ""
	switch(stage)
		if(STARTUP_STAGE)
			weather_state = telegraph_overlay
		if(MAIN_STAGE)
			weather_state = weather_overlay
		if(WIND_DOWN_STAGE)
			weather_state = end_overlay

	// Use all possible offsets
	// Yes this is a bit annoying, but it's too slow to calculate and store these from turfs, and it shouldn't (I hope) look weird
	var/list/gen_overlay_cache = list()
	for(var/offset in 0 to SSmapping.max_plane_offset)
		// Note: what we do here is effectively apply two overlays to each area, for every unique multiz layer they inhabit
		// One is the base, which will be masked by lighting. the other is "glowing", and provides a nice contrast
		// This method of applying one overlay per z layer has some minor downsides, in that it could lead to improperly doubled effects if some have alpha
		// I prefer it to creating 2 extra plane masters however, so it's a cost I'm willing to pay
		// LU
		var/mutable_appearance/glow_overlay = mutable_appearance('icons/effects/glow_weather.dmi', weather_state, overlay_layer, null, ABOVE_LIGHTING_PLANE, 100, offset_const = offset)
		glow_overlay.color = weather_color
		gen_overlay_cache += glow_overlay

		var/mutable_appearance/weather_overlay = mutable_appearance('icons/effects/weather_effects.dmi', weather_state, overlay_layer, plane = overlay_plane, offset_const = offset)
		weather_overlay.color = weather_color
		gen_overlay_cache += weather_overlay

	return gen_overlay_cache

/datum/weather/proc/set_area_icon_state(area/Area)
	switch(stage)
		if(STARTUP_STAGE)
			Area.icon_state = telegraph_overlay
		if(MAIN_STAGE)
			Area.icon_state = weather_overlay
		if(WIND_DOWN_STAGE)
			Area.icon_state = end_overlay
		if(END_STAGE)
			Area.icon_state = ""

/datum/weather/proc/do_thunder()
	if(lightning_in_progress)
		return
	lightning_in_progress = TRUE
	addtimer(CALLBACK(src, .proc/end_thunder), 5 SECONDS)
	addtimer(CALLBACK(src, .proc/do_thunder_sound), 2 SECONDS)
	var/mutable_appearance/appearance_to_add = mutable_appearance('modular_skyrat/modules/overmap/icons/weather_effects.dmi', "lightning_flash")
	appearance_to_add.plane = LIGHTING_PLANE
	appearance_to_add.layer = OBJ_LAYER
	for(var/V in impacted_areas)
		var/area/N = V
		N.luminosity++
		N.underlays += appearance_to_add

/datum/weather/proc/do_thunder_sound()
	var/picked_sound = THUNDER_SOUND
	for(var/i in 1 to impacted_areas.len)
		var/atom/thing = impacted_areas[i]
		SEND_SOUND(thing, sound(picked_sound, volume = 65))
	for(var/i in 1 to outside_areas.len)
		var/atom/thing = outside_areas[i]
		SEND_SOUND(thing, sound(picked_sound, volume = 35))

/datum/weather/proc/end_thunder()
	if(QDELETED(src))
		return
	if(!lightning_in_progress)
		return
	lightning_in_progress = FALSE
	var/mutable_appearance/appearance_to_remove = mutable_appearance('modular_skyrat/modules/overmap/icons/weather_effects.dmi', "lightning_flash")
	appearance_to_remove.plane = LIGHTING_PLANE
	appearance_to_remove.layer = OBJ_LAYER
	for(var/V in impacted_areas)
		var/area/N = V
		N.underlays += appearance_to_remove
		N.luminosity--
