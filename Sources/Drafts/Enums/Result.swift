import Foundation

#if swift(<5.0)

public enum Result<Success, Failure> {
	case success(Success)
	case failure(Failure)
}

#endif
