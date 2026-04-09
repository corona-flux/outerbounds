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
			damage_dealt = -1 * adjust_tox_loss(damage_amount, forced = forced)
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
