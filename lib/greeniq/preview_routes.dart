import 'package:fluro/fluro.dart';
import 'package:thingsboard_app/config/routes/tb_routes.dart';
import 'package:thingsboard_app/greeniq/preview_page.dart';

class PreviewRoutes extends TbRoutes {
  PreviewRoutes(super.tbContext);

  @override
  void doRegisterRoutes(FluroRouter router) {
    router.define('/_preview', handler: Handler(
      handlerFunc: (context, params) => const PreviewPage(),
    ));
  }
}

