//Medical modules for MODsuits

#define HEALTH_SCAN "Health"
#define WOUND_SCAN "Wound"
#define CHEM_SCAN "Chemical"

///Health Analyzer - Gives the user a ranged health analyzer and their health status in the panel.
/obj/item/mod/module/health_analyzer
	name = "MOD health analyzer module"
	desc = "A module installed into the glove of the suit. This is a high-tech biological scanning suite, \
		allowing the user indepth information on the vitals and injuries of others even at a distance, \
		all with the flick of the wrist. Data is displayed in a convenient package on HUD in the helmet, \
		but it's up to you to do something with it."
	icon_state = "health"
	module_type = MODULE_ACTIVE
	complexity = 2
	use_power_cost = DEFAULT_CHARGE_DRAIN
	incompatible_modules = list(/obj/item/mod/module/health_analyzer)
	cooldown_time = 0.5 SECONDS
	tgui_id = "health_analyzer"
	/// Scanning mode, changes how we scan something.
	var/mode = HEALTH_SCAN
	/// List of all scanning modes.
	var/static/list/modes = list(HEALTH_SCAN, WOUND_SCAN, CHEM_SCAN)

/obj/item/mod/module/health_analyzer/add_ui_data()
	. = ..()
	.["userhealth"] = mod.wearer?.health || 0
	.["usermaxhealth"] = mod.wearer?.getMaxHealth() || 0
	.["userbrute"] = mod.wearer?.getBruteLoss() || 0
	.["userburn"] = mod.wearer?.getFireLoss() || 0
	.["usertoxin"] = mod.wearer?.getToxLoss() || 0
	.["useroxy"] = mod.wearer?.getOxyLoss() || 0

/obj/item/mod/module/health_analyzer/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	if(!isliving(target) || !mod.wearer.can_read(src))
		return
	switch(mode)
		if(HEALTH_SCAN)
			healthscan(mod.wearer, target)
		if(WOUND_SCAN)
			woundscan(mod.wearer, target)
		if(CHEM_SCAN)
			chemscan(mod.wearer, target)
	drain_power(use_power_cost)

/obj/item/mod/module/health_analyzer/get_configuration()
	. = ..()
	.["mode"] = add_ui_configuration("Scan Mode", "list", mode, modes)

/obj/item/mod/module/health_analyzer/configure_edit(key, value)
	switch(key)
		if("mode")
			mode = value

#undef HEALTH_SCAN
#undef WOUND_SCAN
#undef CHEM_SCAN

///Quick Carry - Lets the user carry bodies quicker.
/obj/item/mod/module/quick_carry
	name = "MOD quick carry module"
	desc = "A suite of advanced servos, redirecting power from the suit's arms to help carry the wounded; \
		or simply for fun. However, Nanotrasen has locked the module's ability to assist in hand-to-hand combat."
	icon_state = "carry"
	complexity = 1
	idle_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	incompatible_modules = list(/obj/item/mod/module/quick_carry, /obj/item/mod/module/constructor)

/obj/item/mod/module/quick_carry/on_suit_activation()
	ADD_TRAIT(mod.wearer, TRAIT_QUICKER_CARRY, MOD_TRAIT)

/obj/item/mod/module/quick_carry/on_suit_deactivation(deleting = FALSE)
	REMOVE_TRAIT(mod.wearer, TRAIT_QUICKER_CARRY, MOD_TRAIT)

/obj/item/mod/module/quick_carry/advanced
	name = "MOD advanced quick carry module"
	removable = FALSE
	complexity = 0

/obj/item/mod/module/quick_carry/on_suit_activation()
	. = ..()
	ADD_TRAIT(mod.wearer, TRAIT_FASTMED, MOD_TRAIT)

/obj/item/mod/module/quick_carry/on_suit_deactivation(deleting = FALSE)
	. = ..()
	REMOVE_TRAIT(mod.wearer, TRAIT_FASTMED, MOD_TRAIT)

