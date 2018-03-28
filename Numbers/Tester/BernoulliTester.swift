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

class IrregularTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		if !PrimeTester().isSpecial(n: n) { return false }
		if GetBernoulliDivisor(n: n) != nil {
			return true
		}
		return false
	}
	
	private func GetBernoulliDivisor(n: BigUInt) -> (n: BigInt, index: Int)? {
		
		if n == BigUInt(59) {
			var nom = BigInt(17)*BigInt(59)*BigInt(827)*BigInt(17833331)*BigInt("86023144558386407")
			nom = nom * BigInt("299116358909830276447443337")*BigInt("8417841532399822926231891659")
			return (nom,102)
		}
		
		let oeisn = BernoulliTester().oeisn
		guard let seqn = OEIS.shared.GetSequence(oeisnr: oeisn) else { return nil }
		guard let seqd = OEIS.shared.GetSequence(oeisnr: oeisn) else { return nil }
		for (index,b) in seqn.enumerated() {
			let babs = BigUInt(abs(b))
			if babs <= BigInt(1) { continue }
			if babs % n == 0 {
				let d = seqd[index]
				return (b,index)
			}
		}
		return nil
	}
	
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		if BernoulliTester().isSpecial(n: n) { return nil }
		
		if let (b,_) = GetBernoulliDivisor(n: n) {

			let latex =  String(n) + "\\mid " + String(b) + "\\\\"
			let blatex = BernoulliTester().getLatex(n: BigUInt(abs(b))) ?? ""
			return latex + blatex
			
		}
		return nil
	}
	
	func property() -> String {
		return "Irregular prime"
	}
	
}

