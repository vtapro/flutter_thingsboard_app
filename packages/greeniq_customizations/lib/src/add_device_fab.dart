import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:greeniq_customizations/src/provisioning_navigator.dart';

class GreeniqAddDeviceFab extends StatelessWidget {
  const GreeniqAddDeviceFab({super.key, required this.navigator});
  final GreeniqProvisioningNavigator navigator;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'addMeshDevice',
      tooltip: 'Add device',
      onPressed: () => _onPressed(context),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    try {
      final raw = await navigator.scanQrRawValue();
      if (raw == null) return;
      final decoded = jsonDecode(raw) as Map<String, dynamic>?;
      final transport = decoded?['transport']?.toString();
      if (transport == null || decoded == null) return;

      final args = <String, String>{
        'deviceName': (decoded['tbDeviceName'] ?? decoded['name'] ?? '').toString(),
        'deviceSecretKey': (decoded['tbSecretKey'] ?? decoded['pop'] ?? '').toString(),
        'name': (decoded['name'] ?? decoded['tbDeviceName'] ?? '').toString(),
        'pop': (decoded['pop'] ?? decoded['tbSecretKey'] ?? '').toString(),
      };

      bool? ok;
      switch (transport.toLowerCase()) {
        case 'ble':
          ok = await navigator.startBle(args);
          break;
        case 'softap':
          ok = await navigator.startSoftAp(args);
          break;
      }

      if (ok == true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Device provisioned successfully')),
        );
      }
    } catch (_) {
      // ignore for now
    }
  }
}

