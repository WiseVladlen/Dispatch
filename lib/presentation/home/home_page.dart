import 'package:cached_network_image/cached_network_image.dart';
import 'package:dispatch/app/theme_model_provider/theme_model.dart';
import 'package:dispatch/app/user_authentication_bloc/user_authentication_bloc.dart';
import 'package:dispatch/app/user_cubit/user_cubit.dart';
import 'package:dispatch/data/http_service/stomp_service.dart';
import 'package:dispatch/domain/repository/chat_repository.dart';
import 'package:dispatch/domain/repository/message_repository.dart';
import 'package:dispatch/presentation/choose_chat/choose_chat_page.dart';
import 'package:dispatch/presentation/home/bloc/home_bloc.dart';
import 'package:dispatch/presentation/home/bloc/home_event.dart';
import 'package:dispatch/presentation/home/bloc/home_state.dart';
import 'package:dispatch/presentation/home/chat_tile.dart';
import 'package:dispatch/presentation/settings/settings_page.dart';
import 'package:dispatch/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final stompService = context.read<StompService>();

  @override
  void initState() {
    super.initState();
    stompService.activate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(
        chatRepository: context.read<IChatRepository>(),
        messageRepository: context.read<IMessageRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: const Padding(
            padding: EdgeInsets.only(left: 84),
            child: Text(
              'Dispatch',
              style: TextStyles.logoMedium,
            ),
          ),
        ),
        drawer: const _DrawerPage(),
        body: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (oldState, newState) => (oldState.chats != newState.chats),
          builder: (context, state) {
            final chats = state.chats;

            if (chats == null) return const Center(child: CircularProgressIndicator());

            if (chats.isEmpty) return const Center(child: Text('No chats here yet'));

            return NotificationListener<UserScrollNotification>(
              onNotification: (value) {
                context.read<HomeBloc>().add(ScrollDirectionChangedEvent(value.direction));
                return true;
              },
              child: ListView.separated(
                itemCount: chats.length,
                itemBuilder: (_, index) {
                  return ChatTile(
                    key: ValueKey(chats[index].id),
                    chat: chats[index],
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                physics: const BouncingScrollPhysics(),
              ),
            );
          },
        ),
        floatingActionButton: const _AddChatFab(),
      ),
    );
  }

  @override
  void dispose() {
    stompService.deactivate();
    super.dispose();
  }
}

@immutable
class _AddChatFab extends StatefulWidget {
  const _AddChatFab();

  @override
  State<_AddChatFab> createState() => _AddChatFabState();
}

class _AddChatFabState extends State<_AddChatFab> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 2.0),
  ).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInBack,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (oldState, newState) => (oldState.direction != newState.direction),
      listener: (context, state) {
        if (state.direction == ScrollDirection.forward) {
          _animationController.reverse();
        } else if (state.direction == ScrollDirection.reverse) {
          _animationController.forward();
        }
      },
      child: SlideTransition(
        position: _offsetAnimation,
        child: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed(
            ChooseChatPage.path,
            arguments: ChooseChatArgs(
              (email) => context.read<HomeBloc>().firstByEmailOrNull(email),
            ),
          ),
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _DrawerPage extends StatelessWidget {
  const _DrawerPage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 208,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: context.select((UserCubit cubit) => cubit.state.user.imagePath) ?? '',
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  placeholder: (_, __) => Container(color: Theme.of(context).primaryColor),
                  errorWidget: (_, __, ___) => Container(
                    color: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.photo_outlined,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  fadeOutDuration: const Duration(milliseconds: 500),
                  fadeInDuration: const Duration(milliseconds: 500),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: 2,
                    children: [
                      Text(
                        context.select((UserCubit cubit) => cubit.state.user.name),
                        style: TextStyles.headlineLarge,
                      ),
                      Text(
                        context.select((UserCubit cubit) => cubit.state.user.email),
                        style: TextStyles.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () => Navigator.of(context).popAndPushNamed(SettingsPage.path),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out'),
                  onTap: () => context.read<UserAuthenticationBloc>().add(LogoutRequested()),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.mode_night),
                  title: const Text('Night mode'),
                  trailing: Switch(
                    value: !context.read<ThemeModel>().isLightTheme,
                    onChanged: (_) => context.read<ThemeModel>().onThemeSwitched(),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () => context.read<ThemeModel>().onThemeSwitched(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
