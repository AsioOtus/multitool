public struct CategorizedError<Category>: CategorizableError {
	public let category: Category
	
	public init (_ category: Category) {
		self.category = category
	}
}
