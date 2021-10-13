public protocol CategorizableError: Error {
	associatedtype Category
	
	var category: Category { get }
}
