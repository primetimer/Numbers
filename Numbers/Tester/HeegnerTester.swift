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

class HeegnerTester : NumTester {
	func getDesc(n: BigUInt) -> String? {
		let desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		var latex = "\\mathbb{Q} [\\sqrt{-" + String(n) + "}] \\text{has unique prime factorization}"
		switch Int(n) {
		case 19:
			latex = latex + "\\\\e^{\\pi\\sqrt{-19}} \\approx 96^3 + 744 - 0.2"
		case 43:
			latex = latex + "\\\\e^{\\pi\\sqrt{-43}} \\approx 960^3 + 744 - 0.000001"
		case 67:
			latex = latex + "\\\\e^{\\pi\\sqrt{-67}} \\approx 5280^3 + 744 - 0.0002"
		case 163:
			latex = latex + "\\\\e^{\\pi\\sqrt{-163}} \\approx 640320^3 + 744 - 0.0000000000008"
		default:
			break
		}
		return latex
	}
	
	func property() -> String {
		return "Heegner"
	}
	
	func isSpecial(n: BigUInt) -> Bool {
		if let seq = OEIS.shared.seq[property()] {
			if seq.contains(n) {
				return true
			}
			return false
		}
		assert(false)
	}
}

