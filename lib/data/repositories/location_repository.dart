import 'package:beggar_app/data/api/api_client.dart';
import 'package:beggar_app/data/models/location_search_result.dart';

class LocationRepository {
  LocationRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<LocationSearchResult>> search(String query) async {
    final json = await _apiClient.getList(
      '/locations/search',
      query: {'query': query},
    );
    return json
        .map(
          (item) => LocationSearchResult.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}
