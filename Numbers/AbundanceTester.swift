//
//  AbundanceTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 11.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors



extension FactorCache {
	public func Latex(n: Int) -> String? {
		if n<2 { return nil }
		let bign = BigUInt(n)
		let factors = Factor(p: bign)
		if factors.count < 2 { return nil }
		var latex = String(n) + "="
		for (index,f) in factors.enumerated() {
			if index > 0 { latex = latex + "\\cdot{" }
			latex = latex + String(f)
			if index > 0 { latex = latex + "}" }
		}
		return latex
	}
}

class AbundanceTester : NumTester {
	func getDesc(n: Int) -> String? {
		//let sigma0 = SumOfProperDivisors(n: n)
		let desc = String(n) + " is excessive (abundant)"
		return desc
	}
	
	private func SumOfProperDivisors(n: Int) -> BigUInt {
		let p = BigUInt(n)
		let sigma = FactorCache.shared.Sigma(p: p)
		return sigma - p
	}
	
	func getLatex(n: Int) -> String? {
		var latex = String(n) + "<" + "\\sigma^{*}(n) = \\sum_{k \\mid{n}, k<n} k = "
		let sigma = FactorCache.shared.Sigma(p: BigUInt(n)) - BigUInt(n)
		latex = latex + String(sigma)
		return latex
	}
	func property() -> String {
		return "excessive"
	}
	func isSpecial(n: Int) -> Bool {
		if n == 0 { return false }
		let p = BigUInt(n)
		let sigma = FactorCache.shared.Sigma(p: p)
		if sigma > BigUInt(n) * BigUInt(2) {
			return true
		}
		return false
	}
}

class NonTotientTester : NumTester {
	func isSpecial(n: Int) -> Bool {
		
		//2p is nontotient iff 2p+1 is prime
		if n % 2 == 1 { return false }
		let p = BigUInt(n) / BigUInt(2)
		let p21 = p * BigUInt(2) + BigUInt(1)
		if PrimeCache.shared.IsPrime(p: p) {
			if !PrimeCache.shared.IsPrime(p: p21) {
				return true
			}
		}
		if p % 2 == 0  {
			let q = p / BigUInt(2)
			if !PrimeCache.shared.IsPrime(p: q) { return false }
			let q21 = BigUInt(2) * q + BigUInt(1)
			if !PrimeCache.shared.IsPrime(p: q21) {
				if !PrimeCache.shared.IsPrime(p: BigUInt(4)*q+BigUInt(1)) {
					return true
				}
			}
		}
		
		let r1 = BigUInt(n) - BigUInt(1)
		let r2 = r1.squareRoot()
		if (r2 * r2 != r1) { return false }
		if !PrimeCache.shared.IsPrime(p: r2*r2 + BigUInt(2)) {
			return true
		}
		return false		
	}
	
	func getDesc(n: Int) -> String? {
		return "non totient"
	}
	
	func getLatex(n: Int) -> String? {
		var latex = String(n)
		latex = latex + "\\in \\{ n \\in \\mathbb{N} | \\forall x \\in \\mathbb{N} : \\phi(x) \\neq n  \\} \\\\"
		latex = latex + "\\phi(n) = | \\{ x_{\\leq n} \\in  \\mathbb{N} :  gcd(x,n) = 1  \\} |"

		return latex
	}
	
	func property() -> String {
		return "non totient"
	}
	
	
	
}