///Injector - Gives the suit an extendable large-capacity piercing syringe.
/obj/item/mod/module/injector
	name = "MOD injector module"
	desc = "A module installed into the wrist of the suit, this functions as a high-capacity syringe, \
		with a tip fine enough to locate the emergency injection ports on any suit of armor, \
		penetrating it with ease. Even yours."
	icon_state = "injector"
	module_type = MODULE_ACTIVE
	complexity = 1
	active_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	device = /obj/item/reagent_containers/syringe/mod
	incompatible_modules = list(/obj/item/mod/module/injector)
	cooldown_time = 0.5 SECONDS

/obj/item/reagent_containers/syringe/mod
	name = "MOD injector syringe"
	desc = "A high-capacity syringe, with a tip fine enough to locate \
		the emergency injection ports on any suit of armor, penetrating it with ease. Even yours."
	icon_state = "mod_0"
	base_icon_state = "mod"
	amount_per_transfer_from_this = 30
	possible_transfer_amounts = list(5, 10, 15, 20, 30)
	volume = 30
	inject_flags = INJECT_CHECK_PENETRATE_THICK

///Organ Thrower - Lets you shoot organs, immediately replacing them if the target has the organ manipulation surgery.
/obj/item/mod/module/organ_thrower
	name = "MOD organ thrower module"
	desc = "A device recovered from a crashed Interdyne Pharmaceuticals vessel, \
		this module has been unearthed for better or for worse. \
		It's an arm-mounted device utilizing technology similar to modern-day part replacers, \
		capable of storing and inserting organs into open patients. \
		It's recommended by the DeForest Medical Corporation to not inform patients it has been used."
	icon_state = "organ_thrower"
	module_type = MODULE_ACTIVE
	complexity = 2
	use_power_cost = DEFAULT_CHARGE_DRAIN
	incompatible_modules = list(/obj/item/mod/module/organ_thrower, /obj/item/mod/module/microwave_beam)
	cooldown_time = 0.5 SECONDS
	/// How many organs the module can hold.
	var/max_organs = 5
	/// A list of all our organs.
	var/organ_list = list()

/obj/item/mod/module/organ_thrower/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/wearer_human = mod.wearer
	if(isorgan(target))
		if(!wearer_human.Adjacent(target))
			return
		var/atom/movable/organ = target
		if(length(organ_list) >= max_organs)
			balloon_alert(mod.wearer, "too many organs!")
			return
		organ_list += organ
		organ.forceMove(src)
		balloon_alert(mod.wearer, "picked up [organ]")
		playsound(src, 'sound/mecha/hydraulic.ogg', 25, TRUE)
		drain_power(use_power_cost)
		return
	if(!length(organ_list))
		return
	var/atom/movable/fired_organ = pop(organ_list)
	var/obj/projectile/organ/projectile = new /obj/projectile/organ(mod.wearer.loc, fired_organ)
	projectile.preparePixelProjectile(target, mod.wearer)
	projectile.firer = mod.wearer
	playsound(src, 'sound/mecha/hydraulic.ogg', 25, TRUE)
	INVOKE_ASYNC(projectile, /obj/projectile.proc/fire)
	drain_power(use_power_cost)

/obj/projectile/organ
	name = "organ"
	damage = 0
	nodamage = TRUE
	hitsound = 'sound/effects/attackblob.ogg'
	hitsound_wall = 'sound/effects/attackblob.ogg'
	/// A reference to the organ we "are".
	var/obj/item/organ/organ

/obj/projectile/organ/Initialize(mapload, obj/item/stored_organ)
	. = ..()
	if(!stored_organ)
		return INITIALIZE_HINT_QDEL
	appearance = stored_organ.appearance
	stored_organ.forceMove(src)
	organ = stored_organ

/obj/projectile/organ/Destroy()
	organ = null
	return ..()

