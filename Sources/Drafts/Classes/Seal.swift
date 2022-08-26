public extension Seal {
	enum State {
		case inactive
		case sealed
		case unsealed
	}
}

open class Seal: Identifiable {
	public typealias Identifier = UInt
	
	private static var nextId: UInt = 1
	public private(set) var state: State

	public private(set) var id: UInt

	public init (sealed: Bool = true) {
		id = Seal.nextId
		Seal.nextId += 1

		state = sealed ? .sealed : .inactive
	}

	public func seal () {
		guard state == .inactive else { return }
		state = .sealed
	}

	public func unseal () {
		guard state == .sealed else { return }
		state = .unsealed
	}
}

public extension Seal {
	var isInactive: Bool {
		return state == .inactive
	}
	
	var isSealed: Bool {
		return state == .sealed
	}
	
	var isUnsealed: Bool {
		return state == .unsealed
	}
	
	var isActive: Bool {
		return isSealed || isUnsealed
	}
}

extension Seal: Equatable {
	public static func == (left: Seal, right: Seal) -> Bool {
		let isStatesEqual = left.state == right.state
		return isStatesEqual
	}
}
