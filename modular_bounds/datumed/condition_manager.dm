/mob/living/carbon
	/// List of all active conditions as well as what body zone they are tied to
	var/list/medical_conditions = list()
	/// List of limbs that we need to update the bleeding on at the end of processing wounds
	var/list/limbs_with_conditions_to_update = list()

/// Runs through all of the conditions on a mob and updates them
/mob/living/carbon/proc/update_medical_conditions(seconds_per_tick)
	for(var/datum/medical_condition/condition as anything in medical_conditions)
		condition.owner_process(seconds_per_tick)
	for(var/obj/item/bodypart/part as anything in limbs_with_conditions_to_update)
		part.refresh_bleed_rate()

/// Adds a medical condition to the target body zone, or the whole body if none provided and one not needed by the datum
/mob/living/carbon/proc/add_medical_condition(datum/medical_condition/condition, target_body_zone)
	if(!target_body_zone && !condition.limb_independence)
		message_admins("[src] tried to add a condition that requires a specific bodypart defined with no bodypart defined!")
		return
	if(!get_bodypart(target_body_zone))
		return // Much more likely to happen, but still wrong
	var/datum/medical_condition/new_condition = new condition()
	medical_conditions += new_condition
	new_condition.on_application(src, target_body_zone ? get_bodypart(target_body_zone) : null)
	medical_conditions[new_condition] = target_body_zone ? target_body_zone : CONDITION_FULL_BODY
