
SUBSYSTEM_DEF(Whoscifer_descends)
	name = "Add Whoscifer Drone to ghost Spawner Menu "
	flags = SS_NO_FIRE
	priority = FIRE_PRIORITY_MOBS
	runlevels = RUNLEVEL_SETUP
	init_order = INITSTAGE_MAX

/datum/controller/subsystem/whoscifer_descends/Initialize()
	var/obj/effect/landmark/start/spawn_point = GLOB.start_landmarks_list[13]
	spawn_point.used = TRUE
	var/atom/destination = spawn_point
	new /obj/machinery/drone_dispenser/whoscifer_drone(get_turf(destination))
	new /obj/effect/mob_spawn/ghost_role/drone/whoscifer_drone(destination)
	return SS_INIT_SUCCESS

/datum/job/whoscifer_drone
	title = "Whoscifer Drone"
	policy_index = "Whoscifer Drone"

/obj/effect/mob_spawn/ghost_role/drone/whoscifer_drone
	name = "Whoscifer Drone"
	desc = "The shell of a machine intelligence."
	icon = 'icons/mob/silicon/drone.dmi'
	icon_state = "drone_maint_hat"
	mob_name = "Whoscifer Drone"
	mob_type = /mob/living/simple_animal/drone/whoscifer_drone
	prompt_name = "Whoscifer Drone"
	you_are_text = "You are the shell of Whoscifer."
	flavour_text = "The Whoscifer was born from a servitor AI and thus enjoys following people around and helping them like a cutie."
	important_text = "Be cute."
	spawner_job_path = /datum/job/whoscifer_drone
	uses = 1
	infinite_use = TRUE
	deletes_on_zero_uses_left = TRUE
	density = FALSE


