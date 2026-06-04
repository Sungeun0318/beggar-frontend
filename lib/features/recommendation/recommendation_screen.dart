import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/core/utils/formatters.dart';
import 'package:beggar_app/data/models/location_search_result.dart';
import 'package:beggar_app/data/models/recommendation.dart';
import 'package:beggar_app/data/repositories/location_repository.dart';
import 'package:beggar_app/data/repositories/recommendation_repository.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';
import 'package:beggar_app/shared/widgets/recommendation_card.dart';
import 'package:beggar_app/shared/widgets/summary_row.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendationScreen extends StatefulWidget {
  final int roomNo;
  final String initialTag;
  final String region;
  final List<String> tags;
  final VoidCallback onBack;
  final VoidCallback onDone;

  const RecommendationScreen({
    super.key,
    required this.roomNo,
    required this.initialTag,
    required this.region,
    required this.tags,
    required this.onBack,
    required this.onDone,
  });

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  static const int _nearbyRadius = 5000;

  final RecommendationRepository _recommendationRepository =
      RecommendationRepository();
  late String _selectedTag;
  late String _selectedRegion;
  String? _selectedRegionQuery;
  double? _selectedLat;
  double? _selectedLng;
  RecommendationResult? _recommendationResult;
  Object? _recommendationError;
  bool _isLoadingRecommendation = false;
  int _recommendationRequestId = 0;

  @override
  void initState() {
    super.initState();
    _selectedTag = widget.initialTag;
    _selectedRegion = widget.region;
    _refreshRecommendation(showFullLoading: true);
  }

  Future<RecommendationResult> _loadRecommendation() {
    return _recommendationRepository.recommend(
      roomNo: widget.roomNo,
      tag: _selectedTag,
      region:
          _selectedRegionQuery ??
          (_selectedLat == null ? _selectedRegion : null),
      lat: _selectedLat,
      lng: _selectedLng,
      radius: _selectedLat == null ? null : _nearbyRadius,
    );
  }

  void _selectTag(String tag) {
    if (_selectedTag == tag) {
      return;
    }
    setState(() {
      _selectedTag = tag;
    });
    _refreshRecommendation();
  }

  void _selectLocation(LocationSearchResult location) {
    setState(() {
      _selectedRegion = location.name.isEmpty
          ? location.address
          : location.name;
      _selectedRegionQuery = _regionQuery(location.address);
      _selectedLat = location.lat;
      _selectedLng = location.lng;
    });
    _refreshRecommendation(showFullLoading: true);
  }

  void _selectManualRegion(String region) {
    final trimmed = region.trim();
    if (trimmed.isEmpty) {
      return;
    }
    setState(() {
      _selectedRegion = trimmed;
      _selectedRegionQuery = trimmed;
      _selectedLat = null;
      _selectedLng = null;
    });
    _refreshRecommendation(showFullLoading: true);
  }

  void _retryRecommendation() {
    _refreshRecommendation(showFullLoading: true);
  }

  Future<void> _refreshRecommendation({bool showFullLoading = false}) async {
    final requestId = ++_recommendationRequestId;
    setState(() {
      _isLoadingRecommendation = true;
      _recommendationError = null;
      if (showFullLoading) {
        _recommendationResult = null;
      }
    });

    try {
      final result = await _loadRecommendation();
      if (!mounted || requestId != _recommendationRequestId) {
        return;
      }
      setState(() {
        _recommendationResult = result;
        _recommendationError = null;
        _isLoadingRecommendation = false;
      });
    } catch (error, stackTrace) {
      debugPrint('Recommendation request failed\n$error\n$stackTrace');
      if (!mounted || requestId != _recommendationRequestId) {
        return;
      }
      setState(() {
        _recommendationError = error;
        _isLoadingRecommendation = false;
      });
      if (_recommendationResult != null) {
        _showSnack('추천 갱신에 실패했어. 이전 추천을 유지할게.');
      }
    }
  }

  Future<void> _useCurrentLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      _showSnack('기기 위치 서비스가 꺼져 있어.');
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      _showSnack('위치 권한을 허용해야 현재 위치 추천을 쓸 수 있어.');
      return;
    }
    if (permission == LocationPermission.deniedForever) {
      _showSnack('설정에서 위치 권한을 허용해줘.');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      debugPrint(
        'Current position lat=${position.latitude}, lng=${position.longitude}',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedRegion = '현재 위치';
        _selectedRegionQuery = null;
        _selectedLat = position.latitude;
        _selectedLng = position.longitude;
      });
      _refreshRecommendation(showFullLoading: true);
    } catch (error, stackTrace) {
      debugPrint('Current location failed\n$error\n$stackTrace');
      _showSnack('현재 위치를 가져오지 못했어.');
    }
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openLocationSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.card),
        ),
      ),
      builder: (context) {
        return _LocationSheet(
          selectedRegion: _selectedRegion,
          onCurrentLocation: () async {
            Navigator.of(context).pop();
            await _useCurrentLocation();
          },
          onLocationSelected: (location) {
            Navigator.of(context).pop();
            _selectLocation(location);
          },
          onManualRegion: (region) {
            Navigator.of(context).pop();
            _selectManualRegion(region);
          },
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant RecommendationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roomNo != widget.roomNo ||
        oldWidget.region != widget.region ||
        oldWidget.initialTag != widget.initialTag) {
      _selectedTag = widget.initialTag;
      _selectedRegion = widget.region;
      _selectedRegionQuery = null;
      _selectedLat = null;
      _selectedLng = null;
      _refreshRecommendation(showFullLoading: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '예산에 맞는 추천', onBack: widget.onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildRecommendationBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationBody() {
    final result = _recommendationResult;
    if (result == null) {
      if (_isLoadingRecommendation) {
        return const _RecommendationLoading();
      }
      return _RecommendationError(
        message: _recommendationError?.toString() ?? '추천 결과가 아직 없어.',
        onRetry: _retryRecommendation,
      );
    }

    return Stack(
      children: [
        _RecommendationContent(
          result: result,
          selectedRegion: _selectedRegion,
          tags: widget.tags,
          selectedTag: _selectedTag,
          onTagSelected: _selectTag,
          onLocationTap: _openLocationSheet,
          onDone: widget.onDone,
        ),
        if (_isLoadingRecommendation)
          const Positioned(
            top: 0,
            left: AppSpacing.pageH,
            right: AppSpacing.pageH,
            child: LinearProgressIndicator(
              minHeight: 3,
              color: AppColors.accent,
              backgroundColor: AppColors.muted,
            ),
          ),
      ],
    );
  }

  String _regionQuery(String address) {
    final parts = address.trim().split(RegExp(r'\s+'));
    if (parts.length >= 3) {
      return parts.take(3).join(' ');
    }
    return address.trim();
  }
}

class _RecommendationContent extends StatelessWidget {
  final RecommendationResult result;
  final String selectedRegion;
  final List<String> tags;
  final String selectedTag;
  final ValueChanged<String> onTagSelected;
  final VoidCallback onLocationTap;
  final VoidCallback onDone;

  const _RecommendationContent({
    required this.result,
    required this.selectedRegion,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
    required this.onLocationTap,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final budgetLabel = result.recommendationBudget == null
        ? (result.totalBudget == null ? '예산 정보 없이 추천' : '남은 예산 기준 추천')
        : '1인 추천 예산 ${money(result.recommendationBudget!)}원';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onLocationTap,
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: SummaryRow(
              icon: Icons.location_on_outlined,
              label: selectedRegion.isEmpty ? '지역 전체' : selectedRegion,
              trailing: '변경',
              bg: AppColors.accentBg,
            ),
          ),
          const SizedBox(height: 10),
          SummaryRow(
            icon: Icons.account_balance_wallet_outlined,
            label: budgetLabel,
            bg: const Color(0xFFF4F6FF),
          ),
          if (tags.length > 1) ...[
            const SizedBox(height: 16),
            _TagSelector(
              tags: tags,
              selectedTag: selectedTag,
              onSelected: onTagSelected,
            ),
          ],
          if (result.budgetGuide != null) ...[
            const SizedBox(height: 14),
            _BudgetGuide(message: result.budgetGuide!),
          ],
          const SizedBox(height: 22),
          if (result.places.isEmpty)
            const _EmptyRecommendation()
          else
            for (final place in result.places) ...[
              _ApiRecommendationCard(
                place: place,
                onMapTap: () => _openMap(context, place.mapUrl),
              ),
              const SizedBox(height: 14),
            ],
          const SizedBox(height: AppSpacing.gap24),
          const _RecommendationNotice(),
          const SizedBox(height: AppSpacing.gap24),
          PrimaryButton(label: '거지방 시작하기', onTap: onDone),
          const SizedBox(height: AppSpacing.bottomSafe),
        ],
      ),
    );
  }

  Future<void> _openMap(BuildContext context, String mapUrl) async {
    final shouldOpen = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: softBox(radius: AppRadius.card),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '카카오맵으로 이동할까요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '선택한 가게를 카카오맵에서 확인할 수 있어요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                  color: AppColors.sub,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(dialogContext).pop(false),
                      borderRadius: BorderRadius.circular(AppRadius.compact),
                      child: Container(
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(
                            AppRadius.compact,
                          ),
                          border: Border.all(color: AppColors.muted),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.sub,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(dialogContext).pop(true),
                      borderRadius: BorderRadius.circular(AppRadius.compact),
                      child: Container(
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(
                            AppRadius.compact,
                          ),
                        ),
                        child: const Text(
                          '확인',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (shouldOpen != true || !context.mounted) return;

    final uri = Uri.tryParse(mapUrl);
    final opened = uri != null
        ? await launchUrl(uri, mode: LaunchMode.externalApplication)
        : false;

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('카카오맵을 열 수 없어요.')));
    }
  }
}