/obj/projectile/organ/on_hit(atom/target)
	. = ..()
	if(!ishuman(target))
		organ.forceMove(drop_location())
		organ = null
		return
	var/mob/living/carbon/human/organ_receiver = target
	var/succeed = FALSE
	if(organ_receiver.surgeries.len)
		for(var/datum/surgery/procedure as anything in organ_receiver.surgeries)
			if(procedure.location != organ.zone)
				continue
			if(!istype(procedure, /datum/surgery/organ_manipulation))
				continue
			var/datum/surgery_step/surgery_step = procedure.get_surgery_step()
			if(!istype(surgery_step, /datum/surgery_step/manipulate_organs))
				continue
			succeed = TRUE
			break
	if(succeed)
		var/list/organs_to_boot_out = organ_receiver.getorganslot(organ.slot)
		for(var/obj/item/organ/organ_evacced as anything in organs_to_boot_out)
			if(organ_evacced.organ_flags & ORGAN_UNREMOVABLE)
				continue
			organ_evacced.Remove(target)
			organ_evacced.forceMove(get_turf(target))
		organ.Insert(target)
	else
		organ.forceMove(drop_location())
	organ = null

///Patrient Transport - Generates hardlight bags you can put people in.
/obj/item/mod/module/criminalcapture/patienttransport
	name = "MOD patient transport module"
	desc = "A module built into the forearm of the suit. Countless waves of mostly-lost mining teams being sent to \
		Indecipheries and other hazardous locations have taught the DeForest Medical Company many lessons. \
		Physical bodybags are difficult to store, hard to deploy, and even worse to keep intact in tough scenarios. \
		Enter the hardlight transport bag. Summonable with merely a gesture, weightless, and immunized against \
		any extreme scenario the wearer could think of, this bag is perfectly designed for \
		transport of any body in any environment, any time."
	icon_state = "patient_transport"
	bodybag_type = /obj/structure/closet/body_bag/environmental/hardlight
	capture_time = 1.5 SECONDS
	packup_time = 0.5 SECONDS

///Defibrillator - Gives the suit an extendable pair of shock paddles.
/obj/item/mod/module/defibrillator
	name = "MOD defibrillator module"
	desc = "A module built into the gauntlets of the suit; commonly known as the 'Healing Hands' by medical professionals. \
		The user places their palms above the patient. Onboard computers in the suit calculate the necessary voltage, \
		and a modded targeting computer determines the best position for the user to push. \
		Twenty five pounds of force are applied to the patient's skin. Shocks travel from the suit's gloves \
		and counter-shock the heart, and the wearer returns to Medical a hero. Don't you even think about using it as a weapon; \
		regulations on manufacture and software locks expressly forbid it."
	icon_state = "defibrillator"
	module_type = MODULE_ACTIVE
	complexity = 2
	use_power_cost = DEFAULT_CHARGE_DRAIN * 25
	device = /obj/item/shockpaddles/mod
	incompatible_modules = list(/obj/item/mod/module/defibrillator)
	cooldown_time = 0.5 SECONDS
	var/defib_cooldown = 5 SECONDS

/obj/item/mod/module/defibrillator/Initialize(mapload)
	. = ..()
	RegisterSignal(device, COMSIG_DEFIBRILLATOR_SUCCESS, .proc/on_defib_success)

/obj/item/mod/module/defibrillator/proc/on_defib_success(obj/item/shockpaddles/source)
	drain_power(use_power_cost)
	source.recharge(defib_cooldown)
	return COMPONENT_DEFIB_STOP

/obj/item/shockpaddles/mod
	name = "MOD defibrillator paddles"
	req_defib = FALSE

