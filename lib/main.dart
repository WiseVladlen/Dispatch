import 'package:dispatch/app/helper/preloading_repository.dart';
import 'package:dispatch/app/theme_model_provider/theme_model.dart';
import 'package:dispatch/app/user_authentication_bloc/user_authentication_bloc.dart';
import 'package:dispatch/app/user_authentication_bloc/user_authentication_state.dart';
import 'package:dispatch/app/user_cubit/user_cubit.dart';
import 'package:dispatch/data/database.dart';
import 'package:dispatch/data/http_helper/authentication_error_handler.dart';
import 'package:dispatch/data/http_helper/error_interceptor.dart';
import 'package:dispatch/data/http_service/dio_service.dart';
import 'package:dispatch/data/local_data_source/user_local_data_source.dart';
import 'package:dispatch/data/remote_data_source/authentication_remote_data_source.dart';
import 'package:dispatch/data/remote_data_source/chat_remote_data_source.dart';
import 'package:dispatch/data/remote_data_source/message_remote_data_source.dart';
import 'package:dispatch/data/remote_data_source/user_remote_data_source.dart';
import 'package:dispatch/data/repository/authentication_repository.dart';
import 'package:dispatch/data/repository/chat_repository.dart';
import 'package:dispatch/data/repository/message_repository.dart';
import 'package:dispatch/data/repository/user_repository.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:dispatch/domain/repository/authentication_repository.dart';
import 'package:dispatch/domain/repository/chat_repository.dart';
import 'package:dispatch/domain/repository/message_repository.dart';
import 'package:dispatch/domain/repository/user_repository.dart';
import 'package:dispatch/presentation/authentication/authentication_page.dart';
import 'package:dispatch/presentation/chat/chat_page.dart';
import 'package:dispatch/presentation/choose_chat/choose_chat_page.dart';
import 'package:dispatch/presentation/home/home_page.dart';
import 'package:dispatch/presentation/settings/settings_page.dart';
import 'package:dispatch/utils/http_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'data/http_service/stomp_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = Database();

  final userLocalDataSource = UserLocalDataSource(db: database);
  final userRemoteDataSource = UserRemoteDataSource();

  final authenticationRemoteDataSource = AuthenticationRemoteDataSource();

  final userRepository = UserRepository(
    localDataSource: userLocalDataSource,
    remoteDataSource: userRemoteDataSource,
  );

  final authenticationRepository = AuthenticationRepository(
    userLocalDataSource: userLocalDataSource,
    authenticationRemoteDataSource: authenticationRemoteDataSource,
  );

  DioService.addInterceptor(
    ErrorInterceptor(
      onResponseErrorHandler: (title, message) => null,
      authenticationErrorHandler: AuthenticationErrorHandler(
        userLocalDataSource: userLocalDataSource,
      ),
    ),
  );

  await prepareCookieJar();

  await PreloadingRepository(userLocalDataSource: userLocalDataSource).preload();

  runApp(App(
    userRepository: userRepository,
    authenticationRepository: authenticationRepository,
  ));
}

class App extends StatelessWidget {
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;

  const App({
    super.key,
    required this.userRepository,
    required this.authenticationRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IUserRepository>.value(value: userRepository),
        RepositoryProvider<IAuthenticationRepository>.value(value: authenticationRepository),
        RepositoryProvider<IChatRepository>(
          lazy: true,
          create: (_) => ChatRepository(remoteDataSource: ChatRemoteDataSource()),
        ),
      ],
      child: MultiProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => UserAuthenticationBloc(
              authenticationRepository: context.read<IAuthenticationRepository>(),
            ),
          ),
          ChangeNotifierProvider(
            lazy: false,
            create: (_) => ThemeModel(),
          ),
          ProxyProvider<UserAuthenticationBloc, UserCubit>(
            lazy: true,
            updateShouldNotify: (oldState, newState) => oldState.state.user != newState.state.user,
            update: (context, authentication, oldState) => UserCubit(
              user: authentication.state.user ?? proxyUser,
              userRepository: userRepository,
            ),
          ),
          Provider(
            lazy: true,
            create: (context) => StompService(
              onConnect: context.read<IUserRepository>().connect,
              onDisconnect: context.read<IUserRepository>().disconnect,
            ),
            child: RepositoryProvider<IMessageRepository>(
              lazy: true,
              create: (context) => MessageRepository(
                remoteDataSource: MessageRemoteDataSource(
                  stompService: context.read<StompService>(),
                ),
              ),
            ),
          ),
        ],
        child: RepositoryProvider<IMessageRepository>(
          lazy: true,
          create: (context) => MessageRepository(
            remoteDataSource: MessageRemoteDataSource(
              stompService: context.read<StompService>(),
            ),
          ),
          child: const _AppView(),
        ),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dispatch',
      theme: ThemeData(
        brightness: context.watch<ThemeModel>().isLightTheme ? Brightness.light : Brightness.dark,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: BlocBuilder<UserAuthenticationBloc, UserAuthenticationState>(
        buildWhen: (oldState, newState) => (oldState.status != newState.status),
        builder: (context, state) => (state.status.isAuthenticated && state.user != null)
            ? const HomePage()
            : const AuthenticationPage(),
      ),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == ChatPage.path) {
          return MaterialPageRoute(builder: (_) {
            return ChatPage(args: settings.arguments as ChatArguments);
          });
        }

        if (settings.name == SettingsPage.path) {
          return MaterialPageRoute(builder: (_) => const SettingsPage());
        }

        if (settings.name == ChooseChatPage.path) {
          return MaterialPageRoute(builder: (_) {
            return ChooseChatPage(args: settings.arguments as ChooseChatArgs);
          });
        }
        return null;
      },
    );
  }
}
