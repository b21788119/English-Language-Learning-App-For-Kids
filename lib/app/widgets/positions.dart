List<Coordinate> getPositions() {
  return const [
    Coordinate(leftPosition: 830.0, topPosition: 845.0),
    Coordinate(leftPosition: 768.0, topPosition: 706.0),
    Coordinate(leftPosition: 593.0, topPosition: 768.0),
    Coordinate(leftPosition: 410.0, topPosition: 812.0),
    Coordinate(leftPosition: 318.0, topPosition: 663.0),
    Coordinate(leftPosition: 495.0, topPosition: 577.0),
    Coordinate(leftPosition: 695.0, topPosition: 592.0),
    Coordinate(leftPosition: 838.0, topPosition: 495.0),
    Coordinate(leftPosition: 755.0, topPosition: 335.0),
    Coordinate(leftPosition: 575.0, topPosition: 330.0),
    Coordinate(leftPosition: 385.0, topPosition: 365.0),
    Coordinate(leftPosition: 294.0, topPosition: 228.0),
  ];
}

class Coordinate {
  final double leftPosition;
  final double topPosition;
  const Coordinate({
    required this.leftPosition,
    required this.topPosition,
  });
}
