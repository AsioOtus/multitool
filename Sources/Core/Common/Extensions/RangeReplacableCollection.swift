public extension RangeReplaceableCollection {
	func split (chunkSize: Int) -> [Self] {
		guard chunkSize > 0 else { return [] }
		guard chunkSize <= count else { return [self] }
		
		var currentIndex = startIndex
		var splitIndices = [(Index, Index)]()
		
		
		while let nextIndex = self.index(currentIndex, offsetBy: chunkSize - 1, limitedBy: endIndex) {
			splitIndices.append((currentIndex, nextIndex))
			currentIndex = self.index(after: nextIndex)
		}
		
		if currentIndex != endIndex {
			splitIndices.append((currentIndex, self.index(endIndex, offsetBy: -1)))
		}
		
		return splitIndices.map{ Self(self[$0...$1]) }
	}
}

public extension RangeReplaceableCollection {
	func padded (atStartTo length: Int, with padSequence: Self, cutPaddingFromStart: Bool = true) -> Self {
		padding(length, padSequence, cutPaddingFromStart: cutPaddingFromStart) + self
	}
	
	func padded (atEndTo length: Int, with padSequence: Self, cutPaddingFromEnd: Bool = true) -> Self {
		self + padding(length, padSequence, cutPaddingFromStart: !cutPaddingFromEnd)
	}
	
	private func padding (_ length: Int, _ padSequence: Self, cutPaddingFromStart: Bool) -> Self {
		guard count < length else { return Self() }
		
		let difference = length - count
		let rawPaddingLength = Int((Double(difference) / Double(padSequence.count)).rounded(.up))
		let rawPadding = (0..<rawPaddingLength).reduce(Self()) { result, _ in result + padSequence}
		
		let padding = cutPaddingFromStart
			? Self(rawPadding.suffix(difference))
			: Self(rawPadding.prefix(difference))
		
		return padding
	}
}
