///Shows a tgui window with medical conditions
/mob/living/carbon/verb/medical_conditions()
	set name = "Conditions"
	set category = "IC"
	set desc = "View your character's medical conditions."
	if(!conditions_panel)
		conditions_panel = new(usr, src)
	conditions_panel.ui_interact(usr)

///Shows a tgui window with medical conditions
/mob/living/carbon/proc/open_conditions_panel()
	if(!conditions_panel)
		conditions_panel = new(usr, src)
	conditions_panel.ui_interact(usr)

/datum/conditions_panel
	var/mob/living/carbon/mob_reference
	var/client/holder //client of whoever is using this datum

/datum/conditions_panel/New(user, mob_reference)//user can either be a client or a mob due to byondcode(tm)
	if (istype(user, /client))
		var/client/user_client = user
		holder = user_client //if its a client, assign it to holder
	else
		var/mob/user_mob = user
		holder = user_mob.client //if its a mob, assign the mob's client to holder
	src.mob_reference = mob_reference

/datum/conditions_panel/Destroy(force)
	mob_reference.conditions_panel = null
	. = ..()

/datum/conditions_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/conditions_panel/ui_close()
	qdel(src)

/datum/conditions_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ConditionsPanel")
		ui.open()

/datum/conditions_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("refresh")
			ui.send_full_update()
			return TRUE
	return FALSE

/datum/conditions_panel/ui_data(mob/user)
	var/list/data = list()
	var/list/conditions_whole_body = list()
	var/list/conditions_head = list()
	var/list/conditions_chest = list()
	var/list/conditions_groin = list()
	var/list/conditions_left_leg = list()
	var/list/conditions_right_leg = list()
	var/list/conditions_left_arm = list()
	var/list/conditions_right_arm = list()

	for(var/datum/medical_condition/condition as anything in mob_reference.medical_conditions)
		var/list/condition_stats = list(
			"name" = condition.name,
			"icon" = condition.condition_icon,
			"alerts" = condition.condition_alerts_list,
			"treatment" = condition.treatment_text,
			"colour" = condition.menu_color,
		)
		switch(mob_reference.medical_conditions[condition])
			if(CONDITION_FULL_BODY)
				conditions_whole_body += list(condition_stats)
			if(BODY_ZONE_HEAD)
				conditions_head += list(condition_stats)
			if(BODY_ZONE_CHEST)
				conditions_chest += list(condition_stats)
			if(BODY_ZONE_PRECISE_GROIN)
				conditions_groin += list(condition_stats)
			if(BODY_ZONE_L_ARM)
				conditions_left_arm += list(condition_stats)
			if(BODY_ZONE_R_ARM)
				conditions_right_arm += list(condition_stats)

	data["conditions_whole_body"] = conditions_whole_body
	data["conditions_head"] = conditions_head
	data["conditions_chest"] = conditions_chest
	data["conditions_groin"] = conditions_groin
	data["conditions_left_leg"] = conditions_left_leg
	data["conditions_right_leg"] = conditions_right_leg
	data["conditions_left_arm"] = conditions_left_arm
	data["conditions_right_arm"] = conditions_right_arm
	return data