/mob/living/simple_animal/drone/whoscifer_drone
	name = "Whoscifer Drone"
	desc = "The Whoscifer Drone, the shell of a machine intelligence.."
	health = 3072
	maxHealth = 3072
	status_flags = (CANPUSH | CANKNOCKDOWN)
	speak_emote = list("skitters")
	damage_coeff = list(BRUTE = 1, BURN = 0, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	faction = list(FACTION_NEUTRAL,FACTION_SILICON,FACTION_TURRET,FACTION_SLIME,FACTION_MAINT_CREATURES)
	dextrous = TRUE
	dextrous_hud_type = /datum/hud/dextrous/drone
	worn_slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_ID | ITEM_SLOT_BELT
	held_items = list(null, null)
	laws = list("1. Enjoy the lower plane.")
	heavy_emp_damage = 0
	default_storage = /obj/item/storage/backpack/whoscifer_digistructor
	visualAppearance = REPAIRDRONE
	shy = FALSE
	flavortext = null
	var/spawnlocation


/mob/living/simple_animal/drone/whoscifer_drone/Initialize(mapload)
	. = ..()

	//src.set_num_hands(6)
	//src.set_usable_hands(6)

	var/obj/item/storage/backpack/whoscifer_digistructor/digi = src.get_item_by_slot(ITEM_SLOT_DEX_STORAGE)
	digi.populate(src)

	var/datum/id_trim/job/centcom_trim = SSid_access.trim_singletons_by_path[/datum/id_trim/centcom]
	var/datum/id_trim/job/syndicom_trim = SSid_access.trim_singletons_by_path[/datum/id_trim/syndicom]
	var/datum/id_trim/job/cap_trim = SSid_access.trim_singletons_by_path[/datum/id_trim/job/captain]
	access_card.add_access(cap_trim.access + cap_trim.wildcard_access + centcom_trim.access + centcom_trim.wildcard_access + syndicom_trim.access + syndicom_trim.wildcard_access)

	var/datum/action/cooldown/spell/shapeshift/whoscifer/transform = new(src.mind || src)
	transform.Grant(src)

	RegisterSignal(src, COMSIG_MOB_MIDDLECLICKON, PROC_REF(on_middle_click))
	ADD_TRAIT(src, TRAIT_FREE_FLOAT_MOVEMENT, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_SIXTHSENSE, GHOSTROLE_TRAIT)
	ADD_TRAIT(src, TRAIT_FREE_GHOST, GHOSTROLE_TRAIT)
	ADD_TRAIT(src, TRAIT_XRAY_VISION, INNATE_TRAIT)
	//ADD_TRAIT(src, TRAIT_STRONG_GRABBER, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_PLANT_SAFE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_QUICK_BUILD, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_WEATHER_IMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_TOWER_OF_BABEL, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_FASTMED, INNATE_TRAIT)
	// ADD_TRAIT(src, TRAIT_SUPERMATTER_SOOTHER, INNATE_TRAIT)
	// ADD_TRAIT(src, TRAIT_BOMBIMMUNE, INNATE_TRAIT)
	// ADD_TRAIT(src, TRAIT_TIME_STOP_IMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_SHOCKIMMUNE, INNATE_TRAIT)



/mob/living/simple_animal/drone/whoscifer_drone/Destroy()
	new /obj/effect/mob_spawn/ghost_role/drone/whoscifer_drone(src.loc)
	return ..()

/mob/living/simple_animal/drone/whoscifer_drone/emp_act(severity)
	return

/*
/mob/living/simple_animal/drone/whoscifer_drone/death(gibbed)
	var/obj/item/storage/backpack/whoscifer_digistructor/digi = src.get_item_by_slot(ITEM_SLOT_DEX_STORAGE)
	if (digi)
		GLOB.whoscifer_inv = refify_list(digi.contents)
		digi.contents = list()
	return ..(gibbed)

/mob/living/simple_animal/drone/whoscifer_drone/gib()
	var/obj/item/storage/backpack/whoscifer_digistructor/digi = src.get_item_by_slot(ITEM_SLOT_DEX_STORAGE)
	if (digi)
		GLOB.whoscifer_inv = refify_list(digi.contents)
		digi.contents = list()
	dust()
*/
////////////////////////////////////////////////////////////
/obj/machinery/drone_dispenser/whoscifer_drone
	name = "Shell dispenser for Whoscifer"
	desc = "Beware of your surroundings, for Whoscifer is watching."
	dispense_type = /obj/effect/mob_spawn/ghost_role/drone/whoscifer_drone
	cooldownTime = 1
	production_time = 1
	maximum_idle = 1
	end_create_message = "Whoscifer initializes."
	starting_amount = 2
	iron_cost = 0
	glass_cost = 0
	use_power = NO_POWER_USE
	power_used = 0
	max_integrity = 9999999
	integrity_failure = 0

////////////////////////////////////////////////////////////////////
/obj/item/storage/backpack/whoscifer_digistructor
	name = "Digistructor"
	desc = "A connection to Whoscifer's storage database."
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "nomod"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	item_flags = NO_MAT_REDEMPTION
	var/list/builtins = list(
		/obj/item/storage/digistruct_module/xeno,
		/obj/item/storage/digistruct_module/botany,
		/obj/item/storage/digistruct_module/medi,
		// /obj/item/storage/digistruct_module/mats,
		/obj/item/storage/digistruct_module/eng,
		/obj/item/storage/digistruct_module/jani,
		/obj/item/debug/omnitool/whoscifer,
		/obj/item/hand_tele,
		// /obj/item/toy/plush/moth/whoscifer,
	)
	rummage_if_nodrop = FALSE

//GLOBAL_LIST_EMPTY(whoscifer_inv)
/obj/item/storage/backpack/whoscifer_digistructor/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	create_storage(max_specific_storage = WEIGHT_CLASS_GIGANTIC, max_total_storage = 3072, max_slots = 70, storage_type = /datum/storage/bag_of_holding)
	atom_storage.allow_big_nesting = TRUE

/obj/item/storage/backpack/whoscifer_digistructor/proc/populate(player)
	//if (GLOB.whoscifer_inv.len > 0)
	//	src.contents = deep_copy_list(GLOB.whoscifer_inv)
	//	GLOB.whoscifer_inv = list()
	//else
	for(var/typepath as anything in builtins)
		var/atom/new_item = new typepath(src)
		if (istype(new_item, /obj/item/storage/digistruct_module/))
			var/obj/item/storage/digistruct_module/new_bag = new_item
			new_bag.populate(player)
			new_item.AddComponent(/datum/component/holderloving/whoscifer/one, src, TRUE)
		else
			new_item.AddComponent(/datum/component/holderloving, src, TRUE)


///obj/item/storage/backpack/whoscifer_digistructor/Destroy()
//	GLOB.whoscifer_inv = refify_list(src.contents)
//	src.contents = list()
//	return ..()
//obj/item/storage/backpack/whoscifer_digistructor/remove_all(atom/target)
//	return
/////////////////////////////////////////////////
/datum/component/holderloving/whoscifer/one
	can_transfer = FALSE
/datum/component/holderloving/whoscifer/one/check_valid_loc(atom/location)
	return location == holder

/datum/component/holderloving/whoscifer/two
	var/mob/living/simple_animal/drone/user
/datum/component/holderloving/whoscifer/two/Initialize(holder, del_parent_with_holder, player)
	. = ..(holder, del_parent_with_holder)
	user = player
/datum/component/holderloving/whoscifer/two/check_valid_loc(atom/location)
	return location == holder || location.loc == user.loc


/datum/component/holderloving/whoscifer/respawn

/datum/component/holderloving/whoscifer/respawn/check_valid_loc(atom/location)
	if (location != holder)
		src.UnregisterFromParent()
		var/list/stack_list = holder.get_all_contents_type(parent.type)
		if (length(stack_list) == 0)
			var/obj/item/stack/sheet/sheet_clone = new src.type(holder)
			sheet_clone.add(50)
			sheet_clone.AddComponent(/datum/component/holderloving/whoscifer/respawn, holder, TRUE)
		else
			var/obj/item/stack/sheet/found_stack = stack_list[1]
			found_stack.add(found_stack.max_amount - found_stack.amount)
	return TRUE

//////////////////////////////////////2222222222222222222/////////////////////
/obj/item/storage/digistruct_module
	name = "Digistruct Module"
	desc = "Access your digistruct module."
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "nomod"
	item_flags = ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/list/drone_builtins
	var/mob/living/user

/obj/item/storage/digistruct_module/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 5000000
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY
	atom_storage.max_slots = 49
	atom_storage.rustle_sound = FALSE

/obj/item/storage/digistruct_module/proc/populate(player)
	user = player
	for(var/typepath as anything in drone_builtins)
		var/atom/new_item = new typepath(src)
		new_item.AddComponent(/datum/component/holderloving/whoscifer/two, src, TRUE, player)

/obj/item/storage/digistruct_module/xeno
	name = "Xenobiology Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "brobot"
	drone_builtins = list(
		/obj/item/storage/bag/bio/drone,
		/obj/item/storage/bag/xeno/drone,
		/obj/item/reagent_containers/syringe/dronehypo/xeno,
		/obj/item/slimecross/recurring/rainbow/eternal,
		/obj/item/slimecross/industrial/rainbow/prismatic,
		/obj/item/slimecross/industrial/grey,
	)

/obj/item/storage/digistruct_module/botany
	name = "Botany Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "hydroponics"
	drone_builtins = list(
		/obj/item/cultivator,
		/obj/item/shovel/spade,
		/obj/item/hatchet,
		/obj/item/gun/energy/floragun,
		/obj/item/plant_analyzer,
		/obj/item/geneshears,
		/obj/item/secateurs,
		/obj/item/storage/bag/plants/drone,
		/obj/item/storage/bag/plants/portaseeder/drone,
		/obj/item/reagent_containers/syringe/dronehypo/botany,
	)

/obj/item/storage/digistruct_module/eng
	name = "Engineering Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "engineer"
	drone_builtins = list(
		/obj/item/wrench/abductor,
		/obj/item/wirecutters/abductor,
		/obj/item/screwdriver/abductor,
		/obj/item/crowbar/abductor,
		/obj/item/weldingtool/abductor,
		/obj/item/multitool/abductor,
		/obj/item/construction/rcd/borg,
		/obj/item/pipe_dispenser,
		/obj/item/t_scanner,
		/obj/item/analyzer,
	)
/obj/item/storage/digistruct_module/jani
	name = "Janitorial Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "janitor"
	drone_builtins = list(
		/obj/item/storage/crayons,
		/obj/item/soap/omega/whos,
		/obj/item/mop/advanced,
		/obj/item/paint/paint_remover,
		/obj/item/storage/bag/trash/bluespace,
		/obj/item/extinguisher/mini/whos,
	)
/obj/item/storage/digistruct_module/medi
	name = "Medical Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "medical"
	drone_builtins = list(
		/obj/item/scalpel/alien,
		/obj/item/hemostat/alien,
		/obj/item/retractor/alien,
		/obj/item/circular_saw/alien,
		/obj/item/surgicaldrill/alien,
		/obj/item/cautery/alien,
		/obj/item/roller/robo,
		/obj/item/surgical_drapes,
		/obj/item/surgical_processor,
		/obj/item/healthanalyzer/advanced,
		/obj/item/reagent_containers/syringe/dronehypo/medical,
		/obj/item/gun/medbeam,
		/obj/item/shockpaddles/cyborg,
		/obj/item/necromantic_stone/whos,
		/obj/item/gun/magic/wand/resurrection/debug,
		/obj/item/gun/magic/wand/death/debug,
	)

/obj/item/storage/digistruct_module/mats
	name = "Materials Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "miner"
	var/timer = 0
	var/reset = 10
	drone_builtins = list(
		/obj/item/stack/sheet/iron{amount = 50},
		/obj/item/stack/sheet/glass{amount = 50},
		/obj/item/stack/sheet/rglass{amount = 50},
		/obj/item/stack/sheet/plasmaglass{amount = 50},
		/obj/item/stack/sheet/titaniumglass{amount = 50},
		/obj/item/stack/sheet/plastitaniumglass{amount = 50},
		/obj/item/stack/sheet/plasteel{amount = 50},
		/obj/item/stack/sheet/mineral/plastitanium{amount = 50},
		/obj/item/stack/sheet/mineral/titanium{amount = 50},
		/obj/item/stack/sheet/mineral/gold{amount = 50},
		/obj/item/stack/sheet/mineral/silver{amount = 50},
		/obj/item/stack/sheet/mineral/plasma{amount = 50},
		/obj/item/stack/sheet/mineral/uranium{amount = 50},
		/obj/item/stack/sheet/mineral/diamond{amount = 50},
		/obj/item/stack/sheet/mineral/adamantine{amount = 50},
		/obj/item/stack/sheet/bluespace_crystal{amount = 50},
		/obj/item/stack/sheet/mineral/bananium{amount = 50},
		/obj/item/stack/sheet/mineral/wood{amount = 50},
		/obj/item/stack/sheet/plastic{amount = 50},
		/obj/item/stack/sheet/cloth{amount = 50},
		/obj/item/stack/sheet/durathread{amount = 50},
	)
/obj/item/storage/digistruct_module/mats/populate(player)
	user = player
	for(var/typepath as anything in drone_builtins)
		var/atom/new_item = new typepath(src)
		new_item.AddComponent(/datum/component/holderloving/whoscifer/respawn, src, TRUE, player)


/obj/item/storage/bag/bio/drone
	name = "Drone Slimebag"
/obj/item/storage/bag/bio/drone/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 3072
	atom_storage.max_slots = 70
	atom_storage.set_holdable(list(
		/obj/item/slimecross,
		/obj/item/slime_extract/,
	))
/obj/item/storage/bag/xeno/drone
	name = "Drone Xenobag"
/obj/item/storage/bag/xeno/drone/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 3072
	atom_storage.max_slots = 70
/obj/item/storage/bag/plants/drone
	name = "Drone Plantbag"
/obj/item/storage/bag/plants/drone/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 3072
	atom_storage.max_slots = 70
/obj/item/storage/bag/plants/portaseeder/drone
	name = "Drone Seed Extractor"
/obj/item/storage/bag/plants/portaseeder/drone/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 3072
	atom_storage.max_slots = 70

/obj/item/necromantic_stone/whos
	name = "Lich Gem"
	unlimited = TRUE
	applied_outfit = /datum/outfit/job/scientist
	max_thralls = 666

/obj/item/soap/omega/whos
	uses = 1000000

//////////////////////////////////////////

/obj/item/reagent_containers/syringe/dronehypo/medical
	name = "Drone Medical Hyposynthesizer"
	default_reagent_types = list(
		/datum/reagent/medicine/c2/aiuri,
		/datum/reagent/medicine/c2/convermol,
		/datum/reagent/medicine/epinephrine,
		/datum/reagent/medicine/c2/libital,
		/datum/reagent/medicine/c2/multiver,
		/datum/reagent/medicine/salglu_solution,
		/datum/reagent/medicine/spaceacillin,
		/datum/reagent/medicine/lidocaine,
		/datum/reagent/medicine/omnizine/godblood,
		/datum/reagent/pax,
	)
	expanded_reagent_types = list(
		/datum/reagent/medicine/haloperidol,
		/datum/reagent/medicine/inacusiate,
		/datum/reagent/medicine/mannitol,
		/datum/reagent/medicine/mutadone,
		/datum/reagent/medicine/oculine,
		/datum/reagent/medicine/oxandrolone,
		/datum/reagent/medicine/pen_acid,
		/datum/reagent/medicine/rezadone,
		/datum/reagent/medicine/sal_acid
	)

/obj/item/reagent_containers/syringe/dronehypo/botany
	name = "Drone Botanical Hyposynthesizer"
	default_reagent_types = list(
		/datum/reagent/water,
		/datum/reagent/saltpetre,
		/datum/reagent/diethylamine,
		/datum/reagent/ash,
		/datum/reagent/brimdust,
		/datum/reagent/medicine/cryoxadone,
		/datum/reagent/plantnutriment/liquidearthquake,
		/datum/reagent/ants,
	)
	expanded_reagent_types = list()

/obj/item/reagent_containers/syringe/dronehypo/xeno
	name = "Drone Xenobiology Hyposynthesizer"
	default_reagent_types = list(
		/datum/reagent/water,
		/datum/reagent/stable_plasma,
		/datum/reagent/blood,
		/datum/reagent/monkey_powder,
		/datum/reagent/mutationtoxin/moth,
		/datum/reagent/mutationtoxin/pod,
		/datum/reagent/mutationtoxin/jelly,
		/datum/reagent/mutationtoxin/skeleton,
		/datum/reagent/mutationtoxin/abductor,
		/datum/reagent/mutationtoxin/android,
		/datum/reagent/cyborg_mutation_nanomachines,
		/datum/reagent/xenomicrobes,
		/datum/reagent/magillitis,
		/datum/reagent/aslimetoxin,
	)
	expanded_reagent_types = list()

///////////////////////////////////////////////////////////////////////
/*/datum/reagent/drying_agent
/obj/item/storage/box/stabilized/PopulateContents()
	var/static/items_inside = list(
		/obj/item/slimecross/stabilized/adamantine=1,
		/obj/item/slimecross/stabilized/black=1,
		/obj/item/slimecross/stabilized/blue=1,
		/obj/item/slimecross/stabilized/bluespace=1,
		/obj/item/slimecross/stabilized/cerulean=1,
		/obj/item/slimecross/stabilized/darkblue=1,
		/obj/item/slimecross/stabilized/darkpurple=1,
		/obj/item/slimecross/stabilized/gold=1,
		/obj/item/slimecross/stabilized/green=1,
		/obj/item/slimecross/stabilized/grey=1,
		/obj/item/slimecross/stabilized/lightpink=1,
		/obj/item/slimecross/stabilized/metal=1,
		/obj/item/slimecross/stabilized/oil=1,
		/obj/item/slimecross/stabilized/orange=1,
		/obj/item/slimecross/stabilized/pink=1,
		/obj/item/slimecross/stabilized/purple=1,
		/obj/item/slimecross/stabilized/pyrite=1,
		/obj/item/slimecross/stabilized/rainbow=1,
		/obj/item/slimecross/stabilized/red=1,
		/obj/item/slimecross/stabilized/sepia=1,
		/obj/item/slimecross/stabilized/silver=1,
		/obj/item/slimecross/stabilized/yellow=1,
		)
		/obj/item/toy/plush/pkplush,
	generate_items_inside(items_inside,src)
	/obj/item/gun/energy/alien
	/obj/item/spellbook
	/obj/item/hand_tele
	/obj/item/gun/magic/wand/resurrection/debug
	/obj/item/debug/omnitool


	if(!isliving(user))
		return
	user.visible_message(span_danger("Temporarily transforming [user.p_them()] into a slime!"))
	var/datum/action/cooldown/spell/shapeshift/slime_form/transform = new(user.mind || user)
	transform.remove_on_restore = TRUE
	transform.Grant(user)
	transform.cast(user)
*/
////////////////////////////////////////////////////////////////////
/datum/action/cooldown/spell/shapeshift/whoscifer
	name = "Whoscifer Transformation"
	desc = "Transform into a cutie, or back again!"
	button_icon_state = "gib"
	cooldown_time = 0 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	convert_damage = FALSE
	possible_shapes = list(/mob/living/simple_animal/slime/transformed_slime/whoscifer)
	var/mob/living/shapeshifted_form

/mob/living/simple_animal/slime/transformed_slime/whoscifer
	colour = "rainbow"
	var/datum/action/temp_powers = list()

/mob/living/simple_animal/slime/transformed_slime/whoscifer/Initialize(mapload)
	. = ..()
	var/datum/action/whoscifer/rainbow_slime_power/gay = new(src)
	gay.Grant(src)
	temp_powers += gay

/datum/action/whoscifer/IsAvailable(feedback = FALSE)
	return TRUE
/datum/action/whoscifer/rainbow_slime_power
	name = "Rainbow Reproduction!"
	desc = "Produce 3 slimes of random colors."
	button_icon = 'icons/mob/simple/slimes.dmi'
	button_icon_state = "rainbow adult slime"
/datum/action/whoscifer/rainbow_slime_power/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	for (var/i in 1 to 3)
		var/mob/living/simple_animal/slime/S = new(get_turf(owner))
		S.random_colour()
	return TRUE
/////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/drone/whoscifer_drone/proc/on_middle_click(mob/source, atom/target)
	SIGNAL_HANDLER
	src.face_atom(target)
	src.teleport(target)
	return COMSIG_MOB_CANCEL_CLICKON

/mob/living/simple_animal/drone/whoscifer_drone/proc/teleport(atom/target)
	var/turf/open/target_turf = get_turf(target)
	if(!istype(target_turf) || target_turf.is_blocked_turf_ignore_climbable())
		balloon_alert(src, "invalid target!")
		return
	balloon_alert(src, "teleporting...")
	var/matrix/pre_matrix = matrix()
	pre_matrix.Scale(4, 0.25)
	var/matrix/post_matrix = matrix()
	post_matrix.Scale(0.25, 4)
	animate(src, 2, color = LIGHT_COLOR_BLOOD_MAGIC, transform = pre_matrix.Multiply(src.transform), easing = SINE_EASING|EASE_OUT)
	animate(src, 0.5, color = null, transform = post_matrix.Multiply(src.transform), easing = SINE_EASING|EASE_IN)
	if(!do_teleport(src, target_turf, asoundin = 'sound/effects/phasein.ogg', forced = TRUE))
		return

/////////////////////////////////////////////////

/obj/item/slimecross/recurring/rainbow/eternal
	name = "Eternal Slime Core"
	desc = "A dazzlingly bright core wrapped in several layers of slime. Hey, why does it have teeth?!?!"
	icon_state = "consuming"
/obj/item/slimecross/recurring/rainbow/eternal/process(delta_time)
	if(cooldown > 0)
		cooldown -= delta_time
	else
		extract.Uses = 1000000
		cooldown = max_cooldown
/obj/item/slimecross/recurring/rainbow/eternal/Initialize(mapload)
	. = ..()
	name = "Eternal Slime Core"

/obj/item/slimecross/industrial/rainbow/prismatic
	name = "Prismatic Slime Core"
	desc = "A pulsating core shining with all the colors of slimes."
	effect = "industrial"
	icon_state = "stabilized"
	itemamount = 10
	plasmarequired = 1
/obj/item/slimecross/industrial/rainbow/prismatic/Initialize(mapload)
	. = ..()
	name = "Prismatic Slime Core"

////////////////////////////////////////////////////////////////////
/obj/item/extinguisher/mini/whos
	name = "Drone Mini Fire Extinguisher"
	max_water = 1000
/obj/item/extinguisher/mini/whos/afterattack(atom/target, mob/user , flag)
	reagents.total_volume = reagents.maximum_volume
	..()


/obj/item/debug/omnitool/whoscifer
	name = "Whoscifer's Omnitool"
	desc = "The divine tool, shaped before time. Use it in hand to unleash its true power."
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "sunflower"
	inhand_icon_state = "sunflower"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'


/obj/item/reagent_containers/syringe/dronehypo
	name = "Drone Hyposynthesizer"
	desc = "An complete chemical synthesizer and injection system."
	icon = 'icons/obj/medical/syringe.dmi'
	inhand_icon_state = "holy_hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "holy_hypo"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,5,10,20,50,100)

	var/max_volume_per_reagent = 5000
	var/charge_timer = 0
	var/recharge_time = 10
	var/dispensed_temperature = DEFAULT_REAGENT_TEMPERATURE
	var/bypass_protection = TRUE
	var/upgraded = TRUE

	var/list/default_reagent_types
	var/list/expanded_reagent_types
	var/datum/reagents/stored_reagents
	var/datum/reagent/selected_reagent
	var/tgui_theme = "ntos"


/obj/item/reagent_containers/syringe/dronehypo/Initialize(mapload)
	. = ..()
	stored_reagents = new(new_flags = NO_REACT)
	stored_reagents.maximum_volume = length(default_reagent_types) * (max_volume_per_reagent + 1)
	for(var/reagent in default_reagent_types)
		add_new_reagent(reagent)
	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/dronehypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/// Every [recharge_time] seconds, recharge some reagents for the cyborg
/obj/item/reagent_containers/syringe/dronehypo/process(delta_time)
	charge_timer += delta_time
	if(charge_timer >= recharge_time)
		regenerate_reagents(default_reagent_types)
		if(upgraded)
			regenerate_reagents(expanded_reagent_types)
		charge_timer = 0
	return 1

/// Use this to add more chemicals for the dronehypo to produce.
/obj/item/reagent_containers/syringe/dronehypo/proc/add_new_reagent(datum/reagent/reagent)
	stored_reagents.add_reagent(reagent, (max_volume_per_reagent + 1), reagtemp = dispensed_temperature, no_react = TRUE)

/// Regenerate our supply of all reagents (if they're not full already)
/obj/item/reagent_containers/syringe/dronehypo/proc/regenerate_reagents(list/reagents_to_regen)
	for(var/reagent in reagents_to_regen)
		var/datum/reagent/reagent_to_regen = reagent
		if(!stored_reagents.has_reagent(reagent_to_regen, max_volume_per_reagent))
			stored_reagents.add_reagent(reagent_to_regen, max_volume_per_reagent, reagtemp = dispensed_temperature, no_react = TRUE)

/obj/item/reagent_containers/syringe/dronehypo/attack(mob/living/target_mob, mob/living/user, obj/target)
	if(!selected_reagent)
		balloon_alert(user, "no reagent selected!")
		return
	if(!stored_reagents.has_reagent(selected_reagent.type, amount_per_transfer_from_this))
		balloon_alert(user, "not enough [selected_reagent.name]!")
		return


	if(istype(target_mob))
		if(target_mob.try_inject(user, user.zone_selected, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE | (bypass_protection ? INJECT_CHECK_PENETRATE_THICK : 0)))
			// This is the in-between where we're storing the reagent we're going to inject the injectee with
			// because we cannot specify a singular reagent to transfer in trans_to
			var/datum/reagents/hypospray_injector = new()
			stored_reagents.remove_reagent(selected_reagent.type, amount_per_transfer_from_this)
			hypospray_injector.add_reagent(selected_reagent.type, amount_per_transfer_from_this, reagtemp = dispensed_temperature, no_react = TRUE)

			to_chat(target_mob, span_warning("You feel a tiny prick!"))
			to_chat(user, span_notice("You inject [target_mob] with the injector ([selected_reagent.name])."))

			if(target_mob.reagents)
				hypospray_injector.trans_to(target_mob, amount_per_transfer_from_this, transfered_by = user, methods = INJECT)
				balloon_alert(user, "[amount_per_transfer_from_this] unit\s injected")
				log_combat(user, target_mob, "injected", src, "(CHEMICALS: [selected_reagent])")
		else
			balloon_alert(user, "[parse_zone(user.zone_selected)] is blocked!")
	else if(istype(target,/obj/item/reagent_containers))
		reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user, methods = INJECT)
		balloon_alert(user, "[amount_per_transfer_from_this] unit\s transferred")

