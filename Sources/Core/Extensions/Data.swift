import Foundation

public extension Data {
  init? (hex: String) {
    guard !hex.isHex else { return nil }

    let bytes = hex
      .divide(fromEndBy: 2)
      .map { UInt8($0, radix: 16) }
      .compactMap{ $0 }

    self.init(bytes)
  }
}

public extension Data {
  var bin: String { map { .init($0, radix: 2)   .padded(atStartTo: 8, with: "0") }.joined(separator: " ") }
  var oct: String { map { .init($0, radix: 8)   .padded(atStartTo: 3, with: "0") }.joined(separator: " ") }
  var dec: String { map { .init($0, radix: 10) }.joined(separator: " ") }
  var hex: String { map { .init($0, radix: 16)  .padded(atStartTo: 2, with: "0") }.joined(separator: " ") }

  var plainBin: String { map { .init($0, radix: 2)   .padded(atStartTo: 8, with: "0") }.joined() }
  var plainOct: String { map { .init($0, radix: 8)   .padded(atStartTo: 3, with: "0") }.joined() }
  var plainDec: String { map { .init($0, radix: 10) }.joined() }
  var plainHex: String { map { .init($0, radix: 16)  .padded(atStartTo: 2, with: "0") }.joined() }

  var prefixedBin: String { map { String($0, radix: 2)   .padded(atStartTo: 8, with: "0") }.map{ "0b\($0)" }.joined(separator: " ") }
  var prefixedOct: String { map { String($0, radix: 8)   .padded(atStartTo: 3, with: "0") }.map{ "0o\($0)" }.joined(separator: " ") }
  var prefixedDec: String { map { String($0, radix: 10) }.map{ "0d\($0)" }.joined(separator: " ") }
  var prefixedHex: String { map { String($0, radix: 16)  .padded(atStartTo: 2, with: "0") }.map{ "0x\($0)" }.joined(separator: " ") }
}
