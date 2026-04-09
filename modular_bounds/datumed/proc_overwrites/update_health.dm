/mob/living/carbon/updatehealth()
	if(HAS_TRAIT(src, TRAIT_GODMODE))
		return
	var/health_offset = 0
	for(var/datum/medical_condition/condition as anything in medical_conditions)
		health_offset += condition.health_offset // Most of these may also just be zero
	var/new_health = min(maxHealth, round(maxHealth + health_offset, DAMAGE_PRECISION))
	set_health(new_health)
	update_stat()
	update_stamina()
	/// The amount of burn damage needed to be done for this mob to be husked
	// var/husk_threshold = get_bodypart(BODY_ZONE_CHEST).max_damage * -1
	// if(((maxHealth - total_burn) < husk_threshold) && stat == DEAD )
		// become_husk(BURN)
	med_hud_set_health()
	if(stat == SOFT_CRIT)
		add_movespeed_modifier(/datum/movespeed_modifier/carbon_softcrit)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/carbon_softcrit)
	SEND_SIGNAL(src, COMSIG_LIVING_HEALTH_UPDATE)
