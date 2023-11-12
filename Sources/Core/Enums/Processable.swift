public enum Processable <Initial, Processing, Completed, Failed: Error> {
  case initial(Initial)
  case processing(Processing)
  case completed(Completed)
  case failed(Failed)
}

public extension Processable {
  var name: String {
    switch self {
    case .initial:    return "inital"
    case .processing: return "processing"
    case .completed:  return "completed"
    case .failed:     return "failed"
    }
  }
}

public extension Processable {
  var initialValue: Initial?       { if case .initial(let value)    = self { return value } else { return nil } }
  var processingValue: Processing? { if case .processing(let value) = self { return value } else { return nil } }
  var completedValue: Completed?   { if case .completed(let value)  = self { return value } else { return nil } }
  var failedValue: Failed?         { if case .failed(let value)     = self { return value } else { return nil } }

  var isInitial: Bool    { if case .initial    = self { return true } else { return false } }
  var isProcessing: Bool { if case .processing = self { return true } else { return false } }
  var isCompleted: Bool  { if case .completed  = self { return true } else { return false } }
  var isFailed: Bool     { if case .failed     = self { return true } else { return false } }
}

public extension Processable {
  func mapInitialValue <NewInitial> (
    _ mapping: (Initial) -> NewInitial
  ) -> Processable<NewInitial, Processing, Completed, Failed> {
    switch self {
    case .initial(let v):    return .initial(mapping(v))
    case .processing(let v): return .processing(v)
    case .completed(let v):  return .completed(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func mapProcessingValue <NewProcessing> (
    _ mapping: (Processing) -> NewProcessing
  ) -> Processable<Initial, NewProcessing, Completed, Failed> {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(mapping(v))
    case .completed(let v):  return .completed(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func mapCompletedValue <NewCompleted> (
    _ mapping: (Completed) -> NewCompleted
  ) -> Processable<Initial, Processing, NewCompleted, Failed> {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(v)
    case .completed(let v):  return .completed(mapping(v))
    case .failed(let e):     return .failed(e)
    }
  }

  func mapFailedValue <NewFailed: Error> (
    _ mapping: (Failed) -> NewFailed
  ) -> Processable<Initial, Processing, Completed, NewFailed> {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(v)
    case .completed(let v):  return .completed(v)
    case .failed(let e):     return .failed(mapping(e))
    }
  }

  func replaceInitialValue <NewInitial> (
    with newInitial: NewInitial
  ) -> Processable<NewInitial, Processing, Completed, Failed> {
    mapInitialValue { _ in newInitial }
  }

  func replaceProcessingValue <NewProcessing> (
    with newProcessing: NewProcessing
  ) -> Processable<Initial, NewProcessing, Completed, Failed> {
    mapProcessingValue { _ in newProcessing }
  }

  func replaceCompletedValue <NewCompleted> (
    with newCompleted: NewCompleted
  ) -> Processable<Initial, Processing, NewCompleted, Failed> {
    mapCompletedValue { _ in newCompleted }
  }

  func replaceFailedValue <NewFailed: Error> (
    with newFailed: NewFailed
  ) -> Processable<Initial, Processing, Completed, NewFailed> {
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
    case .completed(let v):  return .completed(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func replaceProcessing (
    _ mapping: (Processing) -> Self
  ) -> Self {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return mapping(v)
    case .completed(let v):  return .completed(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func replaceCompleted (
    _ mapping: (Completed) -> Self
  ) -> Self {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(v)
    case .completed(let v):  return mapping(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func replaceFailed (
    _ mapping: (Failed) -> Self
  ) -> Self {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(v)
    case .completed(let v):  return .completed(v)
    case .failed(let e):     return mapping(e)
    }
  }

  func replaceInitial (with value: Self) -> Self {
    replaceInitial { _ in value }
  }

  func replaceProcessing (with value: Self) -> Self {
    replaceProcessing { _ in value }
  }

  func replaceCompleted (with value: Self) -> Self {
    replaceCompleted { _ in value }
  }

  func replaceFailed (with value: Self) -> Self {
    replaceFailed { _ in value }
  }
}

public extension Processable where Failed == Error {
  init (catching: () throws -> Completed) {
    do {
      self = try .completed(catching())
    } catch {
      self = .failed(error)
    }
  }

  init (asyncCatching: () async throws -> Completed) async {
    do {
      self = try await .completed(asyncCatching())
    } catch {
      self = .failed(error)
    }
  }
}

public extension Processable {
  var result: Result<Completed, Failed>? {
    switch self {
    case .initial: nil
    case .processing: nil
    case .completed(let completed): .success(completed)
    case .failed(let failed): .failure(failed)
    }
  }

  init (result: Result<Completed, Failed>) {
    switch result {
    case .success(let success):
      self = .completed(success)
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

public extension Processable where Completed == Void {
  static func completed () -> Self { .completed(Void()) }
}
