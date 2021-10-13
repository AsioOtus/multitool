infix operator +- : AdditionPrecedence
infix operator -+ : AdditionPrecedence
infix operator ** : ExponentiationPrecedence

precedencegroup ExponentiationPrecedence {
	higherThan: MultiplicationPrecedence
	associativity: right
}
