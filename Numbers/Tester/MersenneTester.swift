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

class MersenneTester : NumTester {
	func getDesc(n: BigUInt) -> String? {
		let p = BigUInt(n)
		if PrimeCache.shared.IsPrime(p: p) {
			return String(n) + " is a Mersenne prime"
		}
		let (_,pow) = getPow(n: n+1)
		if PrimeCache.shared.IsPrime(p: BigUInt(pow)) {
			return String(n) + " is a composite Mersenne number"
		}
		return String(n) + " is a Mersenne number"
	}
	
	private func getPow(n: BigUInt) -> (Bool,BigUInt) {
		if n == 0 { return (false,0) }
		if n == 1 { return (true,1) }
		var (nn,pow) = (n,BigUInt(0))
		while nn>1 {
			if nn % 2 == 1 { return (false,0) }
			nn = nn / 2
			pow = pow + 1
		}
		return (true,pow)
	}
	
	func getLatex(n: BigUInt) -> String? {
		if n == 0 { return nil }
		if n == 1 {
			return "1 = M_1 = 2^1 - 1 \\\\"
		}
		let (_,pow) = getPow(n: n+1)
		var latex = String(n) + "= 2^{" + String(pow) + "} - 1"
		if PrimeCache.shared.IsPrime(p: BigUInt(n)) {
			latex = latex + " = M_{" + String(pow) + "} \\in \\mathbb{P}"
		} else if PrimeCache.shared.IsPrime(p: BigUInt(pow)) {
			latex = latex + " = M_{" + String(pow) + "} \\notin \\mathbb{P}"
		}
		return latex
	}
	
	func property() -> String {
		return "Mersenne"
	}
	
	func isSpecial(n: BigUInt) -> Bool {
		if n == 1 { return true }
		if n <= 2 { return false }
		var nn = n+1
		while nn>1 {
			if nn % 2 != 0 {
				return false
			}
			nn = nn / 2
		}
		return true
	}
}

class ProthTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		let (k,_,nn) = getpart(n: n)
		if k < nn { return true }
		return false
	}
	
	func getDesc(n: BigUInt) -> String? {
		if PrimeCache.shared.IsPrime(p: BigUInt(n)) {
			return String(n) + " is a Proth prime"
		}
		return String(n) + " is a Proth number"
	}
	
	func getLatex(n: BigUInt) -> String? {
		
		let (k,pot2,_) = getpart(n: n)
		var latex = String(n) + "= " + String(k) + "\\cdot { 2^{" + String(pot2) + "}} + 1"
		if PrimeCache.shared.IsPrime(p: BigUInt(n)) {
			latex = latex + "\\in \\mathbb{P}"
		}
		latex = latex + "\\\\"
		return latex
	}
	
	func property() -> String {
		return "Proth"
	}
	
	private func getpart(n: BigUInt) -> (k: BigUInt, pot2: BigUInt,nn : BigUInt)
	{
		if n <= 2 { return (0,0,0) }
		if n == 3 { return (1,1,2) }
		var k = n - 1
		var pot2 : BigUInt = 0
		while k % 2 == 0 {
			k = k / 2
			pot2 = pot2 + 1
		}
		let nn = (n-1) / k
		return (k: k, pot2: pot2, nn: nn)
	}
}

class SierpinskiTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		if oeis.contains(n) {
			return true
		}
		return false
	}
	
	func getDesc(n: BigUInt) -> String? {
		let desc = String(n) + " is a Sierpinski number." + String(n) + "* 2^n+1 is never a prime number."
		return desc
	}
	
	func getLatex(n: BigUInt) -> String? {
		let latex =  "\\forall n : " + String(n) + "\\cdot{2^n} +1 \\notin \\mathbb{P}  \\\\"
		return latex
	}
	
	func property() -> String {
		return "Sierpinski"
	}
	
	private let oeis : [BigUInt] = [78557,271129,271577,322523,327739,482719,575041,
								603713,903983,934909,965431,1259779,1290677,
								1518781,1624097,1639459,1777613,2131043,2131099,
								2191531,2510177,2541601,2576089,2931767,2931991,
								3083723,3098059,3555593,3608251]
	
}

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
		var desc = String(n) + " is a Catalan number."
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
			desc = desc + " There are " + String(n) + " triangulations of a " + of
		}
		return desc
	}
	
	func getLatex(n: BigUInt) -> String? {
		let nth = Nth(n: n)
		if n <= 2 { return nil }
		let latex =  String(n) + " = \\prod_{k=1}^{ " + String(nth+2) + "- 2} \\frac{4k-2}{k+1} \\\\"
		return latex
	}
	
	func property() -> String {
		return "Catalan"
	}
}



