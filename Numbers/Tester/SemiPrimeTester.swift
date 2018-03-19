//
//  HCNTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 30.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors

class SemiPrimeTester : NumTester {
	
	func isSpecial(n: BigUInt) -> Bool {
		if PrimeCache.shared.IsPrime(p: n) { return false }
		let factors = FactorCache.shared.Factor(p: n)
		if factors.count != 2 { return false}
		let r3 = n.iroot3()
		for f in factors {
			if f < r3 {
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
		return nil // Factorization is shown elsewhere
	}
	
	func property() -> String {
		return "semiprime"
	}
	func propertyString() -> String {
		return "semi\u{00AD}prime"
	}
}
