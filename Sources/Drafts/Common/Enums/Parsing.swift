extension Parsing {
	enum Result<Failure> {
		case or([Self])
		case any([Self])
		case last([Self])
		case and([Self])
		case all([Self])
		
		case failure(Failure?)
		case success(Value)
		
		var isSuccess: Bool {
			let isSuccess: Bool
			
			switch self {
			case .or(let parsingResults):
				isSuccess = parsingResults.contains{ $0.isSuccess }
			case .any(let parsingResults):
				isSuccess = parsingResults.contains{ $0.isSuccess }
			case .last(let parsingResults):
				isSuccess = parsingResults.contains{ $0.isSuccess }
			case .and(let parsingResults):
				isSuccess = parsingResults.allSatisfy{ $0.isSuccess }
			case .all(let parsingResults):
				isSuccess = parsingResults.allSatisfy{ $0.isSuccess }
				
			case .failure:
				isSuccess = false
			case .success:
				isSuccess = true
			}
			
			return isSuccess
		}
		
		var value: Value? {
			if case .success(let value) = self {
				return value
			} else {
				return nil
			}
		}
	}
}



enum Parsing<Value, Failure> {
	case rule((Value) -> (isSuccess: Bool, value: Value?), Failure? = nil)
	case inner((Value) -> Result<Failure>)
	
	case or([Self])
	case any([Self])
	case last([Self])
	case and([Self])
	case all([Self])
	
	indirect case not(Self, Failure? = nil)
	indirect case `if`((Value) -> Bool, Self)
	indirect case transform((Value) -> Value, Self)
	
	case value(Value)
	
	case success
	case failure(Failure? = nil)
	
	func parse (_ value: Value) -> (Result<Failure>) {
		let parsingResult: Result<Failure>
		
		switch self {
		case .rule(let rule, let failure):
			let ruleResult = rule(value)
			
			if ruleResult.isSuccess {
				if let ruleResultValue = ruleResult.value {
					parsingResult = .success(ruleResultValue)
				} else {
					parsingResult = .success(value)
				}
			} else {
				parsingResult = .failure(failure)
			}
			
		case .inner(let rule):
			parsingResult = rule(value)
			
			
			
		case .or(let parsings):
			var parsingResults = [Result<Failure>]()
			
			for parsing in parsings {
				let parsingResult = parsing.parse(value)
				parsingResults.append(parsingResult)
				
				guard !parsingResult.isSuccess else { break }
			}
			
			parsingResult = .or(parsingResults)
			
		case .any(let parsings):
			var parsingResults = [Result<Failure>]()
			
			for parsing in parsings {
				let parsingResult = parsing.parse(value)
				parsingResults.append(parsingResult)
			}
			
			parsingResult = .any(parsingResults)
			
		case .last(let parsings):
			var parsingResults = [Result<Failure>]()
			
			var value = value
			for parsing in parsings {
				let parsingResult = parsing.parse(value)
				parsingResults.append(parsingResult)
				
				guard let parsingResultValue = parsingResult.value else { break }
				value = parsingResultValue
			}
			
			parsingResult = .last(parsingResults)
			
		case .and(let parsings):
			var parsingResults = [Result<Failure>]()
			
			var value = value
			for parsing in parsings {
				let parsingResult = parsing.parse(value)
				parsingResults.append(parsingResult)
				
				guard parsingResult.isSuccess, let parsingResultValue = parsingResult.value else { break }
				value = parsingResultValue
			}
			
			parsingResult = .and(parsingResults)
			
		case .all(let parsings):
			var parsingResults = [Result<Failure>]()
			
			var value = value
			for parsing in parsings {
				let parsingResult = parsing.parse(value)
				parsingResults.append(parsingResult)
				
				guard let parsingResultValue = parsingResult.value else { break }
				value = parsingResultValue
			}
			
			parsingResult = .all(parsingResults)
			
			
			
		case .not(let parsing, let failure):
			parsingResult = parsing.parse(value).isSuccess ? .failure(failure) : .success(value)
			
		case .if(let condition, let parsing):
			parsingResult = condition(value) ? parsing.parse(value) : .success(value)
			
		case .transform(let transformation, let parsing):
			parsingResult = parsing.parse(transformation(value))
			
			
			
		case .value(let value):
			parsingResult = .success(value)
			
			
			
		case .success:
			parsingResult = .success(value)
			
		case .failure(let failure):
			parsingResult = .failure(failure)
		}
		
		return parsingResult
	}
}



struct ParsingContainer<Value, ResultValue> {
	let original: Value
	var current: Value
	var result: ResultValue
	
	init (original: Value, result: ResultValue) {
		self.original = original
		self.current = original
		self.result = result
	}
}
