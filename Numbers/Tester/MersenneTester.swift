//
//  MersenneTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 25.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors

class MersenneTester : NumTester {
	func getDesc(n: BigUInt) -> String? {
		let mdesc = WikiLinks.shared.Link(key: "Mersenne")
		let p = BigUInt(n)
		if PrimeCache.shared.IsPrime(p: p) {
			return String(n) + " is a " + mdesc + " prime"
		}
		let (_,pow) = getPow(n: n+1)
		if PrimeCache.shared.IsPrime(p: BigUInt(pow)) {
			return String(n) + " is a composite " + mdesc + " number"
		}
		return String(n) + " is a "  + mdesc + "  number"
	}
	
	private func getPow(n: BigUInt) -> (Bool,BigUInt) {
		if n == 0 { return (false,0) }
		if n == 1 { return (true,1) }
		var (nn,pow) = (n,BigUInt(0))
		while nn>1 {
			if nn % 2 == 1 { return (false,0) }
			nn = nn / 2
			pow = pow + 1
		}
		return (true,pow)
	}
	
	func getLatex(n: BigUInt) -> String? {
		if n == 0 { return nil }
		if n == 1 {
			return "1 = M_1 = 2^1 - 1 \\\\"
		}
		let (_,pow) = getPow(n: n+1)
		var latex = String(n) + "= 2^{" + String(pow) + "} - 1"
		if PrimeCache.shared.IsPrime(p: BigUInt(n)) {
			latex = latex + " = M_{" + String(pow) + "} \\in \\mathbb{P}"
		} else if PrimeCache.shared.IsPrime(p: BigUInt(pow)) {
			latex = latex + " = M_{" + String(pow) + "} \\notin \\mathbb{P}"
		}
		return latex
	}
	
	func property() -> String {
		return "Mersenne"
	}
	
	func isSpecial(n: BigUInt) -> Bool {
		if n == 1 { return true }
		if n <= 2 { return false }
		var nn = n+1
		while nn>1 {
			if nn % 2 != 0 {
				return false
			}
			nn = nn / 2
		}
		return true
	}
	func recordLatex() -> String? {
		return "2^{77232917}-1 - \\text{Mersenne prime}(2018)"
	}
	
	func subtester() -> [NumTester]? {
		return [RamanujanNagellTester()]
	}
}

class ProthTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		let (k,_,nn) = getpart(n: n)
		if k < nn { return true }
		return false
	}
	
	func getDesc(n: BigUInt) -> String? {
		let pdesc = WikiLinks.shared.Link(key: self.property())
		if PrimeCache.shared.IsPrime(p: BigUInt(n)) {
			return String(n) + " is a " + pdesc + " prime"
		}
		return String(n) + " is a " + pdesc + " number"
	}
	
	func getLatex(n: BigUInt) -> String? {
		
		let (k,pot2,_) = getpart(n: n)
		var latex = String(n) + "= " + String(k) + "\\cdot { 2^{" + String(pot2) + "}} + 1"
		if PrimeCache.shared.IsPrime(p: BigUInt(n)) {
			latex = latex + "\\in \\mathbb{P}"
		}
		return latex
	}
	
	func property() -> String {
		return "Proth"
	}
	
	private func getpart(n: BigUInt) -> (k: BigUInt, pot2: BigUInt,nn : BigUInt)
	{
		if n <= 2 { return (0,0,0) }
		if n == 3 { return (1,1,2) }
		var k = n - 1
		var pot2 : BigUInt = 0
		while k % 2 == 0 {
			k = k / 2
			pot2 = pot2 + 1
		}
		let nn = (n-1) / k
		return (k: k, pot2: pot2, nn: nn)
	}
	/*
	func recordLatex() -> String? {
		return "10223*2^{31172165}+1 - \\text{Proth prime}"
	}
	*/
}

class SierpinskiTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		if oeis.contains(n) {
			return true
		}
		return false
	}
	
	func getDesc(n: BigUInt) -> String? {
		let desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	
	func getLatex(n: BigUInt) -> String? {
		let latex =  "\\forall n : " + String(n) + "\\cdot{2^n} +1 \\notin \\mathbb{P}  "
		return latex
	}
	
	func property() -> String {
		return "Sierpinski"
	}
	
	private let oeis : [BigUInt] = [78557,271129,271577,322523,327739,482719,575041,
								603713,903983,934909,965431,1259779,1290677,
								1518781,1624097,1639459,1777613,2131043,2131099,
								2191531,2510177,2541601,2576089,2931767,2931991,
								3083723,3098059,3555593,3608251]
	
}

class TitanicTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		let special = OEIS.shared.ContainsNumber(key: property(), n: n)
		return special
	}
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let latex = "10^{999} + " + String(n) + "\\in \\mathbb{P}"
		return latex
	}
	func property() -> String {
		return "titanic"
	}
}