///Thread Ripper - Temporarily rips apart clothing to make it not cover the body.
/obj/item/mod/module/thread_ripper
	name = "MOD thread ripper module"
	desc = "A custom-built module integrated with the suit's wrist. The thread ripper is built from \
		recent technology dating back to the start of 2562, after an attempt by a well-known Nanotrasen researcher to \
		expand on the rapid-tailoring technology found in Autodrobes. Rather than being capable of creating \
		any fabric pattern under the suns, the thread ripper is capable of rapid disassembly of them. \
		Anything from kevlar-weave, to leather, to durathread can be quickly pulled open to the wearer's specification \
		and sewn back together, a development commonly utilized by Medical workers to obtain easy access for \
		surgery, defibrillation, or injection of chemicals to ease patients into not worrying about their \
		brand-name fashion being marred."
	icon_state = "thread_ripper"
	module_type = MODULE_ACTIVE
	complexity = 2
	use_power_cost = DEFAULT_CHARGE_DRAIN
	incompatible_modules = list(/obj/item/mod/module/thread_ripper)
	cooldown_time = 1.5 SECONDS
	overlay_state_inactive = "module_threadripper"
	/// An associated list of ripped clothing and the body part covering slots they covered before
	var/list/ripped_clothing = list()

/obj/item/mod/module/thread_ripper/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	if(!mod.wearer.Adjacent(target) || !iscarbon(target) || target == mod.wearer)
		balloon_alert(mod.wearer, "invalid target!")
		return
	var/mob/living/carbon/carbon_target = target
	if(length(ripped_clothing))
		balloon_alert(mod.wearer, "already ripped!")
		return
	balloon_alert(mod.wearer, "ripping clothing...")
	playsound(src, 'sound/items/zip.ogg', 25, TRUE, frequency = -1)
	if(!do_after(mod.wearer, 1.5 SECONDS, target = carbon_target))
		balloon_alert(mod.wearer, "interrupted!")
		return
	var/target_zones = body_zone2cover_flags(mod.wearer.zone_selected)
	for(var/obj/item/clothing as anything in carbon_target.get_all_worn_items())
		if(!clothing)
			continue
		var/shared_flags = target_zones & clothing.body_parts_covered
		if(shared_flags)
			ripped_clothing[clothing] = shared_flags
			clothing.body_parts_covered &= ~shared_flags

/obj/item/mod/module/thread_ripper/on_process(delta_time)
	. = ..()
	if(!.)
		return
	if(!length(ripped_clothing))
		return
	var/zipped = FALSE
	for(var/obj/item/clothing as anything in ripped_clothing)
		if(QDELETED(clothing))
			ripped_clothing -= clothing
			continue
		var/mob/living/carbon/clothing_wearer = clothing.loc
		if(istype(clothing_wearer) && mod.wearer.Adjacent(clothing_wearer) && !clothing_wearer.is_holding(clothing))
			continue
		zipped = TRUE
		clothing.body_parts_covered |= ripped_clothing[clothing]
		ripped_clothing -= clothing
	if(zipped)
		playsound(src, 'sound/items/zip.ogg', 25, TRUE)
		balloon_alert(mod.wearer, "clothing mended")

/obj/item/mod/module/thread_ripper/on_suit_deactivation(deleting)
	if(!length(ripped_clothing))
		return
	for(var/obj/item/clothing as anything in ripped_clothing)
		if(QDELETED(clothing))
			ripped_clothing -= clothing
			continue
		clothing.body_parts_covered |= ripped_clothing[clothing]
	ripped_clothing = list()
	if(!deleting)
		playsound(src, 'sound/items/zip.ogg', 25, TRUE)

///Surgical Processor - Lets you do advanced surgeries portably.
/obj/item/mod/module/surgical_processor
	name = "MOD surgical processor module"
	desc = "A module using an onboard surgical computer which can be connected to other computers to download and \
		perform advanced surgeries on the go."
	icon_state = "surgical_processor"
	module_type = MODULE_ACTIVE
	complexity = 2
	active_power_cost = DEFAULT_CHARGE_DRAIN
	device = /obj/item/surgical_processor/mod
	incompatible_modules = list(/obj/item/mod/module/surgical_processor)
	cooldown_time = 0.5 SECONDS

