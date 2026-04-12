import { Button, Dimmer, Section, LabeledList } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  conditions_whole_body: Array<ConditionData>;
  conditions_head: Array<ConditionData>;
  conditions_chest: Array<ConditionData>;
  conditions_groin: Array<ConditionData>;
  conditions_left_leg: Array<ConditionData>;
  conditions_right_leg: Array<ConditionData>;
  conditions_left_arm: Array<ConditionData>;
  conditions_right_arm: Array<ConditionData>;
};

type ConditionData = {
  name: string;
  icon: string;
  alerts: { string }[];
};

const ConditionAlerts = (props) => {
  const { alert } = props;
  const { alert_data } = props;

  if (alert === "condition_ui_treatment") {
    return (
      <Button
        icon="grip"
        iconColor='#8d8778'
        tooltipPosition="right"
        tooltip={alert_data}
      />
    );
  }
  if (alert === "condition_ui_bleeding") {
    return (
      <Button
        icon="droplet"
        iconColor='#9d0e0e'
        tooltipPosition="right"
        tooltip={`
          This condition is causing bleeding! You will eventually bleed out if
          you do not do anything to treat it.
        `}
      />
    );
  }
  if (alert === "condition_ui_bandaged") {
    return (
      <Button
        icon="bandage"
        iconColor='#8d8778'
        tooltipPosition="right"
        tooltip={`
          This condition has been safely bandaged.
        `}
      />
    );
  }
  if (alert === "condition_ui_treatment_quality") {
    return (
      <Button
        icon="kit-medical"
        iconColor='#0abe94'
        tooltipPosition="right"
        tooltip={alert_data}
      />
    );
  }
  // Default return / error
  return (
    <Button
      icon="question"
      tooltipPosition="right"
      tooltip={`
        This alert should be telling you something important, but it wasn't set
        up correctly. Oops.
      `}
    />
  );
};

