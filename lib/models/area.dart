enum Type {
  OBSTACLE,
  CHECK_POINT,
}

class Area {
  Area({
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
    required this.type,
    this.checkPointNumber,
  });

  final double left;
  final double right;
  final double top;
  final double bottom;
  final Type type;
  final int? checkPointNumber;

  factory Area.obstacle({
    required double left,
    required double right,
    required double top,
    required double bottom,
  }) =>
      Area(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
        type: Type.OBSTACLE,
      );

  factory Area.checkPoint({
    required double left,
    required double right,
    required double top,
    required double bottom,
    int? checkPointNumber,
  }) =>
      Area(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
        type: Type.CHECK_POINT,
        checkPointNumber: checkPointNumber,
      );

  ({double x, double y}) get center => (x: (right - (right - left) / 2).abs(), y: (top - (top - bottom) / 2).abs());

  String toObjectString() {
    if (type == Type.OBSTACLE) {
      return 'Area.obstacle(bottom: $bottom, left: $left, right: $right, top: $top)';
    }

    return 'Area.checkPoint(bottom: $bottom, left: $left, right: $right, top: $top)';
  }

  static List<Area> generateDefaultAreas() {
    return [
      Area.obstacle(bottom: 0, left: 194, right: 206, top: 300),
      Area.obstacle(bottom: 300, left: 394, right: 406, top: 600),
    ];
  }

