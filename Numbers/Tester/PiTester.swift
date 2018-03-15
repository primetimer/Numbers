//
//  PiTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 29.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import BigFloat


enum MathConstantType : Int {
	case pi = 0
	case e
	case root2
	case ln2
	case gamma
	case mill
	case pisquare
	
	static let allValues = [pi,e,root2,ln2,gamma,mill,pisquare]
	static let name = ["π","e","√2","ln(2)","θ","π^2"]
	private static let latex = ["\\pi","e","\\sqrt{2}","ln(2)","\\gamma","\\mill","\\pi^2]"]
	
	func asString() -> String {
		return MathConstant.shared.dict[self] ?? ""
	}
	func withPot() -> Int{
		switch self {
		case .pi, .e, .pisquare,.root2,.mill:
			return 0
		case .ln2, .gamma:
			return -1
		}
	}
	func Latex() -> String {
		return MathConstantType.latex[self.rawValue]
	}
}



class MathConstant {
	let precision = 1000
	var dict : [MathConstantType:String] = [:]
	static var shared = MathConstant()
	private init() {
		for type in MathConstantType.allValues {
			let val = Value(type: type)
			let s = val.asString(10, maxlen: 1000, fix: 1000)
			let s0 = s.replacingOccurrences(of: "0.", with: "")
			let s1 = s0.replacingOccurrences(of: ".", with: "")
			dict[type] = s1
		}
	}
	
	private func Value(type : MathConstantType) -> BigFloat {
		switch type {
		case .pi:
			return BigFloatConstant.pi
		case .e:
			return BigFloatConstant.e
		case .root2:
			return BigFloatConstant.sqrt2
		case .ln2:
			return BigFloatConstant.ln2
		case .gamma:
			return BigFloat("5772156649015328606065120900824024310421593359399235988057672348848677267776646709369470632917467495")
		case .mill:
			return BigFloat("13063778838630806904686144926026057129167845851567136443680537599664340537668265988215014037011973957")
				case .pisquare:
			return BigFloatConstant.pi2
		}
	}
}



class MathConstantTester : NumTester {
	
	private func FindConst(n : BigUInt) -> (type : MathConstantType, digits: Int, const: String)? {
		let nstr = String(n)
		for c in MathConstantType.allValues {
			let cstr = c.asString()
			if testStr(nstr: nstr, cstr: cstr) {
				return (c,nstr.count, cstr)
			}
		}
		return nil
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
		if FindConst(n: n) == nil {
			return false
		}
		return true
	}
	
	func getConstant(n: BigUInt) -> String? {
		guard let (_,_,const) = FindConst(n: n) else { return nil }
		return const
	}
	
	func getDesc(n: BigUInt) -> String? {
		let desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	
	func getLatex(n: BigUInt) -> String? {
		guard let (type,digits,_) = FindConst(n: n) else { return nil}
		var latex = ""
		var morelatex = ""
		let pot = type.withPot()
		let latexname = type.Latex()
		switch type {
		case .pi:
			morelatex = "\\frac{4}{\\pi} = \\prod_{k=2}^{\\infty} (1 - \\frac{\\chi(p_k)}{p_k})"
		case .pisquare:
			morelatex = "\\frac{6}{\\pi^2} = \\frac{1}{\\zeta(2)} = \\prod_{p \\in \\mathbb{P}} (1-\\frac{1}{p^2})"
		case .ln2:
			morelatex = "\\prod_{p \\leq x}(1-\\frac{1}{p}) \\sim \\frac{e^{-\\gamma}}{ln x}"
		default:
			break
		}
		latex = latexname + " \\approx " + String(n)
		latex = latex + "\\cdot{10^{-" + String(digits-1-pot) + "}}"
		if !morelatex.isEmpty {
			latex = latex + "\\\\" + morelatex
		}
		return latex
	}
	
	func property() -> String {
		return "Math Constant"
	}
}