export const ConditionsPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    conditions_whole_body = [],
    conditions_head = [],
    conditions_chest = [],
    conditions_groin = [],
    conditions_left_leg = [],
    conditions_right_leg = [],
    conditions_left_arm = [],
    conditions_right_arm = [],
  } = data;
  return (
    <Window title="Conditions Panel" width={400} height={500}>
      <Window.Content scrollable>
        <Section
          maxHeight="32px"
          title="Status"
          buttons={
            <>
            <Button
              color="transparent"
              tooltip={`
                This is your overall status, or rather how your characters feels
                at the moment. The overall health and pain may not reflect
                reality, thanks to painkillers or increases in sensitivity.
              `}
              tooltipPosition="bottom-start"
              icon="info"
            />
            <Button
              color="blue"
              tooltip={`
                Refresh the conditions menu manually.
              `}
              tooltipPosition="bottom-start"
              icon="repeat"
            />
            </>
          }
        />
        <Section
          title="Whole Body"
          buttons={
            <Button
              color="transparent"
              tooltip={`
                These are conditions that do not apply to a particular body zone
                and instead affect your whole body.
              `}
              tooltipPosition="bottom-start"
              icon="info"
            />
          }>
            {(!conditions_whole_body.length && (
              <Dimmer align="center">
                No conditions!
              </Dimmer>
            )) || (
              <LabeledList>
                {conditions_whole_body.map((condition) => (
                  <LabeledList.Item
                    key={condition.name}
                    label={condition.name}
                  >
                    {!!condition.alerts &&
                      Object.keys(condition.alerts).map((condition_alert) => (
                        <ConditionAlerts
                          key={condition_alert}
                          alert={condition_alert}
                          alert_data={condition.alerts[condition_alert]}
                        />
                    ))}
                    <Button
                      color="transparent"
                      icon={condition.icon}
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            )}
        </Section>
        <Section title="Head">
            {(!conditions_head.length && (
              <Dimmer align="center">
                No conditions!
              </Dimmer>
            )) || (
              <LabeledList>
                {conditions_head.map((condition) => (
                  <LabeledList.Item
                    key={condition.name}
                    label={condition.name}
                  >
                    {!!condition.alerts &&
                      Object.keys(condition.alerts).map((condition_alert) => (
                        <ConditionAlerts
                          key={condition_alert}
                          alert={condition_alert}
                          alert_data={condition.alerts[condition_alert]}
                        />
                    ))}
                    <Button
                      color="transparent"
                      icon={condition.icon}
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            )}
        </Section>
        <Section title="Chest">
            {(!conditions_chest.length && (
              <Dimmer align="center">
                No conditions!
              </Dimmer>
            )) || (
              <LabeledList>
                {conditions_chest.map((condition) => (
                  <LabeledList.Item
                    key={condition.name}
                    label={condition.name}
                  >
                    {!!condition.alerts &&
                      Object.keys(condition.alerts).map((condition_alert) => (
                        <ConditionAlerts
                          key={condition_alert}
                          alert={condition_alert}
                          alert_data={condition.alerts[condition_alert]}
                        />
                    ))}
                    <Button
                      color="transparent"
                      icon={condition.icon}
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            )}
        </Section>
        <Section title="Groin">
            {(!conditions_groin.length && (
              <Dimmer align="center">
                No conditions!
              </Dimmer>
            )) || (
              <LabeledList>
                {conditions_groin.map((condition) => (
                  <LabeledList.Item
                    key={condition.name}
                    label={condition.name}
                  >
                    {!!condition.alerts &&
                      Object.keys(condition.alerts).map((condition_alert) => (
                        <ConditionAlerts
                          key={condition_alert}
                          alert={condition_alert}
                          alert_data={condition.alerts[condition_alert]}
                        />
                    ))}
                    <Button
                      color="transparent"
                      icon={condition.icon}
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            )}
        </Section>
        <Section title="Left Arm">
            {(!conditions_left_arm.length && (
              <Dimmer align="center">
                No conditions!
              </Dimmer>
            )) || (
              <LabeledList>
                {conditions_left_arm.map((condition) => (
                  <LabeledList.Item
                    key={condition.name}
                    label={condition.name}
                  >
                    {!!condition.alerts &&
                      Object.keys(condition.alerts).map((condition_alert) => (
                        <ConditionAlerts
                          key={condition_alert}
                          alert={condition_alert}
                          alert_data={condition.alerts[condition_alert]}
                        />
                    ))}
                    <Button
                      color="transparent"
                      icon={condition.icon}
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            )}
        </Section>
        <Section title="Right Arm">
            {(!conditions_right_arm.length && (
              <Dimmer align="center">
                No conditions!
              </Dimmer>
            )) || (
              <LabeledList>
                {conditions_right_arm.map((condition) => (
                  <LabeledList.Item
                    key={condition.name}
                    label={condition.name}
                  >
                    {!!condition.alerts &&
                      Object.keys(condition.alerts).map((condition_alert) => (
                        <ConditionAlerts
                          key={condition_alert}
                          alert={condition_alert}
                          alert_data={condition.alerts[condition_alert]}
                        />
                    ))}
                    <Button
                      color="transparent"
                      icon={condition.icon}
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            )}
        </Section>
        <Section title="Left Leg">
            {(!conditions_left_leg.length && (
              <Dimmer align="center">
                No conditions!
              </Dimmer>
            )) || (
              <LabeledList>
                {conditions_left_leg.map((condition) => (
                  <LabeledList.Item
                    key={condition.name}
                    label={condition.name}
                  >
                    {!!condition.alerts &&
                      Object.keys(condition.alerts).map((condition_alert) => (
                        <ConditionAlerts
                          key={condition_alert}
                          alert={condition_alert}
                          alert_data={condition.alerts[condition_alert]}
                        />
                    ))}
                    <Button
                      color="transparent"
                      icon={condition.icon}
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            )}
        </Section>
        <Section title="Right Leg">
            {(!conditions_right_leg.length && (
              <Dimmer align="center">
                No conditions!
              </Dimmer>
            )) || (
              <LabeledList>
                {conditions_right_leg.map((condition) => (
                  <LabeledList.Item
                    key={condition.name}
                    label={condition.name}
                  >
                    {!!condition.alerts &&
                      Object.keys(condition.alerts).map((condition_alert) => (
                        <ConditionAlerts
                          key={condition_alert}
                          alert={condition_alert}
                          alert_data={condition.alerts[condition_alert]}
                        />
                    ))}
                    <Button
                      color="transparent"
                      icon={condition.icon}
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            )}
        </Section>
      </Window.Content>
    </Window>
  );
};
