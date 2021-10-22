@resultBuilder
public struct ArrayBuilder {
	public static func buildBlock <Component> (_ components: Component...) -> [Component] {
		return Array(components)
	}
	
	public static func buildOptional <Component> (_ components: [Component]?) -> [Component] {
		guard let components = components else { return [] }
		return components
	}
	
	public static func buildExpression <Component> (_ component: Component) -> Component {
		component
	}
	
	public static func buildEither <Component> (first component: Component) -> Component {
		component
	}
	
	public static func buildEither <Component> (second component: Component) -> Component {
		component
	}
}
