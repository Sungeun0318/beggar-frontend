import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'package:beggar_app/core/config/api_config.dart';
import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/data/api/api_client.dart';
import 'package:beggar_app/data/models/room_free_chat.dart';
import 'package:beggar_app/data/repositories/room_free_repository.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

class CommunityChatScreen extends StatefulWidget {
  final VoidCallback onBack;

  const CommunityChatScreen({super.key, required this.onBack});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final RoomFreeRepository _repository = RoomFreeRepository(ApiClient());
  final List<RoomFreeChat> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  
  StompClient? _stompClient;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _connectWebSocket();
  }

  @override
  void dispose() {
    _stompClient?.deactivate();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _repository.getChatHistory();
      if (mounted) {
        setState(() {
          _messages.addAll(history);
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('채팅 내역을 불러오지 못했습니다: $e')),
        );
      }
    }
  }

  void _connectWebSocket() {
    _stompClient = StompClient(
      config: StompConfig(
        url: ApiConfig.wsUrl,
        onConnect: (frame) {
          debugPrint('STOMP Connected');
          _stompClient?.subscribe(
            destination: '/topic/chats',
            callback: (frame) {
              if (frame.body != null) {
                final Map<String, dynamic> json = jsonDecode(frame.body!);
                final newMessage = RoomFreeChat.fromJson(json);
                if (mounted) {
                  setState(() {
                    _messages.add(newMessage);
                  });
                  _scrollToBottom();
                }
              }
            },
          );
        },
        onWebSocketError: (dynamic error) => debugPrint('WS Error: $error'),
        onStompError: (frame) => debugPrint('STOMP Error: ${frame.body}'),
        onDisconnect: (frame) => debugPrint('STOMP Disconnected'),
      ),
    );
    _stompClient?.activate();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    try {
      await _repository.sendChat(text);
      // 성공 시 백엔드에서 WebSocket으로 브로드캐스트할 것이므로 여기서 직접 추가하지 않음
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메시지 전송 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '전체 채팅방', onBack: widget.onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: 0,
            right: 0,
            bottom: 92, // MessageBar height
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(child: Text('채팅 내역이 없습니다.'))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.pageH,
                          vertical: 18,
                        ),
                        itemCount: _messages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) return const _ChatNotice();
                          final chat = _messages[index - 1];
                          return _ChatBubble(
                            name: chat.sender,
                            message: chat.message,
                            time: _formatTime(chat.createdAt),
                            mine: chat.isMine,
                          );
                        },
                      ),
          ),
          _buildMessageBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBar() {
    final keyboardBottom = MediaQuery.viewInsetsOf(context).bottom;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(bottom: keyboardBottom),
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 92,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
            decoration: const BoxDecoration(
              color: Color(0xF2FFFFFF),
              border: Border(
                top: BorderSide(color: AppColors.border, width: 0.7),
              ),
            ),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: softBox(radius: AppRadius.chip, shadow: true),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      cursorColor: AppColors.accent,
                      decoration: const InputDecoration(
                        hintText: '메시지 입력',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.placeholder,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send_outlined, color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final ampm = dateTime.hour >= 12 ? '오후' : '오전';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$ampm $hour:$minute';
  }
}

class _ChatNotice extends StatelessWidget {
  const _ChatNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: softBox(color: AppColors.accentBg, radius: AppRadius.card),
      child: const Text(
        '전체 사용자들과 착한가격 업소, 쿠폰, 절약 루트를 자유롭게 공유해요.',
        style: TextStyle(
          fontSize: 13,
          height: 1.45,
          fontWeight: FontWeight.w700,
          color: AppColors.sub,
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final bool mine;

  const _ChatBubble({
    required this.name,
    required this.message,
    required this.time,
    this.mine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 270),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: softBox(
          color: mine ? AppColors.accentBg : Colors.white,
          radius: AppRadius.card,
          shadow: !mine,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!mine)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
              ),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.lightSub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
