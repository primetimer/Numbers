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

class CatalanTester : NumTester {
	
	private let oeis : [BigUInt] = [1,1,2,5,14,42,132,429,1430,4862,16796,58786,
									208012,742900,2674440,9694845,35357670,129644790,
									477638700,1767263190,6564120420,24466267020,
									91482563640,343059613650,1289904147324,
									4861946401452,18367353072152,69533550916004,
									263747951750360,1002242216651368,3814986502092304]
	
	func isSpecial(n: BigUInt) -> Bool {
		if oeis.contains(n) {
			return true
		}
		return false
	}
	
	func Nth(n: BigUInt) -> Int {
		if let nth = oeis.index(where: {$0 == n}) {
			return nth
		}
		return 0
	}
	
	func getDesc(n: BigUInt) -> String? {
		var desc = WikiLinks.shared.getLink(tester: self, n: n)
		let nth = Nth(n: n)
		if n > 1 {
			var of = ""
			switch nth+2 {
			case 2:
				return desc
			case 3:
				of = "triangle"
			case 4:
				of = "square"
			case 5:
				of = "pentagon"
			case 6:
				of = "hexagon"
			case 7:
				of = "heptagon"
			case 8:
				of = "octagon"
			default:
				of = String(nth+2) + "-polygon"
			}
			desc = desc + " There are " + String(n) + " triangulations of a " + of + "."
		}
		return desc
	}
	
	func getLatex(n: BigUInt) -> String? {
		let nth = Nth(n: n)
		if n <= 2 { return nil }
		let latex =  String(n) + " = \\prod_{k=1}^{ " + String(nth+2) + "- 2} \\frac{4k-2}{k+1}"
		return latex
	}
	
	func property() -> String {
		return "Catalan"
	}
}



