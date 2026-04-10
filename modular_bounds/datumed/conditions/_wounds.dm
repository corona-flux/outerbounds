/datum/medical_condition/wound
	abstract_type = /datum/medical_condition/wound
	name = "Unknown Wound"
	desc = "A wound of some kind, but it doesn't seem to do anything."
	treatment_text = null
	natural_cure_time = null
	severity = null
	health_offset = 0
	limb_independence = FALSE
	/// Does this wound cause bleeding?
	var/causes_bleeding = FALSE
	/// How much bleed per life tick does the wound cause maximum
	var/max_bleeding_amount = 0
	/// How much bleed per life tick does the wound actually cause, modified by severity
	var/actual_bleeding_amount = 0

/datum/medical_condition/wound/New(new_severity)
	. = ..()
	if(causes_bleeding)
		max_bleeding_amount *= SEVERITY_2_PERCENT(severity)

/datum/medical_condition/wound/on_application(mob/living/carbon/victim, obj/item/bodypart/target_bodypart)
	. = ..()
	actual_bleeding_amount = max_bleeding_amount

/datum/medical_condition/wound/natural_healing()
	. = ..()
	if(causes_bleeding) // Wounds will stop bleeding before they fully heal
		actual_bleeding_amount = max(round(actual_bleeding_amount - (max_bleeding_amount / 10), DAMAGE_PRECISION), 0)
		if(actual_bleeding_amount <= 0)
			causes_bleeding = FALSE
