public indirect enum GeneralTree <Leaf, Node> {
  case leaf(Leaf)
  case node(Node, [GeneralTree])
}

@available(iOS 13.0, macOS 10.15, *)
public extension GeneralTree where Leaf: Identifiable, Node: Identifiable {
  var leafIds: [Leaf.ID] {
    switch self {
    case .leaf(let leaf):
      return [leaf.id]

    case .node(_, let trees):
      return trees.flatMap { $0.leafIds }
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

    case .node(_ ,let trees):
      for tree in trees {
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

    case .node(let node, let trees):
      if node.id == nodeId {
        return true
      }

      for tree in trees {
        if tree.isContains(nodeId: nodeId) {
          return true
        }
      }

      return false
    }
  }

  func insert (tree: GeneralTree, toNode nodeId: Node.ID) -> Self? {
    switch tree {
    case .leaf(let leaf):
      guard !isContains(leafId: leaf.id) else { return nil }
      return insert(leaf: leaf, toNode: nodeId)

    case .node(let node, let trees):
      guard !isContains(nodeId: node.id) else { return nil }
      return insert(node: node, trees: trees, toNode: nodeId)
    }
  }

  func insert (leaf: Leaf, toNode nodeId: Node.ID) -> Self? {
    guard !isContains(leafId: leaf.id) else { return nil }
    return insert(leaf, toNode: nodeId)
  }

  private func insert (_ leaf: Leaf, toNode nodeId: Node.ID) -> Self? {
    switch self {
    case .leaf:
      return nil

    case .node(let node, var trees):
      if node.id == nodeId {
        return .node(node, [.leaf(leaf)] + trees)
      } else {
        for index in trees.indices {
          if let updatedTree = trees[index].insert(leaf, toNode: nodeId) {
            trees[index] = updatedTree
            return .node(node, trees)
          }
        }

        return nil
      }
    }
  }

  func insert (node: Node, trees: [GeneralTree], toNode nodeId: Node.ID) -> Self? {
    guard !isContains(nodeId: node.id) else { return nil }
    return insert(node, trees, toNode: nodeId)
  }

  private func insert (_ node: Node, _ trees: [GeneralTree], toNode nodeId: Node.ID) -> Self? {
    switch self {
    case .leaf:
      return nil

    case .node(let node, var trees):
      if node.id == nodeId {
        return .node(node, [.node(node, trees)] + trees)
      } else {
        for index in trees.indices {
          if let updatedTree = trees[index].insert(node, trees, toNode: nodeId) {
            trees[index] = updatedTree
            return .node(node, trees)
          }
        }

        return nil
      }
    }
  }

  func update (with tree: GeneralTree) -> Self? {
    switch self {
    case .leaf(let leaf): return update(with: leaf)
    case .node(let node, let trees): return update(with: node, and: trees)
    }
  }

  func update (with updatedLeaf: Leaf) -> Self? {
    switch self {
    case .leaf(let leaf):
      return leaf.id == updatedLeaf.id ? .leaf(updatedLeaf) : nil

    case .node(_, let trees):
      for tree in trees {
        if let updatedTree = tree.update(with: updatedLeaf) {
          return updatedTree
        }
      }

      return nil
    }
  }

  func update (with updatedNode: Node, and updatedTrees: [GeneralTree]? = nil) -> Self? {
    switch self {
    case .leaf:
      return nil

    case .node(let node, var trees):
      if node.id == updatedNode.id {
        return .node(updatedNode, updatedTrees ?? trees)
      } else {
        for index in trees.indices {
          if let updatedTree = trees[index].update(with: updatedNode) {
            trees[index] = updatedTree
            return .node(node, trees)
          }
        }

        return nil
      }
    }
  }

  func update (leafId: Leaf.ID, transformation: (Leaf) -> Leaf) -> Self? {
    switch self {
    case .leaf(let leaf):
      let transformedLeaf = leaf.id == leafId ? transformation(leaf) : nil
      return transformedLeaf.flatMap { $0.id == leaf.id ? .leaf($0) : nil }

    case .node(let node, var trees):
      for index in trees.indices {
        if let updatedTree = trees[index].update(leafId: leafId, transformation: transformation) {
          trees[index] = updatedTree
          return .node(node, trees)
        }
      }

      return nil
    }
  }
}

@available(iOS 13.0, macOS 10.15, *)
extension GeneralTree: Identifiable where Leaf: Identifiable, Node: Identifiable, Leaf.ID == Node.ID {
  public typealias ID = Node.ID

  public var id: ID {
    switch self {
    case .leaf(let leaf): return leaf.id
    case .node(let node, _): return node.id
    }
  }
}

@available(iOS 13.0, macOS 10.15, *)
public extension GeneralTree where Leaf: Identifiable, Node: Identifiable, Leaf.ID == Node.ID {
  var ids: [Leaf.ID] {
    switch self {
    case .leaf(let leaf):
      return [leaf.id]

    case .node(let node, let trees):
      return [node.id] + trees.flatMap { $0.ids }
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

    case .node(let node, let trees):
      if node.id == id {
        return true
      }

      for tree in trees {
        if tree.isContains(id: id) {
          return true
        }
      }

      return false
    }
  }

  func replace (_ id: ID, with tree: GeneralTree) -> Self? {
    switch self {
    case .leaf(let leaf):
      return leaf.id == id ? tree : nil

    case .node(let node, var trees):
      if node.id == id {
        return tree
      } else {
        for index in trees.indices {
          if let replacedTree = trees[index].replace(id, with: tree) {
            trees[index] = replacedTree
            return .node(node, trees)
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

    case .node(let node, let trees):
      if node.id == id {
        return nil
      } else {
        let filteredTrees = trees.compactMap { $0.delete(id: id) }
        return .node(node, filteredTrees)
      }
    }
  }
}
