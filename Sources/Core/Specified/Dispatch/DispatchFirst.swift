public class DispatchFirst {
	private let dispatchResetableFirst = DispatchResetableFirst()
	
	public var isPerformed: Bool { dispatchResetableFirst.isReady }
	
	public init () { }
	
	public func perform (_ action: () -> Void) {
		dispatchResetableFirst.perform(action)
	}
}
