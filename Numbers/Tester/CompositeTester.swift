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


class CompositeTester : NumTester {
	func getLatex(n: BigUInt) -> String? {
		return FactorCache.shared.Latex(n: n, withpot: true)
	}
	func property() -> String {
		return "composite"
	}
	func propertyString() -> String {
		return "com\u{00AD}po\u{00AD}site"
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

struct GaussianInt {
	var a: BigInt = 0
	var i: BigInt = 0
	init(_ a: BigInt, i : BigInt) {
		self.a = a
		self.i = i
	}
	
	func asString() -> String {
		var ans = String(a)
		if self.i == 1 {
			ans = ans + "+i"
		} else if self.i == -1 {
			ans = ans + "-i"
		} else if i > 0 {
			ans = ans + "+" + String(self.i) + "i"
		} else if i < 0 {
			ans = ans + String(self.i) + "i"
		}
		return ans
	}
	
	static func FactorPrime(p : BigUInt) -> (GaussianInt,GaussianInt)? {
		if p == 2 {
			let g1 = GaussianInt(1,i: 1)
			let g2 = GaussianInt(1,i:-1)
			return (g1,g2)
		}
		if p % 4 == 3 {
			return nil
		}
		if let (a,b) = SumOfTwoSquaresTester().Express(n: p) {
			let g1 = GaussianInt(BigInt(a),i:BigInt(b))
			let g2 = GaussianInt(BigInt(a),i:-BigInt(b))
			return (g1,g2)
		}
		return nil
	}
}

