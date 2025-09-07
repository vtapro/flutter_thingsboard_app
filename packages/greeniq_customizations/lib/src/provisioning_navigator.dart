abstract class GreeniqProvisioningNavigator {
  Future<String?> scanQrRawValue();
  Future<bool?> startBle(Map<String, String> args);
  Future<bool?> startSoftAp(Map<String, String> args);
}

