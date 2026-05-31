class LocationSearchResult {
  final String name;
  final String address;
  final double lat;
  final double lng;

  const LocationSearchResult({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory LocationSearchResult.fromJson(Map<String, dynamic> json) {
    return LocationSearchResult(
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}
