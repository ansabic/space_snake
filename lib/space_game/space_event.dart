part of 'space_bloc.dart';

@immutable
abstract class SpaceEvent {}

class Render extends SpaceEvent {}

class Init extends SpaceEvent {}

class Eat extends SpaceEvent {
  final SnakePart newPart;

  Eat({required this.newPart});
}

class Accelerate extends SpaceEvent {
  final Point<double> pointer;
  Accelerate({required this.pointer});
}

class Decelerate extends SpaceEvent {}

class CalculateNewPositions extends SpaceEvent {}

class CheckForFood extends SpaceEvent {}

