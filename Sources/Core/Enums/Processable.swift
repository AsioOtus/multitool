@dynamicMemberLookup
public enum Processable <Initial, Processing, Successful, Failed: Error> {
  case initial(Initial)
  case processing(Processing)
  case successful(Successful)
  case failed(Failed)

	public subscript (dynamicMember _: String) -> Void { Void() }
}

public extension Processable {
  var debugName: String {
    switch self {
    case .initial:    return "inital"
    case .processing: return "processing"
    case .successful: return "successful"
    case .failed:     return "failed"
    }
  }
}

public extension Processable {
  var initialValue: Initial?       { if case .initial(let value)    = self { return value } else { return nil } }
  var processingValue: Processing? { if case .processing(let value) = self { return value } else { return nil } }
  var successfulValue: Successful? { if case .successful(let value)  = self { return value } else { return nil } }
  var failedValue: Failed?         { if case .failed(let value)     = self { return value } else { return nil } }

  var isInitial: Bool    { if case .initial    = self { return true } else { return false } }
  var isProcessing: Bool { if case .processing = self { return true } else { return false } }
  var isSuccessful: Bool { if case .successful  = self { return true } else { return false } }
  var isFailed: Bool     { if case .failed     = self { return true } else { return false } }
}

public extension Processable {
  func mapInitialValue <NewInitial> (
    _ mapping: (Initial) -> NewInitial
  ) -> Processable<NewInitial, Processing, Successful, Failed> {
    switch self {
    case .initial(let v):    return .initial(mapping(v))
    case .processing(let v): return .processing(v)
    case .successful(let v): return .successful(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func mapProcessingValue <NewProcessing> (
    _ mapping: (Processing) -> NewProcessing
  ) -> Processable<Initial, NewProcessing, Successful, Failed> {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(mapping(v))
    case .successful(let v): return .successful(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func mapSuccessfulValue <NewSuccessful> (
    _ mapping: (Successful) -> NewSuccessful
  ) -> Processable<Initial, Processing, NewSuccessful, Failed> {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(v)
    case .successful(let v): return .successful(mapping(v))
    case .failed(let e):     return .failed(e)
    }
  }

  func mapFailedValue <NewFailed: Error> (
    _ mapping: (Failed) -> NewFailed
  ) -> Processable<Initial, Processing, Successful, NewFailed> {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(v)
    case .successful(let v): return .successful(v)
    case .failed(let e):     return .failed(mapping(e))
    }
  }

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
    case .initial(let v):    return mapping(v)
    case .processing(let v): return .processing(v)
    case .successful(let v): return .successful(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func replaceProcessing (
    _ mapping: (Processing) -> Self
  ) -> Self {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return mapping(v)
    case .successful(let v): return .successful(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func replaceSuccessful (
    _ mapping: (Successful) -> Self
  ) -> Self {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(v)
    case .successful(let v): return mapping(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func replaceFailed (
    _ mapping: (Failed) -> Self
  ) -> Self {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(v)
    case .successful(let v): return .successful(v)
    case .failed(let e):     return mapping(e)
    }
  }

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
