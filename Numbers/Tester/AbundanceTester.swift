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

extension BigUInt {
	func isInt64() -> Bool {
		return self<BigUInt(Int64.max) 
	}
}


extension FactorCache {
	public func Latex(n: BigUInt, withpot : Bool) -> String? {
		if n<2 { return nil }
		let factors = Factor(p: n)
		if factors.count < 2 { return nil }
		var latex = String(n) + "="

		if withpot {
			let fwithpots = FactorsWithPot(n: n)
			for (index,f) in fwithpots.enumerated() {
				if index > 0 { latex = latex + "\\cdot{" }
				latex = latex + String(f.f)
				if f.e > 1 {
					latex = latex + "^{" + String(f.e) + "}"
				}
				if index>0 {
					latex = latex + "}"
				}
			}
		} else {
			for (index,f) in factors.enumerated() {
				if index > 0 { latex = latex + "\\cdot{" }
				latex = latex + String(f)
				if index > 0 { latex = latex + "}" }
			}
		}
		latex = latex + "\\\\"
		return latex
	}
	
	struct FactorWithPot {
		
		init(f: BigUInt) {
			self.f = f
			self.e = 1
		}
		init(f: BigUInt, e: Int) {
			self.f = f
			self.e = e
		}
		
		var f: BigUInt = 0
		var e: Int = 0
		
	}
	
	func FactorsWithPot(n: BigUInt) -> [FactorWithPot] {
		var ans : [FactorWithPot] = []
		let factors = Factor(p: n)
		
		var pot = 1
		for (index,f) in factors.enumerated() {
			if index+1 == factors.count {
				let fwithpot = FactorWithPot(f: f, e: pot)
				ans.append(fwithpot)
			} else {
				if f == factors[index+1] {
					pot = pot + 1
				}
				else {
					let fwithpot = FactorWithPot(f: f, e: pot)
					ans.append(fwithpot)
					pot = 1
				}
			}
		}
		return ans
	}
}

class PerfectTester : NumTester {
	
	func property() -> String {
		return "perfect"
	}
	func isSpecial(n: BigUInt) -> Bool {
		let b = seq.contains(n)
		return b
	}
	func getDesc(n: BigUInt) -> String? {
		let desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	
	private func getFaktors(n: BigUInt) -> Int? {
		for (index,p) in mersenne.enumerated() {
			let q = (p + 1) / 2
			let t = p * q
			if t == n { return index }
			if t > n { return nil }
		}
		return nil
	}
	
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		if let m = getFaktors(n: n) {
			var latex = String(n)
			latex = latex + "= 2^{" + String(m) + "}"
			latex = latex + "(2^{" + String(m+1) + "} - 1) \\\\"
			return latex
		}
		return nil
	}
	
	
	
	private let seq : [BigUInt] = [	6, 28, 496, 8128, 33550336, 8589869056, 137438691328, BigUInt("2305843008139952128")!, BigUInt("2658455991569831744654692615953842176")!, BigUInt("191561942608236107294793378084303638130997321548169216")!]
	
	
	private let mersenne : [BigUInt] = [3, 7, 31, 127, 8191, 131071, 524287, 2147483647, BigUInt("2305843009213693951")!, BigUInt("618970019642690137449562111")!, BigUInt("162259276829213363391578010288127")!, BigUInt("170141183460469231731687303715884105727")!]
	
}

class AbundanceTester : NumTester {
	
	private let superabundant = [1, 2, 4, 6, 12, 24, 36, 48, 60, 120, 180, 240, 360, 720, 840, 1260, 1680, 2520, 5040, 10080, 15120, 25200, 27720, 55440, 110880, 166320, 277200, 332640, 554400, 665280, 720720, 1441440, 2162160, 3603600, 4324320, 7207200, 8648640, 10810800, 21621600]
	
	func getDesc(n: BigUInt) -> String? {
		var desc = WikiLinks.shared.getLink(tester: self, n: n)
		
		//let sigma0 = SumOfProperDivisors(n: n)
		let sigma = FactorCache.shared.Sigma(p: n)
		if n.isInt64() {
			if superabundant.contains(Int(n)) {
				desc = desc + " It is also a " + WikiLinks.shared.Link(key: "superabundant") + " number."
			}
		}
		#if false
		if sigma == n * 2 {
			desc = desc + " It is also a " + WikiLinks.shared.Link(key: "perfect") + " number."
			//return String(n) + " is perfect"
		}
			#endif
		
		//let desc = String(n) + " is abundant (excessive)"
		return desc
	}
	
	private func SumOfProperDivisors(n: BigUInt) -> BigUInt {
		let p = BigUInt(n)
		let sigma = FactorCache.shared.Sigma(p: p)
		return sigma - p
	}
	
	func getLatex(n: BigUInt) -> String? {
		var latex = String(n) + "<" + "\\sigma^{*}(n) = \\sum_{k \\mid{n}, k<n} k = "
		let sigma = FactorCache.shared.Sigma(p: BigUInt(n)) - BigUInt(n)
		latex = latex + String(sigma)
		
		if sigma == n {
			latex = String(n) + "= " + "\\sigma^{*}(n) = \\sum_{k \\mid{n}, k<n} k"
			return latex
		}
		
		if n.isInt64() {
			if superabundant.contains(Int(n)) {
				latex = latex + "\\\\"
				latex = latex + "\\forall m<n : \\frac{\\sigma (m)}{m} < \\frac{\\sigma (n)}{n}"
			}
		}
		return latex
	}
	func property() -> String {
		return "abundant"
	}
	func isSpecial(n: BigUInt) -> Bool {
		if n == 0 { return false }
		let p = BigUInt(n)
		let sigma = FactorCache.shared.Sigma(p: p)
		if sigma >= BigUInt(n) * BigUInt(2) {
			return true
		}
		return false
	}
}

class NonTotientTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		
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
	
	func getDesc(n: BigUInt) -> String? {
		var desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	
	func getLatex(n: BigUInt) -> String? {
		var latex = String(n)
		latex = latex + "\\in \\{ n \\in \\mathbb{N} | \\forall x \\in \\mathbb{N} : \\phi(x) \\neq n  \\} \\\\"
		latex = latex + "\\phi(n) = | \\{ x_{\\leq n} \\in  \\mathbb{N} :  gcd(x,n) = 1  \\} |"

		return latex
	}
	
	func property() -> String {
		return "nontotient"
	}
	
	
	
}

