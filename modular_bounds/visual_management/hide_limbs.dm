/obj/item/bodypart/leg/update_limb(dropping_limb, is_creating)
	. = ..()
	var/mob/living/carbon/human/limb_owner = owner
	if(!is_invisible && (!!(limb_owner.obscured_slots & HIDELEGS)))
		is_invisible = TRUE

/obj/item/bodypart/arm/update_limb(dropping_limb, is_creating)
	. = ..()
	var/mob/living/carbon/human/limb_owner = owner
	if(!is_invisible && (!!(limb_owner.obscured_slots & HIDEARMS)))
		is_invisible = TRUE
