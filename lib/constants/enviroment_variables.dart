abstract final class EnvironmentVariables {
  static const apiCalls = bool.fromEnvironment('API_CALLS');
  static const verbose = bool.fromEnvironment('VERBOSE');
  static const showAppVersion = bool.fromEnvironment('showAppVersion');
}