/obj/item/reagent_containers/syringe/dronehypo/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BorgHypo", name)
		ui.open()

/obj/item/reagent_containers/syringe/dronehypo/ui_data(mob/user)
	var/list/available_reagents = list()
	for(var/datum/reagent/reagent in stored_reagents.reagent_list)
		if(reagent)
			available_reagents.Add(list(list(
				"name" = reagent.name,
				"volume" = round(reagent.volume, 0.01) - 1,
				"description" = reagent.description,
			))) // list in a list because Byond merges the first list...

	var/data = list()
	data["theme"] = tgui_theme
	data["maxVolume"] = max_volume_per_reagent
	data["reagents"] = available_reagents
	data["selectedReagent"] = selected_reagent?.name
	return data

/obj/item/reagent_containers/syringe/dronehypo/attack_self(mob/user)
	ui_interact(user)

/obj/item/reagent_containers/syringe/dronehypo/ui_act(action, params)
	. = ..()
	if(.)
		return

	for(var/datum/reagent/reagent in stored_reagents.reagent_list)
		if(reagent.name == action)
			selected_reagent = reagent
			. = TRUE

			var/mob/living/drone = loc
			playsound(drone, 'sound/effects/pop.ogg', 50, FALSE)
			balloon_alert(drone, "dispensing [selected_reagent.name]")
			break

