// This is cheaper than adding to the Topic() of atom
/datum/element/examined_when_worn

/datum/element/examined_when_worn/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_TOPIC, PROC_REF(on_topic))
	ADD_TRAIT(target, TRAIT_WORN_EXAMINE, TRAIT_SUBTREE_REQUIRED_OPERATIONAL_DATUM)

/datum/element/examined_when_worn/proc/on_topic(atom/source, mob/user, href_list)
	if(href_list["examine_loadout"])
		user.run_examinate(source)
		return

/datum/element/examined_when_worn/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, COMSIG_TOPIC)
	REMOVE_TRAIT(source, TRAIT_WORN_EXAMINE, TRAIT_SUBTREE_REQUIRED_OPERATIONAL_DATUM)


/atom/proc/examine_title_worn(mob/user)
	var/regular_examine = src.examine_title(user)
	if(HAS_TRAIT_FROM(src, TRAIT_WORN_EXAMINE, TRAIT_SUBTREE_REQUIRED_OPERATIONAL_DATUM)) // Uses /datum/element/examined_when_worn
		return "<a href='?src=[REF(src)];examine_loadout=1;'>[regular_examine]</a>"
	else
		return regular_examine
