/obj/item/stack/medical/outerbounds/bandage
	name = "debug bandage"
	desc = "should stop bleeding wounds"

/obj/item/stack/medical/outerbounds/bandage/can_heal(mob/living/patient, mob/living/user, healed_zone, silent = FALSE)
	var/mob/living/carbon/carbon_patient = patient
	if(!istype(carbon_patient))
		return FALSE
	if(length(carbon_patient.treatable_conditions[CONDITION_BANDAGABLE]))
		for(var/condition as anything in carbon_patient.treatable_conditions[CONDITION_BANDAGABLE])
			if(carbon_patient.treatable_conditions[CONDITION_BANDAGABLE][condition] == healed_zone)
				return TRUE
	return FALSE

/obj/item/stack/medical/outerbounds/bandage/heal_carbon(mob/living/carbon/patient, mob/living/user, healed_zone)
	var/obj/item/bodypart/affecting = patient.get_bodypart(healed_zone)
	user.visible_message(
		span_green("[user] wraps [src] around [patient]'s [affecting.plaintext_zone]."),
		span_green("You wrap [src] around [patient]'s [affecting.plaintext_zone]."),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)
	var/list/treatable_conditions_to_us = list()
	for(var/datum/medical_condition/condition as anything in patient.treatable_conditions[CONDITION_BANDAGABLE])
		if(patient.treatable_conditions[CONDITION_BANDAGABLE][condition] == healed_zone)
			treatable_conditions_to_us += condition
	var/datum/medical_condition/picked_condition = pick(treatable_conditions_to_us)
	if(istype(picked_condition, /datum/medical_condition/wound))
		var/datum/medical_condition/wound/picked_wound = picked_condition
		picked_wound.causes_bleeding = FALSE
	picked_condition.treatment_heal_multiplier += treatment_quality
	post_heal_effects(0, patient, user)
	return TRUE

/obj/item/stack/medical/outerbounds/bandage/heal_simplemob(mob/living/patient, mob/living/user)
	return TRUE

/obj/item/stack/medical/outerbounds/bandage/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/living/user)
	return
