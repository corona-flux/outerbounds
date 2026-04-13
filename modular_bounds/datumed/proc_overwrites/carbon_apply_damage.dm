/mob/living/carbon/apply_damage(
	damage = 0,
	damagetype = BRUTE,
	def_zone = null,
	blocked = 0,
	forced = FALSE,
	spread_damage = FALSE,
	wound_bonus = 0,
	exposed_wound_bonus = 0,
	sharpness = NONE,
	attack_direction = null,
	attacking_item,
	wound_clothing = TRUE,
)
	SHOULD_CALL_PARENT(FALSE)
	// Spread damage should always have def zone be null
	if(spread_damage)
		def_zone = null
	// Otherwise if def zone is null, we'll get a random bodypart / zone to hit.
	// ALso we'll automatically covnert string def zones into bodyparts to pass into parent call.
	else if(!isbodypart(def_zone))
		var/random_zone = check_zone(def_zone || get_random_valid_zone(def_zone))
		def_zone = get_bodypart(random_zone) || get_bodypart()
	var/damage_amount = damage
	if(!forced)
		damage_amount *= ((100 - blocked) / 100)
		damage_amount *= get_incoming_damage_modifier(damage_amount, damagetype, def_zone, sharpness, attack_direction, attacking_item)
	if(damage_amount <= 0)
		return 0
	SEND_SIGNAL(src, COMSIG_MOB_APPLY_DAMAGE, damage_amount, damagetype, def_zone, blocked, wound_bonus, exposed_wound_bonus, sharpness, attack_direction, attacking_item, wound_clothing)
	var/damage_dealt = 0
	switch(damagetype)
		if(BRUTE)
			if(isbodypart(def_zone))
				var/obj/item/bodypart/actual_hit = def_zone
				var/delta = actual_hit.get_damage()
				if(actual_hit.receive_damage(
					brute = damage_amount,
					burn = 0,
					forced = forced,
					wound_bonus = wound_bonus,
					exposed_wound_bonus = exposed_wound_bonus,
					sharpness = sharpness,
					attack_direction = attack_direction,
					damage_source = attacking_item,
					wound_clothing = wound_clothing,
				))
					update_damage_overlays()
				damage_dealt = actual_hit.get_damage() - delta // Unfortunately bodypart receive_damage doesn't return damage dealt so we do it manually
			else
				damage_dealt = -1 * adjust_brute_loss(damage_amount, forced = forced)
		if(BURN)
			if(isbodypart(def_zone))
				var/obj/item/bodypart/actual_hit = def_zone
				var/delta = actual_hit.get_damage()
				if(actual_hit.receive_damage(
					brute = 0,
					burn = damage_amount,
					forced = forced,
					wound_bonus = wound_bonus,
					exposed_wound_bonus = exposed_wound_bonus,
					sharpness = sharpness,
					attack_direction = attack_direction,
					damage_source = attacking_item,
					wound_clothing = wound_clothing,
				))
					update_damage_overlays()
				damage_dealt = actual_hit.get_damage() - delta // See above
			else
				damage_dealt = -1 * adjust_fire_loss(damage_amount, forced = forced)
		if(TOX)
			if(treatable_conditions[CONDITION_POISONING] != null)
				var/datum/medical_condition/toxin/toxins = treatable_conditions[CONDITION_POISONING]
				toxins.severity += min(10, abs(round((damage_amount * 10) / toxins.maximum_health_offset, DAMAGE_PRECISION)))
			else
				var/toxins_severity = min(10, abs(round((damage_amount * 10) / (maxHealth * 2) + 20, DAMAGE_PRECISION)))
				var/datum/medical_condition/toxin/toxins = new /datum/medical_condition/toxin(toxins_severity)
				add_medical_condition(toxins, null)
		if(OXY)
			damage_dealt = -1 * adjust_oxy_loss(damage_amount, forced = forced)
		if(STAMINA)
			damage_dealt = -1 * adjust_stamina_loss(damage_amount, forced = forced)
		if(BRAIN)
			damage_dealt = -1 * adjust_organ_loss(ORGAN_SLOT_BRAIN, damage_amount)

	SEND_SIGNAL(src, COMSIG_MOB_AFTER_APPLY_DAMAGE, damage_dealt, damagetype, def_zone, blocked, wound_bonus, exposed_wound_bonus, sharpness, attack_direction, attacking_item, wound_clothing)
	if(def_zone && (damagetype == BRUTE || damagetype == BURN))
		damageoverlaytemp += damage_dealt
	return damage_dealt

/mob/living/proc/adjust_tox_loss(amount, updating_health = TRUE, forced = FALSE, required_biotype = ALL)
	if(!can_adjust_tox_loss(amount, forced, required_biotype))
		return 0

	if(!forced && HAS_TRAIT(src, TRAIT_TOXINLOVER)) //damage becomes healing and healing becomes damage
		amount = -amount
		if(HAS_TRAIT(src, TRAIT_TOXIMMUNE)) //Prevents toxin damage, but not healing
			amount = min(amount, 0)
		if(amount > 0)
			adjust_blood_volume(-5 * amount)
		else
			adjust_blood_volume(-amount)

	else if(!forced && HAS_TRAIT(src, TRAIT_TOXIMMUNE)) //Prevents toxin damage, but not healing
		amount = min(amount, 0)

	if(iscarbon(src))
		if(amount <= 0)
			return // we don't need to do anything else
		var/mob/living/carbon/us_but_carbon = src
		if(us_but_carbon.treatable_conditions[CONDITION_POISONING] != null)
			var/datum/medical_condition/toxin/toxins = us_but_carbon.treatable_conditions[CONDITION_POISONING]
			toxins.severity += min(10, abs(round((amount * 10) / toxins.maximum_health_offset, DAMAGE_PRECISION)))
		else
			var/toxins_severity = min(10, abs(round((amount * 10) / ((maxHealth * 2) + 20), DAMAGE_PRECISION)))
			var/datum/medical_condition/toxin/toxins = new /datum/medical_condition/toxin(toxins_severity)
			us_but_carbon.add_medical_condition(toxins, null)
	else
		. = toxloss
		toxloss = clamp((toxloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
		. -= toxloss
		if(!.) // no change, no need to update
			return FALSE
	if(updating_health)
		updatehealth()
