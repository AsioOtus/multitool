public protocol Customizable { }

public extension Customizable {
	func `do` (_ block: (Self) throws -> Void) rethrows {
		try block(self)
	}
	
	func use (_ block: (inout Self) throws -> Void) rethrows {
		var selfCopy = self
		try block(&selfCopy)
	}

	func set (_ block: (inout Self) throws -> Void) rethrows -> Self {
		var selfCopy = self
		try block(&selfCopy)
		return selfCopy
	}
	
	mutating func mutate (_ block: (inout Self) throws -> Void) rethrows {
		try block(&self)
	}
	
	func `let` <T> (_ block: (Self) throws -> T) rethrows -> T {
		try block(self)
	}
}

public extension Customizable where Self: AnyObject {
	func set (_ block: (Self) throws -> Void) rethrows -> Self {
		try block(self)
		return self
	}
}





extension Array:      Customizable { }
extension Dictionary: Customizable { }
extension Set:        Customizable { }
extension String:     Customizable { }
extension Int:        Customizable { }
extension Double:     Customizable { }
extension Float:      Customizable { }
extension Bool:       Customizable { }



import Foundation

extension NSObject: Customizable { }
extension Date:     Customizable { }



#if !os(Linux)
extension CGPoint:  Customizable { }
extension CGRect:   Customizable { }
extension CGSize:   Customizable { }
extension CGVector: Customizable { }
#endif



#if os(iOS) || os(tvOS)
import UIKit.UIGeometry
extension UIEdgeInsets: Customizable { }
extension UIOffset:     Customizable { }
extension UIRectEdge:   Customizable { }
#endif
