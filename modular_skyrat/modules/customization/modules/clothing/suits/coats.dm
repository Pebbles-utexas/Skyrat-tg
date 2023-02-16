/obj/item/clothing/suit/hooded/wintercoat
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/hooded/wintercoat/medical/paramedic
	allowed = list(/obj/item/analyzer, /obj/item/stack/medical, /obj/item/dnainjector, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/hypospray, /obj/item/healthanalyzer, /obj/item/flashlight/pen, /obj/item/reagent_containers/cup/bottle, /obj/item/reagent_containers/cup/beaker, /obj/item/reagent_containers/pill, /obj/item/storage/pill_bottle, /obj/item/paper, /obj/item/melee/baton/telescopic, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)
	armor_type = /datum/armor/wintercoat_paramedic

/datum/armor/wintercoat_paramedic
	bio = 50
	acid = 45
	wound = 3

/obj/item/clothing/suit/hooded/wintercoat/bartender
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	name = "bartender's winter coat"
	desc = "A heavy jacket made from wool originally stolen from the chef's goat. This new design is made to fit the classic suit-and-tie aesthetic, but without the hypothermia."
	icon_state = "coatbar"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/reagent_containers/cup/glass/shaker, /obj/item/reagent_containers/cup/glass/flask, /obj/item/reagent_containers/cup/rag)
	hoodtype = /obj/item/clothing/head/hooded/winterhood/bartender

/obj/item/clothing/head/hooded/winterhood/bartender
	icon = 'modular_skyrat/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head.dmi'
	icon_state = "winterhood_bar"

/obj/item/clothing/suit/hooded/wintercoat/aformal
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	name = "assistant's formal winter coat"
	desc = "A black button up winter coat."
	icon_state = "coataformal"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter,/obj/item/clothing/gloves/color/yellow)
	hoodtype = /obj/item/clothing/head/hooded/winterhood/aformal

/obj/item/clothing/head/hooded/winterhood/aformal
	icon = 'modular_skyrat/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head.dmi'
	desc = "A black winter coat hood."
	icon_state = "winterhood_aformal"

/obj/item/clothing/suit/hooded/wintercoat/ratvar
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	name = "ratvarian winter coat"
	desc = "A brass-plated button up winter coat. Instead of a zipper tab, it has a brass cog with a tiny red gemstone inset."
	icon_state = "coatratvar"
	armor_type = /datum/armor/wintercoat_ratvar
	hoodtype = /obj/item/clothing/head/hooded/winterhood/ratvar

/datum/armor/wintercoat_ratvar
	melee = 30
	melee = 45
	laser = -10
	bomb = 30
	fire = 60
	acid = 60
	wound = 10

/obj/item/clothing/head/hooded/winterhood/ratvar
	icon = 'modular_skyrat/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head.dmi'
	icon_state = "winterhood_ratvar"
	desc = "A brass-plated winter hood that glows softly, hinting at its divinity."
	light_range = 3
	light_power = 1
	light_color = "#B18B25" //clockwork slab background top color

/obj/item/clothing/suit/hooded/wintercoat/narsie
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	name = "narsian winter coat"
	desc = "A somber button-up in tones of grey entropy and a wicked crimson zipper. When pulled all the way up, the zipper looks like a bloody gash. The zipper pull looks like a single drop of blood."
	icon_state = "coatnarsie"
	armor_type = /datum/armor/wintercoat_narsie
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/restraints/legcuffs/bola/cult,/obj/item/melee/cultblade,/obj/item/melee/cultblade/dagger,/obj/item/reagent_containers/cup/beaker/unholywater,/obj/item/cult_shift,/obj/item/flashlight/flare/culttorch,/obj/item/melee/cultblade/halberd)
	hoodtype = /obj/item/clothing/head/hooded/winterhood/narsie

/datum/armor/wintercoat_narsie
	melee = 30
	melee = 20
	laser = 30
	energy = 10
	bomb = 30
	bio = 10
	fire = 30
	acid = 30
	wound = 10

