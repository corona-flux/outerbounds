import { Box, LabeledList, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { PreferenceSingle } from './SinglePreference';
import { PreferencesMenuData } from './types';

export const LorePage = () => {
  const { act, data } = useBackend<PreferencesMenuData>();
  const outerboundsLorePreferences = {
    ...data.character_preferences.outerbounds_lore,
  };
  return (
    <Box className="PreferencesMenu__Lore">
      <Stack.Item
        basis="50%"
        grow
        style={{
          background: 'rgba(0, 0, 0, 0.5)',
          padding: '4px',
        }}
        overflowX="hidden"
        overflowY="auto"
        maxHeight="auto"
      >
        <LabeledList>
          <Section title="Character Details">
            <PreferenceSingle
              pref_key="age"
              preferences={outerboundsLorePreferences}
            />
            <PreferenceSingle
              pref_key="age_chronological"
              preferences={outerboundsLorePreferences}
            />
            <PreferenceSingle
              pref_key="flavor_short_desc"
              preferences={outerboundsLorePreferences}
            />
            <PreferenceSingle
              pref_key="flavor_extended_desc"
              preferences={outerboundsLorePreferences}
            />
            <PreferenceSingle
              pref_key="headshot_url"
              preferences={outerboundsLorePreferences}
            />
          </Section>
          <Section title="Species">
            <PreferenceSingle
              pref_key="custom_species_name"
              preferences={outerboundsLorePreferences}
            />
            <PreferenceSingle
              pref_key="custom_species_desc"
              preferences={outerboundsLorePreferences}
            />
          </Section>
          <Section title="OOC">
            <PreferenceSingle
              pref_key="ooc_notes"
              preferences={outerboundsLorePreferences}
            />
          </Section>
        </LabeledList>
      </Stack.Item>
    </Box>
  );
};
