import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_snake/space_game/space_bloc.dart';

import '../common/constants.dart';

class Space extends StatelessWidget {
  const Space({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpaceBloc(size: MediaQuery.of(context).size),
      child: BlocBuilder<SpaceBloc, SpaceState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<SpaceBloc>(context);
          return Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (event) {
              bloc.add(Accelerate(pointer: Point(event.localPosition.dx, event.localPosition.dy)));
            },
            onPointerUp: (_) {
              bloc.add(Decelerate());
            },
            onPointerMove: (event) {
              bloc.add(Accelerate(pointer: Point(event.localPosition.dx, event.localPosition.dy)));
            },
            onPointerCancel: (event) {
              bloc.add(Decelerate());
            },
            child: Stack(
              children: state.snake
                  .map(
                      (e) => Positioned(left: e.x, top: e.y, child: Icon(Icons.circle, color: Colors.deepPurple, size: bloc.calculateSize())))
                  .toList()
                ..add(Positioned(
                  left: state.food.x,
                  top: state.food.y,
                  child: Icon(Icons.circle, color: Colors.red, size: bloc.calculateSize()),
                )),
            ),
          );
        },
      ),
    );
  }
}
