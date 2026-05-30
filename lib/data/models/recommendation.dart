class RecommendationResult {
  final int roomNo;
  final int? totalBudget;
  final int spentAmount;
  final int? remainingBudget;
  final String? requestedTag;
  final String? requestedRegion;
  final List<RecommendedPlace> places;

  const RecommendationResult({
    required this.roomNo,
    required this.totalBudget,
    required this.spentAmount,
    required this.remainingBudget,
    required this.requestedTag,
    required this.requestedRegion,
    required this.places,
  });

  factory RecommendationResult.fromJson(Map<String, dynamic> json) {
    return RecommendationResult(
      roomNo: json['roomNo'] as int,
      totalBudget: json['totalBudget'] as int?,
      spentAmount: json['spentAmount'] as int,
      remainingBudget: json['remainingBudget'] as int?,
      requestedTag: json['requestedTag'] as String?,
      requestedRegion: json['requestedRegion'] as String?,
      places: (json['places'] as List<dynamic>? ?? [])
          .map(
            (item) => RecommendedPlace.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class RecommendedPlace {
  final String? storeId;
  final String name;
  final String category;
  final int? expectedPrice;
  final String? walkTime;
  final double? rating;
  final String thumbnailUrl;
  final String address;
  final String mapUrl;
  final String source;
  final String reason;

  const RecommendedPlace({
    required this.storeId,
    required this.name,
    required this.category,
    required this.expectedPrice,
    required this.walkTime,
    required this.rating,
    required this.thumbnailUrl,
    required this.address,
    required this.mapUrl,
    required this.source,
    required this.reason,
  });

  factory RecommendedPlace.fromJson(Map<String, dynamic> json) {
    return RecommendedPlace(
      storeId: json['storeId'] as String?,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '기타요식업',
      expectedPrice: json['expectedPrice'] as int?,
      walkTime: json['walkTime'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      thumbnailUrl:
          json['thumbnailUrl'] as String? ??
          'assets/images/figma/reco_food.png',
      address: json['address'] as String? ?? '',
      mapUrl: json['mapUrl'] as String? ?? '',
      source: json['source'] as String? ?? 'GOOD_PRICE_STORE',
      reason: json['reason'] as String? ?? '착한가격업소 기준으로 추천했어요.',
    );
  }
}
