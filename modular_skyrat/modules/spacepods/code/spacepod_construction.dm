/obj/spacepod/examine(mob/user)
	. = ..()
	. += "<hr>"
	switch(construction_state) // more construction states than r-walls!
		if(SPACEPOD_EMPTY)
			. += span_notice("The struts holding it together can be <b>cut</b> and it is missing <i>wires</i>.")
		if(SPACEPOD_WIRES_LOOSE)
			. += span_notice("The <b>wires</b> need to be <i>screwed</i> on.")
		if(SPACEPOD_WIRES_SECURED)
			. += span_notice("The wires are <b>screwed</b> on and need a <i>circuit board</i>.")
		if(SPACEPOD_CIRCUIT_LOOSE)
			. += span_notice("The circuit board is <b>loosely attached</b> and needs to be <i>screwed</i> on.")
		if(SPACEPOD_CIRCUIT_SECURED)
			. += span_notice("The circuit board is <b>screwed</b> on, and there is space for a <i>core</i>.")
		if(SPACEPOD_CORE_LOOSE)
			. += span_notice("The core is <b>loosely attached</b> and needs to be <i>bolted</i> on.")
		if(SPACEPOD_CORE_SECURED)
			. += span_notice("The core is <b>bolted</b> on and the <i>metal</i> bulkhead can be attached.")
		if(SPACEPOD_BULKHEAD_LOOSE)
			. += span_notice("The bulkhead is <b>loosely attached</b> and can be <i>bolted</i> down.")
		if(SPACEPOD_BULKHEAD_SECURED)
			. += span_notice("The bulkhead is <b>bolted</b> on but not <i>welded</i> on.")
		if(SPACEPOD_BULKHEAD_WELDED)
			. += span_notice("The bulkhead is <b>welded</b> on and <i>armor</i> can be attached.")
		if(SPACEPOD_ARMOR_LOOSE)
			. += span_notice("The armor is <b>loosely attached</b> and can be <i>bolted</i> down.")
		if(SPACEPOD_ARMOR_SECURED)
			. += span_notice("The armor is <b>bolted</b> on but not <i>welded</i> on.")
		if(SPACEPOD_ARMOR_WELDED)
			if(hatch_open)
				if(cell || internal_tank || equipment.len)
					. += span_notice("The maintenance hatch is <i>pried</i> open and there are parts inside that can be <b>removed</b>.")
				else
					. += span_notice("The maintenance hatch is <i>pried</i> open and the armor is <b>welded</b> on.")
			else
				if(locked)
					. += span_notice("[src] is <b>locked</b>.")
				else
					. += span_notice("The maintenance hatch is <b>closed</b>.")

