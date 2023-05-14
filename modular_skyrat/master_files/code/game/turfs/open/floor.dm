/turf/open/floor/proc/try_place_tile(obj/item/C, mob/user, can_reinforce, considered_broken)
	if(istype(C, /obj/item/stack/rods) && can_reinforce)
		if(considered_broken)
			if(!iscyborg(user))
				to_chat(user, span_warning("Repair the plating first! Use a welding tool to fix the damage."))
			else
				to_chat(user, span_warning("Repair the plating first! Use a welding tool or a plating repair tool to fix the damage.")) //we don't need to confuse humans by giving them a message about plating repair tools, since only janiborgs should have access to them outside of Christmas presents or admin intervention
			return
		var/obj/item/stack/rods/R = C
		if (R.get_amount() < 2)
			to_chat(user, span_warning("You need two rods to make a reinforced floor!"))
			return
		else
			to_chat(user, span_notice("You begin reinforcing the floor..."))
			if(do_after(user, 30, target = src))
				if (R.get_amount() >= 2 && !istype(src, /turf/open/floor/engine))
					PlaceOnTop(/turf/open/floor/engine, flags = CHANGETURF_INHERIT_AIR)
					playsound(src, 'sound/items/deconstruct.ogg', 80, TRUE)
					R.use(2)
					to_chat(user, span_notice("You reinforce the floor."))
				return
	else if(istype(C, /obj/item/stack/tile))
		if(!considered_broken)
			for(var/obj/O in src)
				for(var/M in O.buckled_mobs)
					to_chat(user, span_warning("Someone is buckled to \the [O]! Unbuckle [M] to move \him out of the way."))
					return
			var/obj/item/stack/tile/tile = C
			tile.place_tile(src, user)
			playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
		else
			if(!iscyborg(user))
				balloon_alert(user, "too damaged, use a welding tool!")
			else
				balloon_alert(user, "too damaged, use a welding or plating repair tool!")
