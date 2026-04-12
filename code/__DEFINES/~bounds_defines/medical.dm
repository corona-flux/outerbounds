/// When a medical condition has no particular body zone and is just "whole body" then use this
#define CONDITION_FULL_BODY "full_body_condition"

/// Maximum condition severity
#define CONDITION_SEVERITY_MAX 10

/// Converts a severity number to a multiplicable percentage
#define SEVERITY_2_PERCENT(SEVERITY) ((SEVERITY) / 10)

/// If the wound is bleeding and bandages should work on it
#define CONDITION_BANDAGABLE "bandagable_condition"
