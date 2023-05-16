@available(macOS 13.0, *)
public indirect enum Tree <Leaf, Node> where Node: TreeNode<Leaf> {
  case leaf(Leaf)
  case node(Node)
}

@available(macOS 13.0, *)
public protocol TreeNode<Leaf> {
  associatedtype Leaf

  typealias InnerTree = Tree<Leaf, Self>

  var trees: [InnerTree] { get set }

  mutating func prepended (leaf: Leaf) -> Self
  mutating func prepended (node: Self) -> Self
  mutating func prepended (tree: InnerTree) -> Self
  mutating func prepended (trees: [InnerTree]) -> Self

  mutating func replaced (with tree: InnerTree, at index: Int) -> Self
  mutating func replacedAll (with trees: [InnerTree]) -> Self

  mutating func removed (at index: Int) -> Self
}

@available(macOS 13.0, *)
public extension TreeNode {
  mutating func prepended (leaf: Leaf) -> Self {
    prepended(tree: .leaf(leaf))
  }

  mutating func prepended (node: Self) -> Self {
    prepended(tree: .node(node))
  }

  mutating func prepended (tree: InnerTree) -> Self {
    prepended(trees: [tree])
  }

  mutating func prepended (trees: [InnerTree]) -> Self {
    self.trees = trees + self.trees
    return self
  }

  mutating func replaced (with tree: InnerTree, at index: Int) -> Self {
    self.trees[index] = tree
    return self
  }

  mutating func replacedAll (with trees: [InnerTree]) -> Self {
    self.trees = trees
    return self
  }

  mutating func removed (at index: Int) -> Self {
    self.trees.remove(at: index)
    return self
  }
}

struct StandardNode<Details>: TreeNode {
  typealias Leaf = String

  let details: Details
  var trees: [InnerTree]

  mutating func prepended (leaf: Leaf) -> Self {
    prepended(tree: .leaf(leaf))
  }

  mutating func prepended (node: Self) -> Self {
    prepended(tree: .node(node))
  }

  mutating func prepended (tree: InnerTree) -> Self {
    prepended(trees: [tree])
  }

  mutating func prepended (trees: [InnerTree]) -> Self {
    self.trees = trees + self.trees
    return self
  }

  mutating func replaced (with tree: InnerTree, at index: Int) -> Self {
    self.trees[index] = tree
    return self
  }

  mutating func replacedAll (with trees: [InnerTree]) -> Self {
    self.trees = trees
    return self
  }

  mutating func removed (at index: Int) -> Self {
    self.trees.remove(at: index)
    return self
  }
}

@available(iOS 13, macOS 13, *)
public extension Tree where Leaf: Identifiable, Node: Identifiable {
  var leafIds: [Leaf.ID] {
    switch self {
    case .leaf(let leaf):
      return [leaf.id]

    case .node(let node):
      return node.trees.flatMap { $0.leafIds }
    }
  }

  var hasDuplicateLeafIds: Bool {
    leafIds.count != Set(leafIds).count
  }

  var validated: Self? {
    hasDuplicateLeafIds ? nil : self
  }

  func isContains (leafId: Leaf.ID) -> Bool {
    switch self {
    case .leaf(let leaf):
      return leaf.id == leafId

    case .node(let node):
      for tree in node.trees {
        if tree.isContains(leafId: leafId) {
          return true
        }
      }

      return false
    }
  }

  func isContains (nodeId: Node.ID) -> Bool {
    switch self {
    case .leaf:
      return false

    case .node(let node):
      if node.id == nodeId {
        return true
      }

      for tree in node.trees {
        if tree.isContains(nodeId: nodeId) {
          return true
        }
      }

      return false
    }
  }
}

@available(iOS 13, macOS 13, *)
public extension Tree where Leaf: Identifiable, Node: Identifiable {
  func insert (tree: Self, toNode nodeId: Node.ID) -> Self {
    insertOrNil(tree: tree, toNode: nodeId) ?? self
  }

