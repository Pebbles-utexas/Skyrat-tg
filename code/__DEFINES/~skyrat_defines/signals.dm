//Movable signals
///When someone talks into a radio
#define COMSIG_MOVABLE_RADIO_TALK_INTO "movable_radio_talk_into"				//from radio talk_into(): (obj/item/radio/radio, message, channel, list/spans, datum/language/language, direct)

//Mob signals
///Resting position for living mob updated
#define COMSIG_LIVING_UPDATED_RESTING "living_updated_resting" //from base of (/mob/living/proc/update_resting): (resting)
///Horror form bombastic flag
#define COMSIG_HORRORFORM_EXPLODE "horrorform_explode"
///Fired in combat_indicator.dm, used for syncing CI between mech and pilot
#define COMSIG_MOB_CI_TOGGLED "mob_ci_toggled"
/// When a hostile simple mob loses it's target.
#define COMSIG_HOSTILE_MOB_LOST_TARGET "hostile_mob_lost_target"

//Gun signals
///When a gun is switched to automatic fire mode
#define COMSIG_GUN_AUTOFIRE_SELECTED "gun_autofire_selected"
///When a gun is switched off of automatic fire mode
#define COMSIG_GUN_AUTOFIRE_DESELECTED "gun_autofire_deselected"
///The gun needs to update the gun hud!
#define COMSIG_UPDATE_AMMO_HUD "update_ammo_hud"

/// Used by /obj/item/melee/hammer
#define COMSIG_BREACHING "breaching_signal_woop_woop"
///The gun has jammed.
#define COMSIG_GUN_JAMMED "gun_jammed"

//Mutant stuff
///When a mutant is cured of the virus
#define COMSIG_MUTANT_CURED "mutant_cured"

// Power signals
/// Sent when an obj/item calls item_use_power: (use_amount, user, check_only)
#define COMSIG_ITEM_POWER_USE "item_use_power"
	#define NO_COMPONENT NONE
	#define COMPONENT_POWER_SUCCESS (1<<0)
	#define COMPONENT_NO_CELL  (1<<1)
	#define COMPONENT_NO_CHARGE (1<<2)

// Health signals
/// /mob/living/proc/updatehealth()
#define COMSIG_MOB_RUN_ARMOR "mob_run_armor"
/// /mob/living/proc/adjustBruteLoss (amount)
#define COMSIG_MOB_LOSS_BRUTE "mob_loss_brute"
/// /mob/living/proc/adjustBurnLoss (amount)
#define COMSIG_MOB_LOSS_FIRE "mob_loss_fire"
/// /mob/living/proc/adjustCloneLoss (amount)
#define COMSIG_MOB_LOSS_CLONE "mob_loss_clone"
/// /mob/living/proc/adjustToxLoss (amount)
#define COMSIG_MOB_LOSS_TOX "mob_loss_tox"
////mob/living/proc/adjustOyxLoss (amount)
#define COMSIG_MOB_LOSS_OXY "mob_loss_oxy"
////mob/living/proc/adjustStaminaLoss (amount)
#define COMSIG_MOB_LOSS_STAMINA "mob_loss_stamina"
/// /mob/living/proc/adjustOrganLoss (slot, amount)
#define COMSIG_MOB_LOSS_ORGAN "mob_loss_organ"
///from base of /turf/handle_fall(): (mob/faller)
#define COMSIG_TURF_MOB_FALL "turf_mob_fall"
///from base of /obj/effect/abstract/liquid_turf/Initialize() (/obj/effect/abstract/liquid_turf/liquids)
#define COMSIG_TURF_LIQUIDS_CREATION "turf_liquids_creation"

/// Called in /obj/machinery/atmospherics/components/unary/engine/DrawThrust(), and in /obj/machinery/power/shuttle_engine/proc/DrawThrust()
#define COMSIG_ENGINE_DRAWN_POWER "engine_drawn_power"

