public struct GeneralTree <Value> {
	public var value: Value
	public var nodes: [GeneralTree<Value>]

	public init (
		value: Value,
		nodes: [GeneralTree<Value>] = []
	) {
		self.value = value
		self.nodes = nodes
	}

	public init (
		value: Value
	) {
		self.init(value: value, nodes: [])
	}
}

public extension GeneralTree {
	var isLeaf: Bool {
		nodes.isEmpty
	}

	var isNode: Bool {
		!nodes.isEmpty
	}

	var depth: Int {
		nodes.map(\.depth).max() ?? 0 + 1
	}
}

extension GeneralTree: Codable where Value: Codable { }
extension GeneralTree: Hashable where Value: Hashable { }
