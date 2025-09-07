import 'package:flutter/material.dart';
import 'package:thingsboard_app/config/routes/router.dart';
import 'package:thingsboard_app/core/context/tb_context_widget.dart';
import 'package:thingsboard_app/generated/l10n.dart';
import 'package:thingsboard_app/locator.dart';
import 'package:thingsboard_app/modules/device/devices_base.dart';
import 'package:thingsboard_app/modules/device/devices_list.dart';
import 'package:thingsboard_app/widgets/tb_app_bar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fluro/fluro.dart';
import 'package:greeniq_customizations/greeniq_customizations.dart';
import 'package:thingsboard_app/modules/device/provisioning/route/esp_provisioning_route.dart';
import 'package:thingsboard_app/widgets/tb_app_search_bar.dart';

class DevicesListPage extends TbContextWidget {
  DevicesListPage(
    super.tbContext, {
    this.deviceType,
    this.active,
    this.searchMode = false,
    super.key,
  });
  final String? deviceType;
  final bool? active;
  final bool searchMode;

  @override
  State<StatefulWidget> createState() => _DevicesListPageState();
}

class _DevicesListPageState extends TbContextState<DevicesListPage>
    with AutomaticKeepAliveClientMixin<DevicesListPage> {
  late final DeviceQueryController _deviceQueryController;

  @override
  void initState() {
    super.initState();
    _deviceQueryController = DeviceQueryController(
      deviceType: widget.deviceType,
      active: widget.active,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final devicesList = DevicesList(
      tbContext,
      _deviceQueryController,
      searchMode: widget.searchMode,
      displayDeviceImage: widget.deviceType == null,
    );
    PreferredSizeWidget appBar;
    if (widget.searchMode) {
      appBar = TbAppSearchBar(
        tbContext,
        onSearch:
            (searchText) => _deviceQueryController.onSearchText(searchText),
      );
    } else {
      final String titleText =
          widget.deviceType != null
              ? widget.deviceType!
              : S.of(context).allDevices;
      String? subTitleText;
      if (widget.active != null) {
        subTitleText =
            widget.active == true
                ? S.of(context).active
                : S.of(context).inactive;
      }
      final Column title = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: subTitleText != null ? 16 : 20,
              height: subTitleText != null ? 20 / 16 : 24 / 20,
            ),
          ),
          if (subTitleText != null)
            Text(
              subTitleText,
              style: TextStyle(
                color: Theme.of(context).primaryTextTheme.titleLarge!.color!
                    .withAlpha((0.38 * 255).ceil()),
                fontSize: 12,
                fontWeight: FontWeight.normal,
                height: 16 / 12,
              ),
            ),
        ],
      );

      appBar = TbAppBar(
        tbContext,
        title: title,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final List<String> params = [];
              // translate-me-ignore-next-line
              params.add('search=true');
              if (widget.deviceType != null) {
                // translate-me-ignore-next-line
                params.add('deviceType=${widget.deviceType}');
              }
              if (widget.active != null) {
                // translate-me-ignore-next-line
                params.add('active=${widget.active}');
              }
              getIt<ThingsboardAppRouter>()
              // translate-me-ignore-next-line
              .navigateTo('/deviceList?${params.join('&')}');
            },
          ),
        ],
      );
    }
    return Scaffold(
      appBar: appBar,
      body: devicesList,
      floatingActionButton: GreeniqAddDeviceFab(
        navigator: _AppProvisioningNavigator(getIt<ThingsboardAppRouter>()),
      ),
    );
  }

  @override
  void dispose() {
    _deviceQueryController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class _AppProvisioningNavigator implements GreeniqProvisioningNavigator {
  _AppProvisioningNavigator(this.router);
  final ThingsboardAppRouter router;

  @override
  Future<String?> scanQrRawValue() async {
    final Barcode? barcode = await router.navigateTo(
      '/qrCodeScan?isProvisioning=true',
      transition: TransitionType.nativeModal,
    );
    return barcode?.rawValue;
  }

  @override
  Future<bool?> startBle(Map<String, String> args) {
    return router.navigateTo(
      EspProvisioningRoute.wifiRoute,
      routeSettings: RouteSettings(arguments: args),
    );
  }

  @override
  Future<bool?> startSoftAp(Map<String, String> args) {
    return router.navigateTo(
      EspProvisioningRoute.softApRoute,
      routeSettings: RouteSettings(arguments: args),
    );
  }
}
