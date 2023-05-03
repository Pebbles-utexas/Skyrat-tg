/obj/item/pod_parts
	icon = 'modular_skyrat/modules/spacepods/icons/parts.dmi'
	w_class = WEIGHT_CLASS_GIGANTIC
	flags_1 = CONDUCT_1

/obj/item/pod_parts/core
	name = "space pod core"
	icon_state = "core"

/obj/item/pod_parts/pod_frame
	name = "space pod frame"
	density = FALSE
	anchored = FALSE
	/// What we are able to link to.
	var/link_to = null
	var/link_angle = 0

/obj/item/pod_parts/pod_frame/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/item/pod_parts/pod_frame/proc/find_square()
	/*
	each part, in essence, stores the relative position of another part
	you can find where this part should be by looking at the current direction of the current part and applying the link_angle
	the link_angle is the angle between the part's direction and its following part, which is the current part's link_to
	the code works by going in a loop - each part is capable of starting a loop by checking for the part after it, and that part checking, and so on
	this 4-part loop, starting from any part of the frame, can determine if all the parts are properly in place and aligned
	it also checks that each part is unique, and that all the parts are there for the spacepod itself
	*/
	var/neededparts = list(/obj/item/pod_parts/pod_frame/aft_port, /obj/item/pod_parts/pod_frame/aft_starboard, /obj/item/pod_parts/pod_frame/fore_port, /obj/item/pod_parts/pod_frame/fore_starboard)
	var/turf/our_turf
	var/obj/item/pod_parts/pod_frame/linked
	var/obj/item/pod_parts/pod_frame/pointer
	var/list/connectedparts =  list()
	neededparts -= src
	linked = src
	for(var/i = 1; i <= 4; i++)
		our_turf = get_turf(get_step(linked, turn(linked.dir, -linked.link_angle))) //get the next place that we want to look at
		if(locate(linked.link_to) in our_turf)
			pointer = locate(linked.link_to) in our_turf
		if(istype(pointer, linked.link_to) && pointer.dir == linked.dir && pointer.anchored)
			if(!(pointer in connectedparts))
				connectedparts += pointer
			linked = pointer
			pointer = null
	if(connectedparts.len < 4)
		return FALSE
	for(var/i = 1; i <=4; i++)
		var/obj/item/pod_parts/pod_frame/frame_part = connectedparts[i]
		if(frame_part.type in neededparts) //if one of the items can be founded in neededparts
			neededparts -= frame_part.type
		else //because neededparts has 4 distinct items, this must be called if theyre not all in place and wrenched
			return FALSE
	return connectedparts

/obj/item/pod_parts/pod_frame/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/stack/rods))
		var/obj/item/stack/rods/rod_stack = attacking_item
		var/list/linkedparts = find_square()
		if(!linkedparts)
			to_chat(user, span_warning("You cannot assemble a pod frame because you do not have the necessary assembly."))
			return TRUE
		if(!rod_stack.use(10))
			to_chat(user, span_warning("You need 10 rods for this."))
			return TRUE
		var/obj/spacepod/pod = new
		pod.forceMove(loc)
		switch(dir)
			if(NORTH)
				pod.angle = 0
			if(SOUTH)
				pod.angle = 180
			if(WEST)
				pod.angle = 270
			if(EAST)
				pod.angle = 90
		pod.process(2)
		to_chat(user, span_notice("You strut the pod frame together."))
		for(var/obj/item/pod_parts/pod_frame/F in linkedparts)
			if(1 == turn(F.dir, -F.link_angle)) //if the part links north during construction, as the bottom left part always does
				pod.forceMove(F.loc)
			qdel(F)
		return TRUE
	if(attacking_item.tool_behaviour == TOOL_WRENCH)
		to_chat(user, span_notice("You [!anchored ? "secure [src] in place."  : "remove the securing bolts."]"))
		anchored = !anchored
		density = anchored
		attacking_item.play_tool_sound(src)
		return TRUE

