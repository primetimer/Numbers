//
//  PalindromicTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 11.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class ExtraTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		return false
	}
	
	func getDesc(n: BigUInt) -> String? {
		let desc =  WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	
	func getLatex(n: BigUInt) -> String? {
		var latex = ""
		latex = latex + String(n) + " |\\ |M| = 2^{46}·\\cdot{3^{20}}·\\cdot{5^{9}}·\\cdot{7^{6}}·\\cdot{11^{2}}·\\cdot{13^3}\\cdot{} \\\\"
		latex = latex + "\\cdot{17}\\cdot{19}\\cdot{23}\\cdot{29}\\cdot{31}\\cdot{41}·\\cdot{47}·\\cdot{59}\\cdot{71}\\\\"
		
		return latex

	}
	
	func property() -> String {
		return "Extra"
	}
	func subtester() -> [NumTester]? {
		return [ZeroTester(),OneTester()]
	}
	
}

class ZeroTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		if n == 0 { return true }
		return false
	}
	
	func getDesc(n: BigUInt) -> String? {
		let desc =  WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	
	func getLatex(n: BigUInt) -> String? {
		return nil
	}
	
	func property() -> String {
		return "zero"
	}
	
}

class OneTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		if n == 1 { return true }
		return false
	}
	func getDesc(n: BigUInt) -> String? {
		let desc =  WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	func getLatex(n: BigUInt) -> String? {
		return nil
	}
	func property() -> String {
		return "one"
	}
	
}





