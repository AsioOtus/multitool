import Foundation

extension Optional: Fluentable { }

extension Array:      Fluentable { }
extension Dictionary: Fluentable { }
extension Set:        Fluentable { }
extension String:     Fluentable { }
extension Int:        Fluentable { }
extension Double:     Fluentable { }
extension Float:      Fluentable { }
extension Bool:       Fluentable { }

extension NSObject: Fluentable { }
extension Date:     Fluentable { }
extension Data:     Fluentable { }



#if !os(Linux)
extension CGPoint:  Fluentable { }
extension CGRect:   Fluentable { }
extension CGSize:   Fluentable { }
extension CGVector: Fluentable { }
#endif



#if os(iOS) || os(tvOS)
import UIKit.UIGeometry
extension UIEdgeInsets: Fluentable { }
extension UIOffset:     Fluentable { }
extension UIRectEdge:   Fluentable { }
#endif
