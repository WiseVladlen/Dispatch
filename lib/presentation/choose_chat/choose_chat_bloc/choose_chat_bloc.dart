import 'package:dispatch/domain/repository/user_repository.dart';
import 'package:dispatch/presentation/choose_chat/choose_chat_bloc/choose_chat_event.dart';
import 'package:dispatch/presentation/choose_chat/choose_chat_bloc/choose_chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseChatBloc extends Bloc<ChooseChatEvent, ChooseChatState> {
  final IUserRepository userRepository;

  ChooseChatBloc({required this.userRepository}) : super(const ChooseChatState()) {
    on<SearchQueryChangedEvent>(_onSearchQueryChangedEvent);
  }

  void _onSearchQueryChangedEvent(SearchQueryChangedEvent event, Emitter<ChooseChatState> emit) {
    final searchQuery = event.searchQuery.trim();

    if (searchQuery == state.searchQuery) return;

    if (searchQuery.isEmpty && searchQuery != state.searchQuery) {
      return emit(state.copyWith(
        searchQuery: searchQuery,
        users: Future.value([]),
      ));
    }

    emit(state.copyWith(
      searchQuery: searchQuery,
      users: userRepository.getUsersByQuery(searchQuery),
    ));
  }
}