  func insertOrNil (tree: Self, toNode nodeId: Node.ID) -> Self? {
    switch tree {
    case .leaf(let leaf):
      guard !isContains(leafId: leaf.id) else { return nil }
      return insertOrNil(leaf, toNode: nodeId)

    case .node(let node):
      guard !isContains(nodeId: node.id) else { return nil }
      return insertOrNil(node, toNode: nodeId)
    }
  }

  func insert (leaf: Leaf, toNode nodeId: Node.ID) -> Self {
    insertOrNil(leaf: leaf, toNode: nodeId) ?? self
  }

  func insertOrNil (leaf: Leaf, toNode nodeId: Node.ID) -> Self? {
    guard !isContains(leafId: leaf.id) else { return nil }
    return insertOrNil(leaf, toNode: nodeId)
  }

  private func insertOrNil (_ leaf: Leaf, toNode nodeId: Node.ID) -> Self? {
    switch self {
    case .leaf:
      return nil

    case .node(var node):
      if node.id == nodeId {
        return .node(node.prepended(leaf: leaf))
      } else {
        for index in node.trees.indices {
          if let updatedTree = node.trees[index].insertOrNil(leaf, toNode: nodeId) {
            let node = node.replaced(with: updatedTree, at: index)
            return .node(node)
          }
        }

        return nil
      }
    }
  }

  func insert (node: Node, toNode nodeId: Node.ID) -> Self {
    insertOrNil(node: node, toNode: nodeId) ?? self
  }

  func insertOrNil (node: Node, toNode nodeId: Node.ID) -> Self? {
    guard !isContains(nodeId: node.id) else { return nil }
    return insertOrNil(node, toNode: nodeId)
  }

  private func insertOrNil (_ newNode: Node, toNode nodeId: Node.ID) -> Self? {
    switch self {
    case .leaf:
      return nil

    case .node(var node):
      if node.id == nodeId {
        return .node(node.prepended(node: newNode))
      } else {
        for index in node.trees.indices {
          if let updatedTree = node.trees[index].insertOrNil(newNode, toNode: nodeId) {
            let node = node.replaced(with: updatedTree, at: index)
            return .node(node)
          }
        }

        return nil
      }
    }
  }
}

@available(iOS 13, macOS 13, *)
public extension Tree where Leaf: Identifiable, Node: Identifiable {
  func update (with tree: Self) -> Self {
    updateOrNil(with: tree) ?? self
  }

  func updateOrNil (with tree: Self) -> Self? {
    switch self {
    case .leaf(let leaf): return updateOrNil(with: leaf)
    case .node(let node): return updateOrNil(with: node)
    }
  }

  func update (with updatedLeaf: Leaf) -> Self {
    updateOrNil(with: updatedLeaf) ?? self
  }

  func updateOrNil (with updatedLeaf: Leaf) -> Self? {
    switch self {
    case .leaf(let leaf):
      return leaf.id == updatedLeaf.id ? .leaf(updatedLeaf) : nil

    case .node(var node):
      for index in node.trees.indices {
        if let updatedTree = node.trees[index].updateOrNil(with: updatedLeaf) {
          let node = node.replaced(with: updatedTree, at: index)
          return .node(node)
        }
      }

      return nil
    }
  }

  func update (with updatedNode: Node) -> Self {
    updateOrNil(with: updatedNode) ?? self
  }

  func updateOrNil (with updatedNode: Node) -> Self? {
    switch self {
    case .leaf:
      return nil

    case .node(var node):
      if node.id == updatedNode.id {
        return .node(updatedNode)
      } else {
        for index in node.trees.indices {
          if let updatedTree = node.trees[index].updateOrNil(with: updatedNode) {
            let node = node.replaced(with: updatedTree, at: index)
            return .node(node)
          }
        }

        return nil
      }
    }
  }

  func update (leafId: Leaf.ID, transformation: (Leaf) -> Leaf) -> Self {
    updateOrNil(leafId: leafId, transformation: transformation) ?? self
  }

