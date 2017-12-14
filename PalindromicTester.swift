//
//  PalindromicTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 11.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation

class PalindromicTester : NumTester {
	func isSpecial(n: Int) -> Bool {
		if n < 11 { return false }
		let c = Array(String(n))
	
		for i in 0..<c.count {
			if c[i] != c[c.count - i - 1] {
					return false
			}
		}
		return true
	}
	
	func getDesc(n: Int) -> String? {
		return String(n) + " is palindromic"
	}
	
	func getLatex(n: Int) -> String? {
		return ""
	}
	
	func property() -> String {
		return "palindromic"
	}
	
	
}
