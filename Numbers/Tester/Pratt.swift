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

typealias LatexString = String
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
		
		repeat {
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
		} while a < n
		return 1
	}
	
	private func witnesslatex(witness : BigUInt,p : BigUInt, mod : BigUInt) -> LatexString {
		var ans = String(witness)
		ans = ans + "^{" + String(p) + "} = "
		let m = witness.power(p / witness, modulus: mod)
		ans = ans + String(m) + "} mod"
		ans = ans + String(p)
		return ans
	}
	
	/*
	func LatexGeneralInfo() -> LatexString {
		var ans = "\\exists a : a^{n-1} \\equiv 1 \\text{ mod } n, \\\\"
		ans = ans + "\\forall q | (n-1) : a^{\\frac{n-1}{q}} \\neq 1 \\text{ mod } n,\\\\"
		ans = ans + "\\Rightarrow n \\in \\mathbb{P} \\\\ "
		return ans
		
	}
	*/
	
	func LatexGeneralInfo() -> LatexString {
		var ans = "n \\in \\mathbb{P}  \\Leftrightarrow \\exists a < n : \\\\"
		ans = ans + "\\quad1: a^{n-1} \\equiv 1 \\text{ mod } n, \\\\"
		ans = ans + "\\quad2:\\forall q \\in \\mathbb{P}, q | (n-1) : a^{\\frac{n-1}{q}} \\neq 1 \\text{ mod } n \\\\"
		return ans
		
	}
	
	func LatexCertificate() -> [LatexString] {
		if PrimeCache.shared.IsPrime(p: nr) {
			return LatexPrimeCertfificate()
		}
		else {
			return LatexCompositeCertificate()
		}
	}
	
	private func LatexCompositeCertificate() -> [LatexString] {
		
		let errtext = "\\text{ guilty } "
		if nr <= 1 {
			let err = String(nr) + "\\text{ not in definition range } "
			return [err]
		}
		if nr <= 3 {
			let err = String(nr) + "\\text{ is self-evident prime } "
			return [err]
		}
		if nr % 2 == 0 {
			let latex = String(nr) + "\\text{ is divisble by 2 }"
			let reason = "\\text{(last digit is in [0,2,4,6,8])}"
			return [latex,reason]
		}
		/*
		if nr % 3 == 0 {
			let latex = String(nr) + "\\text{ is divisble by 3 }"
			let reason = "\\text {(crosssum is divisble by 3)}"
			return [latex,reason]
		}
		if nr % 5 == 0 {
			let latex = String(nr) + "\\text{ is divisble by 5 }"
			let reason = "\\text {because last digit is in [0,2,4,6,8] }"
			return [latex,reason]
		}
		if nr % 11 == 0 {
			let latex = String(nr) + "\\text{ is divisble by 11 }"
			let reason = "\\text {because alternating cross sum is divisible by 11 }"
			return [latex,reason]
		}
		*/

		//Spannender Teil
		var ans : [LatexString] = []
		let p = nr - 1
		
		
		let a = PrimitiveRoot(n: nr)
		do {
			let info = "\\text{certificate for n = }" + String(nr)
			let witnesslatex = info + "\\text{ witness } a = " + String(a)
			ans.append(witnesslatex)
		}
		
		let m = a.power(p, modulus: nr)
		if m != 1 {
			let m = a.power(p, modulus: nr)
			var witnesslatex = String(a)
			witnesslatex = witnesslatex + "^{" + String(p) + "} \\equiv " + String(m) + " (\\neq 1) \\text{ mod }" + String(nr)
			if m != 1 { witnesslatex = witnesslatex + errtext }
			ans.append(witnesslatex)
			return ans
		}
		
		var platex = String(nr) + " - 1 = "
		if let factorlatex = FactorCache.shared.Latex(n: p, withpot: true) {
			platex = platex + factorlatex
		}
		ans.append(platex)
		
		for f in factors {
			let m = a.power(p / f.f / 2, modulus: nr)
			if m == 1 {
				var witnesslatex = String(a) + "^{\\frac{" + String(p) + "}{" + String(f.f) + "}} \\equiv " + String(m) + "(\\neq 1) \\text{ mod }" + String(nr)
				witnesslatex = witnesslatex + errtext
				ans.append(witnesslatex)
			}
		}
		return ans
	}
	
	
	private func LatexPrimeCertfificate() -> [LatexString] {
		
		let errtext = "\\text{ guilty } "
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
			let subcert = subpratt.LatexPrimeCertfificate()
			for s in subcert {
				ans.append("\\quad" + s)
			}
		}
		return ans
	}
}
