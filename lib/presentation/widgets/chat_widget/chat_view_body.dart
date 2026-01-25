import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/data/models/audio_query_response.dart';
import 'package:legal_assistant_app/data/models/file_query_response.dart';
import 'package:legal_assistant_app/data/models/legal_source.dart';
import 'package:legal_assistant_app/data/models/text_query_response.dart';
import 'package:legal_assistant_app/logic/cubit/audio_query_cubit.dart';
import 'package:legal_assistant_app/logic/cubit/file_query_cubit.dart';
import 'package:legal_assistant_app/logic/cubit/login_cubit.dart';
import 'package:legal_assistant_app/logic/cubit/text_query_cubit.dart';
import 'package:legal_assistant_app/logic/cubit/upload_documnet_cubit.dart';
import 'package:legal_assistant_app/logic/states/audio_query_state.dart';
import 'package:legal_assistant_app/logic/states/file_query_state.dart';
import 'package:legal_assistant_app/logic/states/text_query_state.dart';
import 'package:legal_assistant_app/logic/states/upload_document_state.dart';
import 'package:legal_assistant_app/presentation/views/sign_in_view.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/attachment_bottom_sheet.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/chat_message.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/container_chat.dart';
import 'package:legal_assistant_app/presentation/widgets/common/answer_card.dart';
import 'package:legal_assistant_app/presentation/widgets/common/error_message.dart';
import 'package:legal_assistant_app/presentation/widgets/common/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatViewBody extends StatefulWidget {
  const ChatViewBody({super.key});
  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  late final TextEditingController _questionController;
  late final ScrollController _scrollController;
  late final FocusNode _questionFocusNode;
  late final Image _avatarImage;

  final List<ChatMessage> _messages = [];
  bool _textLoading = false;
  bool _audioLoading = false;
  bool _fileLoading = false;
  bool _uploadLoading = false;
  String? _errorMessage;
  bool get _isProcessing => _textLoading || _audioLoading || _fileLoading || _uploadLoading;
  
  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
    _scrollController = ScrollController();
    _questionFocusNode = FocusNode();
    _avatarImage = Image.asset('assets/images/bubble.png');

    _messages.add(
      const ChatMessage(
        role: MessageRole.assistant,
        content: 'أهلاً!👋 أنا قانوني، جاهز أقدم لك المساعدة اللي تحتاجها',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<AudioQueryCubit, AudioQueryState>(
          listener: _handleAudioState,
        ),
        BlocListener<FileQueryCubit, FileQueryState>(
          listener: _handleFileState,
        ),
        // ⭐ إضافة listener للـ UploadDocumentCubit
        BlocListener<UploadDocumentCubit, UploadDocumentState>(
          listener: _handleUploadState,
        ),
      ],
      child: BlocConsumer<TextQueryCubit, TextQueryState>(
        listener: _handleTextState,
        builder: (context, state) {
          return Container(
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
                  _buildHeader(media),
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
                  
                  // Loading Indicator
                  if (_isProcessing) ...[
                    const LoadingIndicator(),
                    SizedBox(height: media.height * .02),
                  ],
                  
                  // Messages List
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        if (message.role == MessageRole.user) {
                          return _buildUserMessage(message.content);
                        }
                        if (message.hasMetadata) {
                          return AnswerCard(message: message);
                        }
                        return _buildAssistantSimpleMessage(message.content);
                      },
                      separatorBuilder: (_, __) =>
                          SizedBox(height: media.height * .02),
                      itemCount: _messages.length,
                    ),
                  ),
                  
                  // Input Area
                  SizedBox(height: media.height * .02),
                  _buildInputArea(media),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(Size media) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ContainerChat(
          height: 40,
          width: 40,
          borderRadius: 20,
          backgroundColor: Colors.grey[900],
          borderColor: Colors.grey[700],
          child: IconButton(
            icon: Icon(CupertinoIcons.back, color: Colors.white, size: 20),
            onPressed: () {
              context.read<LoginCubit>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => SignInView()),
              );
            },
          ),
        ),
        
        ContainerChat(
          width: media.width * .3,
          height: media.height * .05,
          borderRadius: 30,
          backgroundColor: Colors.grey[900],
          borderColor: Colors.grey[700],
          child: GestureDetector(
            onTap: _initializeChatSession,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New Chat',
                  style: AppStyles.styleSemitBold14.copyWith(color: Colors.white),
                ),
                SizedBox(width: media.width * .02),
                Icon(
                  Icons.restart_alt,
                  size: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),        
        ContainerChat(
          height: 40,
          width: 40,
          borderRadius: 20,
          backgroundColor: Colors.grey[900],
          borderColor: Colors.grey[700],
          child: IconButton(
            icon: Icon(Icons.menu, color: Colors.white, size: 20),
            onPressed: () {
              print('Menu button pressed');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey[800]!,
          ),
        ),
        Text(
          '   Today   ',
          style: AppStyles.styleSemitBold16.copyWith(color: Colors.grey[400]),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey[800]!,
          ),
        ),
      ],
    );
  }

  Widget _buildUserMessage(String content) {
    return Container(
      margin: const EdgeInsets.only(right: 16, left: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff770000).withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
                border: Border.all(
                  color: Colors.red[800]!.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                content,
                style: AppStyles.styleRegular16.copyWith(
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.blue[800],
              border: Border.all(color: Colors.blue[600]!),
            ),
            child: const Icon(
              Icons.person,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistantSimpleMessage(String content) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 60, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: AssetImage('assets/images/bubble.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Qanouny Assistant',
                    style: AppStyles.styleSemitBold14.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
                
                Text(
                  content,
                  style: AppStyles.styleRegular16.copyWith(
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(Size media) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _questionController,
                  focusNode: _questionFocusNode,
                  style: AppStyles.styleRegular16.copyWith(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Message Qanouny AI...',
                    hintStyle: AppStyles.styleRegular16.copyWith(
                      color: Colors.grey[500],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: 5,
                  minLines: 1,
                  onSubmitted: (_) => _sendTextQuestion(),
                ),
              ),
              IconButton(
                onPressed: _sendTextQuestion,
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xff770000),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  icon: Icons.attach_file,
                  label: 'File',
                  onTap: _openAttachmentSheet,
                ),
                _buildActionButton(
                  icon: Icons.mic,
                  label: 'Audio',
                  onTap: _pickAudioFile,
                ),
                _buildActionButton(
                  icon: Icons.keyboard,
                  label: 'Type',
                  onTap: () => _questionFocusNode.requestFocus(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppStyles.styleRegular12.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // =============== STATE HANDLERS ===============

  void _handleTextState(BuildContext context, TextQueryState state) {
    setState(() {
      _textLoading = state is TextQueryLoading;
    });
    if (state is TextQuerySuccess) {
      _clearError();
      _addAssistantMessageFromText(state.response);
    } else if (state is TextQueryFailure) {
      _setError(state.message);
    }
  }

  void _handleAudioState(BuildContext context, AudioQueryState state) {
    setState(() {
      _audioLoading = state is AudioQueryLoading;
    });
    if (state is AudioQuerySuccess) {
      _clearError();
      _addAudioConversation(state.response);
    } else if (state is AudioQueryFailure) {
      _setError(state.message);
    }
  }

  void _handleFileState(BuildContext context, FileQueryState state) {
    setState(() {
      _fileLoading = state is FileQueryLoading;
    });
    if (state is FileQuerySuccess) {
      _clearError();
      _addFileAnswer(state.response);
    } else if (state is FileQueryFailure) {
      _setError(state.message);
    }
  }

  // ⭐ إضافة handler للـ UploadDocumentCubit
  void _handleUploadState(BuildContext context, UploadDocumentState state) {
    setState(() {
      _uploadLoading = state is UploadDocumentLoading;
    });

    if (state is UploadDocumentSuccess) {
      _showUploadSuccessMessage(state.response);
    } else if (state is UploadDocumentFailure) {
      _setError('Upload failed: ${state.message}');
    }
  }

  // =============== DOCUMENT UPLOAD ===============

  Future<void> _sendTextQuestion() async {
    final rawText = _questionController.text;
    final question = rawText.trim();

    if (question.isEmpty) {
      _setError('Please type a legal question before sending.');
      _questionFocusNode.requestFocus();
      return;
    }

    _clearError();
    final questionToSend = question;
    _questionController.clear();
    _questionFocusNode.unfocus();
    _addUserMessage(questionToSend);
    context.read<TextQueryCubit>().sendTextQuery(questionToSend);
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    final file = result?.files.single;
    final path = file?.path;
    if (path == null) return;
    if (!mounted) return;

    if (!path.toLowerCase().endsWith('.wav')) {
      _setError('Audio queries currently accept WAV files only.');
      return;
    }

    _clearError();
    context.read<AudioQueryCubit>().sendAudioQuery(path);
  }

  Future<void> _openAttachmentSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return AttachmentBottomSheet(
          onImageSelected: () => _pickDocument(isImage: true),
          onDocumentSelected: () => _pickDocument(isImage: false),
        );
      },
    );
  }

  // ⭐⭐⭐⭐ دالة _pickDocument المعدلة للـ upload ⭐⭐⭐⭐
  Future<void> _pickDocument({required bool isImage}) async {
    try {
      print('=== Starting document upload ===');
      
      // 1. جلب الـ nationalId من SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final nationalId = prefs.getString('nationalId');
      
      if (nationalId == null || nationalId.isEmpty) {
        _setError('Please login first to upload documents.');
        print('❌ No nationalId found in SharedPreferences');
        return;
      }
      
      print('✅ Found nationalId: $nationalId');
      
      // 2. اختيار الملف
      final allowedExtensions = isImage
          ? const ['png', 'jpg', 'jpeg']
          : const ['pdf'];
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );
      
      if (result == null || result.files.isEmpty) {
        print('❌ No file selected');
        return;
      }
      
      final file = result.files.first;
      if (file.path == null) {
        print('❌ File path is null');
        return;
      }
      
      print('📄 Selected file: ${file.name}, path: ${file.path}');
      
      // 3. سؤال المستخدم (اختياري)
      final question = await _showSimpleQuestionDialog(context);
      
      // 4. إضافة رسالة المستخدم للـ chat
      if (question != null && question.isNotEmpty) {
        _addUserMessage(question, kind: MessageKind.file);
      } else {
        _addUserMessage('Uploading document: ${file.name}', kind: MessageKind.file);
      }
      
      // 5. استدعاء الـ upload endpoint
      print('📤 Calling UploadDocumentCubit with:');
      print('   - nationalId: $nationalId');
      print('   - filePath: ${file.path}');
      print('   - title: ${file.name}');
      
      context.read<UploadDocumentCubit>().uploadDocument(
        nationalId: nationalId,
        filePath: file.path!,
        title: file.name,
      );
      
      // 6. (اختياري) إرسال السؤال للـ AI إذا كان موجود
      if (question != null && question.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 1));
        context.read<FileQueryCubit>().sendFileQuery(file.path!, question);
      }
      
    } catch (error) {
      print('❌ Error in _pickDocument: $error');
      _setError('Error uploading document: ${error.toString()}');
    }
  }

  // ⭐ دالة بسيطة للسؤال
  Future<String?> _showSimpleQuestionDialog(BuildContext context) async {
    final controller = TextEditingController();
    
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Document Question',
            style: AppStyles.styleSemitBold16.copyWith(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: AppStyles.styleRegular16.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'What would you like to know about this document?',
              hintStyle: AppStyles.styleRegular16.copyWith(color: Colors.grey[500]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[700]!),
              ),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Skip',
                style: AppStyles.styleRegular16.copyWith(color: Colors.grey[400]),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text(
                'Ask',
                style: AppStyles.styleRegular16.copyWith(color: Colors.blue[300]!),
              ),
            ),
          ],
        );
      },
    );
  }

  // ⭐ دالة لعرض نجاح الـ upload
  void _showUploadSuccessMessage(Map<String, dynamic> response) {
    final documentId = response['document_id'];
    final blobPath = response['blob_path'];
    final truncatedId = documentId != null && documentId.length > 8 
        ? '${documentId.substring(0, 8)}...' 
        : documentId ?? 'N/A';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ Document uploaded successfully!',
          style: AppStyles.styleRegular14.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.green[800],
        duration: const Duration(seconds: 3),
      ),
    );
    
    print('📄 Upload successful!');
    print('   Document ID: $documentId');
    print('   Blob Path: $blobPath');
  }

  Future<String?> _showQuestionPromptDialog(
    BuildContext context, {
    String initialValue = '',
  }) async {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Document Question',
            style: AppStyles.styleSemitBold16.copyWith(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: AppStyles.styleRegular16.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'What would you like to know about this document?',
              hintStyle: AppStyles.styleRegular16.copyWith(color: Colors.grey[500]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[700]!),
              ),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppStyles.styleRegular16.copyWith(color: Colors.grey[400]),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text(
                'Submit',
                style: AppStyles.styleRegular16.copyWith(color: Colors.blue[300]!),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _initializeChatSession() async {
    try {
      // 1. جلب الـ name و gender من SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('fullName') ?? 'User';
      final gender = prefs.getString('gender') ?? 'Unknown';
      
      print('✅ Retrieved from SharedPreferences:');
      print('   - name: $name');
      print('   - gender: $gender');
      
      if (!mounted) return;
      
      // 2. استدعاء الـ initializeChat API
      final cubit = context.read<TextQueryCubit>();
      final response = await cubit.initializeChat(
        name: name,
        gender: gender,
      );
      
      if (!mounted) return;
      
      // 3. معالجة الـ response وإعادة تعيين المحادثة
      if (response != null && response.success) {
        setState(() {
          _messages
            ..clear()
            ..add(
              const ChatMessage(
                role: MessageRole.assistant,
                content: '"تم مسح المحادثة. أنا جاهز لمساعدتك في سؤال جديد."',
              ),
            );
          _errorMessage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message.isEmpty
                  ? 'Conversation history reset successfully.'
                  : response.message,
              style: AppStyles.styleRegular14.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.grey[800],
          ),
        );
      } else {
        _setError('Failed to initialize chat session. Please try again.');
      }
    } catch (error) {
      print('❌ Error in _initializeChatSession: $error');
      _setError('Error initializing chat session: ${error.toString()}');
    }
  }


  void _addUserMessage(String text, {MessageKind kind = MessageKind.text}) {
    setState(() {
      _messages.add(
        ChatMessage(role: MessageRole.user, content: text, kind: kind),
      );
    });
    _scrollToBottom();
  }

  void _addAssistantMessageFromText(TextQueryResponse response) {
    _addAssistantMessage(
      content: response.answer,
      kind: MessageKind.text,
      riskLevel: response.riskLevel,
      citedSources: response.citedSources,
      termSummary: response.termSummary,
    );
  }

  void _addAudioConversation(AudioQueryResponse response) {
    final userQuestion = (response.transcript != null && response.transcript!.trim().isNotEmpty)
        ? response.transcript!
        : response.query;
    _addUserMessage(userQuestion, kind: MessageKind.audio);
    _addAssistantMessage(
      content: response.answer,
      kind: MessageKind.audio,
      riskLevel: response.riskLevel,
      citedSources: response.citedSources,
      termSummary: response.termSummary,
    );
  }

  void _addFileAnswer(FileQueryResponse response) {
    _addAssistantMessage(
      content: response.answer,
      kind: MessageKind.file,
      riskLevel: response.riskLevel,
      fullText: response.fullText,
      citedSources: response.citedSources,
      termSummary: response.termSummary,
    );
  }

  void _addAssistantMessage({
    required String content,
    required MessageKind kind,
    String? riskLevel,
    List<CitedSource>? citedSources,
    String? termSummary,
    String? fullText,
  }) {
    setState(() {
      _messages.add(
        ChatMessage(
          role: MessageRole.assistant,
          content: content,
          kind: kind,
          riskLevel: riskLevel,
          citedSources: citedSources ?? const [],
          termSummary: termSummary,
          fullText: fullText,
        ),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final position = _scrollController.position;
      final fullExtent = position.maxScrollExtent;
      final viewport = position.viewportDimension;
      final target = fullExtent - viewport + 80;
      _scrollController.animateTo(
        target < 0 ? 0 : target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _setError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }
}
