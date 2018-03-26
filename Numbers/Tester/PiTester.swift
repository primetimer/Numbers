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

extension String {
	func asBigFloat() -> BigFloat {
		var pre = ""
		var post = ""
		var postfaktor = BigFloat(1)
		var hasdecimal = false
		for c in self {
			if c == "." {
				hasdecimal = true
				continue
			}
			if hasdecimal {
				postfaktor = postfaktor * BigFloat(10)
				post = post + String(c)
			}
			else {
				pre = pre + String(c)
			}
		}
		let p1 = BigInt(pre) ?? BigInt(0)
		let p2 = BigInt(post) ?? BigInt(0)
		let ans = BigFloat(p1) + BigFloat(p2) / postfaktor
		return ans
	}
}

extension BigFloatConstant {
	static var gamma : BigFloat {
		return "0.5772156649015328606065120900824024310421593359399235988057672348848677267776646709369470632917467495".asBigFloat()
	}
	static var mills: BigFloat {
		return "1.3063778838630806904686144926026057129167845851567136443680537599664340537668265988215014037011973957".asBigFloat()
	}
	static var bruns : BigFloat {
			return "1.902160583104".asBigFloat()
	}
}


enum MathConstantType : Int {
	case pi = 0
	case e
	case gamma
	case mill
	case bruns
	case root2
	case ln2
	case pisquare
	case phi
	case crt2
	
	
	static let allValues = [pi,e,gamma,mill,bruns,root2,ln2,pisquare,phi,crt2]
	static let name = ["π","e","γ","θ","B2","√2","ln(2)","π^2","φ",",∛2",]
	private static let latex = ["\\pi","e","\\gamma","\\theta","B_{2}","\\sqrt{2}","ln(2)","\\pi^2]","\\phi","\\sqrt[3]{2}"]
	
	func asString() -> String {
		return MathConstant.shared.dict[self] ?? ""
	}
	func withPot() -> Int{
		switch self {
		case .pi, .e, .pisquare,.root2,.mill,.phi,.crt2,.bruns:
			return 0
		case .ln2, .gamma:
			return -1
		}
	}
	func Latex() -> String {
		return MathConstantType.latex[self.rawValue]
	}
	func Symbol() -> String {
		return MathConstantType.name[self.rawValue]
	}
	
	func asDouble() -> Double {
		switch self {
		case .pi:
			return Double.pi
		case .e:
			return exp(1.0)
		case .root2:
			return sqrt(2.0)
		case .ln2:
			return log(2.0)
		case .gamma:
			return Double.gamma
		case .mill:
			return Double.mill
		case .pisquare:
			return Double.pi * Double.pi
		case .phi:
			return Double.phi
		case .crt2:
			return pow(2.0,1.0/3.0)
		case .bruns:
			return Double(1.902160583104)
		}
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
			return BigFloatConstant.gamma
		case .mill:
			return BigFloatConstant.mills
		case .bruns:
			return BigFloatConstant.bruns
		case .pisquare:
			return BigFloatConstant.pi2
		case .phi:
			return BigFloatConstant.phi
		case .crt2:
			return BigFloatConstant.crt2
		}
	}
}



class MathConstantTester : NumTester {
	
	internal func FindConst(n : BigUInt) -> (type : MathConstantType, digits: Int)? {
		let nstr = String(n)
		if nstr.count < 3 { return nil }
		//Decimal Digits
		for c in MathConstantType.allValues {
			let cstr = c.asString()
			if testStr(nstr: nstr, cstr: cstr) {
				return (c,nstr.count)
			}
		}
		return nil
	}
	
