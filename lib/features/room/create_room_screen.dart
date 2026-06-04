import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/config/api_config.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/data/models/location_search_result.dart';
import 'package:beggar_app/data/repositories/location_repository.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/choice_box.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/info_card.dart';
import 'package:beggar_app/shared/widgets/input_like.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';
import 'package:beggar_app/shared/widgets/round_icon.dart';
import 'package:beggar_app/shared/widgets/section_title.dart';

class CreateRoomScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;

  const CreateRoomScreen({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  static const String _locationPlaceholder = '예) 강남역, 홍대입구';

  final TextEditingController _roomNameController = TextEditingController();
  LocationSearchResult? _selectedLocation;
  int _maxMemberCount = 4;
  String? _selectedTag;
  bool _isCreatingRoom = false;

  // 백엔드로 데이터 전송 로직
  Future<void> _createNewRoom() async {
    if (_isCreatingRoom) {
      return;
    }
    if (_roomNameController.text.trim().isEmpty) {
      _showSnackBar('거지방 이름을 입력해 주세요!');
      return;
    }
    if (_selectedLocation == null) {
      _showSnackBar('모임 장소(지하철역 등)를 검색해 주세요!');
      return;
    }
    if (_selectedTag == null) {
      _showSnackBar('모임 태그를 선택해 주세요!');
      return;
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/rooms');

    setState(() {
      _isCreatingRoom = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "roomName": _roomNameController.text,
          "tags": [_selectedTag],
          "isFriends": false,
          "location": _selectedLocation!.address.isEmpty
              ? _selectedLocation!.name
              : _selectedLocation!.address,
          "maxMemberCount": _maxMemberCount,
        }),
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final result = jsonDecode(utf8.decode(response.bodyBytes));
        debugPrint("방 생성 성공: $result");
        widget.onNext();
      } else {
        final body = utf8.decode(response.bodyBytes);
        debugPrint("서버 에러: ${response.statusCode} $body");
        _showSnackBar('방 생성에 실패했어. (${response.statusCode})');
      }
    } catch (e) {
      debugPrint("연결 실패: $e");
      _showSnackBar('서버와 연결하지 못했어.');
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingRoom = false;
        });
      }
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      _selectedTag = _selectedTag == tag ? null : tag;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      height: 930,
      child: Stack(
        children: [
          AppHeader.titled(title: '새 거지방 만들기', onBack: widget.onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageH,
                0,
                AppSpacing.pageH,
                132,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('거지방 이름'),
                  const SizedBox(height: 13),
                  TextField(
                    controller: _roomNameController,
                    decoration: InputDecoration(
                      hintText: '예) 마라탕 참기 모임',
                      filled: true,
                      fillColor: AppColors.bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.compact),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const SectionTitle('어디서 모이나요?'),
                  const SizedBox(height: 13),

                  // 🌟 장소 칸 터치 시 카카오 진짜 키보드 검색창 화면으로 이동!
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push<LocationSearchResult>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchAddressPage(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          _selectedLocation = result;
                        });
                      }
                    },
                    child: InputLike(
                      label: _selectedLocation == null
                          ? _locationPlaceholder
                          : (_selectedLocation!.name.isEmpty
                                ? _selectedLocation!.address
                                : _selectedLocation!.name),
                      icon: Icons.location_on_outlined,
                      selected: _selectedLocation != null,
                    ),
                  ),
                  const SizedBox(height: 38),

                  const SectionTitle('어떤 모임인가요?'),
                  const SizedBox(height: 13),
                  GridView.count(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 166 / 56,
                    children: [
                      _buildTagChoice('한식', Icons.restaurant),
                      _buildTagChoice('양식', Icons.restaurant),
                      _buildTagChoice('일식', Icons.ramen_dining),
                      _buildTagChoice('중식', Icons.outdoor_grill),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTagChoice(
                    '기타 요식업',
                    Icons.restaurant,
                    isFullWidth: true,
                  ),
                  const SizedBox(height: 38),

                  const SectionTitle('몇 명이서 모이나요?'),
                  const SizedBox(height: 13),
                  Container(
                    height: 72,
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    decoration: softBox(radius: AppRadius.compact),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.bg,
                          child: Icon(
                            Icons.groups_outlined,
                            color: AppColors.brown,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '참여 인원',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkSub,
                          ),
                        ),
                        const Spacer(),

                        GestureDetector(
                          onTap: () {
                            if (_maxMemberCount > 2) {
                              setState(() {
                                _maxMemberCount--;
                              });
                            }
                          },
                          child: const RoundIcon(icon: Icons.remove),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '$_maxMemberCount',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),

                        GestureDetector(
                          onTap: () {
                            if (_maxMemberCount < 100) {
                              setState(() {
                                _maxMemberCount++;
                              });
                            }
                          },
                          child: const RoundIcon(icon: Icons.add),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '* 최소 2명부터 최대 100명까지 참여 가능해요.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.sub,
                    ),
                  ),
                  const SizedBox(height: 34),
                  const InfoCard(
                    icon: Icons.lock_outline,
                    title: '개인 예산은 익명으로 수집돼요',
                    body: '가장 낮은 금액 기준으로\n오늘의 총예산이 정해져요.',
                  ),
                  const SizedBox(height: AppSpacing.gap24),
                  PrimaryButton(
                    label: _isCreatingRoom ? '방 만드는 중...' : '방 만들기',
                    onTap: _createNewRoom,
                    enabled: !_isCreatingRoom,
                  ),
                  const SizedBox(height: AppSpacing.gap24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChoice(
    String label,
    IconData icon, {
    bool isFullWidth = false,
  }) {
    final isSelected = _selectedTag == label;
    Widget choice = ChoiceBox(icon: icon, label: label);

    if (isFullWidth) {
      choice = SizedBox(height: 56, child: choice);
    }

    return GestureDetector(
      onTap: () => _toggleTag(label),
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                border: Border.all(color: AppColors.brown, width: 2),
                borderRadius: BorderRadius.circular(AppRadius.compact),
              )
            : null,
        child: choice,
      ),
    );
  }
}

