public struct MultiLanguageString {
  public let translations: [String: String]
  public let `default`: String?

  public init (translations: [String: String], default: String? = nil) {
    self.translations = translations
    self.default = `default`
  }

  public init () {
    self.init(translations: [:])
  }

  public func translation (for language: String) -> String? {
    translations[language] ?? self.default
  }

  public func translation (for language: String, default: String) -> String {
    translations[language] ?? `default`
  }
}
