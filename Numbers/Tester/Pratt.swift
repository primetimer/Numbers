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


class PrattTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		let pratt = PrattCertficate(nr: n)
		return pratt.PrattTest()
	}
	
	func getLatex(n: BigUInt) -> String? {
		let pratt = PrattCertficate(nr: n)
		return pratt.LatexGeneralInfo()
	}
	
	func property() -> String {
		return "pratt"
	}
	
}

class PrattCertficate  {
	
	private (set) var nr: BigUInt!
	private var factors : [FactorWithPot] = []
	init(nr: BigUInt) {
		self.nr = nr
		self.factors = FactorCache.shared.FactorsWithPot(n: nr-1)
	}
	
	func PrattTest() -> Bool {
		if nr < 2 { return false }
		if nr <= 3 { return true  }
		let p = nr - 1
		let a = PrimitiveRoot(n: nr)
		let fermat = a.power(p, modulus: nr)
		if fermat != 1 { return false }
		for f in factors {
			let m = a.power(p / f.f / 2, modulus: nr)
			if m == 1 { return false }
		}
		return true
	}
	
	func PrimitiveRoot(n: BigUInt) -> BigUInt {
		if n <= 2 { return 1 }
		var a = BigUInt(2)
		let p = n - 1
		
		while  true {
			var allunequal1 = true
			for f in factors {
				let test = a.power(p / f.f, modulus: n)
				if test == 1 {
					allunequal1 = false
					break
				}
			}
			
			if allunequal1 {
				return a
			}
			a = a + 1
		}
	}
	
	private func witnesslatex(witness : BigUInt,p : BigUInt, mod : BigUInt) -> String {
		var ans = String(witness)
		ans = ans + "^{" + String(p) + "} = "
		let m = witness.power(p / witness, modulus: mod)
		ans = ans + String(m) + "} mod"
		ans = ans + String(p)
		return ans
	}
	
	func LatexGeneralInfo() -> String {
		var ans = "\\exists a : a^{n-1} \\equiv 1 \\text{ mod } n, \\\\"
		ans = ans + "\\forall q | (p-1) : a^{\\frac{n-1}{q}} \\neq 1 \\text{ mod } n,\\\\"
		ans = ans + "\\Rightarrow n \\in \\mathbb{P} \\\\ "
		return ans
		
	}
	
	
	
	func LatexCertfificate() -> [String] {
		
		let errtext = "\\text{ contradiction } "
		if nr % 2 == 0 && nr > 2 {
			let err = String(nr) + "\\text{ is divisible by 2} " + errtext
			return [err]
		}
		
		var ans : [String] = [] //["\\text{ Pratt certificate }"]
		if nr <= 1 {
			assert(false)
			let str = "\\text{not prime}"
			return [str]
		}
		if nr == 2 {
			let str = "\\text{2 is prime (self-evident)}"
			return [str]
		}
		if nr == 3 {
			let str = "\\text{3 is prime (self-evident)}"
			return [str]
		}
		
		let p = nr - 1
		//let factors = FactorCache.shared.FactorsWithPot(n: p)
		var platex = String(nr) + " - 1 = "
		if let factorlatex = FactorCache.shared.Latex(n: p, withpot: true) {
			platex = platex + factorlatex
		}
		
		ans.append(platex)
		let a = PrimitiveRoot(n: nr)
		do {
			let info = "\\text{certificate for n = }" + String(nr)
			let witnesslatex = info + "\\text{ witness } a = " + String(a)
			ans.append(witnesslatex)
		}
		
		do {
			let m = a.power(p, modulus: nr)
			var witnesslatex = String(a)
			witnesslatex = witnesslatex + "^{" + String(p) + "} \\equiv " + String(m) + "\\text{ mod }" + String(nr)
			if m != 1 { witnesslatex = witnesslatex + errtext }
			ans.append(witnesslatex)
		}
		for f in factors {
			let m = a.power(p / f.f / 2, modulus: nr)
			var witnesslatex = String(a) + "^{\\frac{" + String(p) + "}{" + String(f.f) + "}} \\equiv " + String(m) + "(\\neq 1) \\text{ mod }" + String(nr)
			if m == 1 { witnesslatex = witnesslatex + errtext }
			ans.append(witnesslatex)
		}
		
		for f in factors {
			let subpratt = PrattCertficate(nr: f.f)
			let subcert = subpratt.LatexCertfificate()
			for s in subcert {
				ans.append(":" + s)
			}
		}
		return ans
	}
}
