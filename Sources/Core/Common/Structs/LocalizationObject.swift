struct LocalizationObject<LocalizationKey> {
	let key: LocalizationKey
	let params: [String]
	
	init (_ key: LocalizationKey, _ params: [String] = []) {
		self.key = key
		self.params = params
	}
}
