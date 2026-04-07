import { Box, LabeledList, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { PreferenceSingle } from './SinglePreference';
import { PreferencesMenuData } from './types';

export const LorePage = () => {
  const { act, data } = useBackend<PreferencesMenuData>();
  const dopplerLorePreferences = {
    ...data.character_preferences.doppler_lore,
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
              preferences={dopplerLorePreferences}
            />
            <PreferenceSingle
              pref_key="age_chronological"
              preferences={dopplerLorePreferences}
            />
            <PreferenceSingle
              pref_key="flavor_short_desc"
              preferences={dopplerLorePreferences}
            />
            <PreferenceSingle
              pref_key="flavor_extended_desc"
              preferences={dopplerLorePreferences}
            />
            <PreferenceSingle
              pref_key="headshot_url"
              preferences={dopplerLorePreferences}
            />
          </Section>
          <Section title="Species">
            <PreferenceSingle
              pref_key="custom_species_name"
              preferences={dopplerLorePreferences}
            />
            <PreferenceSingle
              pref_key="custom_species_desc"
              preferences={dopplerLorePreferences}
            />
          </Section>
          <Section title="OOC">
            <PreferenceSingle
              pref_key="ooc_notes"
              preferences={dopplerLorePreferences}
            />
          </Section>
        </LabeledList>
      </Stack.Item>
    </Box>
  );
};
