import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparency_mode_audio/screens/home_page_event.dart';
import 'package:transparency_mode_audio/screens/home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc({HomePageState initialState})
      : super(initialState ?? HomePageState(listening: false));

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if (event is HomePageTransparencyButtonClicked) {
      yield* _mapTransparencyButtonClickedToState(event);
    }
  }

  Stream<HomePageState> _mapTransparencyButtonClickedToState(
      HomePageTransparencyButtonClicked event) async* {
    yield state.copyWith(listening: !state.listening);
  }
}
