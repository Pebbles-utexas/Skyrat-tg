// Build Stages
#define SPACEPOD_EMPTY 1
#define SPACEPOD_WIRES_LOOSE 2
#define SPACEPOD_WIRES_SECURED 3
#define SPACEPOD_CIRCUIT_LOOSE 4
#define SPACEPOD_CIRCUIT_SECURED 5
#define SPACEPOD_CORE_LOOSE 6
#define SPACEPOD_CORE_SECURED 7
#define SPACEPOD_BULKHEAD_LOOSE 8
#define SPACEPOD_BULKHEAD_SECURED 9
#define SPACEPOD_BULKHEAD_WELDED 10
#define SPACEPOD_ARMOR_LOOSE 11
#define SPACEPOD_ARMOR_SECURED 12
#define SPACEPOD_ARMOR_WELDED 13

// Slots
#define SPACEPOD_SLOT_CARGO "cargo"
#define SPACEPOD_SLOT_MISC "misc"
#define SPACEPOD_SLOT_WEAPON "weapon"
#define SPACEPOD_SLOT_LOCK "lock"
#define SPACEPOD_SLOT_LIGHT "light"
#define SPACEPOD_SLOT_THRUSTER "thruster"

#define SPACEPOD_WEAPON_SLOT_LEFT "Left Weapon Slot"
#define SPACEPOD_WEAPON_SLOT_RIGHT "Right Weapon Slot"

<<<<<<<< HEAD:modular_skyrat/modules/spacepods/code/_spacepod_defines.dm
========
#define SPACEPOD_DEFAULT_EQUIPMENT_LIMITS_LIST list(SPACEPOD_SLOT_MISC = 5, SPACEPOD_SLOT_CARGO = 2, SPACEPOD_SLOT_WEAPON = 2, SPACEPOD_SLOT_LOCK = 1, SPACEPOD_SLOT_LIGHT = 1, SPACEPOD_SLOT_THRUSTER = 1)

// Rider stuff
#define SPACEPOD_RIDER_TYPE_PILOT "pilot"
#define SPACEPOD_RIDER_TYPE_PASSENGER "passenger"

#define SPACEPOD_RIDER_TYPE "type"
#define SPACEPOD_RIDER_TRAITS "traits"
#define SPACEPOD_RIDER_ACTIONS "actions"

// Impact stuff
#define SPACEPOD_IMPACT_HEAVY 10
#define SPACEPOD_IMPACT_LIGHT 5

>>>>>>>> spaceballs:code/__DEFINES/~skyrat_defines/spacepod_defines.dm
/// A list of lighthouses that enable the spacepods to teleport to.
GLOBAL_LIST_EMPTY(spacepod_beacons)