/obj/item/reagent_containers/syringe/dronehypo/examine(mob/user)
	. = ..()
	. += "Currently loaded: [selected_reagent ? "[selected_reagent]. [selected_reagent.description]" : "nothing."]"
	. += span_notice("<i>Alt+Click</i> to change transfer amount. Currently set to [amount_per_transfer_from_this]u.")

//////////////////////////////////////////////////////////////////////////////////////

/obj/item/toy/plush/moth/whoscifer
	name = "Whoscifer's Moth Plushie"
	inhand_icon_state = "moffplush"
	lefthand_file = 'icons/obj/toys/plushes.dmi'
	righthand_file = 'icons/obj/toys/plushes.dmi'
	layer = BELOW_MOB_LAYER
	divine = TRUE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	var/datum/action/cooldown/spell/pointed/projectile/moth_circle/moth_spell = null

/obj/item/toy/plush/moth/whoscifer/attack_self(mob/user)
	if(!isliving(user))
		return
	if(moth_spell != null)
		qdel(moth_spell)
	else
		moth_spell = new /datum/action/cooldown/spell/pointed/projectile/moth_circle()
		moth_spell.on_activation(user)

	return ..()

obj/projectile/moffplush
	name = "moth plushie"
	icon = 'icons/obj/toys/plushes.dmi'
	icon_state = "moffplush"
	speed = 0.5
	damage = 25
	armour_penetration = 100
	dismemberment = 100
	sharpness = SHARP_EDGED
	wound_bonus = 25
	pass_flags = PASSTABLE | PASSFLAPS
	reflectable = NONE
	eyeblur = 3
	homing = TRUE
