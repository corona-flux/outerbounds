/obj/item/bodypart/proc/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, forced = FALSE, required_bodytype = null, wound_bonus = 0, exposed_wound_bonus = 0, sharpness = NONE, attack_direction = null, damage_source, wound_clothing = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	var/hit_percent = forced ? 1 : (100-blocked)/100
	if((!brute && !burn) || hit_percent <= 0)
		return FALSE
	if (!forced)
		if(!isnull(owner))
			if (HAS_TRAIT(owner, TRAIT_GODMODE))
				return FALSE
			if (SEND_SIGNAL(owner, COMSIG_CARBON_LIMB_DAMAGED, src, brute, burn) & COMPONENT_PREVENT_LIMB_DAMAGE)
				return FALSE
		if(required_bodytype && !(bodytype & required_bodytype))
			return FALSE
	var/dmg_multi = CONFIG_GET(number/damage_multiplier) * hit_percent
	brute = round(max(brute * dmg_multi * brute_modifier, 0), DAMAGE_PRECISION)
	burn = round(max(burn * dmg_multi * burn_modifier, 0), DAMAGE_PRECISION)
	if(!brute && !burn)
		return FALSE
	brute *= wound_damage_multiplier
	burn *= wound_damage_multiplier
	/*
	// START WOUND HANDLING
	*/
	// what kind of wounds we're gonna roll for, take the greater between brute and burn, then if it's brute, we subdivide based on sharpness
	var/wounding_type = (brute > burn ? WOUND_BLUNT : WOUND_BURN)
	var/wounding_dmg = max(brute, burn)
	if(wounding_type == WOUND_BLUNT && sharpness)
		if(sharpness & SHARP_EDGED)
			wounding_type = WOUND_SLASH
		else if (sharpness & SHARP_POINTY)
			wounding_type = WOUND_PIERCE
	if(owner) // i tried to modularize the below, but the modifications to wounding_dmg and wounding_type cant be extracted to a proc
		var/mangled_state = get_mangled_state()
		var/easy_dismember = HAS_TRAIT(owner, TRAIT_EASYDISMEMBER) // if we have easydismember, we don't reduce damage when redirecting damage to different types (slashing weapons on mangled/skinless limbs attack at 100% instead of 50%)
		var/bio_status = get_bio_state_status()
		var/has_exterior = ((bio_status & ANATOMY_EXTERIOR))
		var/has_interior = ((bio_status & ANATOMY_INTERIOR))
		var/exterior_ready_to_dismember = (!has_exterior || ((mangled_state & BODYPART_MANGLED_EXTERIOR)))
		// if we're bone only, all cutting attacks go straight to the bone
		if(!has_exterior && has_interior)
			if(wounding_type == WOUND_SLASH)
				wounding_type = WOUND_BLUNT
				wounding_dmg *= (easy_dismember ? 1 : 0.6)
			else if(wounding_type == WOUND_PIERCE)
				wounding_type = WOUND_BLUNT
				wounding_dmg *= (easy_dismember ? 1 : 0.75)
		else
			// if we've already mangled the skin (critical slash or piercing wound), then the bone is exposed, and we can damage it with sharp weapons at a reduced rate
			// So a big sharp weapon is still all you need to destroy a limb
			if(has_interior && exterior_ready_to_dismember && !(mangled_state & BODYPART_MANGLED_INTERIOR) && sharpness)
				if(wounding_type == WOUND_SLASH && !easy_dismember)
					wounding_dmg *= 0.6 // edged weapons pass along 60% of their wounding damage to the bone since the power is spread out over a larger area
				if(wounding_type == WOUND_PIERCE && !easy_dismember)
					wounding_dmg *= 0.75 // piercing weapons pass along 75% of their wounding damage to the bone since it's more concentrated
				wounding_type = WOUND_BLUNT
		if ((dismemberable_by_wound() || dismemberable_by_total_damage()) && try_dismember(wounding_type, wounding_dmg, wound_bonus, exposed_wound_bonus))
			return
		// now we have our wounding_type and are ready to carry on with wounds and dealing the actual damage
		if(wounding_dmg >= WOUND_MINIMUM_DAMAGE && wound_bonus != CANT_WOUND)
			check_wounding(wounding_type, wounding_dmg, wound_bonus, exposed_wound_bonus, attack_direction, damage_source = damage_source, wound_clothing = wound_clothing)
	for(var/datum/wound/iter_wound as anything in wounds)
		iter_wound.receive_damage(wounding_type, wounding_dmg, wound_bonus, damage_source)
	//back to our regularly scheduled program, we now actually apply damage if there's room below limb damage cap
	var/can_inflict = max_damage - get_damage()
	var/total_damage = brute + burn
	if(total_damage > can_inflict && total_damage > 0) // TODO: the second part of this check should be removed once disabling is all done
		brute = round(brute * (can_inflict / total_damage),DAMAGE_PRECISION)
		burn = round(burn * (can_inflict / total_damage),DAMAGE_PRECISION)
	if(can_inflict <= 0)
		return FALSE
	if(brute)
		set_brute_dam(brute_dam + brute)
	if(burn)
		set_burn_dam(burn_dam + burn)

	if(owner)
		if(can_be_disabled)
			update_disabled()
		if(updating_health)
			owner.updatehealth()
	return update_bodypart_damage_state()
