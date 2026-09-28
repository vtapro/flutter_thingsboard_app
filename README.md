## [ThingsBoard Mobile Application](https://thingsboard.io/products/mobile/) is an open-source project based on [Flutter](https://flutter.dev/)
Powered by [ThingsBoard](https://thingsboard.io) IoT Platform

Build your own IoT mobile application **with minimum coding efforts**

## Please be informed the Web platform is not supported, because it's a part of our main platform!

## Resources

- [Getting started](https://thingsboard.io/docs/mobile/getting-started/) - learn how to set up and run your first IoT mobile app
- [Customize your app](https://thingsboard.io/docs/mobile/customization/) - learn how to customize the app
- [Publish your app](https://thingsboard.io/docs/mobile/release/) - learn how to publish app to Google Play or App Store

## Server endpoint

This build is configured for the **GreenIQ** ThingsBoard server.

The API endpoint is compiled into the app and defaults to `https://app.greeniq.vn`
(see `lib/constants/app_constants.dart`). Because a default endpoint is set, the
North America / Europe region picker is skipped and the app always connects to
`https://app.greeniq.vn` (`Region.custom`).

To point the app at another ThingsBoard server, override the endpoint at build time
(no code change required):

```bash
flutter run   --dart-define=thingsboardApiEndpoint=https://your-server.example.com
flutter build apk --release --dart-define=thingsboardApiEndpoint=https://your-server.example.com
```

App Links / deep links follow the same host and can be overridden too:

```bash
--dart-define=appLinksUrlHost=your-server.example.com
--dart-define=webPathPrefix=/api/noauth/qr
--dart-define=appLinksUrlScheme=https
```

- Android: `android/app/build.gradle` (`appLinksUrlHost` default) →
  `manifestPlaceholders` → `AndroidManifest.xml` intent-filter.
- iOS: `ios/Flutter/TbDefault.xcconfig` (`APPLINKSURLHOST`) →
  `Runner.entitlements` (written by a pre-build script in `Runner.xcscheme`).

## Firebase

Push notifications use the **GreenIQ** Firebase project `greeniq-578ca`.

| Platform | Application ID / bundle ID | Config file |
| --- | --- | --- |
| Android | `vn.greeniq.system` | `android/app/google-services.json` |
| iOS | `vn.greeniq.system` | `ios/Runner/GoogleService-Info.plist` |

- Android: the `com.google.gms.google-services` Gradle plugin is applied in
  `android/settings.gradle` and `android/app/build.gradle`. It injects
  `google_app_id`, `gcm_defaultSenderId`, … into the APK resources. The package
  name in `google-services.json` **must** equal `applicationId`, otherwise the
  Gradle build fails.
- iOS: `GoogleService-Info.plist` is a member of the `Runner` target resources
  build phase, and `PRODUCT_BUNDLE_IDENTIFIER` comes from `IOSAPPLICATIONID` in
  `ios/Flutter/TbDefault.xcconfig`.
- Dart: `lib/firebase_options.dart` carries the same values for
  `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`.

Keep the three places (Gradle `applicationId`, `IOSAPPLICATIONID`, and the two
Firebase config files) in sync when the application ID changes. Firebase is only
initialized when the app talks to its default endpoint — for a custom
`--dart-define=thingsboardApiEndpoint` the app skips Firebase on purpose
(see `lib/utils/services/firebase/firebase_service.dart`).

## Live demo app

To be familiar with common app features try out our ThingsBoard Live mobile application available on Google Play and App Store
- [Get it on Google Play](https://play.google.com/store/apps/details?id=org.thingsboard.demo.app&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1)
- [Download on the App Store](https://apps.apple.com/us/app/thingsboard-live/id1594355695?itsct=apps_box_badge&amp;itscg=30200)
