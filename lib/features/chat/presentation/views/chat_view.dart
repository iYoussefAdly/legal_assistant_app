import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/di/service_locator.dart';
import 'package:legal_assistant_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/chat_view_body.dart';
import 'package:legal_assistant_app/features/documents/presentation/cubit/upload_document_cubit.dart';
import 'package:legal_assistant_app/features/splash/presentation/widgets/custom_background.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ChatCubit>()),
        BlocProvider(create: (_) => sl<UploadDocumentCubit>()),
      ],
      child: const Scaffold(
        body: CustomBackground(child: ChatViewBody()),
      ),
    );
  }
}
