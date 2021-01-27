import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:transparency_mode_audio/extension_methods/random_extension.dart';
import 'package:transparency_mode_audio/generated/l10n.dart';
import 'package:transparency_mode_audio/screens/home_page_bloc.dart';
import 'package:transparency_mode_audio/values/my_strings.dart';

import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final numberOfMusicBars = 25;
  List<AnimationController> _animationControllers;
  List<Animation<double>> _animations;
  math.Random _random;

  @override
  void initState() {
    super.initState();
    _random = math.Random();
    _animationControllers = List<AnimationController>(numberOfMusicBars);
    _animations = List<Animation<double>>(numberOfMusicBars);
    for (int i = 0; i < numberOfMusicBars; ++i) {
      _animationControllers[i] = AnimationController(
          vsync: this,
          lowerBound: 0.0,
          upperBound: 1.0,
          duration: Duration(milliseconds: _random.nextIntInRange(900, 1700)))
        ..repeat(reverse: true);
      _animations[i] = CurvedAnimation(
        parent: _animationControllers[i],
        curve: Curves.bounceInOut,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationControllers.forEach((element) => element.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    const circleSize = 200.0;

    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(MyStrings.applicationName),
        ),
        iosContentPadding: true,
        body: BlocProvider<HomePageBloc>(
          create: (_) => HomePageBloc(),
          child: Builder(
            builder: (BuildContext context) =>
                BlocConsumer<HomePageBloc, HomePageState>(
              listener: (BuildContext context, HomePageState state) {
                if (!state.listening)
                  _animationControllers.forEach((element) => element.stop());
                if (state.listening)
                  _animationControllers
                      .forEach((element) => element.repeat(reverse: true));
              },
              builder: (BuildContext context, HomePageState state) {
                return Stack(
                  children: [
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _animations
                          .map(
                            (animation) => Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: SizeTransition(
                                sizeFactor: animation,
                                axis: Axis.vertical,
                                child: Center(
                                  heightFactor: 1,
                                  child: Container(
                                    color: Colors.grey,
                                    height: circleSize +
                                        _random.nextIntInRange(40, 70),
                                    width: 10.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )),
                    Center(
                      child: GestureDetector(
                        onTap: () => context
                            .read<HomePageBloc>()
                            .add(HomePageTransparencyButtonClicked()),
                        child: Container(
                          width: circleSize,
                          height: circleSize,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.blue, width: 2.0),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.hearing,
                            size: 100.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
