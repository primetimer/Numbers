//
//  PalindromicTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 11.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

extension BigUInt {
	func asString(toBase : Int) -> String {
		if toBase == 12 {
			return self.Duodezimal()
		}
		if toBase == 20 {
			return self.Vigesimal()
		}
		return String(self,radix:toBase)
	}
}

class PalindromicTester : NumTester {
	private let radix = [10,2,16,12,20]
	func isSpecial(n: BigUInt) -> Bool {
		if n < 11 { return false }
		let pbase = PalindromicBase(n: n)
		if pbase.isEmpty { return false }
		return true
	}
	
	func PalindromicBase(n: BigUInt) -> [Int] {
		var ans : [Int] = []
		for r in radix {
			let s = String(n,radix :r)
			if ispalindromicString(s: s) {
				ans.append(r)
			}
		}
		return ans
	}
	
	private func ispalindromicString(s : String) -> Bool
	{
		let c = Array(s)
		if c.count <= 1 { return false }
		for i in 0..<c.count {
			if c[i] != c[c.count - i - 1] {
				return false
			}
		}
		return true
	}
	
	func getDesc(n: BigUInt) -> String? {
		var desc = WikiLinks.shared.getLink(tester: self, n: n)
		let pbase = PalindromicBase(n: n)
		if pbase.count == 0 { return nil }
		
		if pbase.count == 1 && pbase[0] == 10 {
			return desc
		}
		desc = desc + " It is palindromic in base:"
		for b in pbase {
			desc = desc + String(b) + " "
		}
		return desc
	}
	
	func getLatex(n: BigUInt) -> String? {
		let pbase = PalindromicBase(n: n)
		if pbase.count == 0 { return nil }
		var latex = String(n)
		for b in pbase {
			var nstr = n.asString(toBase: b)
			latex = latex + " = " + String(n,radix : b).uppercased() + "_{" + String(b) + "}"
		}
		return latex

	}
	
	func property() -> String {
		return "palindromic"
	}
	
	
}