//when someone casts their fishing rod
#define COMSIG_START_FISHING "start_fishing"
//when someone pulls back their fishing rod
#define COMSIG_FINISH_FISHING "finish_fishing"

/// /client/MouseMove(object, location, control, params)
#define COMSIG_MOB_CLIENT_MOUSE_MOVE "client_mob_mouse_move"

/// /client/MouseMove(object, location, control, params)
#define COMSIG_MOB_CLIENT_MOUSE_MOVE "client_mob_mouse_move"

/// From mob/living/*/set_combat_mode(): (new_state)
#define COMSIG_LIVING_COMBAT_MODE_TOGGLE "living_combat_mode_toggle"


/// when someone attempts to evolve through the rune
#define COMSIG_RUNE_EVOLUTION "rune_evolution"

/// To chambered round on gun's `process_fire()`: (list/iff_factions)
#define COMSIG_CHAMBERED_BULLET_FIRE "chambered_bullet_fire"

/// /datum/component/clockwork_trap signals: ()
#define COMSIG_CLOCKWORK_SIGNAL_RECEIVED "clock_received"

/// Called when a clock cultist uses a clockwork slab: (obj/item/clockwork/clockwork_slab/slab)
#define COMSIG_CLOCKWORK_SLAB_USED "clockwork_slab_used"

/// Engineering Override Access manual toggle
#define COMSIG_GLOB_FORCE_ENG_OVERRIDE "force_engineering_override"

// Physics signals

/// Used to set the direction in which we are going to apply thrust to an object.
#define COMSIG_PHYSICS_SET_THRUST_DIR "physics_set_thrust_dir"

/// Used to set the desired angle of a physics component.
#define COMSIG_PHYSICS_SET_DESIRED_ANGLE "physics_set_desired_angle"

/// Used to set the angle of a physics component. (new_angle)
#define COMSIG_PHYSICS_SET_ANGLE "physics_set_angle"

/// Sets the velocity of a physics component. (new_velocity_x, new_velocity_y)
#define COMSIG_PHYSICS_SET_VELOCITY "physics_set_velocity"

/// Sets the MAX velocity of a physics component. (new_max_velocity_x, new_max_velocity_y)
#define COMSIG_PHYSICS_SET_MAX_VELOCITY "physics_set_max_velocity"

/// Sets the max thrust of a physics component. (forward_maxthrust, backwards_maxthrust, sidways_maxthrust)
#define COMSIG_PHYSICS_SET_MAX_THRUST "physics_set_max_thrust"

/// Sets the max thrust velocity of a physics component (max_thrust_velocity)
#define COMSIG_PHYSICS_SET_MAX_THRUST_VELOCITY "physics_set_max_thrust_velocity"

/// Sent when a physics component processes and updates itself. (updated_angle, updated_velocity_x, updated_velocity_y, updated_offset_x, updated_offset_y)
#define COMSIG_PHYSICS_UPDATE_MOVEMENT "physics_update_movement"

/// Sent when a physics component processes a physics based bump. (bump_velocity, bumped_atom)
#define COMSIG_PHYSICS_PROCESSED_BUMP "physics_processed_bump"

/// Sent to check if the physics component can apply thrust to the atom. (source, total_x, total_y, desired_thrust_dir, seconds_per_tick)
#define COMSIG_PHYSICS_THRUST_CHECK "physics_thrust_check"
	/// Return bitflag for enabled thrust.
	#define COMPONENT_PHYSICS_THRUST (1<<0)

/// Sent to check if the physics component can autostabilise. (source)
#define COMSIG_PHYSICS_AUTOSTABILISE_CHECK "physics_autostabilise_check"
	/// Return bitflag for enabled stabilisation.
	#define COMPONENT_PHYSICS_AUTO_STABILISATION (1<<0)

/// sent when a missile locks onto a target.
#define COMSIG_MISSILE_LOCK "missile_lock"

/// sent when a missile loses target lock on a target.
#define COMSIG_MISSILE_LOCK_LOST "missile_lock_lost"
