import Foundation

public final class LaunchCounter: Sendable {
	public static let `default` = LaunchCounter("default")
	
	private static let cycleIdKey = "cycleId"
	private static let launchCountKey = "launchCount"
	
	public let label: String
	
	public var prefixedCycleIdKey: String { prefixed(Self.cycleIdKey) }
	public var prefixedLaunchCountKey: String { prefixed(Self.launchCountKey) }
	
	public var count: Int { UserDefaults.standard.integer(forKey: prefixedLaunchCountKey) }
	public var isFirst: Bool { count == 1 }
	
	public init (_ label: String) {
		assert(!label.isEmpty, "LaunchCounter – label can not be empty")
		
		self.label = label
	}
	
	public func prefixed (_ key: String) -> String { "LaunchCounter.\(label).\(key)" }
	
	public func launch () {
		UserDefaults.standard.set(count + 1, forKey: prefixedLaunchCountKey)
	}
	
	public func launch (cycle id: String) {
		next(cycle: id)
		launch()
	}
	
	public func ifFirst (_ action: () -> Void) {
		guard count == 0 else { return }
		action()
	}
	
	public func next (cycle id: String) {
		guard id != UserDefaults.standard.string(forKey: prefixedCycleIdKey) else { return }
		UserDefaults.standard.set(0, forKey: prefixedLaunchCountKey)
		UserDefaults.standard.set(id, forKey: prefixedCycleIdKey)
	}
	
	public func resetCount () {
		UserDefaults.standard.set(0, forKey: prefixedLaunchCountKey)
	}
	
	public func resetCycle () {
		UserDefaults.standard.set(nil, forKey: prefixedCycleIdKey)
	}
}
