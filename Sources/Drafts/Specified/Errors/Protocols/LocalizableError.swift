public protocol LocalizableError: Error {
	associatedtype LocalizationKey
	
	var localizationKey: LocalizationKey { get }
}
