import 'package:equatable/equatable.dart';

class SearchTaskParameters extends Equatable {
  final String text;

  const SearchTaskParameters({
    required this.text,
  });

  @override
  List<Object?> get props => [text];
}
