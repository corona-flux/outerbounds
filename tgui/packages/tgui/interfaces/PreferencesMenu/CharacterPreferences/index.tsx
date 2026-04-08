import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Dropdown,
  Flex,
  Stack,
} from 'tgui-core/components'; /* OUTERBOUNDS EDIT: Adds in Dropdown and Flex */
import { exhaustiveCheck } from 'tgui-core/exhaustive';

import { PageButton } from '../components/PageButton';
import type { PreferencesMenuData } from '../types';
import { AntagsPage } from './AntagsPage';
import { JobsPage } from './JobsPage';
import { LoadoutPage } from './loadout';
import { MainPage } from './MainPage';
import { QuirkPersonalityPage } from './QuirksPage';
import { SpeciesPage } from './SpeciesPage';
import { LanguagesPage } from '../LanguagesMenu'; /* OUTERBOUNDS EDIT ADDITION */
import { LorePage } from '../LorePage'; /* OUTERBOUNDS EDIT ADDITION */

enum Page {
  Antags,
  Main,
  Jobs,
  Species,
  Quirks,
  Loadout,
  Languages /* OUTERBOUNDS EDIT ADDITION */,
  Lore /* OUTERBOUNDS EDIT ADDITION */,
}

type ProfileProps = {
  activeSlot: number;
  onClick: (index: number) => void;
  profiles: (string | null)[];
};

function CharacterProfiles(props: ProfileProps) {
  const { activeSlot, onClick, profiles } = props;

  return (
    <Flex /* OUTERBOUNDS EDIT START: Dropdown instead of using buttons */
      align="center"
      justify="center"
    >
      <Flex.Item width="25%">
        <Dropdown
          width="100%"
          selected={activeSlot as unknown as string}
          displayText={profiles[activeSlot]}
          options={profiles.map((profile, slot) => ({
            value: slot,
            displayText: profile ?? 'New Character',
          }))}
          onSelected={(slot) => {
            onClick(slot);
          }}
        />
      </Flex.Item>
    </Flex> /* OUTERBOUNDS EDIT END */
  );
}

export function CharacterPreferenceWindow(props) {
  const { act, data } = useBackend<PreferencesMenuData>();

  const [currentPage, setCurrentPage] = useState(Page.Main);

  let pageContents;

  switch (currentPage) {
    case Page.Antags:
      pageContents = <AntagsPage />;
      break;
    case Page.Jobs:
      pageContents = <JobsPage />;
      break;
    case Page.Main:
      pageContents = (
        <MainPage openSpecies={() => setCurrentPage(Page.Species)} />
      );

      break;
    case Page.Species:
      pageContents = (
        <SpeciesPage closeSpecies={() => setCurrentPage(Page.Main)} />
      );

      break;
    case Page.Quirks:
      pageContents = <QuirkPersonalityPage />;
      break;

    case Page.Loadout:
      pageContents = <LoadoutPage />;
      break;

    // OUTERBOUNDS EDIT START
    case Page.Lore:
      pageContents = <LorePage />;
      break;
    case Page.Languages:
      pageContents = <LanguagesPage />;
      break;
    // OUTERBOUNDS EDIT END

    default:
      exhaustiveCheck(currentPage);
  }

  return (
    <Stack vertical fill>
      <Stack.Item>
        <CharacterProfiles
          activeSlot={data.active_slot - 1}
          onClick={(slot) => {
            act('change_slot', {
              slot: slot + 1,
            });
          }}
          profiles={data.character_profiles}
        />
      </Stack.Item>
      {/*{!data.content_unlocked && ( // OUTERBOUNDS EDIT - Hide byond premium banner
        <Stack.Item align="center">
          Buy BYOND premium for more slots!
        </Stack.Item>
      )}*/}
      <Stack.Divider />
      <Stack.Item>
        <Stack fill>
          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Main}
              setPage={setCurrentPage}
              otherActivePages={[Page.Species]}
            >
              Character
            </PageButton>
          </Stack.Item>

          {/* // OUTERBOUNDS EDIT ADDITION*/}
          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Lore}
              setPage={setCurrentPage}
            >
              Lore
            </PageButton>
          </Stack.Item>
          {/* // OUTERBOUNDS EDIT ADDITION END*/}

          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Loadout}
              setPage={setCurrentPage}
            >
              Loadout
            </PageButton>
          </Stack.Item>

          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Jobs}
              setPage={setCurrentPage}
            >
              {/*
                    Fun fact: This isn't "Jobs" so that it intentionally
                    catches your eyes, because it's really important!
                  */}
              Occupations
            </PageButton>
          </Stack.Item>

          {/* // OUTERBOUNDS EDIT ADDITION*/}
          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Languages}
              setPage={setCurrentPage}
            >
              Languages
            </PageButton>
          </Stack.Item>
          {/* // OUTERBOUNDS EDIT ADDITION END*/}

          {/*<Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Antags}
              setPage={setCurrentPage}
            >
              Antagonists
            </PageButton>
          </Stack.Item>*/}

          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Quirks}
              setPage={setCurrentPage}
            >
              Quirks and Personality
            </PageButton>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item grow position="relative" overflowX="hidden" overflowY="auto">
        {pageContents}
      </Stack.Item>
    </Stack>
  );
}
