@resultBuilder
public struct ProcessorBuilder {
	public static func buildBlock <Value, Failure> (_ components: AnyProcessor<Value, Failure>...) -> [AnyProcessor<Value, Failure>] {
		Array(components)
	}
	
	public static func buildOptional <Value, Failure> (_ components: [AnyProcessor<Value, Failure>]?) -> [AnyProcessor<Value, Failure>] {
		guard let components = components else { return [] }
		return components
	}
	
	public static func buildExpression <Value, Failure> (_ component: AnyProcessor<Value, Failure>) -> AnyProcessor<Value, Failure> {
		component
	}
	
	public static func buildEither <Value, Failure> (first component: AnyProcessor<Value, Failure>) -> AnyProcessor<Value, Failure> {
		component
	}
	
	public static func buildEither <Value, Failure> (second component: AnyProcessor<Value, Failure>) -> AnyProcessor<Value, Failure> {
		component
	}
}
