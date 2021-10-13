public struct LocalizedError<LocalizationKey>: LocalizableError {
	public let localizationKey: LocalizationKey
	
	public init (_ localizationKey: LocalizationKey) {
		self.localizationKey = localizationKey
	}
}
