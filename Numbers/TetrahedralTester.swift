//
//  TetrahedralTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 24.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class TetrahedralTest : NumTester {
	func property() -> String {
		return "tetrahedral"
	}
	
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	
	func isSpecial(n: BigUInt) -> Bool {
		let (b,_) = test(n: n)
		return b
	}
	private func test(n: BigUInt) -> (Bool,Int) {
		if n == 0 { return (false,0) }
		var (sum,k) = (0,1)
		while sum < n {
			sum = sum + k * (k+1) / 2
			if sum == n { return (true,k) }
			k = k + 1
		}
		return (false,k)
	}
	
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a tetrahedral number"
		return str
	}
	
	func getLatex(n: BigUInt) -> String? {
		let (_,k) = test(n: n)
		
		let latex = String(n) + "= \\sum_{k=1}^{" + String(k) + "}\\frac{k\\cdot{(k+1)}}{2}"
		return latex
	}
}