/obj/item/clothing/head/hooded/winterhood/narsie
	icon = 'modular_skyrat/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head.dmi'
	desc = "A black winter hood full of whispering secrets that only she shall ever know."
	icon_state = "winterhood_narsie"

/obj/item/clothing/suit/hooded/wintercoat/ratvar/fake
	name = "brass winter coat"
	desc = "A brass-plated button up winter coat. Instead of a zipper tab, it has a brass cog with a tiny red piece of plastic as an inset."
	icon_state = "coatratvar"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter)
	armor_type = /datum/armor/none

/obj/item/clothing/suit/hooded/wintercoat/narsie/fake
	name = "runed winter coat"
	desc = "A dusty button up winter coat in the tones of oblivion and ash. The zipper pull looks like a single drop of blood."
	icon_state = "coatnarsie"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter)
	armor_type = /datum/armor/none

/obj/item/clothing/suit/flakjack
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	name = "flak jacket"
	desc = "A dilapidated jacket made of a supposedly bullet-proof material (Hint: It isn't.). Smells faintly of napalm."
	icon_state = "flakjack"
	inhand_icon_state = "armor"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	resistance_flags = NONE
	armor_type = /datum/armor/suit_flakjack
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/datum/armor/suit_flakjack
	bomb = 5
	fire = -5
	acid = -15

/obj/item/clothing/suit/hooded/cloak/david
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	name = "red cloak"
	icon_state = "goliath_cloak"
	desc = "Ever wanted to look like a badass without ANY effort? Try this nanotrasen brand red cloak, perfect for kids"
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/david
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/hooded/cloakhood/david
	icon = 'modular_skyrat/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head.dmi'
	name = "red cloak hood"
	icon_state = "golhood"
	desc = "conceal your face in shame with this nanotrasen brand hood"
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/urban
	name = "urban coat"
	desc = "A coat built for urban life."
	icon_state = "urban_coat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	greyscale_config = /datum/greyscale_config/urban_coat
	greyscale_config_worn = /datum/greyscale_config/urban_coat/worn
	greyscale_colors = "#252e5a#938060#66562b"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/toggle/deckard
	name = "runner coat"
	desc = "They say you overused reference. Tell them you're eating in this lovely coat, a long flowing brown one."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "deckard"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	inhand_icon_state = "det_suit"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor_type = /datum/armor/toggle_deckard
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS

/datum/armor/toggle_deckard
	melee = 25
	bullet = 10
	laser = 25
	energy = 35
	acid = 45

/obj/item/clothing/suit/jacket/leather/colourable
	desc = "Now with more color!"
	icon_state = "leather_jacket"
	greyscale_config = /datum/greyscale_config/leather_jacket
	greyscale_config_worn = /datum/greyscale_config/leather_jacket/worn
	greyscale_colors = "#FFFFFF"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/duster
	name = "duster"
	desc = "This station ain't big enough for the both of us."
	icon_state = "duster"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	greyscale_config = /datum/greyscale_config/duster
	greyscale_config_worn = /datum/greyscale_config/duster/worn
	greyscale_colors = "#954b21"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/toggle/peacoat
	name = "peacoat"
	desc = "The way you guys are blending in with the local colour. I mean, Flag Girl was bad enough, but U-Boat Captain?"
	icon_state = "peacoat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	greyscale_config = /datum/greyscale_config/peacoat
	greyscale_config_worn = /datum/greyscale_config/peacoat/worn
	greyscale_colors = "#61618a"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/toggle/lawyer/black/better
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "suitjacket_black"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/costume/poncho
	supports_variations_flags = STYLE_TAUR_ALL

/obj/item/clothing/suit/apron
	supports_variations_flags = STYLE_TAUR_ALL

