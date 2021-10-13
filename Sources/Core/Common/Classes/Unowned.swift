open class Unowned<T: AnyObject> {
	public unowned var value: T
	
	public init (_ value: T) {
		self.value = value
	}
}