	internal func FindRational(n: BigUInt) -> (type : MathConstantType, n: BigInt, d: BigInt, index: Int)? {
		for type in MathConstantType.allValues {
			guard let (oeis_n_nr,oeis_d_nr,_) = type.OEISRational() else { continue }
			if !OEIS.shared.ContainsNumber(oeisnr: oeis_n_nr, n: n) { continue }
			guard let seqn = OEIS.shared.GetSequence(oeisnr: oeis_n_nr) else { continue }
			guard let seqd = OEIS.shared.GetSequence(oeisnr: oeis_d_nr) else { continue }
			
			for i in 0..<seqn.count {
				if seqn[i] == n {
					return (type,seqn[i],seqd[i],i)
				}
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
		if n < BigUInt(10) { return false }
		if FindConst(n: n) != nil {
			return true
		}
		if FindRational(n: n) != nil {
			return true
		}
		return false
	}
	
	func getConstant(n: BigUInt) -> String? {
		guard let (type,_) = FindConst(n: n) else { return nil }
		return type.asString()
	}
	
	func getDesc(n: BigUInt) -> String? {
		let desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	
	private func moreLatex(type: MathConstantType) -> String {
		switch type {
		case .pi:
			return "\\frac{4}{\\pi} = \\prod_{k=2}^{\\infty} (1 - \\frac{\\chi(p_k)}{p_k})"
		case .pisquare:
			return "\\frac{6}{\\pi^2} = \\frac{1}{\\zeta(2)} = \\prod_{p \\in \\mathbb{P}} (1-\\frac{1}{p^2})"
		case .ln2:
			return "\\prod_{p \\leq x}(1-\\frac{1}{p}) \\sim \\frac{e^{-\\gamma}}{ln x}"
		case .bruns:
			return "B_2 = \\sum_{p,p+2 \\in \\mathbb{P}} (\\frac{1}{p} + \\frac{1}{p+2})"
		case .gamma:
			return "\\gamma = \\lim\\limits_{n \\rightarrow \\infty}{\\sum_{k=1}^{n} \\frac{1}{k} - ln{ }n}"
		default:
			return ""
		}
	}
	func getLatex(n: BigUInt) -> String? {
		var latex = ""
		var morelatex = ""
		if !isSpecial(n: n) { return nil }
		
		if let (type,digits) = FindConst(n: n)
		{
			let latexname = type.Latex()
			let pot = type.withPot()
			
			latex = String(n)
			latex = latex + "\\cdot{10^{-" + String(digits-1-pot) + "}} \\approx "
			latex = latex + latexname + "=" + String(type.asDouble()) + "..."
			morelatex = moreLatex(type: type)
		}
		if let (type,num,denom,index) = FindRational(n: n) {
			let latexname = type.Latex()
			guard let (_,_,oeiscf) = type.OEISRational() else { return nil }
			if !latex.isEmpty { latex = latex + "\\\\" }
			latex = latex + latexname + " \\approx " + "\\frac{"
			latex = latex + String(num) + "}{" + String(denom) + "} ="
			guard let seq = OEIS.shared.GetSequence(key: oeiscf) else { return nil }
			for i in 0...index {
				if i == 0 {
					latex = latex + String(seq[0]) + " + "
				} else if i < index {
					latex = latex + "\\frac{1}{" + String(seq[i]) + "+\\text{ }}"
				} else if i == index {
					latex = latex + "\\frac{1}{" + String(seq[i]) + "}"
				}
			}
			let morelatex2 = moreLatex(type: type)
			if !morelatex.isEmpty && !morelatex2.isEmpty {
				morelatex = morelatex + "\\\\" + morelatex2
			} else {
				morelatex = morelatex2
			}
		}
		
		if !morelatex.isEmpty {
			latex = latex + "\\\\" + morelatex
		}
		return latex
	}
	
	func property() -> String {
		return "Math Constant"
	}
}

/*
class PiContinuedFractionTester : NumTester {

init() {
if PiContinuedFractionTester.rationals.isEmpty {
ComputeRationals()
}
}
private static var rationals : [(n:BigUInt,d:BigUInt)] = []

private func ComputeRationals() {
guard let seq = OEIS.shared.seq["cfpi"] else { assert(false) }
PiContinuedFractionTester.rationals = ContinuedFractions.shared.RationalSequence(seq: seq)
}
func isSpecial(n: BigUInt) -> Bool {
for r in PiContinuedFractionTester.rationals {
if r.n == n { return true }
if r.n > n { return false }
}
return false
/*
for t in MathConstantType.allValues {
let oeisnr = t.OEISnr()
if OEIS.shared.ContainsNumber(key: <#T##String#>, n: <#T##BigUInt#>)
let isspecial = OEIS.shared.ContainsNumber(key: oeisnr, n: n)
return isspecial
}
*/
}

func getLatex(n: BigUInt) -> String? {
return nil
}

func property() -> String {
return "Numerator for rational pi approximation"
}
}
*/




