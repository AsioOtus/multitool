import Foundation

public protocol HTTPURLResponseStringConverter {
    func convert (_ httpUrlResponse: HTTPURLResponse, body: Data?) -> String
}
