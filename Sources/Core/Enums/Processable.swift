public enum Processable <Initial, Processing, Successful, Failed: Error> {
	case initial(Initial)
	case processing(Processing)
	case successful(Successful)
	case failed(Failed)
}

public extension Processable {
	var debugName: String {
		switch self {
		case .initial:    "inital"
		case .processing: "processing"
		case .successful: "successful"
		case .failed:     "failed"
		}
	}
}

public extension Processable {
	var initialValue: Initial?       { if case .initial(let value)    = self { value } else { nil } }
	var processingValue: Processing? { if case .processing(let value) = self { value } else { nil } }
	var successfulValue: Successful? { if case .successful(let value) = self { value } else { nil } }
	var failedValue: Failed?         { if case .failed(let value)     = self { value } else { nil } }

	var isInitial: Bool    { if case .initial    = self { true } else { false } }
	var isProcessing: Bool { if case .processing = self { true } else { false } }
	var isSuccessful: Bool { if case .successful = self { true } else { false } }
	var isFailed: Bool     { if case .failed     = self { true } else { false } }
}

public extension Processable {
	func mapInitialValue <NewInitial> (
		_ mapping: (Initial) -> NewInitial
	) -> Processable<NewInitial, Processing, Successful, Failed> {
		switch self {
		case .initial(let v):    .initial(mapping(v))
		case .processing(let v): .processing(v)
		case .successful(let v): .successful(v)
		case .failed(let e):     .failed(e)
		}
	}

	func mapProcessingValue <NewProcessing> (
		_ mapping: (Processing) -> NewProcessing
	) -> Processable<Initial, NewProcessing, Successful, Failed> {
		switch self {
		case .initial(let v):    .initial(v)
		case .processing(let v): .processing(mapping(v))
		case .successful(let v): .successful(v)
		case .failed(let e):     .failed(e)
		}
	}

	func mapSuccessfulValue <NewSuccessful> (
		_ mapping: (Successful) -> NewSuccessful
	) -> Processable<Initial, Processing, NewSuccessful, Failed> {
		switch self {
		case .initial(let v):    .initial(v)
		case .processing(let v): .processing(v)
		case .successful(let v): .successful(mapping(v))
		case .failed(let e):     .failed(e)
		}
	}

	func mapFailedValue <NewFailed: Error> (
		_ mapping: (Failed) -> NewFailed
	) -> Processable<Initial, Processing, Successful, NewFailed> {
		switch self {
		case .initial(let v):    .initial(v)
		case .processing(let v): .processing(v)
		case .successful(let v): .successful(v)
		case .failed(let e):     .failed(mapping(e))
		}
	}
}

public extension Processable {
	func replaceInitialValue <NewInitial> (
		with newInitial: NewInitial
	) -> Processable<NewInitial, Processing, Successful, Failed> {
		mapInitialValue { _ in newInitial }
	}

	func replaceProcessingValue <NewProcessing> (
		with newProcessing: NewProcessing
	) -> Processable<Initial, NewProcessing, Successful, Failed> {
		mapProcessingValue { _ in newProcessing }
	}

	func replaceSuccessfulValue <NewSuccessful> (
		with newSuccessful: NewSuccessful
	) -> Processable<Initial, Processing, NewSuccessful, Failed> {
		mapSuccessfulValue { _ in newSuccessful }
	}

	func replaceFailedValue <NewFailed: Error> (
		with newFailed: NewFailed
	) -> Processable<Initial, Processing, Successful, NewFailed> {
		mapFailedValue { _ in newFailed }
	}
}

public extension Processable {
	func replaceInitial (
		_ mapping: (Initial) -> Self
	) -> Self {
		switch self {
		case .initial(let v):    mapping(v)
		case .processing(let v): .processing(v)
		case .successful(let v): .successful(v)
		case .failed(let e):     .failed(e)
		}
	}

	func replaceProcessing (
		_ mapping: (Processing) -> Self
	) -> Self {
		switch self {
		case .initial(let v):    .initial(v)
		case .processing(let v): mapping(v)
		case .successful(let v): .successful(v)
		case .failed(let e):     .failed(e)
		}
	}

	func replaceSuccessful (
		_ mapping: (Successful) -> Self
	) -> Self {
		switch self {
		case .initial(let v):    .initial(v)
		case .processing(let v): .processing(v)
		case .successful(let v): mapping(v)
		case .failed(let e):     .failed(e)
		}
	}

	func replaceFailed (
		_ mapping: (Failed) -> Self
	) -> Self {
		switch self {
		case .initial(let v):    .initial(v)
		case .processing(let v): .processing(v)
		case .successful(let v): .successful(v)
		case .failed(let e):     mapping(e)
		}
	}
}

public extension Processable {
	func replaceInitial (with value: Self) -> Self {
		replaceInitial { _ in value }
	}

	func replaceProcessing (with value: Self) -> Self {
		replaceProcessing { _ in value }
	}

	func replaceSuccessful (with value: Self) -> Self {
		replaceSuccessful { _ in value }
	}

	func replaceFailed (with value: Self) -> Self {
		replaceFailed { _ in value }
	}
}

public extension Processable where Failed == Error {
	func tryMapInitialValue <NewInitial> (
		_ mapping: (Initial) throws -> NewInitial
	) -> Processable<NewInitial, Processing, Successful, Failed> {
		do {
			return switch self {
			case .initial(let v):    .initial(try mapping(v))
			case .processing(let v): .processing(v)
			case .successful(let v): .successful(v)
			case .failed(let e):     .failed(e)
			}
		} catch {
			return .failed(error)
		}
	}

	func tryMapProcessingValue <NewProcessing> (
		_ mapping: (Processing) throws -> NewProcessing
	) -> Processable<Initial, NewProcessing, Successful, Failed> {
		do {
			return switch self {
			case .initial(let v):    .initial(v)
			case .processing(let v): .processing(try mapping(v))
			case .successful(let v): .successful(v)
			case .failed(let e):     .failed(e)
			}
		} catch {
			return .failed(error)
		}
	}

	func tryMapSuccessfulValue <NewSuccessful> (
		_ mapping: (Successful) throws -> NewSuccessful
	) -> Processable<Initial, Processing, NewSuccessful, Failed> {
		do {
			return switch self {
			case .initial(let v):    .initial(v)
			case .processing(let v): .processing(v)
			case .successful(let v): .successful(try mapping(v))
			case .failed(let e):     .failed(e)
			}
		} catch {
			return .failed(error)
		}
	}
}

public extension Processable where Failed == Error {
	init (catching: () throws -> Successful) {
		do {
			self = try .successful(catching())
		} catch {
			self = .failed(error)
		}
	}

	init (asyncCatching: () async throws -> Successful) async {
		do {
			self = try await .successful(asyncCatching())
		} catch {
			self = .failed(error)
		}
	}
}

public extension Processable {
	var result: Result<Successful, Failed>? {
		switch self {
		case .initial: nil
		case .processing: nil
		case .successful(let successful): .success(successful)
		case .failed(let failed): .failure(failed)
		}
	}

	init (result: Result<Successful, Failed>) {
		switch result {
		case .success(let success):
			self = .successful(success)
		case .failure(let failure):
			self = .failed(failure)
		}
	}
}

public extension Processable where Initial == Void {
	init () { self = .initial() }

	static func initial () -> Self { .initial(Void()) }
}

public extension Processable where Processing == Void {
	static func processing () -> Self { .processing(Void()) }
}

public extension Processable where Successful == Void {
	static func successful () -> Self { .successful(Void()) }
}
