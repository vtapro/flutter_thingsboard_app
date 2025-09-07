abstract final class ThingsboardAppConstants {
  static const thingsBoardApiEndpoint = String.fromEnvironment(
    'thingsboardApiEndpoint',
    defaultValue: 'https://iot.greeniq.vn',
  );
  static const thingsboardOAuth2CallbackUrlScheme = String.fromEnvironment(
    'thingsboardOAuth2CallbackUrlScheme',
  );
  static const thingsboardIOSAppSecret = String.fromEnvironment(
    'thingsboardIosAppSecret',
  );
  static const thingsboardAndroidAppSecret = String.fromEnvironment(
    'thingsboardAndroidAppSecret',
  );
  static const ignoreRegionSelection = thingsBoardApiEndpoint != '';
}
