//
// HappyTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 28.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors


class HappyTester : NumTester {
	
	private func SumOfDigits2(n: BigUInt) -> BigUInt {
		var sum : BigUInt = 0
		var nn = n
		while nn > 0 {
			let digit = nn % 10
			sum = sum + digit * digit
			nn = nn / 10
		}
		return sum
	}
	
	private func TestHappy(h: BigUInt) -> Bool
	{
		var n = h
		while n > 999 { //4 digit numbers cant cycle
			n = SumOfDigits2(n: n)
		}
		var nn = SumOfDigits2(n: n)
		while (nn != n && nn != 1) {
			n = SumOfDigits2(n: n)
			nn = SumOfDigits2(n: SumOfDigits2(n: nn))
		}
		return n == 1
	}
	
	private func HappySequence(n: BigUInt, maxit : Int = 100) -> [BigUInt] {
		var ans : [BigUInt] = [n]
		var p = n
		for i in 0...maxit {
			let sum = SumOfDigits2(n: p)
			ans.append(sum)
			if sum == 1 { return ans }
		}
		return ans
	}
	
	func isSpecial(n: BigUInt) -> Bool {
		guard let seq = OEIS.shared.GetSequence(key: self.property()) else { return false }
		for p in seq {
			if p == n { return true }
			if p > n { return false }
		}
		return TestHappy(h: n)

	}
	
	func getDesc(n: BigUInt) -> String? {
		if isSpecial(n: n) {
			return WikiLinks.shared.getLink(tester: self, n: n)
		}
		return ""
	}
	
	func getLatex(n: BigUInt) -> String? {
		var latex = ""
		var h = n
		while h > 0 {
			var digit2latex = ""
			var (hh,dsum) = (h,BigUInt(0))
			while hh > 0 {
				let digit = hh % 10
				hh = hh / 10
				dsum = dsum + digit * digit
				if digit == 0 { continue }
				if !digit2latex.isEmpty { digit2latex = "+" + digit2latex }
				digit2latex = String(digit) + "^{2}" + digit2latex
			}
			digit2latex = digit2latex + "=" + String(dsum)
			latex = latex + digit2latex
			if dsum == 1 { return latex }
			latex = latex + "\\rightarrow"
			if latex.count > 100 {
				if isSpecial(n: n) {
					latex = latex + "1"
				}
				return latex
			}
			
			h = dsum
		}
		return latex		
	}
	
	func property() -> String {
		return "happy"
	}
}

