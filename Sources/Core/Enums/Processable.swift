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
  func mapInitial <NewInitial> (
    _ mapping: (Initial) -> NewInitial
  ) -> Processable<NewInitial, Processing, Completed, Failed> {
    switch self {
    case .initial(let v):    return .initial(mapping(v))
    case .processing(let v): return .processing(v)
    case .completed(let v):  return .completed(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func mapProcessing <NewProcessing> (
    _ mapping: (Processing) -> NewProcessing
  ) -> Processable<Initial, NewProcessing, Completed, Failed> {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(mapping(v))
    case .completed(let v):  return .completed(v)
    case .failed(let e):     return .failed(e)
    }
  }

  func mapCompleted <NewCompleted> (
    _ mapping: (Completed) -> NewCompleted
  ) -> Processable<Initial, Processing, NewCompleted, Failed> {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(v)
    case .completed(let v):  return .completed(mapping(v))
    case .failed(let e):     return .failed(e)
    }
  }

  func mapFailed <NewFailed: Error> (
    _ mapping: (Failed) -> NewFailed
  ) -> Processable<Initial, Processing, Completed, NewFailed> {
    switch self {
    case .initial(let v):    return .initial(v)
    case .processing(let v): return .processing(v)
    case .completed(let v):  return .completed(v)
    case .failed(let e):     return .failed(mapping(e))
    }
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
}

public extension Processable {
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

public extension Processable {
  var result: Result<Completed, Failed>? {
    switch self {
    case .initial: nil
    case .processing: nil
    case .completed(let completed): .success(completed)
    case .failed(let failed): .failure(failed)
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
