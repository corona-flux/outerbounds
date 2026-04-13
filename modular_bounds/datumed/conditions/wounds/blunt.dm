/datum/medical_condition/wound/crushing
	name = "Crush"
	desc = "The limb has been crushed by a large blunt force."
	treatment_text = "Time cures all wounds."
	natural_cure_time = 10 MINUTES
	maximum_health_offset = -20
	condition_icon = FA_ICON_BURST

/datum/medical_condition/wound/crack
	name = "Crack"
	desc = "The bone within the limb has been cracked."
	treatment_text = "Time cures all wounds."
	natural_cure_time = 15 MINUTES
	maximum_health_offset = -15
	condition_icon = FA_ICON_BURST

/datum/medical_condition/wound/bruise
	name = "Bruise"
	desc = "The skin has been bruised by a blunt force."
	treatment_text = "Time cures all wounds."
	natural_cure_time = 7 MINUTES
	maximum_health_offset = -8
	severity_name_thresholds = list(
		"Tender" = 3,
		"Stinging" = 6,
		"Bad" = INFINITY,
	)
	condition_icon = FA_ICON_BURST