  func updateOrNil (leafId: Leaf.ID, transformation: (Leaf) -> Leaf) -> Self? {
    switch self {
    case .leaf(let leaf):
      let transformedLeaf = leaf.id == leafId ? transformation(leaf) : nil
      return transformedLeaf.flatMap { $0.id == leaf.id ? .leaf($0) : nil }

    case .node(var node):
      for index in node.trees.indices {
        if let updatedTree = node.trees[index].updateOrNil(leafId: leafId, transformation: transformation) {
          let node = node.replaced(with: updatedTree, at: index)
          return .node(node)
        }
      }

      return nil
    }
  }

  func update (nodeId: Node.ID, transformation: (Node) -> Node) -> Self {
    updateOrNil(nodeId: nodeId, transformation: transformation) ?? self
  }

  func updateOrNil (nodeId: Node.ID, transformation: (Node) -> Node) -> Self? {
    switch self {
    case .leaf:
      return nil

    case .node(var node):
      if node.id == nodeId {
        let transformedNode = transformation(node)
        return transformedNode.id == nodeId ? .node(transformedNode) : nil
      } else {
        for index in node.trees.indices {
          if let updatedTree = node.trees[index].updateOrNil(nodeId: nodeId, transformation: transformation) {
            let node = node.replaced(with: updatedTree, at: index)
            return .node(node)
          }
        }
      }

      return nil
    }
  }
}

@available(iOS 13, macOS 13, *)
extension Tree: Identifiable where Leaf: Identifiable, Node: Identifiable, Leaf.ID == Node.ID {
  public typealias ID = Node.ID

  public var id: ID {
    switch self {
    case .leaf(let leaf): return leaf.id
    case .node(let node): return node.id
    }
  }
}

@available(iOS 13, macOS 13, *)
public extension Tree where Leaf: Identifiable, Node: Identifiable, Leaf.ID == Node.ID {
  var ids: [Leaf.ID] {
    switch self {
    case .leaf(let leaf):
      return [leaf.id]

    case .node(let node):
      return [node.id] + node.trees.flatMap { $0.ids }
    }
  }

  var hasDuplicateIds: Bool {
    ids.count != Set(ids).count
  }

  var validated: Self? { hasDuplicateIds ? nil : self }

  func isContains (id: ID) -> Bool {
    switch self {
    case .leaf(let leaf):
      return leaf.id == id

    case .node(let node):
      if node.id == id {
        return true
      }

      for tree in node.trees {
        if tree.isContains(id: id) {
          return true
        }
      }

      return false
    }
  }

  func update (id: ID, transformation: (Self) -> Self) -> Self {
    updateOrNil(id: id, transformation: transformation) ?? self
  }

  func updateOrNil (id: ID, transformation: (Self) -> Self) -> Self? {
    switch self {
    case .leaf(let leaf):
      let transformedTree = leaf.id == id ? transformation(self) : nil
      return transformedTree.flatMap { $0.id == leaf.id ? $0 : nil }

    case .node(var node):
      if node.id == id {
        let transformedTree = transformation(self)
        return transformedTree.id == id ? transformedTree : nil
      } else {
        for index in node.trees.indices {
          if let updatedTree = node.trees[index].updateOrNil(id: id, transformation: transformation) {
            let node = node.replaced(with: updatedTree, at: index)
            return .node(node)
          }
        }
      }

      return nil
    }
  }

  func replace (id: ID, with tree: Self) -> Self {
    replaceOrNil(id: id, with: tree) ?? self
  }

  func replaceOrNil (id: ID, with tree: Self) -> Self? {
    switch self {
    case .leaf(let leaf):
      return leaf.id == id ? tree : nil

    case .node(var node):
      if node.id == id {
        return tree
      } else {
        for index in node.trees.indices {
          if let replacedTree = node.trees[index].replaceOrNil(id: id, with: tree) {
            let node = node.replaced(with: replacedTree, at: index)
            return .node(node)
          }
        }

        return nil
      }
    }
  }

  func delete (id: ID) -> Self? {
    guard isContains(id: id) else { return self }

    switch self {
    case .leaf(let leaf):
      return leaf.id == id ? nil : self

    case .node(var node):
      if node.id == id {
        return nil
      } else {
        let filteredTrees = node.trees.compactMap { $0.delete(id: id) }
        let node = node.replacedAll(with: filteredTrees)
        return .node(node)
      }
    }
  }
}
