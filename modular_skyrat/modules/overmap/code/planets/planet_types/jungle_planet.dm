/datum/planet_template/jungle_planet
	name = "Jungle Planet"
	area_type = /area/planet/jungle
	generator_type = /datum/map_generator/planet_gen/jungle

	default_traits_input = list(ZTRAIT_MINING = TRUE, ZTRAIT_BASETURF = /turf/open/floor/planetary/rock)
	overmap_type = /datum/overmap_object/shuttle/planet/jungle
	atmosphere_type = /datum/atmosphere/jungle
	weather_controller_type = /datum/weather_controller/lush

	rock_color = list(COLOR_BEIGE_GRAYISH, COLOR_BEIGE, COLOR_ASTEROID_ROCK)
	plant_color = list(COLOR_PALE_BTL_GREEN)
	plant_color_as_grass = TRUE

/datum/overmap_object/shuttle/planet/jungle
	name = "Jungle Planet"
	planet_color = COLOR_PALE_BTL_GREEN

/area/planet/jungle
	name = "Jungle Planet Surface"
	ambientsounds = list(
		'modular_skyrat/master_files/sound/ambience/jungle.ogg',
		'modular_skyrat/master_files/sound/ambience/eeriejungle1.ogg',
		'modular_skyrat/master_files/sound/ambience/eeriejungle2.ogg',
	)
	min_ambience_cooldown = 2 MINUTES
	max_ambience_cooldown = 3 MINUTES

/datum/map_generator/planet_gen/jungle
	possible_biomes = list(
	BIOME_LOW_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/plains,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/mudlands,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/mudlands,
		BIOME_HIGH_HUMIDITY = /datum/biome/water,
		),
	BIOME_LOWMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/plains,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/jungle,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/jungle,
		BIOME_HIGH_HUMIDITY = /datum/biome/mudlands,
		),
	BIOME_HIGHMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/plains,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/plains,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/jungle/deep,
		BIOME_HIGH_HUMIDITY = /datum/biome/jungle,
		),
	BIOME_HIGH_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/wasteland,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/plains,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/jungle,
		BIOME_HIGH_HUMIDITY = /datum/biome/jungle/deep,
		),
	)
	high_height_biome = /datum/biome/mountain
	perlin_zoom = 30

/datum/biome/mudlands
	turf_type = /turf/open/floor/planetary/dirt/jungle/dark
	flora_types = list(
		/obj/structure/flora/grass/jungle,
		/obj/structure/flora/grass/jungle/b,
		/obj/structure/flora/rock/style_random,
		/obj/structure/flora/rock/pile/jungle/large/style_random,
	)
	flora_density = 3

/datum/biome/plains
	turf_type = /turf/open/floor/planetary/grass
	flora_types = list(
		/obj/structure/flora/grass/jungle,
		/obj/structure/flora/grass/jungle/b,
		/obj/structure/flora/tree/jungle,
		/obj/structure/flora/rock/style_random,
		/obj/structure/flora/bush/jungle/a/style_random,
		/obj/structure/flora/bush/jungle/b/style_random,
		/obj/structure/flora/bush/jungle/c/style_random,
		/obj/structure/flora/rock/pile/jungle/large/style_random
	)
	flora_density = 15

/datum/biome/jungle
	turf_type = /turf/open/floor/planetary/grass
	flora_types = list(
		/obj/structure/flora/grass/jungle,
		/obj/structure/flora/grass/jungle/b,
		/obj/structure/flora/tree/jungle,
		/obj/structure/flora/bush/jungle/a/style_random,
		/obj/structure/flora/bush/jungle/b/style_random,
		/obj/structure/flora/bush/jungle/c/style_random,
		/obj/structure/flora/bush/large/style_random,
		/obj/structure/flora/rock/pile/jungle/style_random,
		/obj/structure/flora/rock/pile/jungle/large/style_random,
	)
	flora_density = 40
	fauna_density = 0.5
	fauna_weight_types = list(
		/mob/living/simple_animal/hostile/jungle/leaper = 100,
		/mob/living/simple_animal/hostile/jungle/mega_arachnid = 100,
		/mob/living/simple_animal/hostile/jungle/mook = 100,
		/mob/living/simple_animal/hostile/jungle/seedling = 100,
	)

/datum/biome/jungle/deep
	flora_density = 65
	fauna_density = 0.5
	fauna_weight_types = list(
		/mob/living/simple_animal/hostile/jungle/leaper = 100,
		/mob/living/simple_animal/hostile/jungle/mega_arachnid = 100,
		/mob/living/simple_animal/hostile/jungle/mook = 100,
		/mob/living/simple_animal/hostile/jungle/seedling = 100,
	)

/datum/biome/wasteland
	turf_type = /turf/open/floor/planetary/wasteland

/datum/atmosphere/jungle
	base_gases = list(
		/datum/gas/nitrogen=10,
		/datum/gas/oxygen=40,
	)
	normal_gases = list(
		/datum/gas/oxygen=5,
		/datum/gas/nitrogen=5,
	)
	restricted_chance = 0

	minimum_pressure = ONE_ATMOSPHERE - 10
	maximum_pressure = ONE_ATMOSPHERE + 20

	minimum_temp = T20C
	maximum_temp = BODYTEMP_HEAT_DAMAGE_LIMIT -10
