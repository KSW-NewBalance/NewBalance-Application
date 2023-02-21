import 'package:flutter/cupertino.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

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
    var response =
        await tbClient.login(LoginRequest('tenant@thingsboard.org', 'tenant'));
    //debugPrint('jwt: ${response.token}');

    findDeviceByFootId();
  }

  void addDevice() async {
    try {
      // Construct device object
      var device = Device('App Device', 'default');
      device.additionalInfo = {'description': 'Test App Device'};

      // Add device
      var savedDevice = await tbClient.getDeviceService().saveDevice(device);
      debugPrint('savedDevice: ${savedDevice}');
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('Stack: $s');
    }
  }

  static void findDeviceByFootId() {
    findRightFootDevice();
    findLeftFootDevice();
  }

  // Find device by device id
  static void findRightFootDevice() async {
    DeviceInfo? foundDevice = await tbClient
        .getDeviceService()
        .getDeviceInfo(rightFootId);
    debugPrint('right foundDevice: ${foundDevice}');
    rightFootDevice = foundDevice;
  }

  static void findLeftFootDevice() async {
    DeviceInfo? foundDevice = await tbClient
        .getDeviceService()
        .getDeviceInfo(leftFootId);
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
}
