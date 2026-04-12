/obj/item/bodypart/proc/refresh_bleed_rate()
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	var/old_bleed_rate = cached_bleed_rate
	cached_bleed_rate = 0
	if(!owner)
		return
	if(!can_bleed())
		if(cached_bleed_rate != old_bleed_rate)
			update_part_wound_overlay()
		return
	if(generic_bleedstacks > 0)
		cached_bleed_rate += 0.5
	// In 99% of situations we won't get to this point if we aren't wired or blooded
	// But I'm covering my ass in case someone adds some weird new species
	var/surgery_bloodloss = 0
	if(biological_state & BIOSTATE_HAS_VESSELS)
		// better clamp those up quick
		if(HAS_ANY_SURGERY_STATE(surgery_state, SURGERY_VESSELS_UNCLAMPED))
			surgery_bloodloss += UNCLAMPED_VESSELS_BLEEDING
		// better, but still not exactly ideal
		else if(HAS_ANY_SURGERY_STATE(surgery_state, SURGERY_VESSELS_CLAMPED|SURGERY_ORGANS_CUT))
			surgery_bloodloss += CLAMPED_VESSELS_BLEEDING
		// modify rate so cutting everything open won't nuke people
		if(body_zone == BODY_ZONE_HEAD)
			surgery_bloodloss *= 0.5
		else if(body_zone != BODY_ZONE_CHEST)
			surgery_bloodloss *= 0.25
		// bonus for being gauzed up
		if(LAZYACCESS(applied_items, LIMB_ITEM_GAUZE))
			surgery_bloodloss *= 0.4
		cached_bleed_rate += surgery_bloodloss
	for(var/obj/item/embeddies as anything in embedded_objects)
		if(!embeddies.get_embed().is_harmless())
			cached_bleed_rate += 0.25
	for(var/datum/medical_condition/wound/condition in owner.medical_conditions)
		if(!condition.causes_bleeding)
			continue
		cached_bleed_rate += condition.actual_bleeding_amount
	if(owner.body_position == LYING_DOWN)
		cached_bleed_rate *= 0.75
	if(grasped_by)
		cached_bleed_rate *= 0.7
	if(LAZYACCESS(applied_items, LIMB_ITEM_TOURNIQUET))
		cached_bleed_rate *= 0.1
	// Our bleed overlay is based directly off bleed_rate, so go aheead and update that would you?
	if(cached_bleed_rate != old_bleed_rate)
		update_part_wound_overlay()
	return cached_bleed_rate
