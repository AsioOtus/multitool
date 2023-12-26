import Foundation

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
public extension OSStatus {
	var message: String? {
		if #available(iOS 11.3, *) {
			let message = (SecCopyErrorMessageString(self, nil) as String?)
			return message
		} else {
			return self.description
		}
	}
}
#endif