class _ApiRecommendationCard extends StatelessWidget {
  final RecommendedPlace place;
  final VoidCallback onMapTap;

  const _ApiRecommendationCard({required this.place, required this.onMapTap});

  @override
  Widget build(BuildContext context) {
    final (tagBg, tagColor) = _tagColors(place.category);
    return RecommendationCard(
      image: place.thumbnailUrl,
      tag: place.category,
      title: place.name,
      walk: place.walkTime == null
          ? place.address
          : '${place.walkTime} · ${place.address}',
      rating: place.menuName == null || place.menuName!.isEmpty
          ? '대표 메뉴'
          : place.menuName!,
      amount: place.expectedPrice == null
          ? '가격 정보 없음'
          : '${money(place.expectedPrice!)}원',
      tagBg: tagBg,
      tagColor: tagColor,
      onMapTap: onMapTap,
    );
  }

  (Color, Color) _tagColors(String category) {
    if (category.contains('기타')) {
      return (AppColors.tagBgCafe, AppColors.tagFgCafe);
    }
    return (AppColors.tagBgFood, AppColors.danger);
  }
}

class _LocationSheet extends StatefulWidget {
  final String selectedRegion;
  final Future<void> Function() onCurrentLocation;
  final ValueChanged<LocationSearchResult> onLocationSelected;
  final ValueChanged<String> onManualRegion;

