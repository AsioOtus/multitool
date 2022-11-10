import Combine
import Foundation



public extension Source {
	static let general: Self = "general"
}




let s: Source = ["3", "4"]
let s1: Source = "1.2"
print(s.string)
print(s1.string)

print(s1.add(s).string)