/obj/item/surgical_processor/mod
	name = "MOD surgical processor"

/obj/item/mod/module/status_readout/generic
	name = "MOD status readout module"
	desc = "A once-common module, this technology went unfortunately out of fashion; \
		but still remaining in older suit variations. This hooks into the suit's spine, \
		capable of capturing and displaying all possible biometric data of the wearer; sleep, nutrition, fitness, fingerprints, \
		and even useful information such as their overall health and wellness."

///Blatant copy of the adrenaline boost module.
/obj/item/mod/module/auto_doc
	name = "MOD automatic paramedical module"
	desc = "The reverse-engineered and redesigned medical assistance system, previously used by the now decommissioned VOSKHOD combat armor. \
		The technology it uses is very similar to the one of Spider Clan, yet Innovations and Defense Collegium reject any similarities. \
		Using a built-in storage of chemical compounds and miniature surgical robots capable of pinpoint damage treatment,\
		it's capable of injecting its user with simple painkillers and coagulants, assisting them with their restoration, as long as they don't overdose themselves. \
		However, this system heavily relies on some rarely combat-available chemical compounds to prepare its injections, mainly Cryptobiolin, which appear in the user's bloodstream from time to time, \
		and its trivial damage assesment systems are inadequate for complete restoration purposes."
	icon_state = "adrenaline_boost"
	module_type = MODULE_TOGGLE
	incompatible_modules = list(/obj/item/mod/module/adrenaline_boost, /obj/item/mod/module/auto_doc)
	cooldown_time = null
	complexity = 4
	use_power_cost = DEFAULT_CHARGE_DRAIN*20
	/// What reagent we need to refill?
	var/reagent_required = /datum/reagent/cryptobiolin
	/// How much of a reagent we need to refill a single boost.
	var/reagent_required_amount = 0
	/// Maximum amount of reagents this module can hold.
	var/reagent_max_amount = 120
	/// Health threshold above which the module won't heal.
	var/health_threshold = 100
	/// Amount of raw damage heal per treatment.
	var/heal_amount = 10
	/// Amount of raw stamdamage heal per treatment.
	var/stamina_heal_amount = 50
	/// Cooldown betwen each treatment.
	var/heal_cooldown = 10 SECONDS

	/// Timer for the cooldown
	COOLDOWN_DECLARE(heal_timer)

/obj/item/mod/module/auto_doc/Initialize(mapload)
	. = ..()
	create_reagents(reagent_max_amount)
	reagents.add_reagent(reagent_required, reagent_max_amount)

/obj/item/mod/module/auto_doc/on_activation()
	. = ..()
	if(!.)
		return
	RegisterSignal(mod.wearer, COMSIG_CARBON_HEALTH_UPDATE, .proc/on_use)
	drain_power(use_power_cost)