/obj/spacepod/proc/handle_spacepod_construction(obj/item/tool, mob/living/user)
	// time for a construction/deconstruction process to rival r-walls

	switch(construction_state)
		if(SPACEPOD_EMPTY)
			if(tool.tool_behaviour == TOOL_WIRECUTTER)
				. = TRUE
				user.visible_message("[user] deconstructs [src].", "You deconstruct [src].")
				tool.play_tool_sound(src)
				deconstruct(TRUE)
			else if(istype(tool, /obj/item/stack/cable_coil))
				. = TRUE
				var/obj/item/stack/cable_coil = tool
				if(cable_coil.use(10))
					user.visible_message("[user] wires [src].", "You wire [src].")
					construction_state++
				else
					to_chat(user, span_warning("You need 10 wires for this!"))
		if(SPACEPOD_WIRES_LOOSE)
			if(tool.tool_behaviour == TOOL_WIRECUTTER)
				. = TRUE
				var/obj/item/stack/cable_coil/cable_coil = new
				cable_coil.amount = 10
				cable_coil.forceMove(loc)
				tool.play_tool_sound(src)
				construction_state--
				user.visible_message("[user] cuts [src]'s wiring.", "You remove [src]'s wiring.")
			else if(tool.tool_behaviour == TOOL_SCREWDRIVER)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state++
				user.visible_message("[user] screws on [src]'s wiring harnesses.", "You screw on [src]'s wiring harnesses.")
		if(SPACEPOD_WIRES_SECURED)
			if(tool.tool_behaviour == TOOL_SCREWDRIVER)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state--
				user.visible_message("[user] unclips [src]'s wiring harnesses.", "You unclip [src]'s wiring harnesses.")
			else if(istype(tool, /obj/item/circuitboard/mecha/pod))
				. = TRUE
				if(user.temporarilyRemoveItemFromInventory(tool))
					qdel(tool)
					construction_state++
					user.visible_message("[user] inserts the mainboard into [src].", "You insert the mainboard into [src].")
				else
					to_chat(user, span_warning("[tool] is stuck to your hand!"))
		if(SPACEPOD_CIRCUIT_LOOSE)
			if(tool.tool_behaviour == TOOL_CROWBAR)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state--
				var/obj/item/circuitboard/mecha/pod/pod_circuitboard = new
				pod_circuitboard.forceMove(loc)
				user.visible_message("[user] pries out the mainboard from [src].", "You pry out the mainboard from [src].")
			else if(tool.tool_behaviour == TOOL_SCREWDRIVER)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state++
				user.visible_message("[user] secures the mainboard to [src].", "You secure the mainboard to [src].")
		if(SPACEPOD_CIRCUIT_SECURED)
			if(tool.tool_behaviour == TOOL_SCREWDRIVER)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state--
				user.visible_message("[user] unsecures the mainboard.", "You unscrew the mainboard from [src].")
			else if(istype(tool, /obj/item/pod_parts/core))
				. = TRUE
				if(user.temporarilyRemoveItemFromInventory(tool))
					qdel(tool)
					construction_state++
					user.visible_message("[user] inserts the core into [src].", "You carefully insert the core into [src].")
				else
					to_chat(user, span_warning("[tool] is stuck to your hand!"))
		if(SPACEPOD_CORE_LOOSE)
			if(tool.tool_behaviour == TOOL_CROWBAR)
				. = TRUE
				tool.play_tool_sound(src)
				var/obj/item/pod_parts/core/spacepod_core = new
				spacepod_core.forceMove(loc)
				construction_state--
				user.visible_message("[user] delicately removes the core from [src].", "You delicately remove the core from [src].")
			else if(tool.tool_behaviour == TOOL_WRENCH)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state++
				user.visible_message("[user] secures [src]'s core bolts.", "You secure [src]'s core bolts.")
		if(SPACEPOD_CORE_SECURED)
			if(tool.tool_behaviour == TOOL_WRENCH)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state--
				user.visible_message("[user] unsecures [src]'s core.", "You unsecure [src]'s core.")
			else if(istype(tool, /obj/item/stack/sheet/iron))
				. = TRUE
				var/obj/item/stack/sheet/iron/iron_sheets = tool
				if(iron_sheets.use(5))
					user.visible_message("[user] fabricates a pressure bulkhead for [src].", "You frabricate a pressure bulkhead for [src].")
					construction_state++
				else
					to_chat(user, span_warning("You need 5 metal for this!"))
		if(SPACEPOD_BULKHEAD_LOOSE)
			if(tool.tool_behaviour == TOOL_CROWBAR)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state--
				var/obj/item/stack/sheet/iron/five/iron_sheets = new
				iron_sheets.forceMove(loc)
				user.visible_message("[user] pops [src]'s bulkhead panelling loose.", "You pop [src]'s bulkhead panelling loose.")
			else if(tool.tool_behaviour == TOOL_WRENCH)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state++
				user.visible_message("[user] secures [src]'s bulkhead panelling.", "You secure [src]'s bulkhead panelling.")
		if(SPACEPOD_BULKHEAD_SECURED)
			if(tool.tool_behaviour == TOOL_WRENCH)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state--
				user.visible_message("[user] unbolts [src]'s bulkhead panelling.", "You unbolt [src]'s bulkhead panelling.")
			else if(tool.tool_behaviour == TOOL_WELDER)
				. = TRUE
				if(tool.use_tool(src, user, 20, amount = 3, volume = 50))
					construction_state = SPACEPOD_BULKHEAD_WELDED
					user.visible_message("[user] seals [src]'s bulkhead panelling.", "You seal [src]'s bulkhead panelling.")
		if(SPACEPOD_BULKHEAD_WELDED)
			if(tool.tool_behaviour == TOOL_WELDER)
				. = TRUE
				if(tool.use_tool(src, user, 20, amount = 3, volume = 50))
					construction_state = SPACEPOD_BULKHEAD_SECURED
					user.visible_message("[user] cuts [src]'s bulkhead panelling loose.", "You cut [src]'s bulkhead panelling loose.")
			if(istype(tool, /obj/item/pod_parts/armor))
				. = TRUE
				if(user.transferItemToLoc(tool, src))
					add_armor(tool)
					construction_state++
					user.visible_message("[user] installs [src]'s armor plating.", "You install [src]'s armor plating.")
				else
					to_chat(user, "[tool] is stuck to your hand!")
		if(SPACEPOD_ARMOR_LOOSE)
			if(tool.tool_behaviour == TOOL_CROWBAR)
				. = TRUE
				if(pod_armor)
					pod_armor.forceMove(loc)
					remove_armor()
				tool.play_tool_sound(src)
				construction_state--
				user.visible_message("[user] pries off [src]'s armor.", "You pry off [src]'s armor.")
			if(tool.tool_behaviour == TOOL_WRENCH)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state++
				user.visible_message("[user] bolts down [src]'s armor.", "You bolt down [src]'s armor.")
		if(SPACEPOD_ARMOR_SECURED)
			if(tool.tool_behaviour == TOOL_WRENCH)
				. = TRUE
				tool.play_tool_sound(src)
				construction_state--
				user.visible_message("[user] unsecures [src]'s armor.", "You unsecure [src]'s armor.")
			else if(tool.tool_behaviour == TOOL_WELDER)
				. = TRUE
				if(tool.use_tool(src, user, 50, amount = 3, volume = 50))
					construction_state = SPACEPOD_ARMOR_WELDED
					user.visible_message("[user] welds [src]'s armor.", "You weld [src]'s armor.")
					// finally this took too fucking long
					// somehow this takes up 40 lines less code than the original, code-less version. And it actually works
	update_icon()
