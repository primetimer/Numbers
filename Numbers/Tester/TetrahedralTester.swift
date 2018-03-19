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
	
	static private var tetrahedral : [BigUInt] = [BigUInt(1)]
	func property() -> String {
		return "tetrahedral"
	}
	func propertyString() -> String {
		return "tetra\u{00AD}hedral"
	}
	
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	
	func isSpecial(n: BigUInt) -> Bool {
		let (b,_) = test(n: n)
		return b
	}
	
	private func Tn(n: BigUInt) -> BigUInt {
		return n*(n+1)*(n+2)
	}
	
	private func test(n: BigUInt) -> (Bool,Int) {
		
		if n == 0 { return (false,0) }
		
		let p = n*6
		let divisors = FactorCache.shared.Divisors(p: p)
		for d in divisors.sorted().reversed() {
			let y = BigInt(d*(d+1)*(d+2)) - BigInt(p)
			if y == 0 {
				return (true,Int(d))
			}
			if y < 0 {
				return (false,0)
			}
		}
		return (false,0)
		
		//let C = D1 + (D1*D1 - 4 * D0*D0*D0)
		
		
		/*
		var index = BigInt(n.iroot3())	//This number is too small
		
		while true {
			let y = index * (index+1) * (index+2) - BigInt(n) * 6
			if y == 0 {
				return (true,Int(index))
			}
			if y > 0 {
				return (false,0)
			}
			index = index + 1
		}
		
		
		let count = TetrahedralTest.tetrahedral.count
		var (sum,k) = (TetrahedralTest.tetrahedral[count-1],count+1)
		if n<sum {
			if let index = TetrahedralTest.tetrahedral.index(of: n) {
				return (true,index+1)
			}
			return (false,0)
		}
		
		//var (sum,k) = (0,1)
		while sum < n {
			sum = sum + BigUInt(k) * (BigUInt(k)+1) / 2
			TetrahedralTest.tetrahedral.append(sum)
			if sum == n { return (true,k) }
			k = k + 1
		}
		return (false,k)
		*/
	}
	
	func getDesc(n: BigUInt) -> String? {
		return WikiLinks.shared.getLink(tester: self, n: n)
		/*
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a tetrahedral number"
		return str
		*/
	}
	
	func getLatex(n: BigUInt) -> String? {
		let (_,k) = test(n: n)
		
		let latex = String(n) + "= \\sum_{k=1}^{" + String(k) + "}\\frac{k\\cdot{(k+1)}}{2}"
		return latex
	}
}



