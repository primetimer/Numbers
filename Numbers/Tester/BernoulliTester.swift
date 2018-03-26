//
//  HCNTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 30.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class BernoulliTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		if n < 5 { return false }
		if  OEIS.shared.NumberIndex(oeisnr: oeisn, n: n, ordered: false) != nil {
			return true
		}
		return false
	}
	
	let (oeisn,oeisd) = ("A027641","A027642")
	
	func getDesc(n: BigUInt) -> String? {
		return WikiLinks.shared.getLink(tester: self, n: n)
	}
	
	func getLatex(n: BigUInt) -> String? {
		guard let index = OEIS.shared.NumberIndex(oeisnr: oeisn, n: n, ordered: false) else { return nil }
		guard let seqn = OEIS.shared.GetSequence(oeisnr: oeisn) else { return nil }
		guard let seqd = OEIS.shared.GetSequence(oeisnr: oeisd) else { return nil }
		let bn = seqn[index]
		let bd = seqd[index]
		
		var latex = "\\frac{" + String(bn) + "}{" + String(bd) + "} = "
		latex = latex + "B_{" + String(index) + "} = "
		latex = latex + "\\frac{(-1)^{ " + String(index/2+1) + "} \\cdot{2}\\cdot{"  + String(index) + "!}}"
		latex = latex + "{(2\\pi)^{" + String(index) + "}} \\zeta(" + String(index) + ")"
		return latex
	}
	
	func property() -> String {
		return "Bernoulli numerator"
	}
	
	
}

