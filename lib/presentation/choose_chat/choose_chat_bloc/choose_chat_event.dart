import 'package:equatable/equatable.dart';

sealed class ChooseChatEvent extends Equatable {
  const ChooseChatEvent();

  @override
  List<Object?> get props => [];
}

final class SearchQueryChangedEvent extends ChooseChatEvent {
  final String searchQuery;

  const SearchQueryChangedEvent({required this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}
