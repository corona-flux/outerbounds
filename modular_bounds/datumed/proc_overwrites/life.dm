/mob/living/carbon/Life(seconds_per_tick = SSMOBS_DT)
	if(HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return
	if(damageoverlaytemp)
		damageoverlaytemp = 0
		update_damage_hud()
	for(var/datum/wound/wound as anything in all_wounds)
		if(!wound.processes) // meh
			continue
		wound.handle_process(seconds_per_tick)
	if(HAS_TRAIT(src, TRAIT_STASIS))
		. = ..()
		reagents?.handle_stasis_chems(src, seconds_per_tick)
	else
		//Reagent processing needs to come before breathing, to prevent edge cases.
		handle_dead_metabolization(seconds_per_tick) //Dead metabolization first since it can modify life metabolization.
		handle_organs(seconds_per_tick)
		. = ..()
		if(QDELETED(src))
			return
		if(.) //not dead
			handle_blood(seconds_per_tick)
		if(stat != DEAD) // still not dead (blood could have changed that)
			for(var/key in mind?.addiction_points)
				GLOB.addictions[key].process_addiction(src, seconds_per_tick)
			handle_brain_damage(seconds_per_tick)
	if(stat != DEAD)
		handle_bodyparts(seconds_per_tick)
	if(stat != DEAD)
		return TRUE
