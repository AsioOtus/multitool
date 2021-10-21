enum GeneralDisplayableError: Error {
	case terminal(TerminalError)
	case communication(CommunicationError)
}

enum TerminalError: Error {
	case internal
	case critical
	case fatal
	case unresolved
	case unresolvable
	case unexpected
	case unknown
}

enum CommunicationError: Error {
	case unknownApiResponse
}