// 카카오 통합 키보드 검색창
class SearchAddressPage extends StatefulWidget {
  const SearchAddressPage({super.key});

  @override
  State<SearchAddressPage> createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends State<SearchAddressPage> {
  final LocationRepository _locationRepository = LocationRepository();
  final TextEditingController _searchController = TextEditingController();
  List<LocationSearchResult> _searchResults = [];
  Timer? _debounceTimer;
  bool _isLoading = false;
  int _searchRequestId = 0;
  String? _errorMessage;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 350),
      () => _searchLocation(query),
    );
  }

  Future<void> _searchLocation(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
        _errorMessage = null;
      });
      return;
    }

    final requestId = ++_searchRequestId;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _locationRepository.search(query);
      if (!mounted || requestId != _searchRequestId) {
        return;
      }
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint('방 생성 지역 검색 실패\n$error\n$stackTrace');
      if (!mounted || requestId != _searchRequestId) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = '지역 검색을 불러오지 못했어.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '내 근처 역 검색',
          style: TextStyle(color: AppColors.brown, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 카카오 검색어 타이핑 입력창
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: _searchLocation,
              decoration: InputDecoration(
                hintText: '지하철역 이름이나 장소를 입력하세요 (ex: 홍대입구)',
                prefixIcon: const Icon(Icons.search, color: AppColors.brown),
                filled: true,
                fillColor: AppColors.bg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 쭈루룩 나열될 카카오 실제 검색 결과 공간
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.brown),
                    )
                  : _errorMessage != null
                  ? Center(
                      child: Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.sub),
                      ),
                    )
                  : _searchResults.isEmpty
                  ? const Center(
                      child: Text(
                        '검색 결과가 없습니다.\n궁금한 지하철역 명칭을 입력창에 쳐보세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.sub),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults[index];
                        final placeName = item.name.isEmpty
                            ? item.address
                            : item.name;
                        final addressName = item.address;

                        return ListTile(
                          leading: const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.brown,
                          ),
                          title: Text(
                            placeName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            addressName,
                            style: const TextStyle(
                              color: AppColors.sub,
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: AppColors.sub,
                          ),
                          onTap: () {
                            Navigator.pop(context, item);
                          },
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
