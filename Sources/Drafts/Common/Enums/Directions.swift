public typealias Direction2DBase   = Direction.TwoDimensional.Base
public typealias Direction2DMain   = Direction.TwoDimensional.Main
public typealias Direction2DExtend = Direction.TwoDimensional.Extend

public typealias DirectionHexFlat   = Direction.TwoDimensional.Hexagonal.Flat
public typealias DirectionHexPointy = Direction.TwoDimensional.Hexagonal.Pointy

public typealias Direction3DBase   = Direction.ThreeDimensional.Base
public typealias Direction3DMain   = Direction.ThreeDimensional.Main
public typealias Direction3DExtend = Direction.ThreeDimensional.Extend

public enum Direction {
	public enum TwoDimensional {
		public enum Base {
			case up
			case right
			case down
			case left
		}
		
		public enum Main {
			case up
			case upRight
			case right
			case downRight
			case down
			case downLeft
			case left
			case upLeft
		}
		
		public enum Extend {
			case up
			case upUpRight
			case upRight
			case upRightRight
			case right
			case downRightRight
			case downRight
			case downDownRight
			case down
			case downDownLeft
			case downLeft
			case downLeftLeft
			case left
			case upLeftLeft
			case upLeft
			case upUpLeft
		}
		
		public enum Hexagonal {
			public enum Flat {
				case up
				case upRight
				case downRight
				case down
				case downLeft
				case upLeft
			}
			
			public enum Pointy {
				case upRight
				case right
				case downRight
				case downLeft
				case left
				case upLeft
			}
		}
	}
	
	public enum ThreeDimensional {
		public enum Base {
			
		}
		
		public enum Main {
			
		}
		
		public enum Extend {
			
		}
	}
}

extension Direction2DBase:   CaseIterable, CreatableByInt, Randomable { }
extension Direction2DMain:   CaseIterable, CreatableByInt, Randomable { }
extension Direction2DExtend: CaseIterable, CreatableByInt, Randomable { }

extension DirectionHexFlat:   CaseIterable, CreatableByInt, Randomable { }
extension DirectionHexPointy: CaseIterable, CreatableByInt, Randomable { }

extension Direction3DBase:   CaseIterable, CreatableByInt, Randomable { }
extension Direction3DMain:   CaseIterable, CreatableByInt, Randomable { }
extension Direction3DExtend: CaseIterable, CreatableByInt, Randomable { }
