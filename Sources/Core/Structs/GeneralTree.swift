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

public extension GeneralTree where Value: Identifiable {
	mutating func removeNodes (withId id: Value.ID) {
		nodes.removeAll { $0.value.id == id }

		for index in nodes.indices {
			nodes[index].removeNodes(withId: id)
		}
	}
}

extension GeneralTree: Codable where Value: Codable { }
extension GeneralTree: Equatable where Value: Equatable { }
extension GeneralTree: Hashable where Value: Hashable { }