/obj/item/mod/module/auto_doc/on_use()
	if(!COOLDOWN_FINISHED(src, heal_timer))
		return FALSE
	if(!check_power(use_power_cost))
		balloon_alert(mod.wearer, "not enough charge!")
		SEND_SIGNAL(src, COMSIG_MODULE_DEACTIVATED)
		return FALSE
	if(!allowed_in_phaseout && istype(mod.wearer.loc, /obj/effect/dummy/phased_mob))
		to_chat(mod.wearer, span_warning("You cannot activate this right now."))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_MODULE_TRIGGERED) & MOD_ABORT_USE)
		return FALSE
	if(!reagents.has_reagent(reagent_required, reagent_required_amount))
		balloon_alert(mod.wearer, "not enough chems!")
		SEND_SIGNAL(src, COMSIG_MODULE_DEACTIVATED)
		return FALSE
	if(mod.wearer.health > health_threshold)
		return
	var/new_bruteloss = mod.wearer.getBruteLoss()
	var/new_fireloss = mod.wearer.getFireLoss()
	var/new_toxloss = mod.wearer.getToxLoss()
	var/new_stamloss = mod.wearer.getStaminaLoss()
	playsound(mod.wearer, 'modular_skyrat/modules/hev_suit/sound/hev/hiss.ogg', 100)
	if(new_bruteloss)
		mod.wearer.adjustBruteLoss(-heal_amount)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/mine_salve, 10)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/sal_acid, 5)
		to_chat(mod.wearer, span_warning("Brute treatment administered. Overdose risks present on further use, consult your first-aid analyzer."))
	if(new_fireloss)
		mod.wearer.adjustFireLoss(-heal_amount)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/mine_salve, 10)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/oxandrolone, 5)
		to_chat(mod.wearer, span_warning("Burn treatment administered. Overdose risks present on further use, consult your first-aid analyzer."))
	if(new_toxloss)
		mod.wearer.adjustToxLoss(-heal_amount)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/mine_salve, 10)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/pen_acid, 5)
		to_chat(mod.wearer, span_warning("Toxin treatment administered. Overdose risks present on further use, consult your first-aid analyzer."))
	if(new_stamloss)
		mod.wearer.adjustStaminaLoss(-stamina_heal_amount)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/mine_salve, 10)
		mod.wearer.reagents.add_reagent(/datum/reagent/medicine/stimulants, 10)
		to_chat(mod.wearer, span_warning("Combat stimulants administered. Overdose risks present on further use, consult your first-aid analyzer."))
	mod.wearer.reagents.add_reagent(/datum/reagent/medicine/coagulant, 5)
	reagents.remove_reagent(reagent_required, reagent_required_amount)
	drain_power(use_power_cost*10)
	addtimer(CALLBACK(src, .proc/boost_aftereffects, mod.wearer), 45 SECONDS)
	COOLDOWN_START(src, heal_timer, heal_cooldown)

/obj/item/mod/module/auto_doc/proc/charge_boost(obj/item/attacking_item, mob/user)
	if(!attacking_item.is_open_container())
		return FALSE
	if(reagents.has_reagent(reagent_required, reagent_max_amount))
		balloon_alert(mod.wearer, "already full!")
		return FALSE
	if(!attacking_item.reagents.trans_id_to(src, reagent_required, reagent_required_amount))
		return FALSE
	balloon_alert(mod.wearer, "charge reloaded")
	return TRUE

/obj/item/mod/module/auto_doc/on_deactivation(display_message = TRUE, deleting = FALSE)
	. = ..()
	UnregisterSignal(mod.wearer, COMSIG_CARBON_HEALTH_UPDATE)

/obj/item/mod/module/auto_doc/on_install()
	RegisterSignal(mod, COMSIG_PARENT_ATTACKBY, .proc/on_attackby)

/obj/item/mod/module/auto_doc/on_uninstall(deleting)
	UnregisterSignal(mod, COMSIG_PARENT_ATTACKBY)

/obj/item/mod/module/auto_doc/attackby(obj/item/attacking_item, mob/user, params)
	if(charge_boost(attacking_item, user))
		return TRUE
	return ..()

/obj/item/mod/module/auto_doc/proc/on_attackby(datum/source, obj/item/attacking_item, mob/user)
	SIGNAL_HANDLER

	if(charge_boost(attacking_item, user))
		return COMPONENT_NO_AFTERATTACK
	return NONE

/obj/item/mod/module/auto_doc/proc/boost_aftereffects(mob/affected_mob)
	if(!affected_mob)
		return
	mod.wearer.reagents.add_reagent(/datum/reagent/cryptobiolin, 10)
	mod.wearer.reagents.add_reagent(/datum/reagent/drug/maint/sludge, 5)
	to_chat(affected_mob, span_danger("Your head starts slightly spinning, and your chest hurts."))
