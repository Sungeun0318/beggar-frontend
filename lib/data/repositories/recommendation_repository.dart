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
  }) async {
    final json = await _apiClient.get(
      '/rooms/$roomNo/recommend',
      query: {'tag': tag, 'region': region},
    );
    return RecommendationResult.fromJson(json);
  }
}
