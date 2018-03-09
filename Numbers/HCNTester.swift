//
//  HCNTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 30.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class HCNTester : NumTester {
	private func findHCN(n: BigUInt) -> HCNumber.HCN? {
		let hcn = HCNumber.shared.hcnarr
		for h in hcn {
			if h.n == n { return h }
			if h.n > n { return nil }
		}
		return nil
	}
	func isSpecial(n: BigUInt) -> Bool {
		if let hcn = findHCN(n: n) {
			return true
		}
		return false
	}
	
	func getDesc(n: BigUInt) -> String? {
		if let hcn = findHCN(n: n) {
			 var desc = WikiLinks.shared.getLink(tester: self, n: n)
			 desc = desc + " It has " + String(hcn.div)
				desc = desc + " divisors. More than any smaller number"
				return desc
			
		}
		return nil
	}
	
	func getLatex(n: BigUInt) -> String? {
		if n == 1 {
			return "\\tau (1) = 1"
		}
		if let hcn = findHCN(n: n) {
			var latex = ""
			/*
			latex = String(n) + " = "
			for k in 0..<hcn.exponents.count {
				latex = latex + String(HCNumber.shared.primes[k])
			}
			latex = latex + "\\\\"
			*/
			latex = latex + "\\tau (n) = " + String(hcn.div)
			return latex
		}
		return nil
	}
	
	func property() -> String {
		return "highly composite"
	}
	
	
}

class HCNumber {
	
	static let shared = HCNumber()

	let primes : [BigUInt] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59]
	let maxn  = 1000000000000 //00000000
	
	private init() {
		gen_hcn()
	}

	struct HCN : Comparable {
		static func <(lhs: HCNumber.HCN, rhs: HCNumber.HCN) -> Bool {
			return lhs.n < rhs.n
		}
		
		static func ==(lhs: HCNumber.HCN, rhs: HCNumber.HCN) -> Bool {
			return lhs.n == rhs.n
		}
		
		init(n: BigUInt, div: BigUInt, exponents : [Int]) {
			self.n = n
			self.div = div
			self.exponents = exponents
		}
		var n : BigUInt
		var div : BigUInt
		var exponents : [Int]
	}
	private var possible_hcn : [HCN] = []
	private (set) var hcnarr : [HCN] = []
	
	private func gen_hcn() {
		gen_possible_hcn(exponents: [])
		possible_hcn.sort()
		var div : BigUInt = 0
		for (_,hcn) in possible_hcn.enumerated() {
			if hcn.div > div {
				hcnarr.append(hcn)
				div = hcn.div
				print(hcn.n,hcn.div,hcn.exponents)
			}
		}
		possible_hcn = []
	}

	private func gen_possible_hcn(exponents : [Int]) {

		let l = exponents.count
		if l >= primes.count { return }
		var n : BigUInt = 1
		var div : BigUInt = 1
		for i in 0..<l {
			var pipow : BigUInt = 1
			if exponents.count > 0 {
				
				for k in 1...exponents[i] {
					pipow = pipow * primes[i]
				}
				n = n * pipow
				div = div * BigUInt(exponents[i]+1)
				if n > maxn {
					return
				}
			}
		}
			
			let possible = HCN(n: n, div: div, exponents: exponents)
			possible_hcn.append(possible)
			//print(possible)


			var maxe = 60
			if l >= 1 {
				maxe = exponents[l-1]
			}
			for e in 1...maxe {
				var exponents_new = exponents
				exponents_new.append(e)
				gen_possible_hcn(exponents: exponents_new)
			}
		
	}
}

