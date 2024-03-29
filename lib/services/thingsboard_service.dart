import 'package:flutter/cupertino.dart';
import 'package:thingsboard_client/thingsboard_client.dart';
import 'package:newbalance_flutter/util/constants.dart' as constants;

class ThingsBoardService {
  static const String apiEndPoint = 'http://34.125.194.104:8080/';
  static const String rightFootId = 'b5fe57a0-b153-11ed-8412-f17eb4c552ac';
  static const String leftFootId = 'a1bc5670-b153-11ed-8412-f17eb4c552ac';

  // Create instance of ThingsBoard API Client
  static var tbClient = ThingsboardClient(apiEndPoint);
  static var rightFootDevice;
  static var leftFootDevice;

  // Perform login with default Tenant Administrator credentials
  static void performLoginInTenant() async {
    await tbClient.login(LoginRequest('tenant@thingsboard.org', 'tenant'));
    findDeviceByFootId();
  }

  static void findDeviceByFootId() {
    findRightFootDevice();
    findLeftFootDevice();
  }

  // Find device by device id
  static void findRightFootDevice() async {
    DeviceInfo? foundDevice =
        await tbClient.getDeviceService().getDeviceInfo(rightFootId);
    debugPrint('right foundDevice: ${foundDevice}');
    rightFootDevice = foundDevice;
  }

  static void findLeftFootDevice() async {
    DeviceInfo? foundDevice =
        await tbClient.getDeviceService().getDeviceInfo(leftFootId);
    debugPrint('left foundDevice: ${foundDevice}');
    leftFootDevice = foundDevice;
  }

  // Save device shared attributes
  static void saveSharedAttributes(DeviceInfo device, bool value) async {
    var res = await tbClient.getAttributeService().saveEntityAttributesV2(
        device.id!,
        AttributeScope.SHARED_SCOPE.toShortString(),
        {'isRunning': value});
    debugPrint('Save attributes result: $res');
  }

  // Get device shared attributes
  static Future<Map> getSharedAttributes(DeviceInfo device) async {
    List<AttributeKvEntry> attributes = await tbClient
        .getAttributeService()
        .getAttributesByScope(
            device.id!, AttributeScope.SHARED_SCOPE.toShortString(), [
      constants.avgFootAngle,
      constants.fsr1,
      constants.fsr2,
      constants.fsr3,
      constants.fsr4
    ]);

    var dataMap = {};
    for (var entry in attributes) {
      debugPrint('${entry.getKey()}: ${entry.getValue()}');
      dataMap[entry.getKey()] = entry.getValue();
    }

    return dataMap;
  }
}
