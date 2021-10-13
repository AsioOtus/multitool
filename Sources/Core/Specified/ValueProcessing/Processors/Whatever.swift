extension Whatever {
	struct Result: MultipleResultProtocol {
		let results: [ProcessingResult<Value, Failure>]
		let summaryResult: SingleResult<Value, Failure>
		
		init (_ results: [ProcessingResult<Value, Failure>], _ value: Value) {
			self.results = results
			self.summaryResult = {
				return .init(.success(value), Whatever.name)
			}()
		}
	}
}

struct Whatever <Value, Failure>: ProcessorProtocol {
	static var name: String { "whatever" }
	
	let processors: [AnyProcessor<Value, Failure>]
	
	init (_ processors: [AnyProcessor<Value, Failure>]) {
		self.processors = processors
	}
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		var results = [ProcessingResult<Value, Failure>]()
		
		var value = value
		for processor in processors {
			let result = processor.process(value)
			results.append(result)
			
			if case .success(let processedValue) = result.summaryResult.category {
				value = processedValue
			}
		}
		
		return .multiple(Result(results, value).eraseToAnyMultipleResult())
	}
}

extension AnyProcessor {
	static func whatever (_ processors: [Self]) -> Self {
		Whatever(processors).eraseToAnyProcessor()
	}
	
	static func whatever (@ArrayBuilder _ processors: () -> ([Self])) -> Self {
		Whatever(processors()).eraseToAnyProcessor()
	}
}
