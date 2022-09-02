part of 'space_bloc.dart';

@immutable
abstract class SpaceState {
  final List<SnakePart> snake;
  final Point<double> food;

  const SpaceState({required this.snake, required this.food});
}

class SpaceInitial extends SpaceState {
  final Size size;

  SpaceInitial({required this.size})
      : super(
            snake: [SnakePart(y: size.height / 2, x: size.width / 2)],
            food: Point(Random(DateTime.now().microsecondsSinceEpoch).nextDouble() * size.width * 0.8,
                Random(DateTime.now().microsecondsSinceEpoch).nextDouble() * size.height * 0.8));
}

class RefreshScreen extends SpaceState {
  const RefreshScreen({required super.snake, required super.food});

  RefreshScreen copyWith({List<SnakePart>? snake, Point<double>? food}) =>
      RefreshScreen(snake: snake ?? this.snake, food: food ?? this.food);
}
