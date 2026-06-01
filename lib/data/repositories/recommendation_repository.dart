import 'package:beggar_app/data/api/api_client.dart';
import 'package:beggar_app/data/models/recommendation.dart';

class RecommendationRepository {
  RecommendationRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<RecommendationResult> recommend({
    required int roomNo,
    String? tag,
    String? region,
    double? lat,
    double? lng,
    int? radius,
  }) async {
    final json = await _apiClient.get(
      '/rooms/$roomNo/recommend',
      query: {
        'tag': tag,
        'region': region,
        'lat': lat?.toString(),
        'lng': lng?.toString(),
        'radius': radius?.toString(),
      },
    );
    return RecommendationResult.fromJson(json);
  }
}
