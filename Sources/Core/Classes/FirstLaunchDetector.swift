import Foundation

public final class FirstLaunchDetector: Sendable {
	public static let shared = FirstLaunchDetector()
	private static let storageKey = "FirstLaunchDetector.launchCount"
	
	public var launchCount: Int {
		UserDefaults.standard.integer(forKey: Self.storageKey)
	}
	
	public var isFirstLaunch: Bool {
		launchCount == 1
	}
	
	public func launch () {
		UserDefaults.standard.set(launchCount + 1, forKey: Self.storageKey)
	}
	
	public func ifFirst (_ action: () -> Void) {
		guard isFirstLaunch else { return }
		action()
	}
}
