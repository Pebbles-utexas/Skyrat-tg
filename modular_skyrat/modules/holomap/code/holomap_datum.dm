// Simple datum to keep track of a running holomap. Each machine capable of displaying the holomap will have one.
/datum/station_holomap
	var/image/base_map
	var/image/cursor
	var/image/legend

/datum/station_holomap/New()
	. = ..()
	cursor = image('icons/holomap_markers.dmi', "you")
	legend = image('icons/64x64.dmi', "legend")

/datum/station_holomap/proc/initialize_holomap(var/turf/turf, var/mob/user = null, var/reinit_base_map = FALSE, extra_overlays = list())
	world.log << "Init holomap with [length(extra_overlays)]"
	if(!base_map || reinit_base_map)
		base_map = image(SSholomaps.extra_holomaps["[HOLOMAP_EXTRA_STATIONMAP]_[turf.z]"])

	if(isAI(user) || isaicamera(user))
		turf = get_turf(user.client.eye)

	update_map(turf, extra_overlays)

/// Updates the map with the provided overlays, with any, removing any overlays it already had that aren't the cursor or legend.
/// If there is no turf, then it doesn't add the cursor or legend back.
/// Make sure to set the pixel x and y of your overlays, or they'll render in the far bottom left.
/datum/station_holomap/proc/update_map(turf/map_turf, list/overlays_to_use = list())
	base_map.cut_overlays()

	if(map_turf)
		cursor.pixel_x = map_turf.x - 6 + HOLOMAP_CENTER_X
		cursor.pixel_y = map_turf.y - 6 + HOLOMAP_CENTER_Y

		legend.pixel_x = 96
		legend.pixel_y = 96

		base_map.add_overlay(legend)
		base_map.add_overlay(cursor)

	for(var/image/map_layer as anything in overlays_to_use)
		world.log << "Adding overlay to map"
		base_map.add_overlay(map_layer)

/datum/station_holomap/proc/initialize_holomap_bogus()
	base_map = image('icons/480x480.dmi', "stationmap")

	var/image/legend = image('icons/64x64.dmi', "notfound")
	legend.pixel_x = 192
	legend.pixel_y = 224

	update_map(overlays_to_use = list(legend))
