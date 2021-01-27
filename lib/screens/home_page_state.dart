import 'package:equatable/equatable.dart';

class HomePageState extends Equatable {
  final bool listening;

  const HomePageState({this.listening});

  HomePageState copyWith({bool listening}) =>
      HomePageState(listening: listening ?? this.listening);

  @override
  List<Object> get props => [listening];
}
