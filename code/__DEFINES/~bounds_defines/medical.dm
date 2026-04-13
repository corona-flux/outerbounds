/// When a medical condition has no particular body zone and is just "whole body" then use this
#define CONDITION_FULL_BODY "full_body_condition"

/// Maximum condition severity
#define CONDITION_SEVERITY_MAX 10

/// Converts a severity number to a multiplicable percentage
#define SEVERITY_2_PERCENT(SEVERITY) ((SEVERITY) / 10)

/// If the wound is bleeding and bandages should work on it
#define CONDITION_BANDAGABLE "bandagable_condition"
/// Tracker for the generic "poisoning" condition
#define CONDITION_POISONING "poisoning_condition"

/// For condition alerts that have no alert data
#define CONDITION_ALERT_NO_DATA "condition_alert_no_data"
/// For the tgui window, this wound has treatment info
#define CONDITION_UI_TREATMENT "condition_ui_treatment"
/// For the tgui window, this wound is currently bleeding
#define CONDITION_UI_BLEEDING "condition_ui_bleeding"
/// For the tgui window, this wound has been bandaged and is no longer bleeding
#define CONDITION_UI_BANDAGED "condition_ui_bandaged"
/// For the tgui window, this condition has increased healing factor thanks to treatment
#define CONDITION_UI_TREATMENT_QUALITY "condition_ui_treatment_quality"
/// For the tgui window, this condition is fatal at maximum severity
#define CONDITION_UI_MAX_SEVERITY_FATAL "condition_ui_max_severity_fatal"
