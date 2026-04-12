/obj/item/stack/medical/outerbounds
	/// Does this stack item work on non_organics or not
	var/works_on_non_organics = FALSE
	/// The treatment quality of this bandage, should be usually no greater than 1 unless its like super medicine
	var/treatment_quality = 0

/obj/item/stack/medical/outerbounds/heal_carbon(mob/living/carbon/patient, mob/living/user, healed_zone)
	return TRUE

/obj/item/stack/medical/outerbounds/heal_simplemob(mob/living/patient, mob/living/user)
	return TRUE

/obj/item/stack/medical/outerbounds/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/living/user)
	return

/obj/item/stack/medical/outerbounds/can_heal(mob/living/patient, mob/living/user, healed_zone, silent = FALSE)
	return patient.try_inject(user, healed_zone, injection_flags = silent ? NONE : INJECT_TRY_SHOW_ERROR_MESSAGE)

/obj/item/stack/medical/outerbounds/try_heal_checks(mob/living/patient, mob/living/user, healed_zone, silent = FALSE)
	if(!(healed_zone in patient.get_all_limbs()))
		healed_zone = BODY_ZONE_CHEST
	if(!can_heal(patient, user, healed_zone, silent))
		return FALSE
	if(!works_on_dead && patient.stat == DEAD)
		if(!silent)
			patient.balloon_alert(user, "[patient.p_theyre()] dead!")
		return FALSE
	if(iscarbon(patient))
		var/mob/living/carbon/carbon_patient = patient
		var/obj/item/bodypart/affecting = carbon_patient.get_bodypart(healed_zone)
		if(!affecting) //Missing limb?
			if(!silent)
				carbon_patient.balloon_alert(user, "no [parse_zone(healed_zone)]!")
			return FALSE
		if(!IS_ORGANIC_LIMB(affecting) && !works_on_non_organics) //Limb must be organic to be healed - RR
			if(!silent)
				carbon_patient.balloon_alert(user, "[affecting.plaintext_zone] is not organic!")
			return FALSE
		return TRUE
	if(isanimal_or_basicmob(patient))
		if(!heal_brute) // only brute can heal
			if(!silent)
				patient.balloon_alert(user, "can't heal with [name]!")
			return FALSE
		if(!(patient.mob_biotypes & MOB_ORGANIC))
			if(!silent)
				patient.balloon_alert(user, "no organic tissue!")
			return FALSE
		if(patient.health == patient.maxHealth)
			if(!silent)
				patient.balloon_alert(user, "not hurt!")
			return FALSE
		return TRUE
	return FALSE