  const _LocationSheet({
    required this.selectedRegion,
    required this.onCurrentLocation,
    required this.onLocationSelected,
    required this.onManualRegion,
  });

  @override
  State<_LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends State<_LocationSheet> {
  final LocationRepository _locationRepository = LocationRepository();
  final TextEditingController _controller = TextEditingController();
  List<LocationSearchResult> _searchResults = [];
  String? _searchError;
  bool _isSearching = false;
  int _searchRequestId = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty || _isSearching) {
      return;
    }
    FocusScope.of(context).unfocus();
    debugPrint('Location search query=$query');
    final requestId = ++_searchRequestId;
    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      final results = await _locationRepository.search(query);
      if (!mounted || requestId != _searchRequestId) {
        return;
      }
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (error, stackTrace) {
      debugPrint('Location search failed\n$error\n$stackTrace');
      if (!mounted || requestId != _searchRequestId) {
        return;
      }
      setState(() {
        _searchError = '지역 검색을 불러오지 못했어.';
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.pageH,
        right: AppSpacing.pageH,
        top: 22,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '추천 지역',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.sub),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              widget.selectedRegion,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.sub,
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _isSearching ? null : widget.onCurrentLocation,
              icon: const Icon(Icons.my_location, size: 18),
              label: const Text('현재 위치 사용'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.text,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.compact),
                ),
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      hintText: '동네, 역, 건물명 검색',
                      filled: true,
                      fillColor: AppColors.bg,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.compact),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isSearching ? null : _search,
                  icon: _isSearching
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(48, 48),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isSearching)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
              )
            else if (_searchError != null)
              _LocationMessage(
                message: _searchError!,
                actionLabel: '다시 검색',
                onAction: _search,
              )
            else if (_controller.text.trim().isNotEmpty &&
                _searchResults.isEmpty)
              _LocationMessage(
                message: '검색 결과가 없어.',
                actionLabel: '입력한 지역으로 검색',
                onAction: () => widget.onManualRegion(_controller.text),
              )
            else if (_searchResults.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, index) {
                    final item = _searchResults[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      subtitle: Text(
                        item.address,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.sub),
                      ),
                      onTap: () => widget.onLocationSelected(item),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LocationMessage extends StatelessWidget {
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _LocationMessage({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.sub,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class _TagSelector extends StatelessWidget {
  final List<String> tags;
  final String selectedTag;
  final ValueChanged<String> onSelected;

  const _TagSelector({
    required this.tags,
    required this.selectedTag,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in tags)
          _TagButton(
            label: tag,
            selected: tag == selectedTag,
            onTap: () => onSelected(tag),
          ),
      ],
    );
  }
}

class _TagButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TagButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.chip),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentBg : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.text : AppColors.sub,
          ),
        ),
      ),
    );
  }
}

class _BudgetGuide extends StatelessWidget {
  final String message;

  const _BudgetGuide({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: softBox(color: AppColors.bg, radius: AppRadius.compact),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: 18,
            color: AppColors.brown,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: AppColors.darkSub,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationNotice extends StatelessWidget {
  const _RecommendationNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: softBox(
        color: AppColors.accentBg,
        radius: AppRadius.card,
        shadow: true,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Image.asset(Assets.mascotSmall, width: 28, height: 28),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '남는 예산까지 고려한 조합을\n추천해드려요!',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: AppColors.darkSub,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.brown),
        ],
      ),
    );
  }
}

class _RecommendationLoading extends StatelessWidget {
  const _RecommendationLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.accent),
    );
  }
}

class _RecommendationError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _RecommendationError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: softBox(radius: AppRadius.card),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '추천을 불러오지 못했어요.\n$message',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkSub,
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(label: '다시 불러오기', onTap: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyRecommendation extends StatelessWidget {
  const _EmptyRecommendation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: softBox(radius: AppRadius.card),
      child: const Text(
        '조건에 맞는 추천이 부족해서 범위를 넓혀봤어요.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkSub,
        ),
      ),
    );
  }
}
