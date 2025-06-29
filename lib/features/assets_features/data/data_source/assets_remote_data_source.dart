import 'package:tractian_task/features/assets_features/data/models/assets_model.dart';
import 'package:tractian_task/features/assets_features/data/models/company_model.dart';
import 'package:tractian_task/features/assets_features/data/models/location_model.dart';

class ApiService {
  static const String baseUrl = 'https://fake-api.tractian.com';

  static Future<List<Company>> getCompanies() async {
    return [
      Company(id: '662fd0ee639069143a8fc387', name: 'Jaguar Unit'),
      Company(id: '662fd0fab3fd5656edb39af5', name: 'Tobias Unit'),
      Company(id: '662fd100f990557384756e58', name: 'Apex Unit'),
    ];
  }

  static Future<List<Location>> getCompanyLocations(String companyId) async {
    return [
      Location(
        id: "65674204664c41001e91ecb4",
        name: "PRODUCTION AREA - RAW MATERIAL",
        parentId: null,
      ),
      Location(
        id: "656a07b3f2d4a1001e2144bf",
        name: "CHARCOAL STORAGE SECTOR",
        parentId: "65674204664c41001e91ecb4",
      ),
      Location(
        id: "656a07b3f2d4a1001e2144c0",
        name: "MACHINERY HOUSE",
        parentId: null,
      ),
    ];
  }

  static Future<List<Asset>> getCompanyAssets(String companyId) async {
    return [
      Asset(
        id: "656734821f4664001f296973",
        name: "Fan - External",
        sensorId: "MTC052",
        sensorType: "energy",
        status: "operating",
        gatewayId: "QHI640",
      ),
      Asset(
        id: "656a07bbf2d4a1001e2144c2",
        name: "CONVEYOR BELT ASSEMBLY",
        locationId: "656a07b3f2d4a1001e2144bf",
      ),
      Asset(
        id: "656a07c3f2d4a1001e2144c5",
        name: "MOTOR TC01 COAL UNLOADING AF02",
        parentId: "656a07bbf2d4a1001e2144c2",
      ),
      Asset(
        id: "656a07cdc50ec9001e84167b",
        name: "MOTOR RT COAL AF01",
        parentId: "656a07c3f2d4a1001e2144c5",
        sensorId: "FIJ309",
        sensorType: "energy",
        status: "operating",
        gatewayId: "FRH546",
      ),
      Asset(
        id: "656a07b3f2d4a1001e2144d0",
        name: "MOTORS H12D",
        locationId: "656a07b3f2d4a1001e2144c0",
      ),
      Asset(
        id: "656a07b3f2d4a1001e2144d1",
        name: "MOTORS H12D - Stage 1",
        parentId: "656a07b3f2d4a1001e2144d0",
        sensorId: "ABC123",
        sensorType: "vibration",
        status: "alert",
        gatewayId: "GHI789",
      ),
      Asset(
        id: "656a07b3f2d4a1001e2144d2",
        name: "MOTORS H12D - Stage 2",
        parentId: "656a07b3f2d4a1001e2144d0",
        sensorId: "DEF456",
        sensorType: "vibration",
        status: "alert",
        gatewayId: "JKL012",
      ),
      Asset(
        id: "656a07b3f2d4a1001e2144d3",
        name: "MOTORS H12D - Stage 3",
        parentId: "656a07b3f2d4a1001e2144d0",
        sensorId: "GHI789",
        sensorType: "vibration",
        status: "alert",
        gatewayId: "MNO345",
      ),
    ];
  }
}
