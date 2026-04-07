/mob/living/carbon/human
	/// Color of the undershirt
	var/undershirt_color = "#FFFFFF"
	/// Color of the socks
	var/socks_color = "#FFFFFF"
	/// The selected bra.
	var/bra = "Nude"
	/// Color of the bra.
	var/bra_color = "#FFFFFF"
	/// Flags for showing/hiding underwear, toggleabley by a verb
	var/underwear_visibility = NONE

/// Copies over clothing preferences like underwear to another human
/mob/living/carbon/human/copy_clothing_prefs(mob/living/carbon/human/destination)
	. = ..()
	destination.undershirt_color = undershirt_color
	destination.socks_color = socks_color
	destination.bra = bra
	destination.bra_color = bra_color

/datum/preferences
	/// Preference of how the preview should show the character.
	var/preview_pref = PREVIEW_PREF_JOB
	/// Associative list, keyed by language typepath, pointing to list(percent_understood, (LANGUAGE_UNDERSTOOD, or LANGUAGE_SPOKEN, for whether we understand or speak the language))
	var/list/languages = list()

// Updates the mob's chat color in the global cache
/datum/preferences/safe_transfer_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE, is_antag = FALSE)
	. = ..()
	GLOB.chat_colors_by_mob_name[character.name] = list(character.chat_color, character.chat_color_darkened) // by now the mob has had its prefs applied to it
