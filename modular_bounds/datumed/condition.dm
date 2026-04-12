/datum/medical_condition
	abstract_type = /datum/medical_condition
	/// The name of the condition as it appears to players
	var/name = "Unknown Condition"
	/// The base name to reference when updating the name with severity, do not manually set
	var/base_name = null
	/// A brief description of the condition, do not put treatment text in this
	var/desc = "A medical condition of some kind, but it doesn't seem to do anything."
	/// How to treat the condition, if at all
	var/treatment_text = null
	/// The fontawesome icon this will have in the conditions menu
	var/condition_icon = FA_ICON_INFO_CIRCLE
	/// List of alerts for the tgui conditions menu
	var/list/condition_alerts_list = list()
	/// How much of a treatment healing multiplier do we apply to the condition? >1 means faster healing
	var/treatment_heal_multiplier = 1
	/// If the condition should only last a certain amount of time, how long? In SECONDS
	var/natural_cure_time = null
	/// Cooldown between times the severity should drop on this wound
	COOLDOWN_DECLARE(natural_healing_delay)
	/// Generic "severity" tracker, for use by subtypes for whatever they wish
	var/severity = 0
	/// The severity we started with, used for natural healing, don't set directly
	var/starting_severity = 0
	/// Does the name of this datum change based on severity?
	var/severity_changes_name = TRUE
	/// What we call different severity levels, needs to be in proper order like shown here
	var/severity_name_thresholds = list(
		"Severe" = INFINITY,
		"Moderate" = 6,
		"Minor" = 3,
		"Negligible" = 1,
	)
	/// The owner of this condition
	var/mob/living/carbon/owner = null
	/// The specific limb of the owner we are applied to, always null for whole body conditions
	var/obj/item/bodypart/owner_bodypart = null
	/// The maximum health offset this wound can have, modified by severity, negative lowers health
	var/maximum_health_offset = 0
	/// The actual health offset modified by severity, do not set directly
	var/health_offset = 0
	/// If this can be applied to a limb independent of if that limb is actually there or not, for delimbing wounds
	var/limb_independence = FALSE

/datum/medical_condition/New(new_severity)
	severity = min(CONDITION_SEVERITY_MAX, new_severity)
	starting_severity = severity
	base_name = name

/datum/medical_condition/Destroy(force)
	owner = null
	owner_bodypart = null
	return ..()

/// What to do to the mob and or the limb on application
/datum/medical_condition/proc/on_application(mob/living/carbon/victim, obj/item/bodypart/target_bodypart)
	SHOULD_CALL_PARENT(TRUE)
	if(!victim || (!limb_independence && !target_bodypart))
		message_admins("Condition \"[src.name]\" has no target, or needs a target bodypart and didn't get one!")
		qdel(src) // ?? How did you do that
		return
	owner = victim
	if(target_bodypart)
		owner_bodypart = target_bodypart
	if(natural_cure_time)
		COOLDOWN_START(src, natural_healing_delay, natural_cure_time / 20)
	update_condition_name()
	health_offset = maximum_health_offset * SEVERITY_2_PERCENT(severity)
	if(treatment_text)
		condition_alerts_list |= list(
			CONDITION_UI_TREATMENT = treatment_text
		)

/// What to do to the mob and or the limb on removal
/datum/medical_condition/proc/on_removal()
	SHOULD_CALL_PARENT(TRUE)
	if(owner)
		owner.medical_conditions -= src
	qdel(src)

/// Connected to life processing to the owner mob, for condition progression, or constant effects
/datum/medical_condition/proc/owner_process(seconds_per_tick)
	SHOULD_CALL_PARENT(TRUE)
	if(!owner || severity <= 0)
		on_removal()
		return
	if((!owner.get_bodypart(owner.medical_conditions[src])) && !limb_independence)
		on_removal()
		return
	update_condition_name()
	if(COOLDOWN_FINISHED(src, natural_healing_delay))
		natural_healing()
		COOLDOWN_START(src, natural_healing_delay, natural_cure_time / 20)
	health_offset = maximum_health_offset * SEVERITY_2_PERCENT(severity)
	if(treatment_heal_multiplier != 1)
		condition_alerts_list |= list(
			CONDITION_UI_TREATMENT_QUALITY = "This condition has been treated to a quality of [treatment_heal_multiplier * 100], changing the rate it heals at."
		)

/// Called when the natural healing cooldown has finished
/datum/medical_condition/proc/natural_healing()
	severity = round(treatment_heal_multiplier * max(severity - (starting_severity / 20),  0), DAMAGE_PRECISION)

/// Updates the name of the datum depending on severity level
/datum/medical_condition/proc/update_condition_name()
	if(!severity_changes_name)
		return
	var/severity_append = null
	var/last_iterator_stored = null
	for(var/iterator as anything in severity_name_thresholds)
		if(severity <= severity_name_thresholds[iterator])
			last_iterator_stored = iterator
			continue
		severity_append = last_iterator_stored
		break
	name = "[base_name] ([severity_append])"
