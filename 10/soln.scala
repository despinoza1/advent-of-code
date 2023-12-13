import scala.collection.mutable
import scala.io.Source

case class Point(x: Int, y: Int):
  def +(other: Point): Point = Point(x + other.x, y + other.y)
  def -(other: Point): Point = Point(x - other.x, y - other.y)

val North = Point(0, -1)
val South = Point(0, 1)
val West = Point(-1, 0)
val East = Point(1, 0)

case class Tile(symbol: Char, pos: Point):
  val neighbours: Set[Point] =
    symbol match
      // vertical pipe
      case '|' => Set(pos + North, pos + South)
      // horizontal pipe
      case '-' => Set(pos + East, pos + West)
      // 90-degree bend connecting north and east
      case 'L' => Set(pos + North, pos + East)
      // 90-degree bend connecting north and west
      case 'J' => Set(pos + North, pos + West)
      // 90-degree bend connecting south and west
      case '7' => Set(pos + South, pos + West)
      // 90-degree bend connecting south and east
      case 'F' => Set(pos + South, pos + East)
      // ground
      case _ => Set.empty

def findLoop(tiles: Map[Point, Tile]) =
  val start = tiles.values.find(t => t.symbol == 'S').get

  val neighbours = Seq(North, East, South, West)
    .flatMap(d => tiles.get(start.pos + d))
    .filter(_.neighbours.contains(start.pos))

  val neighbourPts = neighbours.map(_.pos).toSet
  val fixedStart = "|-LJ7F"
    .map(Tile(_, start.pos))
    .find(t => t.neighbours == neighbourPts)
    .get

  val fixedTiles = tiles ++ Map(fixedStart.pos -> fixedStart)

  val loop = mutable.ArrayBuffer[Tile](fixedStart)
  var current = neighbours.head
  while (current != fixedStart) do
    val next = fixedTiles(current.neighbours.find(_ != loop.last.pos).get)
    loop += current
    current = next

  (loop.toSeq, fixedTiles)

def toMapTiles(input: Iterator[String]): Map[Point, Tile] =
  input.zipWithIndex
    .flatMap((line, y) => line.zipWithIndex.map((char, x) => (char, x, y)))
    .map((char, x, y) => Point(x, y) -> Tile(char, Point(x, y)))
    .toMap

@main def solve() =
  val input = Source.fromFile("input.txt").getLines
  // println(input)

  val (loop, tiles) = findLoop(toMapTiles(input))
  println(loop.size / 2)

  val cornerPairs = Map('F' -> '7', 'L' -> 'J')
  println {
    tiles.values
      .filter(!loop.toSet.contains(_))
      .count: t =>
        val leftWalls = loop
          .groupBy(_.pos.y)
          .map((y, tiles) => (y, tiles.toSeq.sortBy(_.pos.x)))
          .get(t.pos.y)
          .getOrElse(Seq.empty)
          .filter(_.pos.x < t.pos.x)

        val wallCount = leftWalls.foldLeft((0, '.')):
          case ((count, prevCorner), wall) =>
            wall.symbol match
              case '|' => (count + 1, prevCorner)
              case c if cornerPairs.get(prevCorner) == Some(c) => (count - 1, c)
              case c: ('L' | 'F')                              => (count + 1, c)
              case c: ('7' | 'J')                              => (count, c)
              case _ => (count, prevCorner)
        wallCount._1 % 2 == 1
  }
