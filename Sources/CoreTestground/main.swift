import Multitool

extension Int: Identifiable {
  public var id: Self { self }
}

@available(macOS 13, *)
struct Model: TreeNode, Identifiable {
  typealias Leaf = Self

  let id: Int
  let value: String
  var trees: [InnerTree] = []
}

if #available (macOS 13, *) {
  let tree = Tree<Model, Model>
    .node(
      .init(
        id: 1,
        value: "123",
        trees: [
          .leaf(.init(id: 11, value: "123")),
          .leaf(.init(id: 12, value: "123")),
          .node(
            .init(
              id: 13,
              value: "123",
              trees: [
                .leaf(.init(id: 131, value: "123")),
                .leaf(.init(id: 132, value: "123"))
              ]
            )
          ),
          .leaf(.init(id: 14, value: "123")),
        ]
      )
    )
    .validated!

  print(tree)
  print(tree.delete(id: 13)!)
  print(
    tree
      .insert(leaf: .init(id: 32, value: "qwe"), toNode: 13)
      .replace(id: 12, with: .leaf(.init(id: 12, value: "qeqweqweqweqweqew")))
//      .update(leafId: 12) { _ in
//        .init(id: 12, value: "qeqweqweqweqweqew")
//      }
  )
}
