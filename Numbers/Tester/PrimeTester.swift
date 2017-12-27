//
//  PrimeTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 10.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors

class PrimeTester : NumTester {
	
	func property() -> String {
		return "prime"
	}
	func isSpecial(n: Int) -> Bool {
		let p = BigUInt(n)
		if PrimeCache.shared.IsPrime(p: p) {
			return true
		}
		return false
	}
	func getDesc(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		let nstr = String(n)
		
		if n<2 { return nil }
		if n==2 { return "2 is the one and only even prime" }
		
		if PrimeCache.shared.IsPrime(p: BigUInt(n+2)) {
			return nstr + " is a twin prime"
		}
		if PrimeCache.shared.IsPrime(p: BigUInt(n-2)) {
			return nstr + " is a twin prime"
		}
		if PrimeCache.shared.IsPrime(p: BigUInt(n+4)) {
			return nstr + " is a cousin prime"
		}
		if PrimeCache.shared.IsPrime(p: BigUInt(n+6)) {
			return nstr + " is a sexy prime"
		}
		return nstr + " is a prime"
	}
	
	private func subset(type : Int) -> String {
		let difstr : String = (type > 0 ) ? "+" + String(type) : String(type)
		let latex = "\\in \\mathbb{P}_{" + String(type) + "}:= \\{ p \\in \\mathbb{P} : p" + difstr + "\\in \\mathbb{P} \\}"
		return latex
	}
	
	func getLatex(n: Int) -> String? {
		if !isSpecial(n: n) { return nil }
		if n<2 { return nil }
		//if n==2 { return "2 is the one and only even prime" }
		let nstr = String(n)
		if PrimeCache.shared.IsPrime(p: BigUInt(n+2)) {
			return nstr + subset(type:2)
		}
		if PrimeCache.shared.IsPrime(p: BigUInt(n-2)) {
			return nstr + subset(type:-2)
		}
		if PrimeCache.shared.IsPrime(p: BigUInt(n+4)) {
			return nstr + subset(type:4)
		}
		if PrimeCache.shared.IsPrime(p: BigUInt(n+6)) {
			return nstr + subset(type:6)
		}
		return nstr + "\\in \\mathbb{P} := \\{ p \\in \\mathbb{N} | \\forall q : q\\mid p \\rightarrow q=1 \\lor q=p \\} \\\\"
	}
}
