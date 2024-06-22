public struct Tree <Value> {
	public var value: Value
	public var nodes: [Tree<Value>]

	public init (
		value: Value,
		nodes: [Tree<Value>] = []
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

public extension Tree {
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

public extension Tree where Value: Identifiable {
	mutating func removeNodes (withId id: Value.ID) {
		nodes.removeAll { $0.value.id == id }

		for index in nodes.indices {
			nodes[index].removeNodes(withId: id)
		}
	}
}

extension Tree: Codable where Value: Codable { }
extension Tree: Equatable where Value: Equatable { }
extension Tree: Hashable where Value: Hashable { }