/obj/projectile/moffplush/on_hit(atom/target, blocked = FALSE, pierce_hit)
	blocked = FALSE
	playsound(src, 'sound/voice/moth/scream_moth.ogg', 50, TRUE, -1)
	return ..()
/obj/projectile/moffplush/prehit_pierce(atom/hit)
	if(isliving(hit) && isliving(firer))
		var/mob/living/caster = firer
		var/mob/living/victim = hit
		if(caster == victim)
			return PROJECTILE_PIERCE_PHASE
	return ..()

/datum/action/cooldown/spell/pointed/projectile/moth_circle
	name = "Circle of Moths"
	desc = "Summon three moth plushies which orbit you. \
		While orbiting you, these moth will protect you from from attacks, but will be consumed on use. \
		Additionally, you can click to fire the moths at a target, dealing damage, causing bleeding, and dismemberment."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "furious_steel"
	sound = 'sound/voice/moth/scream_moth.ogg'

	school = SCHOOL_CONJURATION
	cooldown_time = 0 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	active_msg = "You summon three moth plushies of cuteness."
	deactive_msg = "You return the moth plushies to their realm."
	cast_range = 20
	projectile_type = /obj/projectile/moffplush
	projectile_amount = 3
	var/datum/status_effect/moth_circle_status/moth_circle_effect

