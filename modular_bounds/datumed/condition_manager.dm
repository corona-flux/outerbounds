/mob/living/carbon
	/// List of all active conditions as well as what body zone they are tied to
	var/list/medical_conditions = list()

/mob/living/carbon/proc/add_medical_condition(datum/medical_condition/condition, target_body_zone)
	if(!target_body_zone && !condition.limb_independence)
		message_admins("[src] tried to add a condition that requires a specific bodypart defined with no bodypart defined!")
		return
	if(!get_bodypart(target_body_zone))
		return // Much more likely to happen, but still wrong
	var/datum/medical_condition/new_condition = new condition()
	medical_conditions += new_condition
	new_condition.on_application(src, target_body_zone ? get_bodypart(target_body_zone) : null)
	medical_conditions[new_condition] = target_body_zone
