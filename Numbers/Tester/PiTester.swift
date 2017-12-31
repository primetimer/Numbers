//
//  PiTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 29.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt


enum MathConstantString : Int {
	case pi = 0
	case e
	case root2
	case ln2
	case gamma
	
	static let allValues = [pi,e,root2,ln2,gamma]
	static let name = ["π","e","√2","ln(2)","gamma"]
	static let val = [pistr,estr,root2str,ln2str,gammastr]
	static let pot = [0,0,0,-1,-1]
	
	static let pistr = "31415926535897932384626433832795028841972"
	static let estr = "27182818284590452353602874713526624977572"
	static let root2str = "14142135623730950488016887242096980785697"
	static let ln2str = "69314718055994530941723212145817656807550"
	static let gammastr = "5772156649015328606065120900824024310421"
}

class MathConstantTester : NumTester {
	
	func Nth(n : BigUInt) -> (nth: Int?, hit: MathConstantString? ) {
		let s = String(n)
		for k in 0..<MathConstantString.allValues.count {
			if testStr(nstr: s, cstr: MathConstantString.val[k]) {
				return (s.count,MathConstantString.allValues[k])
			}
		}
		return (nil,nil)
	}

	private func testStr(nstr: String, cstr : String) -> Bool
	{
		let nc = Array(nstr)
		let cc = Array(cstr)
		if nc.count<=1 { return false }
		for i in 0..<nc.count {
			if i >= cc.count-1 { return false }
			if nc[i] != cc[i] { return false }
		}
		return true
	}

	func isSpecial(n: BigUInt) -> Bool {
		let (nth,_) = Nth(n: n)
		if nth == nil { return false }
		return true
	}
	
	func getDesc(n: BigUInt) -> String? {
		let (nth,hit) = Nth(n: n)
		if nth == nil { return nil }
		let hitstr = MathConstantString.name[hit!.rawValue]
		let nthstr = String(nth!)
		var desc = String(n) + " are the first "
		desc = desc + nthstr + " digits of " + hitstr
		return desc
	}
	
	private func getErrLatex(str: String, nth: Int, pot : Int) -> String
	{
		let valc = Array(str)
		let nextdigit = valc[nth]
		var powerr = nth-pot
		var nextdigit1 = ""
		switch nextdigit {
		case "0":
			nextdigit1 = "1"
		case "1":
			nextdigit1 = "2"
		case "2":
			nextdigit1 = "3"
		case "3":
			nextdigit1 = "4"
		case "4":
			nextdigit1 = "5"
		case "5":
			nextdigit1 = "6"
		case "6":
			nextdigit1 = "7"
		case "7":
			nextdigit1 = "8"
		case "8":
			nextdigit1 = "9"
		case "9":
			nextdigit1 = "1"
			powerr = powerr - 1
		default:
			assert(false)
		}
		
		let latex = "\\pm" + nextdigit1 + "\\cdot{10^{-" + String(powerr) + "}}"
		return latex
	}
	
	func getLatex(n: BigUInt) -> String? {
		let (nth,hit) = Nth(n: n)
		var latex = ""
		if let hit = hit, let nth = nth {
			let val = MathConstantString.val[hit.rawValue]
			let pot = MathConstantString.pot[hit.rawValue]
			let errlatex = getErrLatex(str: val, nth: nth, pot : pot)
			var latexname = ""
			switch hit {
			case .pi:
				latexname = "\\pi"
			case .root2:
				latexname = "\\sqrt{2}"
			case .ln2:
				latexname = "ln(2)"
			case .gamma:
				latexname = "\\gamma"
			default:
				latexname = MathConstantString.name[hit.rawValue]
			}
			latex = latexname + " = " + String(n)
			latex = latex + "\\cdot{10^{-" + String(nth-1-pot) + "}}"
			latex = latex + errlatex
		}
		return latex
	}
	
	func property() -> String {
		return "Math Constant"
	}
}




