import Toast from "react-native-toast-message";

import NativeMountCarmelUtils from "../../specs/NativeMountCarmelUtils";

export function backToNativeApp() {
  if (NativeMountCarmelUtils !== null && NativeMountCarmelUtils !== undefined) {
    NativeMountCarmelUtils.navPopAsync();
  } else {
    Toast.show({
      type: "error",
      text1: "NativeMountCarmelUtils Native Module is not available!",
      position: "bottom",
    });
  }
}
