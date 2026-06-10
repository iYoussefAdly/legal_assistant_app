import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/router/app_router.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:legal_assistant_app/features/chat/presentation/cubit/chat_state.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/answer_card.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/assistant_message_bubble.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/attachment_bottom_sheet.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/chat_header.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/chat_message.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/error_message.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/loading_indicator.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/question_dialog.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/user_message_bubble.dart';
import 'package:legal_assistant_app/features/documents/presentation/cubit/upload_document_cubit.dart';
import 'package:legal_assistant_app/features/documents/presentation/cubit/upload_document_state.dart';

class ChatViewBody extends StatefulWidget {
  const ChatViewBody({super.key});

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  late final TextEditingController _questionController;
  late final ScrollController _scrollController;
  late final FocusNode _questionFocusNode;

  final List<ChatMessage> _messages = [];
  bool _textLoading = false;
  bool _audioLoading = false;
  bool _fileLoading = false;
  bool _uploadLoading = false;
  String? _errorMessage;

  bool get _isProcessing =>
      _textLoading || _audioLoading || _fileLoading || _uploadLoading;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
    _scrollController = ScrollController();
    _questionFocusNode = FocusNode();
    _messages.add(const ChatMessage(
      role: MessageRole.assistant,
      content: 'أهلاً!👋 أنا قانوني، جاهز أقدم لك المساعدة اللي تحتاجها',
    ));
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    _questionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatCubit, ChatState>(listener: _handleChatState),
        BlocListener<UploadDocumentCubit, UploadDocumentState>(
            listener: _handleUploadState),
      ],
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.only(
            top: media.height * .06,
            bottom: media.height * .02,
            left: media.width * .03,
            right: media.width * .03,
          ),
          child: Column(
            children: [
              ChatHeader(
                onLogout: _logout,
                onNewChat: _resetChatSession,
                onMenu: () {},
              ),
              SizedBox(height: media.height * .03),
              _buildDivider(),
              SizedBox(height: media.height * .02),
              if (_errorMessage != null) ...[
                ErrorMessage(
                  message: _errorMessage!,
                  onClose: () => setState(() => _errorMessage = null),
                ),
                SizedBox(height: media.height * .015),
              ],
              if (_isProcessing) ...[
                const LoadingIndicator(),
                SizedBox(height: media.height * .02),
              ],
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: media.height * .02),
                  itemBuilder: (_, index) {
                    final msg = _messages[index];
                    if (msg.role == MessageRole.user) {
                      return UserMessageBubble(content: msg.content);
                    }
                    if (msg.hasMetadata) return AnswerCard(message: msg);
                    return AssistantMessageBubble(content: msg.content);
                  },
                ),
              ),
              SizedBox(height: media.height * .02),
              ChatInputBar(
                controller: _questionController,
                focusNode: _questionFocusNode,
                onSend: _sendTextQuestion,
                onAttachFile: _openAttachmentSheet,
                onAttachAudio: _pickAudioFile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.grey[800]!)),
        Text('   Today   ',
            style:
                AppStyles.styleSemitBold16.copyWith(color: Colors.grey[400])),
        Expanded(child: Divider(thickness: 1, color: Colors.grey[800]!)),
      ],
    );
  }

  // ── State handlers ────────────────────────────────────────────────────────

  void _handleChatState(BuildContext context, ChatState state) {
    setState(() {
      _textLoading = state is TextQueryLoading;
      _audioLoading = state is AudioQueryLoading;
      _fileLoading = state is FileQueryLoading || state is ChatSessionResetting;
    });

    switch (state) {
      case TextQuerySuccess(:final response):
        _clearError();
        _addAssistantMessage(
          content: response.answer,
          kind: MessageKind.text,
          riskLevel: response.riskLevel,
          citedSources: response.citedSources,
          termSummary: response.termSummary,
        );
      case AudioQuerySuccess(:final response):
        _clearError();
        final userText = (response.transcript?.trim().isNotEmpty ?? false)
            ? response.transcript!
            : response.query;
        _addMessage(ChatMessage(
            role: MessageRole.user,
            content: userText,
            kind: MessageKind.audio));
        _addAssistantMessage(
          content: response.answer,
          kind: MessageKind.audio,
          riskLevel: response.riskLevel,
          citedSources: response.citedSources,
          termSummary: response.termSummary,
        );
      case FileQuerySuccess(:final response):
        _clearError();
        _addAssistantMessage(
          content: response.answer,
          kind: MessageKind.file,
          riskLevel: response.riskLevel,
          citedSources: response.citedSources,
          termSummary: response.termSummary,
          fullText: response.fullText,
        );
      case ChatSessionReset(:final response):
        _clearError();
        setState(() {
          _messages
            ..clear()
            ..add(const ChatMessage(
              role: MessageRole.assistant,
              content: '"تم مسح المحادثة. أنا جاهز لمساعدتك في سؤال جديد."',
            ));
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            response.message.isEmpty
                ? 'Conversation history reset successfully.'
                : response.message,
            style: AppStyles.styleRegular14.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.grey[800],
        ));
      case TextQueryFailure(:final message) ||
            AudioQueryFailure(:final message) ||
            FileQueryFailure(:final message) ||
            ChatSessionResetFailure(:final message):
        _setError(message);
      default:
        break;
    }
  }

  void _handleUploadState(
      BuildContext context, UploadDocumentState state) {
    setState(() => _uploadLoading = state is UploadDocumentLoading);
    if (state is UploadDocumentSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('✅ Document uploaded successfully!',
            style:
                AppStyles.styleRegular14.copyWith(color: Colors.white)),
        backgroundColor: Colors.green[800],
        duration: const Duration(seconds: 3),
      ));
    } else if (state is UploadDocumentFailure) {
      _setError('Upload failed: ${state.message}');
    }
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _sendTextQuestion() {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      _setError('Please type a legal question before sending.');
      _questionFocusNode.requestFocus();
      return;
    }
    _clearError();
    _questionController.clear();
    _questionFocusNode.unfocus();
    _addMessage(
        ChatMessage(role: MessageRole.user, content: question));
    context.read<ChatCubit>().sendTextQuery(question);
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.audio, allowMultiple: false);
    final path = result?.files.single.path;
    if (path == null || !mounted) return;
    if (!path.toLowerCase().endsWith('.wav')) {
      _setError('Audio queries currently accept WAV files only.');
      return;
    }
    _clearError();
    context.read<ChatCubit>().sendAudioQuery(path);
  }

  Future<void> _openAttachmentSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AttachmentBottomSheet(
        onImageSelected: () => _pickDocument(isImage: true),
        onDocumentSelected: () => _pickDocument(isImage: false),
      ),
    );
  }

  Future<void> _pickDocument({required bool isImage}) async {
    final nationalId = context.read<ChatCubit>().currentNationalId;
    if (nationalId == null || nationalId.isEmpty) {
      _setError('Please login first to upload documents.');
      return;
    }

    final ext = isImage ? const ['png', 'jpg', 'jpeg'] : const ['pdf'];
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ext);
    final file = result?.files.first;
    if (file?.path == null || !mounted) return;

    // Capture cubits before any further async gaps
    final chatCubit = context.read<ChatCubit>();
    final uploadCubit = context.read<UploadDocumentCubit>();

    final question = await showQuestionDialog(context);
    if (!mounted) return;

    _addMessage(ChatMessage(
      role: MessageRole.user,
      content: question?.isNotEmpty == true
          ? question!
          : 'Uploading document: ${file!.name}',
      kind: MessageKind.file,
    ));

    uploadCubit.uploadDocument(
      nationalId: nationalId,
      filePath: file!.path!,
      title: file.name,
    );

    if (question?.isNotEmpty == true) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      chatCubit.sendFileQuery(file.path!, question!);
    }
  }

  void _resetChatSession() =>
      context.read<ChatCubit>().resetChatSession();

  void _logout() {
    Navigator.pushReplacementNamed(context, AppRoutes.signIn);
  }

  // ── Message helpers ───────────────────────────────────────────────────────

  void _addMessage(ChatMessage msg) {
    setState(() => _messages.add(msg));
    _scrollToBottom();
  }

  void _addAssistantMessage({
    required String content,
    required MessageKind kind,
    String? riskLevel,
    List? citedSources,
    String? termSummary,
    String? fullText,
  }) {
    _addMessage(ChatMessage(
      role: MessageRole.assistant,
      content: content,
      kind: kind,
      riskLevel: riskLevel,
      citedSources: citedSources?.cast() ?? const [],
      termSummary: termSummary,
      fullText: fullText,
    ));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final pos = _scrollController.position;
      final target = pos.maxScrollExtent - pos.viewportDimension + 80;
      _scrollController.animateTo(
        target < 0 ? 0 : target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _setError(String msg) => setState(() => _errorMessage = msg);

  void _clearError() {
    if (_errorMessage != null) setState(() => _errorMessage = null);
  }
}
