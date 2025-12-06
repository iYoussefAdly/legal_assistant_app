import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';   // ⬅️ مهم جدًا
  import 'package:legal_assistant_app/data/api/qanouny_api_service.dart';
  import 'package:legal_assistant_app/data/repository/qanouny_repository.dart';
import 'package:legal_assistant_app/logic/cubit/audio_query_cubit.dart';
import 'package:legal_assistant_app/logic/cubit/file_query_cubit.dart';
import 'package:legal_assistant_app/logic/cubit/login_cubit.dart';
import 'package:legal_assistant_app/logic/cubit/text_query_cubit.dart';
import 'package:legal_assistant_app/presentation/views/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final apiService = QanounyApiService();
  final repository = QanounyRepository(apiService);

  runApp(LegalAssistantApp(repository: repository));
}

class LegalAssistantApp extends StatelessWidget {
  const LegalAssistantApp({super.key, required this.repository});

  final QanounyRepository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: MultiBlocProvider(
        providers: [
           BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(),
    ),
          BlocProvider<TextQueryCubit>(
            create: (context) => TextQueryCubit(repository),
          ),
          BlocProvider<AudioQueryCubit>(
            create: (context) => AudioQueryCubit(repository),
          ),
          BlocProvider<FileQueryCubit>(
            create: (context) => FileQueryCubit(repository),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
      ),
    );
  }
}
