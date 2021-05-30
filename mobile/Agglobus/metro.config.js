// Learn more https://docs.expo.io/guides/customizing-metro
const { getDefaultConfig } = require('@expo/metro-config');

const defaultConfig = getDefaultConfig(__dirname);
defaultConfig.transformer = {}
defaultConfig.resolver = {}

defaultConfig.transformer.getTransformOptions = async () => ({
    transform: {
        experimentalImportSupport: false,
        inlineRequires: false,
    },
});
defaultConfig.resolver.sourceExts = ['jsx', 'js', 'ts', 'tsx'];

module.exports = defaultConfig;
