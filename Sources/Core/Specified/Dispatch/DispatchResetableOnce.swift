public class DispatchResetableOnce {
	private let dispatchResetableFirst = DispatchResetableFirst()
	
	private let action: () -> Void
	
	public var isPerformed: Bool { dispatchResetableFirst.isReady }
	
	public init (_ action: @escaping () -> Void) {
		self.action = action
	}
	
	public func perform () {
		dispatchResetableFirst.perform(action)
	}
	
	public func reset () {
		dispatchResetableFirst.reset()
	}
}
