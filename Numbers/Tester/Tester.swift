//
//  Tester.swift
//  Numbers
//
//  Created by Stephan Jancar on 10.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors

protocol NumTester {
	func isSpecial(n: BigUInt) -> Bool
	func getDesc(n: BigUInt) -> String?
	func getLatex(n: BigUInt) -> String?
	func property() -> String	//Name of tested property
}

class Tester : NumTester {
	func property() -> String {
		return ""
	}
	
	static var shared = Tester()
	private var testers : [NumTester] = [PrimeTester(), AbundanceTester(),
										 TriangleTester(),SquareTester(),CubeTester(),
										 FibonacciTester(),TetrahedralTest(),
										 PentagonalTester(),HexagonalTester(),
										 Pow2Tester(),MersenneTester(), ProthTester(),
										 HCNTester(),
										 SierpinskiTester(),CatalanTester(),NonTotientTester(),
										 PalindromicTester(),LucasTester(),
										 DullTester(), LuckyTester(),
										 MathConstantTester()]
	private init() {}
	
	func isSpecial(n: BigUInt) -> Bool {
		return true //!isDull(n: n)
	}
	
	func isDull(n: BigUInt) -> Bool {
		if n <= 2 { return false }
		for t in testers {
			if t is DullTester {
				continue
			}
			if t.isSpecial(n: n) {
				return false
			}
		}
		return true
	}
	
	func getDesc(n: BigUInt) -> String? {
		var str : String = ""
		for t in testers {
			if t.isSpecial(n: n) {
				str = str + t.getDesc(n: n)! + "\n"
			}
		}
		return str
	}
	
	func getLatex(n: BigUInt) -> String? {
		var latex : String = ""
		for t in testers {
			if t.isSpecial(n: n) {
				if let ltest = t.getLatex(n: n) {
					latex = latex + ltest + "\\\\"
				}
			}
		}
		return latex
	}
	
	func properties(n: BigUInt) -> String {
		var prop : String = ""
		if n == 0 {
			prop = "Neutral Element of addition"
		}
		if n == 1 {
			prop = "Neutral Element of mulitplication"
		}


		for t in testers {
			if t.isSpecial(n: n) {
				if prop.count > 0 { prop = prop + "\n" }
				prop = prop + t.property()
			}
		}
		return prop
	}
}

class FactorTester : NumTester {
	private let primetester = PrimeTester()
	func isSpecial(n: BigUInt) -> Bool {
		return !primetester.isSpecial(n: n)
	}
	
	func getDesc(n: BigUInt) -> String? {
		return nil
	}
	
	func getLatex(n: BigUInt) -> String? {
		return nil
	}
	
	func property() -> String {
		return "Factorization"
	}
	
	
}

class DullTester : NumTester {
	
	let firstdull = BigUInt(39)
	let seconddull = BigUInt(46)
	func isSpecial(n: BigUInt) -> Bool {
		return Tester.shared.isDull(n: n)
	}
	
	func getDesc(n: BigUInt) -> String? {
		switch n
		{
		case firstdull:
			return "39 is the smallest dull number"
		case seconddull:
			return "46 is the first really boring number"
		default:
		return String(n) + " is a dull number"
		}
	}
	
	func getLatex(n: BigUInt) -> String? {
		var latex = ""
		switch n {
		case firstdull:
			latex = "39 = min \\{ n \\in \\mathbb{N}  : n \\notin \\mathbb{I} \\} \\\\"
			latex = latex + "\\mathbb{I} := \\{ n : n \\text{ is interesting} \\} "
		default:
			latex = String(n) + " \\notin \\mathbb{I} := \\{ n : n \\text{ is interesting} \\} \\\\"
		}
		return latex
	}
	
	func property() -> String {
		return "dull"
	}
	
	
}

class TriangleTester : NumTester {
	func property() -> String {
		return "triangle"
	}

	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	private func troot(x: Double) -> Double {
		let troot = (sqrt(8.0*x+1) - 1.0) / 2.0
		return troot
	}
	func isSpecial(n: BigUInt) -> Bool {
		if n == 0 { return false }
		let tr = troot(x: Double(n))
		return IsInt(x: tr)
	}
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a triangle number"
		return str
	}	
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let nth = Int(troot(x: Double(n)))
		let latex = String(n) + "= \\sum_{k=1}^{" + String(nth) + "}  k"
		return latex
	}
}

class PentagonalTester : NumTester {
	func property() -> String {
		return "pentagonal"
	}
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	private func troot(x: Double) -> Double {
		let troot = (sqrt(24.0*x+1) + 1.0) / 6.0
		return troot
	}
	func isSpecial(n: BigUInt) -> Bool {
		let tr = troot(x: Double(n))
		return IsInt(x: tr)
	}
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a pentagonal number"
		return str
	}
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let nth = Int(troot(x: Double(n)))
		let latex = String(n) + "= \\sum_{k=1}^{" + String(nth) + "} \\frac{3\\cdot{k^2-k}}{2} \\\\"
		return latex
	}
}

class Pow2Tester : NumTester {
	func getDesc(n: BigUInt) -> String? {
		return String(n) + " is a power of 2"
	}
	
	func getLatex(n: BigUInt) -> String? {
		if n <= 1 { return nil }
		var (nn,pow) = (n,0)
		while nn>1 {
			nn = nn / 2
			pow = pow + 1
		}
		let latex = String(n) + "= 2^{" + String(pow) + "} \\\\"
		return latex
	}
	