  // WIP use generateDefaultAreas instead
  static List<Area> generateDefaultAreasV2() {
    return [
      Area.checkPoint(left: 150, right: 200, top: 200, bottom: 150, checkPointNumber: 1),
      Area.checkPoint(left: 150, right: 200, top: 500, bottom: 450, checkPointNumber: 2),
      Area.checkPoint(left: 150, right: 200, top: 400, bottom: 350, checkPointNumber: 3),
      Area.checkPoint(left: 250, right: 300, top: 250, bottom: 200, checkPointNumber: 4),
      Area.checkPoint(left: 450, right: 500, top: 200, bottom: 150, checkPointNumber: 5),
      Area.checkPoint(left: 350, right: 400, top: 350, bottom: 300, checkPointNumber: 6),
      Area.checkPoint(left: 300, right: 350, top: 600, bottom: 550, checkPointNumber: 7),
      //----
      Area.obstacle(bottom: -6, left: 0, right: 600, top: 6),
      Area.obstacle(bottom: 0, left: 594, right: 606, top: 500),
      Area.obstacle(bottom: 494, left: 450, right: 600, top: 506),
      Area.obstacle(bottom: 544, left: 500, right: 600, top: 556),
      Area.obstacle(bottom: 550, left: 594, right: 606, top: 600),
      Area.obstacle(bottom: 594, left: 0, right: 600, top: 606),
      Area.obstacle(bottom: 550, left: 444, right: 456, top: 600),
      Area.obstacle(bottom: 0, left: 544, right: 556, top: 150),
      Area.obstacle(bottom: 144, left: 500, right: 550, top: 156),
      Area.obstacle(bottom: 100, left: 494, right: 506, top: 200),
      Area.obstacle(bottom: 94, left: 450, right: 500, top: 106),
      Area.obstacle(bottom: 0, left: 494, right: 506, top: 50),
      Area.obstacle(bottom: 44, left: 350, right: 500, top: 56),
      Area.obstacle(bottom: 94, left: 350, right: 400, top: 106),
      Area.obstacle(bottom: 150, left: 394, right: 406, top: 200),
      Area.obstacle(bottom: 144, left: 400, right: 450, top: 156),
      Area.obstacle(bottom: 150, left: 444, right: 456, top: 200),
      Area.obstacle(bottom: 50, left: 344, right: 356, top: 100),
      Area.obstacle(bottom: 0, left: 294, right: 306, top: 50),
      Area.obstacle(bottom: 50, left: 244, right: 256, top: 100),
      Area.obstacle(bottom: 94, left: 250, right: 350, top: 106),
      Area.obstacle(bottom: 100, left: 344, right: 356, top: 150),
      Area.obstacle(bottom: 144, left: 200, right: 350, top: 156),
      Area.obstacle(bottom: 100, left: 194, right: 206, top: 200),
      Area.obstacle(bottom: 150, left: 244, right: 256, top: 250),
      Area.obstacle(bottom: 244, left: 150, right: 250, top: 256),
      Area.obstacle(bottom: 194, left: 300, right: 400, top: 206),
      Area.obstacle(bottom: 200, left: 294, right: 306, top: 250),
      Area.obstacle(bottom: 450, left: 494, right: 506, top: 500),
      Area.obstacle(bottom: 444, left: 500, right: 550, top: 456),
      Area.obstacle(bottom: 394, left: 450, right: 600, top: 406),
      Area.obstacle(bottom: 344, left: 500, right: 550, top: 356),
      Area.obstacle(bottom: 200, left: 544, right: 556, top: 350),
      Area.obstacle(bottom: 194, left: 550, right: 600, top: 206),
      Area.obstacle(bottom: 300, left: 494, right: 506, top: 350),
      Area.obstacle(bottom: 294, left: 450, right: 500, top: 306),
      Area.obstacle(bottom: 350, left: 444, right: 456, top: 450),
      Area.obstacle(bottom: 344, left: 400, right: 450, top: 356),
      Area.obstacle(bottom: 300, left: 394, right: 406, top: 400),
      Area.obstacle(bottom: 444, left: 350, right: 450, top: 456),
      Area.obstacle(bottom: 450, left: 344, right: 356, top: 550),
      Area.obstacle(bottom: 544, left: 350, right: 400, top: 556),
      Area.obstacle(bottom: 450, left: 394, right: 406, top: 500),
      Area.obstacle(bottom: 200, left: 344, right: 356, top: 400),
      Area.obstacle(bottom: 394, left: 300, right: 350, top: 406),
      Area.obstacle(bottom: 350, left: 294, right: 306, top: 500),
      Area.obstacle(bottom: 344, left: 200, right: 300, top: 356),
      Area.obstacle(bottom: 350, left: 194, right: 206, top: 400),
      Area.obstacle(bottom: 394, left: 200, right: 250, top: 406),
      Area.obstacle(bottom: 400, left: 244, right: 256, top: 550),
      Area.obstacle(bottom: 544, left: 200, right: 300, top: 556),
      Area.obstacle(bottom: 550, left: 194, right: 206, top: 600),
      Area.obstacle(bottom: 500, left: 144, right: 156, top: 550),
      Area.obstacle(bottom: 494, left: 150, right: 250, top: 506),
      Area.obstacle(bottom: 444, left: 150, right: 200, top: 456),
      Area.obstacle(bottom: 250, left: 144, right: 156, top: 450),
      Area.obstacle(bottom: 400, left: 94, right: 106, top: 600),
      Area.obstacle(bottom: 344, left: 50, right: 100, top: 356),
      Area.obstacle(bottom: 200, left: 94, right: 106, top: 350),
      Area.obstacle(bottom: 194, left: 100, right: 150, top: 206),
      Area.obstacle(bottom: 150, left: 144, right: 156, top: 200),
      Area.obstacle(bottom: 144, left: 50, right: 150, top: 156),
      Area.obstacle(bottom: 94, left: 0, right: 150, top: 106),
      Area.obstacle(bottom: 100, left: -6, right: 6, top: 600),
      Area.obstacle(bottom: 394, left: 0, right: 50, top: 406),
      Area.obstacle(bottom: 400, left: 44, right: 56, top: 500),
      Area.obstacle(bottom: 294, left: 0, right: 50, top: 306),
      Area.obstacle(bottom: 200, left: 44, right: 56, top: 300),
    ];
  }
}
