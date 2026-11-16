import { ActionSheetIOS, Alert, Platform } from "react-native";
import { useNewStaffApplicationStore } from "../../../../stores/new-staff-application-store";
import { ModalUtilityProps } from "../types";

export const useNewLeaveCancelAction = (params: ModalUtilityProps["params"], closeModal: ModalUtilityProps["closeModal"]) => {
  const cancel = () => {
    const { isCommonStatesEmpty, isLeaveStatesEmpty, isShortLeaveStatesEmpty } =
      useNewStaffApplicationStore.getState();

    if (
      isCommonStatesEmpty() &&
      isLeaveStatesEmpty() &&
      isShortLeaveStatesEmpty()
    ) {
      closeModal();
    } else {
      if (Platform.OS === "ios") {
        ActionSheetIOS.showActionSheetWithOptions(
          {
            options: ["Keep Editing", "Discard Changes"],
            cancelButtonIndex: 0,
            title: "Are you sure you want to discard the changes?",
            // message: "You will lose all unsaved changes.",
          },
          (buttonIndex) => {
            if (buttonIndex === 1) {
              closeModal();
            }
            if (buttonIndex === 0) {
              // Do nothing
            }
          }
        );
      } else {
        Alert.alert(
          "Alert!",
          "Are you sure you want to discard the changes?",
          [
            {
              text: "Keep Editing",
              style: "default",
              onPress: () => {},
              isPreferred: true,
            },
            {
              text: "Discard",
              onPress: () => closeModal(),
              style: "cancel",
            },
          ],
          {
            cancelable: true,
            userInterfaceStyle: "light",
          }
        );
      }
    }
  };

  return { cancel };
};