/obj/item/clothing/suit/toggle/lawyer/white
	name = "white suit jacket"
	desc = "A very versatile part of a suit ensable. Oddly in fashion with mobsters."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "suitjacket_white"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/hooded/wintercoat/christmas
	name = "red christmas coat"
	desc = "A festive red Christmas coat! Smells like Candy Cane!"
	icon_state = "christmascoatr"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	hoodtype = /obj/item/clothing/head/hooded/winterhood/christmas

/obj/item/clothing/head/hooded/winterhood/christmas
	icon = 'modular_skyrat/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head.dmi'
	icon_state = "christmashoodr"

/obj/item/clothing/suit/hooded/wintercoat/christmas/green
	name = "green christmas coat"
	desc = "A festive green Christmas coat! Smells like Candy Cane!"
	icon_state = "christmascoatg"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	hoodtype = /obj/item/clothing/head/hooded/winterhood/christmas/green

/obj/item/clothing/head/hooded/winterhood/christmas/green
	icon_state = "christmashoodg"

/obj/item/clothing/suit/hooded/wintercoat/christmas/gamerpc
	name = "red and green christmas coat"
	desc = "A festive red and green Christmas coat! Smells like Candy Cane!"
	icon_state = "christmascoatrg"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/christmas/gamerpc

/obj/item/clothing/head/hooded/winterhood/christmas/gamerpc
	icon_state = "christmashoodrg"

/obj/item/clothing/suit/armor/vest/det_suit/runner
	name = "joyful coat"
	desc = "<i>\"You look like a good Joe.\"</i>"
	icon_state = "bladerunner_neue"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|ARMS|LEGS
	heat_protection = CHEST|ARMS|GROIN|LEGS
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	blood_overlay_type = "coat"

/obj/item/clothing/suit/croptop
	name = "black crop top turtleneck"
	desc = "A comfy looking turtleneck that exposes your midriff, fashionable but makes the point of a sweater moot."
	icon_state = "croptop_black"
	body_parts_covered = CHEST|ARMS
	cold_protection = CHEST|ARMS
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/varsity
	name = "varsity jacket"
	desc = "A simple varsity jacket with no obvious sources."
	icon_state = "varsity_jacket"
	greyscale_config = /datum/greyscale_config/varsity
	greyscale_config_worn = /datum/greyscale_config/varsity/worn
	greyscale_colors = "#553022#a67a5b#2d2d33"
	body_parts_covered = CHEST|GROIN|ARMS
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/hooded/leather
	name = "hooded leather coat"
	desc = "A simple leather coat with a hoodie underneath it, not really hooded is it?"
	icon_state = "leatherhoodie"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	hoodtype = /obj/item/clothing/head/hooded/leather

/obj/item/clothing/head/hooded/leather
	name = "jacket hood"
	desc = "A hood attached to a hoodie, nothing special."
	icon_state = "leatherhood"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head.dmi'
	flags_inv = HIDEHAIR

/obj/item/clothing/suit/tailored_jacket
	name = "tailored jacket"
	desc = "A somewhat long jacket tailor made for... however it looks right now!"
	icon_state = "tailored_jacket"
	greyscale_config = /datum/greyscale_config/tailored_jacket
	greyscale_config_worn = /datum/greyscale_config/tailored_jacket/worn
	greyscale_colors = "#8c8c8c#8c8c8c#8c8c8c#bf9f78#8c8c8c#8c8c8c#8c8c8c#bf9f78#8c8c8c" // Look this has a lot of colorable sections
	body_parts_covered = CHEST|ARMS
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/tailored_jacket/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "sleeves")

/obj/item/clothing/suit/tailored_jacket/short
	name = "tailored short jacket"
	desc = "A jacket tailor made for... however it looks right now!"
	greyscale_config = /datum/greyscale_config/tailored_short_jacket
	greyscale_config_worn = /datum/greyscale_config/tailored_short_jacket/worn
	greyscale_colors = "#8c8c8c#8c8c8c#8c8c8c#bf9f78#8c8c8c#8c8c8c#bf9f78#8c8c8c"