	func property() -> String {
		return "power of two"
	}
	func isSpecial(n: BigUInt) -> Bool {
		if n == 0 { return false }
		if n == 1 { return false }
		var nn = n
		while nn>1 {
			if nn % 2 != 0 {
				return false
			}
			nn = nn / 2
		}
		return true
	}
	
}


class HexagonalTester : NumTester {
	func property() -> String {
		return "hexagonal"
	}
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	private func troot(x: Double) -> Double {
		let troot = (sqrt(8*x+1) + 1.0) / 4.0
		return troot
	}
	func isSpecial(n: BigUInt) -> Bool {
		let tr = troot(x: Double(n))
		return IsInt(x: tr)
	}
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a hexagonal number"
		return str
	}
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let nth = Int(troot(x: Double(n)))
		let latex = String(n) + "= \\sum_{k=0}^{" + String(nth-1) + "} (4k+1)"
		return latex
	}
}


class SquareTester : NumTester {
	func property() -> String {
		return "square"
	}
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	private func root(x: Double) -> Double {
		let root = sqrt(x)
		return root
	}
	func isSpecial(n: BigUInt) -> Bool {
		if n == 0 { return false }
		let r = root(x: Double(n))
		return IsInt(x: r)
	}
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a square"
		return str
	}
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let nth = String(Int(root(x: Double(n))))
		
		let latex = String(n) + "=" + nth + "^2 = " + nth + "\\cdot{" + nth + "}"
		return latex
	}
}

class CubeTester : NumTester {
	func property() -> String {
		return "cube"
	}
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	private func root(x: Double) -> Double {
		let root = pow(x,1.0/3.0)
		return root
	}
	func isSpecial(n: BigUInt) -> Bool {
		if n == 0 { return false }
		let r = root(x: Double(n))
		return IsInt(x: r)
	}
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a cube"
		return str
	}
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let nth = String(Int(root(x: Double(n))))
		let latex = String(n) + "=" + nth + "^3 = " + nth + "\\cdot{" + nth + "}" + "\\cdot{" + nth + "}"
		return latex
	}
}

class FibonacciTester : NumTester {
	func property() -> String {
		return "fibonacci"
	}
	
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	
	func isSpecial(n: BigUInt) -> Bool {
		if n == 0 { return false }
		if n == 1 { return true }
		let n2 = Double(n) * Double(n)
		let x1 = 5.0*n2 + 4.0
		let x2 = 5.0*n2 - 4.0
		if IsInt(x: sqrt(x1)) || IsInt(x: sqrt(x2)) {
			return true
		}
		return false
	}
	
	private func Nth(n: BigUInt) -> Int {
		let phi = (1.0 + sqrt(5)) / 2.0
		let a = Double(n)*sqrt(5.0)+0.5
		let l = log(a) / log(phi)
		let nth = floor(l)
		return Int(nth)
	}
	
	private func prev(n: BigUInt) -> BigUInt {
		let phi = (1.0 + sqrt(5)) / 2.0
		let nbyphi = Double(n) / phi
		let round = Darwin.round(nbyphi)
		return BigUInt(round)
	}
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a Fibonacci number"
		return str
	}
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		if n == 1 {
			return nil
		}
		let prevf = prev(n: n)
		let secf = n - prevf
		let nth = Nth(n:n)
		var latex = String(n) + "=" + String(secf) + "+" + String(prevf) + " = "
		latex = latex + "f_{" + String(nth-2) + "} + f_{" + String(nth-1) + "}"
		return latex
	}
}

class LucasTester : NumTester {
	func property() -> String {
		return "lucas"
	}
	
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	
	func isSpecial(n: BigUInt) -> Bool {
		if n == 0 { return false }
		if n <= 3 { return true }
		var (l1,l2,l3) = (BigUInt(2),BigUInt(1),BigUInt(3))
		
		while n>l3 {
			l3 = l1 + l2
			l1 = l2
			l2 = l3
		}
		if n == l3 {
			return true
		}
		return false
	}
	
	private func prev(n: BigUInt) -> (BigUInt,BigUInt) {
		if n == 1 { return (0,1) }
		if n == 2 { return (0,2) }
		if n == 3 { return (1,2) }
		var (l1,l2,l3) = (BigUInt(2),BigUInt(1),BigUInt(3))
		
		while n>=l3 {
			l3 = l1 + l2
			if n == l3 { return (l1,l2) }
			l1 = l2
			l2 = l3
		}
		return (0,0)
	}
	
	func getDesc(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a Lucas number"
		return str
	}
	
	func Nth(n: BigUInt) -> Int {
		if n == 2 { return 1 }
		if n == 1 { return 2 }
		if n == 3 { return 3 }
		
		var (l1,l2,l3) = (2,1,3)
		var c = 2
		while n>l3 {
			l3 = l1 + l2
			l1 = l2
			l2 = l3
			c = c + 1
		}
		return c
	}
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		if n <= 2 {
			return nil
		}
		let (l1,l2) = prev(n: n)
		let nth = Nth(n: n)
		var latex = String(n) + "=" + String(l1) + "+" + String(l2)
		latex = latex + " = L_{" + String(nth-3) + "} + L_{" + String(nth-2) + "}"
		return latex
	}
}

