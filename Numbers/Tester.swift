//
//  Tester.swift
//  Numbers
//
//  Created by Stephan Jancar on 10.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation

protocol NumTester {
	
	func isSpecial(n: Int) -> Bool
	func getDesc(n: Int) -> String?
	func getLatex(n: Int) -> String?
	
}

class Tester : NumTester {
	
	static var shared = Tester()
	private var testers : [NumTester] = [TriangleTester(),SquareTester(),
										 FibonacciTester(),TetrahedralTest(),
										 PentagonalTester(),HexagonalTester()]
	private init() {}
	
	func isSpecial(n: Int) -> Bool {
		for t in testers {
			if t.isSpecial(n: n) { return true }
		}
		return false
	}
	
	func getDesc(n: Int) -> String? {
		var str : String = ""
		for t in testers {
			if t.isSpecial(n: n) {
				str = str + t.getDesc(n: n)! + "\n"
			}
		}
		return str
	}
	
	func getLatex(n: Int) -> String? {
		var latex : String = ""
		for t in testers {
			if t.isSpecial(n: n) {
				latex = latex + t.getLatex(n: n)! + "\\\\"
			}
		}
		return latex
	}
	
	
}


class TriangleTester : NumTester {
	
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	
	private func troot(x: Double) -> Double {
		let troot = (sqrt(8.0*x+1) - 1.0) / 2.0
		return troot
	}
	
	func isSpecial(n: Int) -> Bool {
		let tr = troot(x: Double(n))
		return IsInt(x: tr)
	}
	
	func getDesc(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a triangle number"
		return str
	}
	
	func getLatex(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		let nth = Int(troot(x: Double(n)))
		let latex = String(n) + "= \\sum_{k=1}^{" + String(nth) + "}  k \\\\"
		return latex
	}
}

class PentagonalTester : NumTester {
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	private func troot(x: Double) -> Double {
		let troot = (sqrt(24.0*x+1) + 1.0) / 6.0
		return troot
	}
	func isSpecial(n: Int) -> Bool {
		let tr = troot(x: Double(n))
		return IsInt(x: tr)
	}
	func getDesc(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a pentagonal number"
		return str
	}
	func getLatex(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		let nth = Int(troot(x: Double(n)))
		let latex = String(n) + "= \\sum_{k=1}^{" + String(nth) + "} \\frac{3\\cdot{k^2-k}}{2} \\\\"
		return latex
	}
}

class HexagonalTester : NumTester {
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	private func troot(x: Double) -> Double {
		let troot = (sqrt(8*x+1) + 1.0) / 4.0
		return troot
	}
	func isSpecial(n: Int) -> Bool {
		let tr = troot(x: Double(n))
		return IsInt(x: tr)
	}
	func getDesc(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a hexagonal number"
		return str
	}
	func getLatex(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		let nth = Int(troot(x: Double(n)))
		let latex = String(n) + "= \\sum_{k=0}^{" + String(nth-1) + "} (4k+1) \\\\"
		return latex
	}
}


class SquareTester : NumTester {
	
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	
	private func root(x: Double) -> Double {
		let root = sqrt(x)
		return root
	}
	
	func isSpecial(n: Int) -> Bool {
		let r = root(x: Double(n))
		return IsInt(x: r)
	}
	
	func getDesc(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a square"
		return str
	}
	
	func getLatex(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		let nth = String(Int(root(x: Double(n))))
		
		let latex = String(n) + "=" + nth + "^2 = " + nth + "\\cdot{" + nth + "}"
		return latex
	}
}

class FibonacciTester : NumTester {
	
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	
	func isSpecial(n: Int) -> Bool {
		if n == 0 { return false }
		if n == 1 { return true }
		let x1 = 5.0*Double(n*n) + 4.0
		let x2 = 5.0*Double(n*n) - 4.0
		if IsInt(x: sqrt(x1)) || IsInt(x: sqrt(x2)) {
			return true
		}
		return false
	}
	
	private func prev(n: Int) -> Int {
		let phi = (1.0 + sqrt(5)) / 2.0
		let nbyphi = Double(n) / phi
		let round = Darwin.round(nbyphi)
		return Int(round)
	}
	
	func getDesc(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a Fibonacci number"
		return str
	}
	
	func getLatex(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		if n == 1 {
			return " 1 = 0 + 1"
		}
		let prevf = prev(n: n)
		let secf = n - prevf
		
		let latex = String(n) + "=" + String(secf) + "+" + String(prevf)
		return latex
	}
}

class TetrahedralTest : NumTester {
	
	private func IsInt(x: Double) -> Bool {
		if x == floor(x) { return true }
		return false
	}
	
	func isSpecial(n: Int) -> Bool {
		let (b,_) = test(n: n)
		return b
	}
	private func test(n: Int) -> (Bool,Int) {
		if n == 0 { return (false,0) }
		var (sum,k) = (0,1)
		while sum < n {
			sum = sum + k * (k+1) / 2
			if sum == n { return (true,k) }
			k = k + 1
		}
		return (false,k)
	}
	
	func getDesc(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		let str = String(n) + " is a tetrahedral number"
		return str
	}
	
	func getLatex(n: Int) -> String? {
		let (_,k) = test(n: n)
		
		let latex = String(n) + "= \\sum_{k=1}^{" + String(k) + "}\\frac{k\\cdot{(k+1)}}{2}"
		return latex
	}
}


