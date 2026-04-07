/// Associative list of mob name to chat colour
GLOBAL_LIST_INIT(chat_colors_by_mob_name, list(
	"Unknown" = list("#ffffff", "#d8d8d8"),
))

/// Maximum length of the short character description
#define MAX_FLAVOR_SHORT_DESC_LEN 250
/// Maximum length of the extended character description
#define MAX_FLAVOR_EXTENDED_DESC_LEN 4096

/// Preference category for doppler lore items
#define PREFERENCE_CATEGORY_DOPPLER_LORE "doppler_lore"

/// View with your job clothing on + loadout
#define PREVIEW_PREF_JOB "Job"
/// View with your loadout items only
#define PREVIEW_PREF_LOADOUT "Loadout"
/// View with underwear visible
#define PREVIEW_PREF_UNDERWEAR "Underwear"
/// View with nothing on
#define PREVIEW_PREF_NAKED "Naked"

/// For use by flavour texts, reads a specific preference without having to copy the whole big line
#define READ_PREFS(target, pref) (target.client?.prefs?.read_preference(/datum/preference/pref))
