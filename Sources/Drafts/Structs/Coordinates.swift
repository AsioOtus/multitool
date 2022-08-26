public typealias Coordinates2D = Coordinates.TwoDimensional
public typealias Coordinates3D = Coordinates.ThreeDimentional

public struct Coordinates {
	private init () { }
	
	public struct TwoDimensional<T: Numeric> {
		public var x, y: T
		
		public static var zero: Coordinates2D<T> {
			return Coordinates2D(0, 0)
		}
		
		public init () {
			self.x = 0
			self.y = 0
		}
		
		public init (_ x: T, _ y: T) {
			self.x = x
			self.y = y
		}
		
		public init (x: T = 0, y: T = 0) {
			self.init(x, y)
		}
		
		public func changed (deltaX: T = 0, deltaY: T = 0) -> Coordinates2D<T> {
			let newCoordinates = Coordinates2D(x + deltaX, y + deltaY)
			return newCoordinates
		}
		
		public static func + (left: Coordinates2D<T>, right: Coordinates2D<T>) -> Coordinates2D<T> {
			return Coordinates2D(left.x + right.x, left.y + right.x)
		}
		
		public static func - (left: Coordinates2D<T>, right: Coordinates2D<T>) -> Coordinates2D<T> {
			return Coordinates2D(left.x - right.x, left.y - right.x)
		}
		
		public static func +- (left: Coordinates2D<T>, right: Coordinates2D<T>) -> Coordinates2D<T> {
			return Coordinates2D(left.x + right.x, left.y - right.x)
		}
		
		public static func -+ (left: Coordinates2D<T>, right: Coordinates2D<T>) -> Coordinates2D<T> {
			return Coordinates2D(left.x - right.x, left.y + right.x)
		}
	}
	
	public struct ThreeDimentional<T: Numeric> {
		public var x, y, z: T
		
		public static var zero: Coordinates3D<T> {
			return Coordinates3D(0, 0, 0)
		}
		
		public init () {
			self.x = 0
			self.y = 0
			self.z = 0
		}
		
		public init (_ x: T, _ y: T, _ z: T) {
			self.x = x
			self.y = y
			self.z = z
		}
		
		public init (x: T = 0, y: T = 0, z: T = 0) {
			self.init(x, y, z)
		}
		
		func changed (deltaX: T = 0, deltaY: T = 0, deltaZ: T = 0) -> Coordinates3D<T> {
			let newCoordinates = Coordinates3D(x + deltaX, y + deltaY, z + deltaZ)
			return newCoordinates
		}
	}
}

public extension Coordinates2D where T: FixedWidthInteger {
	func nearby (at direction: DirectionHexFlat) -> Coordinates2D<T> {
		var nearbyCoordinates: Coordinates2D<T>
		
		switch direction {
		case .up:
			nearbyCoordinates = self + Coordinates2D(0, 1)
		case .upRight:
			nearbyCoordinates = self + Coordinates2D(1, 1)
		case .downRight:
			nearbyCoordinates = self + Coordinates2D(1, -1)
		case .down:
			nearbyCoordinates = self + Coordinates2D(0, -1)
		case .downLeft:
			nearbyCoordinates = self + Coordinates2D(-1, -1)
		case .upLeft:
			nearbyCoordinates = self + Coordinates2D(-1, 1)
		}
		
		return nearbyCoordinates
	}
	
	func nearby (at direction: DirectionHexPointy) -> Coordinates2D<T> {
		var nearbyCoordinates: Coordinates2D<T>
		
		switch direction {
		case .upRight:
			nearbyCoordinates = self + Coordinates2D(1, 1)
		case .right:
			nearbyCoordinates = self + Coordinates2D(1, 0)
		case .downRight:
			nearbyCoordinates = self + Coordinates2D(1, -1)
		case .downLeft:
			nearbyCoordinates = self + Coordinates2D(-1, -1)
		case .left:
			nearbyCoordinates = self + Coordinates2D(-1, 0)
		case .upLeft:
			nearbyCoordinates = self + Coordinates2D(-1, 1)
		}
		
		return nearbyCoordinates
	}
}

extension Coordinates2D: Equatable {
	public static func == (left: Coordinates2D<T>, right: Coordinates2D<T>) -> Bool {
		let isCoordinatesEqual = left.x == right.x && left.y == right.y
		return isCoordinatesEqual
	}
}

extension Coordinates2D: CustomStringConvertible {
	public var description: String {
		return "(\(x), \(y))"
	}
}

extension Coordinates3D: Equatable {
	public static func == (left: Coordinates3D<T>, right: Coordinates3D<T>) -> Bool {
		let isCoordinatesEqual = left.x == right.x && left.y == right.y && left.z == right.z
		return isCoordinatesEqual
	}
}

extension Coordinates3D: CustomStringConvertible {
	public var description: String {
		return "(\(x), \(y), \(z))"
	}
}
