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

class SumOfTwoCubesTester : NumTester {
	
	func getDesc(n: BigUInt) -> String? {
		var desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	
	
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		if let (a,b) = Express(n: n) {
			let stra = String(a)
			let strb = String(b)
			var latex = String(n) + "=" + stra + "^3 + " + strb + "^3"
			return latex
		}
		return nil
	}
	func property() -> String {
		return "sum of two cubes"
	}
	private let r63 = [3,4,5,6,10,11,12,13,14,15,17,18,21, 22, 23, 24, 25, 30, 31, 32, 33, 38, 39, 40,
				41, 42, 45, 46, 48, 49, 50, 51, 52, 53, 57,
				58, 59, 60]
	func isSpecial(n: BigUInt) -> Bool {
		if n <= 1 { return false }
		if n == 2 { return true }
		
		do {
			let n7 = Int(n % 7)
			if n7 == 3 || n7 == 4  { return false }
		}
		do {
			let n9 = Int(n % 9)
			if n9 >= 3 && n9<=6 { return false }
		}
		do {
			let n63 = Int(n%63)
			if r63.contains(n63) { return false }
		}

		var (n0,_) = (n,BigUInt(1))
		if n > 1000000000 {
			(n0,_) = RemoveCubes(n: n)
		}
		
		let r3 = n0.iroot3()
		let r4 = (n0*4).iroot3()
		let divisors = FactorCache.shared.Divisors(p: n0)
		for m in divisors.sorted() {
			if m < r3 { continue }
			if m > r4 { return false }
			if m*m < n0/m { continue }
			let temp =  (m*m-n0/m) * 4
			if temp % 3 != 0 { continue }
			if m*m < temp / 3  { return false }
			let temp2 = m*m - temp / 3
			let rtemp2 = temp2.squareRoot()
			if rtemp2 * rtemp2 == temp2 {
				return true
			}
		}
		return false
	}
	
	private func RemoveCubes(n:BigUInt) -> (n:BigUInt,cube: BigUInt) {
		if n.isPrime() {
			return (n:n,cube:1)
		}
		var cube : BigUInt = 1
		let factors = FactorCache.shared.FactorsWithPot(n: n)
		for f in factors {
			if f.e >= 3 {
				cube = cube * f.f.power(f.e - f.e % 3)
			}
		}
		return (n: n/cube, cube:cube.iroot3())
	}
	
	func Express(n: BigUInt) -> (a: BigUInt, b:BigUInt)? {
		if !isSpecial(n: n) { return nil }
		//let (n0,cube) = RemoveCubes(n: n)
		var (n0,cube) = (n,BigUInt(1))
		if n > 1000000000 {
			(n0,cube) = RemoveCubes(n: n)
		}
		
		var a : BigUInt = 0
		while true {
			let a3 = a * a * a
			if a3 > n0 { return nil }
			if a3 == n0 { return (a: a*cube, b: 0) }
			let b3 = n0 - a3
			let r3 = b3.iroot3()
			if r3 * r3 * r3 == b3 {
				return (a:a*cube, b: r3*cube)
			}
			a = a + 1
		}
	}
}

