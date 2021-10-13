protocol LocalizableObject {
	associatedtype LocalizationKey
	
	var localizationKey: LocalizationKey { get }
	var parameters: [String] { get }
}
