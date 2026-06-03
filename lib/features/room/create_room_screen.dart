import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
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
  final TextEditingController _roomNameController = TextEditingController();
  String _selectedAddress = "예) 강남역, 홍대입구"; // 선택된 최종 역/장소 이름
  int _maxMemberCount = 4;
  final List<String> _selectedTags = [];

  // 백엔드로 데이터 전송 로직
  Future<void> _createNewRoom() async {
    if (_roomNameController.text.trim().isEmpty) {
      _showSnackBar('거지방 이름을 입력해 주세요!');
      return;
    }
    if (_selectedAddress == "예) 강남역, 홍대입구") {
      _showSnackBar('모임 장소(지하철역 등)를 검색해 주세요!');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8080/rooms');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "roomName": _roomNameController.text,
          "tags": _selectedTags,
          "isFriends": false,
          "location": _selectedAddress, // 카카오 리스트에서 선택한 역 이름 글자 전송
          "maxMemberCount": _maxMemberCount
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(utf8.decode(response.bodyBytes));
        print("방 생성 성공: $result");
        widget.onNext();
      } else {
        print("서버 에러: ${response.statusCode}");
      }
    } catch (e) {
      print("연결 실패: $e");
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
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
                      final result = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchAddressPage(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          _selectedAddress = result; // 카카오가 찾아준 장소 명칭 안착!
                        });
                      }
                    },
                    child: InputLike(
                      label: _selectedAddress,
                      icon: Icons.location_on_outlined,
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
                  _buildTagChoice('기타 요식업', Icons.restaurant, isFullWidth: true),
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
                          child: Icon(Icons.groups_outlined, color: AppColors.brown),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '참여 인원',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkSub),
                        ),
                        const Spacer(),

                        GestureDetector(
                          onTap: () {
                            if (_maxMemberCount > 2) {
                              setState(() { _maxMemberCount--; });
                            }
                          },
                          child: const RoundIcon(icon: Icons.remove),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '$_maxMemberCount',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 16),

                        GestureDetector(
                          onTap: () {
                            if (_maxMemberCount < 100) {
                              setState(() { _maxMemberCount++; });
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
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.sub),
                  ),
                  const SizedBox(height: 34),
                  const InfoCard(
                    icon: Icons.lock_outline,
                    title: '개인 예산은 익명으로 수집돼요',
                    body: '가장 낮은 금액 기준으로\n오늘의 총예산이 정해져요.',
                  ),
                  const SizedBox(height: AppSpacing.gap24),
                  PrimaryButton(label: '방 만들기', onTap: _createNewRoom),
                  const SizedBox(height: AppSpacing.gap24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChoice(String label, IconData icon, {bool isFullWidth = false}) {
    final isSelected = _selectedTags.contains(label);
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
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _kakaoResults = []; // 카카오 장소 검색 결과 목록
  bool _isLoading = false;

  // 카카오 로직 전용 REST API 실시간 호출 함수
  Future<void> _searchFromKakao(String query) async {
    if (query.trim().isEmpty) {
      setState(() { _kakaoResults = []; });
      return;
    }

    setState(() { _isLoading = true; });

    // 카카오 로직 장소 검색 API 주소
    final url = Uri.parse('https://dapi.kakao.com/v2/local/search/keyword.json?query=${Uri.encodeComponent(query)}');

    try {
      final response = await http.get(
        url,
        headers: {
          // 카카오 전용 REST API 인증키 (웹/앱 우회 공용 키 매핑)
          'Authorization': 'KakaoAK 8ca6ba7bf5f2d65611df42a15f913d5a'
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
        final documents = decodedData['documents'] as List?;

        if (documents != null) {
          setState(() {
            _kakaoResults = documents.map<Map<String, String>>((doc) {
              return {
                'placeName': doc['place_name'] ?? '', // 장소명 (ex: 강남역 2호선)
                'addressName': doc['address_name'] ?? '', // 지번 주소 또는 도로명
              };
            }).toList();
          });
        }
      }
    } catch (e) {
      print("카카오 로컬 API 호출 실패: $e");
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('내 근처 역 검색', style: TextStyle(color: AppColors.brown, fontWeight: FontWeight.bold)),
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
              onChanged: (text) => _searchFromKakao(text), // 타이핑 ing 카카오 실시간 검색
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
                  ? const Center(child: CircularProgressIndicator(color: AppColors.brown))
                  : _kakaoResults.isEmpty
                  ? const Center(child: Text('검색 결과가 없습니다.\n궁금한 지하철역 명칭을 입력창에 쳐보세요!', textAlign: TextAlign.center, style: TextStyle(color: AppColors.sub)))
                  : ListView.builder(
                itemCount: _kakaoResults.length,
                itemBuilder: (context, index) {
                  final item = _kakaoResults[index];
                  final placeName = item['placeName']!;
                  final addressName = item['addressName']!;

                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined, color: AppColors.brown),
                    title: Text(placeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: Text(addressName, style: const TextStyle(color: AppColors.sub, fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.sub),
                    onTap: () {
                      Navigator.pop(context, placeName);
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