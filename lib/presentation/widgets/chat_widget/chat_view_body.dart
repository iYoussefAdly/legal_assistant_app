import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/data/models/audio_query_response.dart';
import 'package:legal_assistant_app/data/models/file_query_response.dart';
import 'package:legal_assistant_app/data/models/text_query_response.dart';
import 'package:legal_assistant_app/logic/cubit/audio_query_cubit.dart';
import 'package:legal_assistant_app/logic/cubit/file_query_cubit.dart';
import 'package:legal_assistant_app/logic/cubit/text_query_cubit.dart';
import 'package:legal_assistant_app/logic/states/audio_query_state.dart';
import 'package:legal_assistant_app/logic/states/file_query_state.dart';
import 'package:legal_assistant_app/logic/states/text_query_state.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/attachment_bottom_sheet.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/bubble_chat.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/bubble_chat_ai.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/chat_message.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/container_chat.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/container_chat_bottom.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/question_prompt_dialog.dart';
import 'package:legal_assistant_app/presentation/widgets/common/answer_card.dart';
import 'package:legal_assistant_app/presentation/widgets/common/error_message.dart';
import 'package:legal_assistant_app/presentation/widgets/common/loading_indicator.dart';

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
  String? _errorMessage;

  bool get _isProcessing => _textLoading || _audioLoading || _fileLoading;

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
        content:
            'Hello! I’m your smart legal assistant. How can I help you today?',
      ),
    );
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
    final media = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<AudioQueryCubit, AudioQueryState>(
          listener: _handleAudioState,
        ),
        BlocListener<FileQueryCubit, FileQueryState>(
          listener: _handleFileState,
        ),
      ],
      child: BlocConsumer<TextQueryCubit, TextQueryState>(
        listener: _handleTextState,
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
              top: media.height * .06,
              bottom: media.height * .02,
              left: media.width * .03,
              right: media.width * .03,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ContainerChat(icon: CupertinoIcons.back),
                    GestureDetector(
                      onTap: _resetConversation,
                      child: Container(
                        width: media.width * .3,
                        height: media.height * .05,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(231, 214, 248, 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('New Chat',
                                style: AppStyles.styleSemitBold14),
                            SizedBox(width: media.width * .02),
                            const Icon(Icons.restart_alt, size: 24),
                          ],
                        ),
                      ),
                    ),
                    ContainerChat(icon: Icons.menu),
                  ],
                ),
                SizedBox(height: media.height * .03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: const Color.fromRGBO(153, 44, 230, 0.3),
                      ),
                    ),
                    Text('   Today   ', style: AppStyles.styleSemitBold16),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: const Color.fromRGBO(153, 44, 230, 0.3),
                      ),
                    ),
                  ],
                ),
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
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      if (message.role == MessageRole.user) {
                        return ChatBubble(message: message.content);
                      }
                      if (message.hasMetadata) {
                        return AnswerCard(message: message);
                      }
                      return ChatBubbleAi(
                        message: message.content,
                        avatarImage: _avatarImage,
                      );
                    },
                    separatorBuilder: (_, __) =>
                        SizedBox(height: media.height * .02),
                    itemCount: _messages.length,
                  ),
                ),
                SizedBox(height: media.height * .02),
                ContainerChatBottom(
                  width: media.width,
                  borderRadius: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: media.height * .04,
                          maxHeight: media.height * .15,
                        ),
                        child: SingleChildScrollView(
                          child: TextField(
                            controller: _questionController,
                            focusNode: _questionFocusNode,
                            minLines: 1,
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: 'Message Qanouny AI...',
                              hintStyle: AppStyles.styleRegular16,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: media.height * .02,
                                horizontal: media.width * .04,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendTextQuestion(),
                          ),
                        ),
                      ),
                      SizedBox(height: media.height * .01),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: _openAttachmentSheet,
                            child: ContainerChatBottom(
                              height: media.height * .04,
                              width: media.width * .12,
                              borderRadius: 30,
                              child: const Icon(Icons.add, size: 25),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _questionFocusNode.requestFocus(),
                            child: ContainerChatBottom(
                              height: media.height * .04,
                              width: media.width * .4,
                              borderRadius: 30,
                              child: Row(
                                children: [
                                  const Icon(Icons.travel_explore, size: 22),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Type your question',
                                      style: AppStyles.styleRegular14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickAudioFile,
                            child: ContainerChatBottom(
                              height: media.height * .04,
                              width: media.width * .12,
                              borderRadius: 30,
                              child: const Icon(Icons.mic, size: 25),
                            ),
                          ),
                          GestureDetector(
                            onTap: _sendTextQuestion,
                            child: ContainerChatBottom(
                              height: media.height * .05,
                              width: media.width * .1,
                              borderRadius: 30,
                              child:
                                  const Icon(Icons.arrow_outward_sharp, size: 25),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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

  Future<void> _sendTextQuestion() async {
    // Get the text from controller
    final rawText = _questionController.text;
    
    // Trim and validate
    final question = rawText.trim();
    
    // Check if question is empty after trimming
    if (question.isEmpty) {
      _setError('Please type a legal question before sending.');
      _questionFocusNode.requestFocus();
      return;
    }
    
    // Clear any previous errors
    _clearError();
    
    // Store question before clearing controller
    final questionToSend = question;
    
    // Clear the controller
    _questionController.clear();
    
    // Unfocus the text field
    _questionFocusNode.unfocus();
    
    // Add user message to chat
    _addUserMessage(questionToSend);
    
    // Send the query
    context.read<TextQueryCubit>().sendTextQuery(questionToSend);
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['wav'],
    );
    final file = result?.files.single;
    if (file?.path == null) return;
    if (!mounted) return;
    _clearError();
    context.read<AudioQueryCubit>().sendAudioQuery(file!.path!);
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

  Future<void> _pickDocument({required bool isImage}) async {
    final allowedExtensions =
        isImage ? const ['png', 'jpg', 'jpeg'] : const ['pdf'];
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    final file = result?.files.single;
    if (file?.path == null) return;

    if (!mounted) return;
    final question = await showQuestionPromptDialog(
      context,
      initialValue: _questionController.text.trim(),
    );
    if (!mounted || question == null) return;

    _questionController.clear();
    _addUserMessage(
      question,
      kind: MessageKind.file,
    );
    _clearError();
    context.read<FileQueryCubit>().sendFileQuery(file!.path!, question);
  }

  Future<void> _resetConversation() async {
    final cubit = context.read<TextQueryCubit>();
    final response = await cubit.resetConversation();
    if (!mounted) return;
    if (response != null && response.success) {
      setState(() {
        _messages
          ..clear()
          ..add(
            const ChatMessage(
              role: MessageRole.assistant,
              content:
                  'Conversation cleared. I am ready to help with a new question.',
            ),
          );
        _errorMessage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.message.isEmpty
                ? 'Conversation reset successfully.'
                : response.message,
          ),
        ),
      );
    }
  }

  void _addUserMessage(String text, {MessageKind kind = MessageKind.text}) {
    setState(() {
      _messages.add(
        ChatMessage(
          role: MessageRole.user,
          content: text,
          kind: kind,
        ),
      );
    });
    _scrollToBottom();
  }

  void _addAssistantMessageFromText(TextQueryResponse response) {
    _addAssistantMessage(
      content: response.answer,
      kind: MessageKind.text,
      riskLevel: response.riskLevel,
      sources: response.sources,
    );
  }

  void _addAudioConversation(AudioQueryResponse response) {
    _addUserMessage(response.query, kind: MessageKind.audio);
    _addAssistantMessage(
      content: response.answer,
      kind: MessageKind.audio,
      riskLevel: response.riskLevel,
      sources: response.sources,
    );
  }

  void _addFileAnswer(FileQueryResponse response) {
    _addAssistantMessage(
      content: response.answer,
      kind: MessageKind.file,
      riskLevel: response.riskLevel,
      sources: response.sources,
      fullText: response.fullText,
    );
  }

  void _addAssistantMessage({
    required String content,
    required MessageKind kind,
    String? riskLevel,
    List<String>? sources,
    String? fullText,
  }) {
    setState(() {
      _messages.add(
        ChatMessage(
          role: MessageRole.assistant,
          content: content,
          kind: kind,
          riskLevel: riskLevel,
          sources: sources ?? const [],
          fullText: fullText,
        ),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _setError(String message) {
    setState(() {
      _errorMessage = message;
    });
    // Error is already displayed in the ErrorMessage widget, no need for snackbar
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }
}