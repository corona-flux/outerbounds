import {
  Feature,
  FeatureNumberInput,
  FeatureShortTextInput,
  FeatureTextInput,
} from '../base';

export const age_chronological: Feature<number> = {
  name: 'Age (Chronological)',
  description:
    'The amount of time the character has existed in this world, in years.  This includes time spent in any kind of stasis, however other methods of spacetime manipulation (such as timeskips) may not necessarily apply.',
  component: FeatureNumberInput,
};

export const flavor_short_desc: Feature<string> = {
  name: 'Short description',
  description:
    "Appears when shift-clicked or otherwise looked at, when not disguised. A one to three sentence blurb that describes the major features of your character at a glance, such as gender, race, height, etc. Example: 'Standing at five and a half feet tall, this brown-skinned, grizzled human male is a distinct rarity out in this part of the galaxy.'",
  component: FeatureTextInput,
};

export const flavor_extended_desc: Feature<string> = {
  name: 'Long description',
  description:
    "Appears when examined further. A lengthy description of your character written as descriptive prose, up to 4096 characters in total length. Your <i>short description</i> will always be shown as your first paragraph, so you don't need to duplicate it again here. ",
  component: FeatureTextInput,
};

export const headshot_url: Feature<string> = {
  name: 'Headshot image (URL)',
  description:
    "A https link to a hosted image of your character's headshot. Must be: no larger than 250x250px (you can use larger images, but they will be scaled down, and probably poorly above 500px), a jpg/png/jpeg file, and hosted on either Gyazo (i.gyazo.com), Byondhome (files.byondhome.com), Imgbox (images2.imgbox.com) or Catbox (files.catbox.moe). Transparent backgrounds are highly recommended (but only supported on .png files).",
  component: FeatureShortTextInput,
};

export const custom_species_name: Feature<string> = {
  name: 'Species name',
  description:
    'Appears when looked at. Leave blank to match a default coded race (such as Human).',
  component: FeatureShortTextInput,
};

export const custom_species_desc: Feature<string> = {
  name: 'Species description',
  description:
    "Appears when examined further. An overview of your species, ideally limited to commonly-known facts such as general physical appearances, origin world/sector, and so on. This should not be excessively long - you're better off sharing that information via IC interactions (or records) instead of expecting people to read it off your examine.",
  component: FeatureTextInput,
};

export const ooc_notes: Feature<string> = {
  name: 'OOC notes',
  description:
    'Include anything you think people might need to know OOCly here, such as your boundaries, interaction preferences, any credits for material used to create your character, contact info, or more. Keep it short and sweet, though!',
  component: FeatureTextInput,
};