/obj/item/pod_parts/pod_frame/fore_port
	name = "fore port pod frame"
	icon_state = "pod_fp"
	desc = "A space pod frame component. This is the fore port component."
	link_to = /obj/item/pod_parts/pod_frame/fore_starboard
	link_angle = 90

/obj/item/pod_parts/pod_frame/fore_starboard
	name = "fore starboard pod frame"
	icon_state = "pod_fs"
	desc = "A space pod frame component. This is the fore starboard component."
	link_to = /obj/item/pod_parts/pod_frame/aft_starboard
	link_angle = 180

/obj/item/pod_parts/pod_frame/aft_port
	name = "aft port pod frame"
	icon_state = "pod_ap"
	desc = "A space pod frame component. This is the aft port component."
	link_to = /obj/item/pod_parts/pod_frame/fore_port
	link_angle = 0

/obj/item/pod_parts/pod_frame/aft_starboard
	name = "aft starboard pod frame"
	icon_state = "pod_as"
	desc = "A space pod frame component. This is the aft starboard component."
	link_to = /obj/item/pod_parts/pod_frame/aft_port
	link_angle = 270

/obj/item/pod_parts/armor
	name = "civilian pod armor"
	icon_state = "pod_armor_civ"
	desc = "Spacepod armor. This is the civilian version. It looks rather flimsy."
	/// The finished pod icon, this is what determines what the pod will look like.
	var/pod_icon = 'modular_skyrat/modules/spacepods/icons/pod2x2.dmi'
	/// The icon state of the pod icon that will be applied on completion.
	var/pod_icon_state = "pod_civ"
	/// The description that will be applied to the pod upon completion.
	var/pod_desc = "A sleek civilian space pod."
	/// The integrity that will be given to the pod upon completion.
	var/pod_integrity = 250

/obj/item/pod_parts/armor/syndicate
	name = "syndicate pod armor"
	icon_state = "pod_armor_synd"
	desc = "Tough-looking spacepod armor, with a bold \"FUCK NT\" stenciled directly into it."
	pod_icon_state = "pod_synd"
	pod_desc = "A menacing military space pod with \"FUCK NT\" stenciled onto the side"
	pod_integrity = 400

/obj/item/pod_parts/armor/black
	name = "black pod armor"
	icon_state = "pod_armor_black"
	desc = "Plain black spacepod armor, with no logos or insignias anywhere on it."
	pod_icon_state = "pod_black"
	pod_desc = "An all black space pod with no insignias."

/obj/item/pod_parts/armor/gold
	name = "golden pod armor"
	icon_state = "pod_armor_gold"
	desc = "Golden spacepod armor. Looks like what a rich spessmen put on their spacepod."
	pod_icon_state = "pod_gold"
	pod_desc = "A civilian space pod with a gold body, must have cost somebody a pretty penny"
	pod_integrity = 220

/obj/item/pod_parts/armor/industrial
	name = "industrial pod armor"
	icon_state = "pod_armor_industrial"
	desc = "Tough industrial-grade spacepod armor. While meant for construction work, it is commonly used in spacepod battles, too."
	pod_icon_state = "pod_industrial"
	pod_desc = "A rough looking space pod meant for industrial work"
	pod_integrity = 330

/obj/item/pod_parts/armor/security
	name = "security pod armor"
	icon_state = "pod_armor_mil"
	desc = "Tough military-grade pod armor, meant for use by the NanoTrasen military and it's sub-divisons for space combat."
	pod_icon_state = "pod_sec"
	pod_desc = "An armed security spacepod with reinforced armor plating brandishing the Nanotrasen Military insignia"
	pod_integrity = 350

/obj/item/pod_parts/armor/security/red
	name = "security pod armor"
	icon_state = "pod_armor_synd"
	desc = "Tough military-grade pod armor, meant for use by the NanoTrasen military and it's sub-divisons for space combat."
	pod_icon_state = "pod_synd"
	pod_desc = "An armed security spacepod with reinforced armor plating brandishing the Nanotrasen Military insignia"
	pod_integrity = 350

/obj/item/circuitboard/mecha/pod
	name = "Circuit board (Space Pod Mainboard)"
	icon_state = "mainboard"