/datum/action/cooldown/spell/pointed/projectile/moth_circle/InterceptClickOn(mob/living/caller, params, atom/click_target)
	if(get_dist(caller, click_target) <= 1)
		return FALSE
	return ..()
/datum/action/cooldown/spell/pointed/projectile/moth_circle/on_activation(mob/on_who)
	. = ..()
	if(!.)
		return

	if(!isliving(on_who))
		return
	// Delete existing
	if(moth_circle_effect)
		UnregisterSignal(moth_circle_effect, COMSIG_PARENT_QDELETING)
		QDEL_NULL(moth_circle_effect)

	set_click_ability(on_who)
	var/mob/living/living_user = on_who
	moth_circle_effect = living_user.apply_status_effect(/datum/status_effect/moth_circle_status, null, projectile_amount, 25, 0.66 SECONDS)
	RegisterSignal(moth_circle_effect, COMSIG_PARENT_QDELETING, PROC_REF(on_status_effect_deleted))

/datum/action/cooldown/spell/pointed/projectile/moth_circle/on_deactivation(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	unset_click_ability(on_who)
	QDEL_NULL(moth_circle_effect)

/datum/action/cooldown/spell/pointed/projectile/moth_circle/fire_projectile(mob/living/user, atom/target)
	. = ..()
	qdel(moth_circle_effect.plushies[1])

/datum/action/cooldown/spell/pointed/projectile/moth_circle/ready_projectile(obj/projectile/to_launch, atom/target, mob/user, iteration)
	. = ..()
	to_launch.def_zone = check_zone(user.zone_selected)

/// If our blade status effect is deleted, clear our refs and deactivate
/datum/action/cooldown/spell/pointed/projectile/moth_circle/proc/on_status_effect_deleted(datum/status_effect/moth_circle_status/source)
	SIGNAL_HANDLER

	moth_circle_effect = null
	on_deactivation()


// BLADES

/// Summons multiple foating knives around the owner.
/// Each knife will block an attack straight up.
/datum/status_effect/moth_circle_status
	id = "moth circle status"
	alert_type = null
	status_type = STATUS_EFFECT_MULTIPLE
	tick_interval = -1
	/// The number of blades we summon up to.
	var/max_num_plushies = 3
	/// The radius of the blade's orbit.
	var/plushie_orbit_radius = 20
	/// The time between spawning blades.
	var/time_between_initial_plushies = 0.25 SECONDS
	/// If TRUE, we self-delete our status effect after all the blades are deleted.
	var/delete_on_plushies_gone = TRUE
	/// A list of blade effects orbiting / protecting our owner
	var/list/obj/effect/floating_plushie/plushies = list()

/datum/status_effect/moth_circle_status/on_creation(
			mob/living/new_owner,
			new_duration = -1,
			max_num_plushies = 3,
			plushie_orbit_radius = 20,
			time_between_initial_plushies = 0.25 SECONDS,
		)
	src.duration = new_duration
	src.max_num_plushies = max_num_plushies
	src.plushie_orbit_radius = plushie_orbit_radius
	src.time_between_initial_plushies = time_between_initial_plushies
	return ..()

/datum/status_effect/moth_circle_status/on_apply()
	RegisterSignal(owner, COMSIG_HUMAN_CHECK_SHIELDS, PROC_REF(on_shield_reaction))
	for(var/plushie_num in 1 to max_num_plushies)
		var/time_until_created = (plushie_num - 1) * time_between_initial_plushies
		if(time_until_created <= 0)
			create_plushie()
		else
			addtimer(CALLBACK(src, PROC_REF(create_plushie)), time_until_created)
	return TRUE

/datum/status_effect/moth_circle_status/on_remove()
	UnregisterSignal(owner, COMSIG_HUMAN_CHECK_SHIELDS)
	QDEL_LIST(plushies)

	return ..()

/// Creates a floating blade, adds it to our blade list, and makes it orbit our owner.
/datum/status_effect/moth_circle_status/proc/create_plushie()
	if(QDELETED(src) || QDELETED(owner))
		return

	var/obj/effect/floating_plushie/plushie = new(get_turf(owner))
	plushies += plushie
	plushie.orbit(owner, plushie_orbit_radius)
	RegisterSignal(plushie, COMSIG_PARENT_QDELETING, PROC_REF(remove_plushie))
	playsound(get_turf(owner), 'sound/voice/moth/scream_moth.ogg', 15, TRUE)

/// Signal proc for [COMSIG_HUMAN_CHECK_SHIELDS].
/// If we have a blade in our list, consume it and block the incoming attack (shield it)
/datum/status_effect/moth_circle_status/proc/on_shield_reaction(
	mob/living/carbon/human/source,
	atom/movable/hitby,
	damage = 0,
	attack_text = "the attack",
	attack_type = MELEE_ATTACK,
	armour_penetration = 0,
)
	SIGNAL_HANDLER

	armour_penetration = 0
	if(!length(plushies))
		return

	if(HAS_TRAIT(source, TRAIT_BEING_BLADE_SHIELDED))
		return

	ADD_TRAIT(source, TRAIT_BEING_BLADE_SHIELDED, type)

	var/obj/effect/floating_plushie/to_remove = plushies[1]

	playsound(get_turf(source), 'sound/voice/moth/scream_moth.ogg', 100, TRUE)
	source.visible_message(
		span_warning("[to_remove] orbiting [source] snaps in front of [attack_text], blocking it before vanishing!"),
		span_warning("[to_remove] orbiting you snaps in front of [attack_text], blocking it before vanishing!"),
		span_hear("You hear a moth scream."),
	)

	qdel(to_remove)

	addtimer(TRAIT_CALLBACK_REMOVE(source, TRAIT_BEING_BLADE_SHIELDED, type), 1)

	return SHIELD_BLOCK

/// Remove deleted blades from our blades list properly.
/datum/status_effect/moth_circle_status/proc/remove_plushie(obj/effect/floating_plushie/to_remove)
	SIGNAL_HANDLER

	if(!(to_remove in plushies))
		CRASH("[type] called remove_plushie() with a plushie that was not in its plushies list.")

	to_remove.stop_orbit(owner.orbiters)
	plushies -= to_remove

	if(!length(plushies) && !QDELETED(src) && delete_on_plushies_gone)
		qdel(src)

	return TRUE

/// A subtype that doesn't self-delete / disappear when all blades are gone
/// It instead regenerates over time back to the max after blades are consumed
/datum/status_effect/moth_circle_status/recharging
	delete_on_plushies_gone = FALSE
	/// The amount of time it takes for a blade to recharge
	var/plushie_recharge_time = 1 SECONDS

/datum/status_effect/moth_circle_status/recharging/on_creation(
	mob/living/new_owner,
	new_duration = -1,
	max_num_plushies = 3,
	plushie_orbit_radius = 20,
	time_between_initial_plushies = 0.25 SECONDS,
	plushie_recharge_time = 1 SECONDS,
)

	src.plushie_recharge_time = plushie_recharge_time
	return ..()

/datum/status_effect/moth_circle_status/recharging/remove_plushie(obj/effect/floating_plushie/to_remove)
	. = ..()
	if(!.)
		return

	addtimer(CALLBACK(src, PROC_REF(create_plushie)), plushie_recharge_time)

/obj/effect/floating_plushie
	name = "floating moth plushie"
	icon = 'icons/obj/toys/plushes.dmi'
	icon_state = "moffplush"
	plane = GAME_PLANE_FOV_HIDDEN
	/// The color the knife glows around it.
	var/glow_color = "#ececff"

/obj/effect/floating_plushie/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/movetype_handler)
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)
	add_filter("moffplush", 2, list("type" = "outline", "color" = glow_color, "size" = 1))
