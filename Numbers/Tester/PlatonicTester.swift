//
//  Platonictester.swift
//  Numbers
//
//  Created by Stephan Jancar on 11.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class PlatonicTester : NumTester {
	
	private var platonic = [4,6,8,12,20]
	func isSpecial(n: BigUInt) -> Bool {
		for p in platonic {
			if BigUInt(p) == n { return true }
		}
		return false
	}

	func getDesc(n: BigUInt) -> String? {
		var desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	
	func getLatex(n: BigUInt) -> String? {
		//n+e-f == 2
		var latex = ""
		switch n {
		case 4:
			latex = "E - K + F = 4 - 6 + 4 = 2 \\text{tetrahedron}"
		case 6:
			latex = "E - K + F = 8 - 12 + 6 = 2 \\text{cube}"
		case 8:
			latex = "E - K + F = 6 - 12 + 8 = 2 \\text{octahedron}"
		case 12:
			latex = "E - K + F = 20 - 30 + 12 = 2 \\text{dodecahedron}"
		case 20:
			latex = "E - K + F = 12 - 30 + 20 = 2 \\text{icosahedron}"
		default:
			return nil
		}
		return latex
	}
	
	func property() -> String {
		return "platonic"
	}
	func propertyString() -> String {
		return "pla\u{00AD}tonic solid"
	}
}
