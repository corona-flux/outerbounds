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

/datum/medical_condition/wound/debug_damage_wound
	name = "Debug Damage Wound"
	desc = "Ow Ow Ow Owwwiie."
	treatment_text = "Start praying."
	natural_cure_time = 3 MINUTES
	severity = CONDITION_SEVERITY_MAX
	health_offset = -15
	limb_independence = TRUE
