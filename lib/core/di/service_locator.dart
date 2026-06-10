import 'package:get_it/get_it.dart';
import 'package:legal_assistant_app/core/network/dio_client.dart';
import 'package:legal_assistant_app/core/services/local_storage_service.dart';
import 'package:legal_assistant_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:legal_assistant_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:legal_assistant_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:legal_assistant_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:legal_assistant_app/features/auth/domain/use_cases/signup_use_case.dart';
import 'package:legal_assistant_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:legal_assistant_app/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:legal_assistant_app/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:legal_assistant_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:legal_assistant_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:legal_assistant_app/features/chat/domain/use_cases/init_chat_use_case.dart';
import 'package:legal_assistant_app/features/chat/domain/use_cases/send_audio_query_use_case.dart';
import 'package:legal_assistant_app/features/chat/domain/use_cases/send_file_query_use_case.dart';
import 'package:legal_assistant_app/features/chat/domain/use_cases/send_text_query_use_case.dart';
import 'package:legal_assistant_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:legal_assistant_app/features/documents/data/data_sources/document_remote_data_source.dart';
import 'package:legal_assistant_app/features/documents/data/repositories/document_repository_impl.dart';
import 'package:legal_assistant_app/features/documents/domain/repositories/document_repository.dart';
import 'package:legal_assistant_app/features/documents/domain/use_cases/upload_document_use_case.dart';
import 'package:legal_assistant_app/features/documents/presentation/cubit/upload_document_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ── External ─────────────────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // ── Core ──────────────────────────────────────────────────────────────────
  sl.registerSingleton<LocalStorageService>(LocalStorageService(sl()));

  // ── Network ───────────────────────────────────────────────────────────────
  sl.registerSingleton(DioClient.mainApi(), instanceName: 'mainApi');
  sl.registerSingleton(DioClient.azureApi(), instanceName: 'azureApi');

  // ── Auth ──────────────────────────────────────────────────────────────────
  sl.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSource(sl(instanceName: 'azureApi')),
  );
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));
  sl.registerFactory<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerFactory<SignupUseCase>(() => SignupUseCase(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl(), sl()));
  sl.registerFactory<SignupCubit>(() => SignupCubit(sl()));

  // ── Chat ──────────────────────────────────────────────────────────────────
  sl.registerSingleton<ChatRemoteDataSource>(
    ChatRemoteDataSource(sl(instanceName: 'mainApi')),
  );
  sl.registerSingleton<ChatRepository>(ChatRepositoryImpl(sl()));
  sl.registerFactory<SendTextQueryUseCase>(() => SendTextQueryUseCase(sl()));
  sl.registerFactory<SendAudioQueryUseCase>(() => SendAudioQueryUseCase(sl()));
  sl.registerFactory<SendFileQueryUseCase>(() => SendFileQueryUseCase(sl()));
  sl.registerFactory<InitChatUseCase>(() => InitChatUseCase(sl()));
  sl.registerFactory<ChatCubit>(
    () => ChatCubit(
      sendTextQuery: sl(),
      sendAudioQuery: sl(),
      sendFileQuery: sl(),
      initChat: sl(),
      storage: sl(),
    ),
  );

  // ── Documents ─────────────────────────────────────────────────────────────
  sl.registerSingleton<DocumentRemoteDataSource>(
    DocumentRemoteDataSource(sl(instanceName: 'azureApi')),
  );
  sl.registerSingleton<DocumentRepository>(DocumentRepositoryImpl(sl()));
  sl.registerFactory<UploadDocumentUseCase>(() => UploadDocumentUseCase(sl()));
  sl.registerFactory<UploadDocumentCubit>(() => UploadDocumentCubit(sl()));
}
