//
//  PrimeTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 10.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors

class TwinPrimeTester : PrimeTester {
	override func property() -> String {
		return "twin prime"
	}
	override func isSpecial(n: BigUInt) -> Bool {
		if !super.isSpecial(n: n) { return false }
		if super.isSpecial(n: n-2) { return true }
		if super.isSpecial(n: n+2) { return true }
		return false
	}
}

class CousinPrimeTester : PrimeTester {
	override func property() -> String {
		return "cousin prime"
	}
	override func isSpecial(n: BigUInt) -> Bool {
		if !super.isSpecial(n: n) { return false }
		if super.isSpecial(n: n+4) { return true }
		return false
	}
}

class SexyPrimeTester : PrimeTester {
	override func property() -> String {
		return "sexy prime"
	}
	override func isSpecial(n: BigUInt) -> Bool {
		if !super.isSpecial(n: n) { return false }
		if super.isSpecial(n: n+6) { return true }
		return false
	}
}
class SOGPrimeTester : PrimeTester {
	override func property() -> String {
		return "Sophie Germain prime"
	}
	override func isSpecial(n: BigUInt) -> Bool {
		if !super.isSpecial(n: n) { return false }
		if super.isSpecial(n: 2*n+1) { return true }
		return false
	}
}

class SafePrimeTester : PrimeTester {
	override func property() -> String {
		return "safe prime"
	}
	override func isSpecial(n: BigUInt) -> Bool {
		if !super.isSpecial(n: n) { return false }
		if super.isSpecial(n: (n-1)/2) { return true }
		return false
	}
}

class ProbablePrimeTester : NumTester {
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	func getLatex(n: BigUInt) -> String? {
		if n <= 2 { return nil }
		let latex = "2^{" + String(n-1) + "} \\equiv_{" + String(n) + "} 1 "
		return latex
	}
	
	var base = BigUInt(2)
	func property() -> String {
		return "Probable Prime"
	}
	func isSpecial(n: BigUInt) -> Bool {
		if n <= 2 { return false }
		let test = base.power(n-1, modulus: n)
		if 	test == 1 {
			return true
		}
		return false
	}
}

class CarmichaelTester : NumTester{
	func property() -> String {
		return "Carmichael"
	}
	func isSpecial(n: BigUInt) -> Bool {
		if n <= 2 { return false }
		if n % 2 == 0 { return false }
		if PrimeTester().isSpecial(n: n) { return false }
		let factors = FactorCache.shared.FactorsWithPot(n: n)
		for f in factors {
			if f.e > 1 { return false }
			if f.f % BigUInt(2) == 0 { return false }
			if (n - BigUInt(1)) % (f.f - BigUInt(1)) != 0 {
				return false
			}
		}
		return true
	}
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	func getLatex(n: BigUInt) -> String? {
		if n <= 2 { return nil }
		let latex = "\\forall b \\in \\mathbb{N} : b^{" + String(n-1) + "} \\equiv_{" + String(n) + "} 1 "
		return latex
	}
}

class CompositeTester : NumTester {
	func getLatex(n: BigUInt) -> String? {
		return FactorCache.shared.Latex(n: n, withpot: true)
	}
	func property() -> String {
		return "composite"
	}
	func isSpecial(n: BigUInt) -> Bool {
		if n <= 2 { return false }
		return !PrimeTester().isSpecial(n: n)
		
	}
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
}

class PrimeTester : NumTester {
	func property() -> String {
		return "prime"
	}
	func isSpecial(n: BigUInt) -> Bool {
		return PrimeCache.shared.IsPrime(p: n)
	}
	func invers() -> NumTester? {
		return CompositeTester()
	}	
	
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		var desc = WikiLinks.shared.getLink(tester: self, n: n)
		
		if n<2 { return nil }
		if n==2 { return desc + "2 is the one and only even prime" }
		
		if PrimeCache.shared.IsPrime(p: BigUInt(n+2)) {
			desc = desc + "\nIt is a " + WikiLinks.shared.Link(key: "twin prime") + "."
		} else if PrimeCache.shared.IsPrime(p: BigUInt(n-2)) {
			desc = desc + "\nIt is a " + WikiLinks.shared.Link(key: "twin prime") + "."
		}
		if PrimeCache.shared.IsPrime(p: BigUInt(n+4)) {
			desc = desc + "\nIt is a " + WikiLinks.shared.Link(key: "cousin prime") + "."
		}
		if PrimeCache.shared.IsPrime(p: BigUInt(n+6)) {
			desc = desc + "\nIt is a " + WikiLinks.shared.Link(key: "cousin prime") + "."
		}
		
		if PrimeCache.shared.IsPrime(p: BigUInt(2*n+1)) {
			desc = desc + "\nIt is a " + WikiLinks.shared.Link(key: "Sophie Germain prime") + "."
		}
		if PrimeCache.shared.IsPrime(p: BigUInt((n-1)/2)) {
			desc = desc + "\nIt is a " + WikiLinks.shared.Link(key: "safe prime") + "."
		}
		return desc
	}
	
	private func subset(type : Int) -> String {
		let difstr : String = (type > 0 ) ? "+" + String(type) : String(type)
		let latex = "\\in \\mathbb{P}_{" + String(type) + "}:= \\{ p \\in \\mathbb{P} : p" + difstr + "\\in \\mathbb{P} \\}"
		return latex
	}
	
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		if n<2 { return nil }
		//if n==2 { return "2 is the one and only even prime" }
		let nstr = String(n)
		if PrimeCache.shared.IsPrime(p: BigUInt(n+2)) {
			return nstr + subset(type:2)
		}
		if PrimeCache.shared.IsPrime(p: BigUInt(n-2)) {
			return nstr + subset(type:-2)
		}
		if PrimeCache.shared.IsPrime(p: BigUInt(n+4)) {
			return nstr + subset(type:4)
		}
		if PrimeCache.shared.IsPrime(p: BigUInt(n+6)) {
			return nstr + subset(type:6)
		}
		return nstr + "\\in \\mathbb{P} := \\{ p \\in \\mathbb{N} | \\forall q : q\\mid p \\rightarrow q=1 \\lor q=p \\}"
	}
}
