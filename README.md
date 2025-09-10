## [ThingsBoard Mobile Application](https://thingsboard.io/products/mobile/) is an open-source project based on [Flutter](https://flutter.dev/)
Powered by [ThingsBoard](https://thingsboard.io) IoT Platform

Build your own IoT mobile application **with minimum coding efforts**

## Please be informed the Web platform is not supported, because it's a part of our main platform!

## Resources

- [Getting started](https://thingsboard.io/docs/mobile/getting-started/) - learn how to set up and run your first IoT mobile app
- [Customize your app](https://thingsboard.io/docs/mobile/customization/) - learn how to customize the app
- [Publish your app](https://thingsboard.io/docs/mobile/release/) - learn how to publish app to Google Play or App Store

## Live demo app

To be familiar with common app features try out our ThingsBoard Live mobile application available on Google Play and App Store
- [Get it on Google Play](https://play.google.com/store/apps/details?id=org.thingsboard.demo.app&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1)
- [Download on the App Store](https://apps.apple.com/us/app/thingsboard-live/id1594355695?itsct=apps_box_badge&amp;itscg=30200)

---

## Ghi Chú Tuỳ Biến Greeniq (Tiếng Việt)

Mục này mô tả các thay đổi đã thêm so với mã nguồn gốc để bạn dễ theo dõi và tái sử dụng.

### Mã tuỳ biến theo dạng plugin (local package)
- Tất cả tính năng bổ sung được gom vào local package: `packages/greeniq_customizations`.
  - Sử dụng trong `pubspec.yaml` qua path:
    ```
    greeniq_customizations:
      path: packages/greeniq_customizations
    ```
  - Xuất các tiện ích:
    - `GreeniqAddDeviceFab` (nút dấu + thêm thiết bị, gọi QR và điều hướng qua delegate)
    - (đã gỡ) các thành phần Preview trong giai đoạn phát triển
- App chỉ giữ lớp “adapter/delegate” mỏng để gọi router hiện tại, ví dụ `_AppProvisioningNavigator` trong `lib/modules/device/devices_list_page.dart`.

### Endpoint máy chủ
- Mặc định API trỏ về: `https://iot.greeniq.vn`.
- Có thể override khi chạy: `--dart-define=thingsboardApiEndpoint=https://iot.greeniq.vn`.
- Android App Links host mặc định: `iot.greeniq.vn`.
- iOS App Links và Registration Redirect host mặc định: `iot.greeniq.vn`.

### Màn “Preview” nhanh
Đã gỡ hoàn toàn các nút/route Preview ra khỏi mã nguồn sản phẩm.

### Thêm thiết bị Mesh qua QR
- Ở màn “All devices”, nút nổi (Floating Action Button) dấu “+” sẽ mở trình quét QR để thêm thiết bị.
- QR phải là JSON tối thiểu gồm:
  - `transport`: `ble` hoặc `softap`
  - `tbDeviceName` hoặc `name`
  - `tbSecretKey` hoặc `pop`
- Sau khi cấu hình Wi‑Fi thành công, ứng dụng sẽ “claim” thiết bị lên ThingsBoard. Thiết bị phải được cấu hình cho phép claim và secret khớp trên máy chủ.

### Ghi chú môi trường build
- Đã nâng: Android Gradle Plugin 8.6.0, Kotlin 2.1.0, Gradle 8.10.2.
- Yêu cầu JDK 17.
- Đã giảm cảnh báo từ thư viện bên thứ ba bằng tuỳ chọn Java 17 và tham số `-Xlint` trong `android/build.gradle`.

### Khắc phục lỗi build Android (JVM target mismatch)
Nếu gặp lỗi khi chạy `flutter run`/build Android:

```
Execution failed for task ':audio_session:compileDebugKotlin'.
Inconsistent JVM-target compatibility detected for tasks 'compileDebugJavaWithJavac' (17) and 'compileDebugKotlin' (11).
```

Nguyên nhân: một số plugin Kotlin mặc định biên dịch với JVM 11, trong khi dự án dùng Java 17.

Đã khắc phục sẵn trong repo: `android/build.gradle` cưỡng bức tất cả module Kotlin dùng `jvmTarget = "17"` để đồng bộ với Java 17.

Trường hợp bạn migrate từ code cũ hoặc thấy lỗi quay lại, áp dụng các bước sau:

1) Đảm bảo JDK 17

- Kiểm tra: `java -version` → phải hiển thị `17`.
- Nếu khác 17, cài JDK 17 và trỏ `JAVA_HOME` tới JDK 17 (Android Studio Arctic/Flamingo trở lên thường đã đi kèm JDK 17).

2) Đồng bộ Java/Kotlin = 17 trong Gradle

- Trong `android/app/build.gradle`:
  ```gradle
  android {
    compileOptions {
      sourceCompatibility JavaVersion.VERSION_17
      targetCompatibility JavaVersion.VERSION_17
    }
    kotlinOptions {
      jvmTarget = "17"
    }
  }
  ```
- Trong `android/build.gradle` (gốc), thêm cấu hình bắt buộc cho mọi subproject (đã có sẵn trong repo):
  ```gradle
  if (project.plugins.hasPlugin("org.jetbrains.kotlin.android") ||
      project.plugins.hasPlugin("kotlin-android")) {
    project.tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile).configureEach { task ->
      task.kotlinOptions { jvmTarget = "17" }
    }
  }
  ```
- Đảm bảo phiên bản Kotlin plugin khớp: trong `android/settings.gradle` có `org.jetbrains.kotlin.android` version `2.1.0` (hoặc tương thích với AGP đang dùng).

3) Làm sạch và build lại

```bash
flutter clean
flutter pub get
flutter run
```

Nếu vẫn còn lỗi, xoá thư mục `build/` trong root và trong `android/`, sau đó chạy lại các lệnh trên, hoặc mở issue kèm log lỗi đầy đủ.

### Lệnh hữu ích
- Làm sạch và lấy gói: `flutter clean && flutter pub get`
- Chạy Android/iOS: `flutter run`
- Chạy với endpoint tuỳ chỉnh: `flutter run --dart-define=thingsboardApiEndpoint=https://iot.greeniq.vn`

---

## Quy ước cấu trúc & Quy trình merge bản ThingsBoard mới

Mục tiêu: luôn có thể merge bản mới từ ThingsBoard App mà xung đột tối thiểu.

### Cấu trúc thư mục (merge‑friendly)
```
packages/
  greeniq_customizations/        # Plugin nội bộ chứa toàn bộ logic/màn hình bổ sung
lib/
  modules/device/devices_list_page.dart  # Gắn FAB (điểm móc mỏng)
  core/auth/login/login_page.dart        # Gắn nút Preview (điểm móc mỏng)
  config/routes/router.dart              # Đăng ký route /_preview (1 đoạn nhỏ)
```

Giải thích:
- Tất cả tính năng mới/logic riêng đặt trong `packages/greeniq_customizations` để không đụng code gốc.
- Ở code gốc chỉ thêm “điểm móc” gọi ra plugin (không nhúng logic vào file gốc).

### Điểm móc hiện tại (để so sánh khi merge)
- `lib/modules/device/devices_list_page.dart`: thêm FloatingActionButton sử dụng `GreeniqAddDeviceFab` + adapter điều hướng.
- (Đã gỡ) các điểm móc cho Preview gồm nút Preview ở `login_page.dart` và route `/_preview`.

### Nguyên tắc phát triển tiếp theo
- Thêm tính năng mới → đặt vào `packages/greeniq_customizations`, chỉ chạm code gốc bằng 1–2 điểm móc gọi plugin.
- Ưu tiên cấu hình bằng `--dart-define` và `kDebugMode` để hạn chế sửa nhiều file.
- Không chỉnh sửa file sinh tự động hoặc thư viện bên thứ ba.

### Quy trình cập nhật (khi có bản ThingsBoard mới)
1) Merge từ nhánh ThingsBoard gốc vào fork.
2) Kiểm tra 3 “điểm móc hiện tại” ở trên; nếu upstream đổi cấu trúc file, chèn lại 1–2 dòng gọi plugin.
3) `flutter pub get` → build thử `flutter run`.
4) Nếu có API/route thay đổi, cập nhật adapter trong app hoặc plugin cho phù hợp (không đổ logic vào file gốc).
