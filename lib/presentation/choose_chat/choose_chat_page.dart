import 'package:dispatch/domain/model/chat_model.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:dispatch/domain/repository/user_repository.dart';
import 'package:dispatch/presentation/choose_chat/choose_chat_bloc/choose_chat_bloc.dart';
import 'package:dispatch/presentation/choose_chat/choose_chat_bloc/choose_chat_event.dart';
import 'package:dispatch/presentation/choose_chat/choose_chat_bloc/choose_chat_state.dart';
import 'package:dispatch/presentation/choose_chat/user_tile.dart';
import 'package:dispatch/utils/connection_utils.dart';
import 'package:dispatch/utils/delayed_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseChatArgs {
  const ChooseChatArgs(this.chatByEmailOrNull);

  final ChatModel? Function(String) chatByEmailOrNull;
}

class ChooseChatPage extends StatelessWidget {
  const ChooseChatPage({super.key, required this.args});

  final ChooseChatArgs args;

  static const path = '/choose_chat';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChooseChatBloc(userRepository: context.read<IUserRepository>()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: _SearchInput(),
        ),
        body: SafeArea(
          child: BlocBuilder<ChooseChatBloc, ChooseChatState>(
            buildWhen: (oldState, newState) => (oldState.users != newState.users),
            builder: (context, state) {
              return FutureBuilder<List<UserModel>>(
                future: state.users,
                builder: (context, data) {
                  late final users = data.data;

                  print('users is $users');

                  if (!data.connectionState.isNone && !data.connectionState.isDone) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (data.hasData && users != null && users.isNotEmpty) {
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return UserTile(
                          key: ValueKey(users[index].email),
                          user: users[index],
                          isFirstEntryByAlphabetLetter:
                              (index == 0) || (users[index - 1].name[0] != users[index].name[0]),
                          chatByEmailOrNull: args.chatByEmailOrNull,
                        );
                      },
                      physics: const BouncingScrollPhysics(),
                    );
                  }
                  return const Center(child: Text('No users found'));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('chooseChatPage_searchInput_TextField'),
      onChanged: (searchQuery) => DelayedAction.run(() {
        context.read<ChooseChatBloc>().add(SearchQueryChangedEvent(searchQuery: searchQuery));
      }),
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Search',
        border: InputBorder.none,
      ),
      cursorColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
