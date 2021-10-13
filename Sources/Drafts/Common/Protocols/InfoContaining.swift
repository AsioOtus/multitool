public protocol InfoContaining {
	associatedtype Info
	
	var info: Info { get }
}
