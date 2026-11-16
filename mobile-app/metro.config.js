const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

// lottie-react-native's .lottie (dotLottie) files aren't a default Metro asset type.
config.resolver.assetExts.push('lottie');

// Expo disables inlineRequires by default, which breaks react-native-worklets' JS-to-native
// init pipeline and crashes the app (segfault in Worklets' console/JSI glue on any console call).
// https://docs.swmansion.com/react-native-worklets/docs/guides/troubleshooting/
config.transformer.getTransformOptions = async () => ({
  transform: {
    experimentalImportSupport: false,
    inlineRequires: true,
  },
});

module.exports = config;
