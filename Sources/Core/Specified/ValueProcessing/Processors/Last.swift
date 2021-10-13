extension Last {
	struct Result: MultipleResultProtocol {
		let results: [ProcessingResult<Value, Failure>]
		let summaryResult: SingleResult<Value, Failure>
		
		init (_ results: [ProcessingResult<Value, Failure>], _ value: Value, _ label: String? = nil) {
			self.results = results
			self.summaryResult = {
				guard !results.isEmpty else { return .init(.success(value), Last.name) }
				
				if let lastSuccessResult = results.last(where: {
					if case .success = $0.summaryResult.category { return true }
					else { return false }
				}) {
					return .init(lastSuccessResult.summaryResult.category, Last.name, lastSuccessResult.summaryResult.label)
				} else {
					return .init(.failure(), Last.name)
				}
			}()
		}
	}
}

struct Last <Value, Failure>: ProcessorProtocol {
	static var name: String { "last" }
	
	let failure: Failure?
	
	let processors: [AnyProcessor<Value, Failure>]
	
	init (failure: Failure? = nil, _ processors: [AnyProcessor<Value, Failure>]) {
		self.failure = failure
		self.processors = processors
	}
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		var results = [ProcessingResult<Value, Failure>]()
		
		var value = value
		for processor in processors {
			let result = processor.process(value)
			results.append(result)
			
			guard case .success(let processedValue) = result.summaryResult.category else { continue }
			value = processedValue
		}
		
		return .multiple(Result(results, value).eraseToAnyMultipleResult())
	}
}

extension AnyProcessor {
	static func last (_ processors: [Self]) -> Self {
		Last(processors).eraseToAnyProcessor()
	}
	
	static func last (@ArrayBuilder _ processors: () -> ([Self])) -> Self {
		Last(processors()).eraseToAnyProcessor()
	}
}

