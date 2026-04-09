/datum/medical_condition
	abstract_type = /datum/medical_condition
	/// The name of the condition as it appears to players
	var/name = "Unknown Condition"
	/// A brief description of the condition, do not put treatment text in this
	var/desc = "A medical condition of some kind, but it doesn't seem to do anything."
	/// How to treat the condition, if at all
	var/treatment_text = null
	/// If the condition should only last a certain amount of time, how long? In SECONDS
	var/natural_cure_time = null
	/// Timer for the condition naturally going away, can be modified
	var/natural_cure_timer = null
	/// Generic "severity" tracker, for use by subtypes for whatever they wish
	var/severity = null
	/// The owner of this condition
	var/mob/living/carbon/owner = null
	/// The specific limb of the owner we are applied to, always null for whole body conditions
	var/obj/item/bodypart/owner_bodypart = null
	/// If this condition offsets mob health while active and by how much, greater or less than zero, negative lowers health
	var/health_offset = 0
	/// If this can be applied to a limb independent of if that limb is actually there or not, for delimbing wounds
	var/limb_independence = FALSE

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
		natural_cure_timer = addtimer(CALLBACK(src, PROC_REF(on_removal)), natural_cure_time, TIMER_STOPPABLE | TIMER_UNIQUE)

/// What to do to the mob and or the limb on removal
/datum/medical_condition/proc/on_removal(mob/living/carbon/victim, obj/item/bodypart/target_bodypart)
	SHOULD_CALL_PARENT(TRUE)
	if(victim)
		victim.medical_conditions -= src
	qdel(src)

/// Connected to life processing to the owner mob, for condition progression, or constant effects
/datum/medical_condition/proc/owner_process(mob/living/carbon/victim)
	SHOULD_CALL_PARENT(TRUE)
	if(!victim) // ?? Bad things are happening
		on_removal()
		return
	if(!victim.get_bodypart(victim.medical_conditions[src]))
		on_removal()
		return
