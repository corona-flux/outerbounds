/datum/medical_condition/wound/cut
	name = "Cut"
	desc = "The limb has been cut."
	treatment_text = "Bandage to stop the bleeding and improve healing."
	natural_cure_time = 10 MINUTES
	maximum_health_offset = -15
	causes_bleeding = TRUE
	max_bleeding_amount = 0.1
	condition_icon = FA_ICON_SCISSORS

/datum/medical_condition/wound/scratch
	name = "Scratch"
	desc = "The limb has been scratched."
	treatment_text = "Bandage to stop the bleeding and improve healing."
	natural_cure_time = 7 MINUTES
	maximum_health_offset = -5
	causes_bleeding = TRUE
	max_bleeding_amount = 0.05
	condition_icon = FA_ICON_SCISSORS

/datum/medical_condition/wound/bite
	name = "Bite"
	desc = "The limb has been bitten."
	treatment_text = "Bandage to stop the bleeding and improve healing."
	natural_cure_time = 10 MINUTES
	maximum_health_offset = -10
	causes_bleeding = TRUE
	max_bleeding_amount = 0.1125
	condition_icon = FA_ICON_SCISSORS

/datum/medical_condition/wound/stab
	name = "Stab"
	desc = "The limb has been stabbed."
	treatment_text = "Bandage to stop the bleeding and improve healing."
	natural_cure_time = 13 MINUTES
	maximum_health_offset = -10
	causes_bleeding = TRUE
	max_bleeding_amount = 0.375
	condition_icon = FA_ICON_SCISSORS

/datum/medical_condition/wound/gunshot
	name = "Gunshot"
	desc = "The limb has been shot through with a projectile."
	treatment_text = "Bandage to stop the bleeding and improve healing."
	natural_cure_time = 15 MINUTES
	maximum_health_offset = -25
	causes_bleeding = TRUE
	max_bleeding_amount = 0.375
	condition_icon = FA_ICON_SCISSORS

/datum/medical_condition/wound/shred
	name = "Shredded"
	desc = "The limb has been shredded and mangled."
	treatment_text = "Bandage to stop the bleeding and improve healing."
	natural_cure_time = 20 MINUTES
	maximum_health_offset = -25
	causes_bleeding = TRUE
	max_bleeding_amount = 0.5625
	condition_icon = FA_ICON_SCISSORS
