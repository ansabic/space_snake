import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:space_snake/model/snake_part.dart';
import 'package:space_snake/model/snake_velocity.dart';

import '../common/constants.dart';

part 'space_event.dart';

part 'space_state.dart';

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  late RefreshScreen _nextState;
  late Point<double> _pointer;
  bool _accelerating = false;
  late Size _size;
  final SnakeVelocity _velocity = SnakeVelocity(vX: 0, vY: 0);
  DateTime _lastTime = DateTime.now();

  double calculateSize() => sqrt(min(_size.width, _size.height));


  SpaceBloc({required Size size}) : super(SpaceInitial(size: size)) {
    _size = size;
    on<Accelerate>(
      (event, emit) {
        _pointer = event.pointer;
        _accelerating = true;
      },
    );
    on<Decelerate>((event, emit) {
      _accelerating = false;
    });
    on<Eat>((event, emit) {
      _nextState = _nextState.copyWith(
          snake: [event.newPart, ..._nextState.snake],
          food: Point(Random(DateTime.now().microsecondsSinceEpoch).nextDouble() * _size.width * 0.8,
              Random(DateTime.now().microsecondsSinceEpoch).nextDouble() * _size.height * 0.8));
      add(Render());
    });
    on<CheckForFood>((event, emit) {
      final distance = sqrt(
          (_nextState.food.x - _nextState.snake.first.x) * (_nextState.food.x - _nextState.snake.first.x) +
              (_nextState.food.y - _nextState.snake.first.y) * (_nextState.food.y - _nextState.snake.first.y));
      if (distance <= calculateSize()) {
        add(Eat(newPart: SnakePart(y: _nextState.food.y, x: _nextState.food.x)));
      } else {
        add(CalculateNewPositions());
      }
    });
    on<Render>((event, emit) {
      _lastTime = DateTime.now();
      emit(RefreshScreen(snake: _nextState.snake, food: _nextState.food));
    });

    on<CalculateNewPositions>((event, emit) {
      if (!_accelerating && _velocity.vX.abs() < 0.01 && _velocity.vY.abs() < 0.01) {
        _velocity.vY = 0;
        _velocity.vX = 0;
      } else {
        final time = DateTime.now().difference(_lastTime).inMilliseconds / 1000;

        final delX = _accelerating ? _pointer.x - _nextState.snake.first.x : _velocity.vX;
        final delY = _accelerating ? _pointer.y - _nextState.snake.first.y : _velocity.vY;
        final distance = sqrt((delX) * (delX) + (delY) * (delY));
        final sign = _accelerating ? 1 : (-0.07);
        final accX = sign * Constants.acc * delX.abs() / distance;
        final accY = sign * Constants.acc * delY.abs() / distance;
        _velocity.vX = _velocity.vX + delX.sign * accX * time;
        _velocity.vY = _velocity.vY + delY.sign * accY * time;
        if (_nextState.snake.first.y <= 0 || _nextState.snake.first.y >= _size.height) {
          _velocity.vY = -_velocity.vY;
        }
        if (_nextState.snake.first.x <= 0 || _nextState.snake.first.x >= _size.width) {
          _velocity.vX = -_velocity.vX;
        }
        final xNew = _nextState.snake.first.x + _velocity.vX * time;
        final yNew = _nextState.snake.first.y + _velocity.vY * time;
        _nextState.snake.first.x = xNew;
        _nextState.snake.first.y = yNew;
        for (int i = 0; i < _nextState.snake.length - 1; i++) {
          final moved = _nextState.snake[i];
          final finalX = moved.x;
          final finalY = moved.y;
          final current = _nextState.snake[i + 1];
          final delX = finalX - current.x;
          final delY = finalY - current.y;
          final bigDistance = sqrt((delX * delX) + (delY * delY));
          final resX = finalX - (calculateSize() / bigDistance) * delX;
          final resY = finalY - (calculateSize() / bigDistance) * delY;

          _nextState.snake[i + 1].x = resX;
          _nextState.snake[i + 1].y = resY;
        }
      }
      _nextState = RefreshScreen(snake: _nextState.snake, food: _nextState.food);
      add(Render());
    });

    on<Init>((event, emit) {
      _nextState = RefreshScreen(snake: state.snake, food: state.food);
      Timer.periodic(const Duration(milliseconds: 1000 ~/ Constants.fps), (timer) {
        add(CheckForFood());
      });
    });

    add(Init());
  }
}
