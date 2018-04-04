//
// Lookandsay
//  Numbers
//
//  Created by Stephan Jancar on 28.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors

class AudioActiveTester : NumTester {
	func isSpecial(n: BigUInt) -> Bool {
		if ConwayActive.shared.contains(nr: n) != nil {
			return true
		}
		return false
	}
	
	func latexName(name: String) -> String {
		guard let elem = ConwayActive.shared.contains(name: name) else { return "" }
		let ans = elem.name + "_{" + String(elem.index+1) + "}"
		return ans
	}
	func latexIsotops(elem: ConwayElem) -> String {
		var ans = ""
		for (index,isotop) in elem.isotopes.enumerated() {
			if index > 0 { ans = ans + "+"}
			ans = ans + latexName(name: isotop)
		}
		ans = ans + "=" + elem.dest
		return ans
	}
	
	func getLatex(n: BigUInt) -> String? {
		guard let elem = ConwayActive.shared.contains(nr: n) else { return nil }
		var latex = String(n) + " = " + elem.name + "_{" + String(elem.index+1) + "}"
		latex = latex + "\\rightarrow "
		latex = latex + latexIsotops(elem: elem)
		return latex
	}
	
	func property() -> String {
		return "audioactive"
	}
}

class ConwayPrimordial  {
	private (set) var src : String = ""
	private (set) var dest : String = ""
	
	init(src: String) {
		self.src = src
		self.dest = ConwayElem.LookandSay(look: src)
	}
}

class ConwayElem : ConwayPrimordial {
	internal (set) var index : Int = 0
	internal (set) var name : String = ""
	internal (set) var isotopes : [String] = []
	internal (set) var nr : BigUInt = 0
	
	var graph : [ConwayElem] = []
	
	init(index : Int, src: String, name: String, isotop: String) {
		super.init(src: src)
		self.index = index
		self.name = name
		self.nr = BigUInt(src)!
		self.isotopes = isotop.split(separator: " ").map(String.init)
	}
	
	func Isotops(upto : Int = 92) -> [ConwayElem] {
		var ans : [ConwayElem] = []
//		if self.name == "H" { return ans }
		for s in isotopes {
			guard let sub = ConwayActive.shared.contains(name: s) else {
				assert(false);
				return ans
			}
			if sub.index < upto {
				ans.append(sub)
			}
		}
		return ans
	}
	
	static func LookandSay(look : String) -> String {
		var ans = ""
		let c = Array(look)
		var rep = 1
		var repdigit = c[0]
		if c.count == 1 {
			return "1" + String(c[0])
		}
		for i in 1..<c.count {
			let nextdigit = c[i]
			if nextdigit == repdigit {
				rep = rep + 1
			} else {
				ans = ans + String(rep) + String(repdigit)
				rep = 1
				repdigit = nextdigit
			}
		}
		ans = ans + String(rep) + String(repdigit)
		return ans
	}
	
}
class ConwayActive {
	
	static var shared = ConwayActive()
	private (set) var elems : [ConwayElem] = []
	init() {
		for (index,s) in strelems.enumerated() {
			let elem = ConwayElem(index: index,src: s, name: chemsrc[index],isotop: chemdest[index])
			elems.append(elem)
		}
	}
	
	private func candidate(s: String) -> [ConwayElem] {
		var cand : [ConwayElem] = []
		for e in elems {
			if e.src.count > s.count { continue }
			let index1 = s.index(s.startIndex, offsetBy: e.src.count)
			let substring1 = s[s.startIndex..<index1]
			if e.src == substring1 {
				cand.append(e)
			}
		}
		return cand
	}
	
	private func TestEvolution(elem: String, rest: String, org: String) -> Bool {
		var ref1 = elem
		var ref2 = rest
		var check = org
		for k in 1 ... 10 {
			ref1 = ConwayElem.LookandSay(look: ref1)
			ref2 = ConwayElem.LookandSay(look: ref2)
			check = ConwayElem.LookandSay(look: check)
			if ref1 + ref2 != check {
				print("Incompatible")
					return false
			}
		}
		return true
	}
	
	func ConvertToElems(prim: [ConwayPrimordial]) -> [ConwayElem]?
	{
		var ans : [ConwayElem] = []
		for p in prim {
			if let elem = p as? ConwayElem {
				ans.append(elem)
			}
			else {
				return nil
			}
		}
		return ans
	}
	
	func Compose(s: String) -> [ConwayPrimordial] {
		for e in elems {
			if e.src == s { return [e] }
		}
		var ans : [ConwayPrimordial] = []
		let cand = candidate(s: s)
		for e in cand {
			let index2 = s.index(s.startIndex, offsetBy: e.src.count)
			let rest = s[index2..<s.endIndex]
			if TestEvolution(elem: e.src, rest: String(rest), org: s) {
				ans.append(e)
				let more = Compose(s: String(rest))
				ans.append(contentsOf: more)
				return ans
			}
		}
		
		//Nichts gefunden
		let prim = ConwayPrimordial(src: s)
		return [prim]
	}
		
	func contains(nr: BigUInt) -> ConwayElem? {
		let search = String(nr)
		for e in elems {
			if e.src == search {
				return e
			}
		}
		return nil
	}
	func contains(name: String) -> ConwayElem? {
		for e in elems {
			if e.name == name { return e }
		}
		return nil
	}
	
	private let chemsrc : [String] = ["H","He","Li","Be","B","C",
									  "N","O","F","Ne","Na","Mg",	"Al","Si","P","S",	"Cl",	"Ar","K","Ca","Sc","Ti",
									  "V",	"Cr",	"Mn",	"Fe",	"Co",	"Ni",	"Cu",	"Zn",	"Ga",	"Ge",	"As",
									  "Se",	"Br",	"Kr",	"Rb",	"Sr",	"Y",	"Zr",	"Nb",
									  "Mo",	"Tc",	"Ru",	"Rh",	"Pd",	"Ag",	"Cd",	"In",
									  "Sn",	"Sb",	"Te",	"I",	"Xe",	"Cs",	"Ba",	"La",
									  "Ce",	"Pr",	"Nd",	"Pm",	"Sm",	"Eu",	"Gd",	"Tb",
									  "Dy",	"Ho",	"Er",	"Tm",	"Yb",	"Lu",	"Hf",	"Ta",
									  "W",	"Re",	"Os",	"Ir",	"Pt",	"Au",	"Hg",	"Tl",
									  "Pb",	"Bi",	"Po",	"At",	"Rn",	"Fr",	"Ra",	"Ac",
									  "Th",	"Pa",	"U"]
	
	private let chemdest = ["H",	"Hf Pa H Ca Li",	"He",	"Ge Ca Li",	"Be",	"B",	"C",
							"N",	"O",	"F",	"Ne",	"Pm Na",	"Mg",	"Al",	"Ho Si",
							"P",	"S",	"Cl",	"Ar",	"K",	"Ho Pa H Ca Co",	"Sc",	"Ti",
							"V",	"Cr Si",	"Mn",	"Fe",	"Zn Co",	"Ni",	"Cu",	"Eu Ca Ac H Ca Zn",
							"Ho Ga",	"Ge Na",	"As",	"Se",	"Br",	"Kr",	"Rb",	"Sr U",
							"Y H Ca Tc",	"Er Zr", "Nb",	"Mo",	"Eu Ca Tc",	"Ho Ru",
							"Rh",	"Pd",	"Ag",	"Cd",	"In",	"Pm Sn",	"Eu Ca Sb",	"Ho Te",
							"I",	"Xe",	"Cs",	"Ba",	"La H Ca Co",	"Ce",	"Pr",	"Nd",
							"Pm Ca Zn",	"Sm",	"Eu Ca Co",	"Ho Gd", "Tb",	"Dy",	"Ho Pm",	"Er Ca Co",
							"Tm",	"Yb",	"Lu",	"Hf Pa H Ca W",	"Ta",	"Ge Ca W",	"Re",	"Os",
							"Ir",	"Pt",	"Au",	"Hg",	"Tl",	"Pm Pb",	"Bi",	"Po",
							"Ho At",	"Rn",	"Fr",	"Ra",	"Ac",	"Th",	"Pa"]
	
	private let strelems = [
		"22",
		"13112221133211322112211213322112",
		"312211322212221121123222112",
		"111312211312113221133211322112211213322112",
		"1321132122211322212221121123222112",
		"3113112211322112211213322112",
		"111312212221121123222112",
		"132112211213322112",
		"31121123222112",
		"111213322112",
		"123222112",
		"3113322112",
		"1113222112",
		"1322112",
		"311311222112",
		"1113122112",
		"132112",
		"3112",
		"1112",
		"12",
		"3113112221133112",
		"11131221131112",
		"13211312",
		"31132",
		"111311222112",
		"13122112",
		"32112",
		"11133112",
		"131112",
		"312",
		"13221133122211332",
		"31131122211311122113222",
		"11131221131211322113322112",
		"13211321222113222112",
		"3113112211322112",
		"11131221222112",
		"1321122112",
		"3112112",
		"1112133",
		"12322211331222113112211",
		"1113122113322113111221131221",
		"13211322211312113211",
		"311322113212221",
		"132211331222113112211",
		"311311222113111221131221",
		"111312211312113211",
		"132113212221",
		"3113112211",
		"11131221",
		"13211",
		"3112221",
		"1322113312211",
		"311311222113111221",
		"11131221131211",
		"13211321",
		"311311",
		"11131",
		"1321133112",
		"31131112",
		"111312",
		"132",
		"311332",
		"1113222",
		"13221133112",
		"3113112221131112",
		"111312211312",
		"1321132",
		"311311222",
		"11131221133112",
		"1321131112",
		"311312",
		"11132",
		"13112221133211322112211213322113",
		"312211322212221121123222113",
		"111312211312113221133211322112211213322113",
		"1321132122211322212221121123222113",
		"3113112211322112211213322113",
		"111312212221121123222113",
		"132112211213322113",
		"31121123222113",
		"111213322113",
		"123222113",
		"3113322113",
		"1113222113",
		"1322113",
		"311311222113",
		"1113122113",
		"132113",
		"3113",
		"1113",
		"13",
		"3" ]
}


/*
var elements : [(Int,String,String,BigInt,BigInt)] = [

(1,	"H",	"H" ,	22,	22),
(2,	"He",	"Hf, Pa H Ca Li",	BigInt("13112221133211322112211213322112"),BigInt("11132132212312211322212221121123222112")),
(3,	"Li",	"He",BigInt("312211322212221121123222112"),BigInt("13112221133211322112211213322112")),
(4,"Be",	"Ge Ca Li",
BigInt("111312211312113221133211322112211213322112"),BigInt("3113112221131112211322212312211322212221121123222112")),
(5,"B",	"Be",BigInt("1321132122211322212221121123222112"),BigInt(	"111312211312113221133211322112211213322112")),
(6,"C",	"B",BigInt(	"3113112211322112211213322112"),BigInt("1321132122211322212221121123222112")),
(7,"N",	"C",BigInt(	"111312212221121123222112"	),BigInt("3113112211322112211213322112")),
(8,"O",	"N",BigInt(	"132112211213322112"),BigInt("111312212221121123222112")),
(9,"F",	"O",BigInt(	"31121123222112"),BigInt("132112211213322112")),
(10,	"Ne",	"F",BigInt(	"111213322112"),BigInt("31121123222112")),
(11,"Na",	"Ne",BigInt(	"123222112"),BigInt("111213322112")),
(12,"Mg",	"Pm Na",BigInt(	"3113322112"),BigInt("132123222112")),
(13,"Al",	"Mg",BigInt(	"1113222112"),BigInt("3113322112")),
(14,"Si",	"Al",BigInt(	"1322112"),BigInt("1113222112")),
(15,"P",	"Ho Si",BigInt(	"311311222112"),BigInt("13211321322112")),
(16,"S",	"P",BigInt(	"1113122112"),BigInt("311311222112")),
(17,"Cl",	"S",BigInt(	"132112"),BigInt("1113122112")),
(18,"Ar",	"Cl",BigInt("3112"),BigInt("132112")),


(19,"K","Ar",BigInt("1112"),BigInt("3112"))
(20,"Ca","K",BigInt("12"),BigInt("1112"))
(21,"Sc","Ho Pa H Ca Co",BigInt("3113112221133112"),BigInt("	132113213221232112"))
(22,"Ti","Sc",BigInt("11131221131112"),BigInt("	3113112221133112"))
(23,"V","Ti",BigInt("13211312"),BigInt("	11131221131112"))
(24,"Cr","V",BigInt("31132"),BigInt("	13211312"))
(25,"Mn","Cr Si",BigInt("	111311222112"),BigInt("	311321322112
(26,"Fe","Mn",BigInt("	13122112"),BigInt("	111311222112
(27,"Co	Fe",BigInt("	32112"),BigInt("	13122112
(28,"Ni	Zn Co",BigInt("	11133112"),BigInt("	31232112
(29,"Cu	Ni",BigInt("	131112"),BigInt("	11133112
(30,"Zn	Cu",BigInt("	312"),BigInt("	131112
(31,"Ga	Eu Ca Ac H Ca Zn",BigInt("	13221133122211332"),BigInt("	11132221231132212312
(32,"Ge	Ho Ga",BigInt("	31131122211311122113222"),BigInt("	132113213221133122211332
(33,"As	Ge Na",BigInt("	11131221131211322113322112"),BigInt("	31131122211311122113222123222112
(34,"Se	As",BigInt("	13211321222113222112"),BigInt("	11131221131211322113322112
(35,"Br	Se",BigInt("	3113112211322112"),BigInt("	13211321222113222112
(36,"Kr	Br",BigInt("	11131221222112"),BigInt("	3113112211322112
(37,"Rb	Kr",BigInt("	1321122112"),BigInt("	11131221222112
(38,"Sr	Rb",BigInt("	3112112"),BigInt("	1321122112
(39,"Y	Sr U",BigInt("	1112133"),BigInt("	31121123
(40,"Zr	Y H Ca Tc",BigInt("	12322211331222113112211"),BigInt("	11121332212311322113212221
(41,"Nb	Er Zr",BigInt("	1113122113322113111221131221"),BigInt("	31131122212322211331222113112211

(42,"Mo	Nb",BigInt("	13211322211312113211"),BigInt("	1113122113322113111221131221
43	Tc	Mo	311322113212221	13211322211312113211
44	Ru	Eu Ca Tc	132211331222113112211	111322212311322113212221
45	Rh	Ho Ru	311311222113111221131221	1321132132211331222113112211
46	Pd	Rh	111312211312113211	311311222113111221131221
47	Ag	Pd	132113212221	111312211312113211
48	Cd	Ag	3113112211	132113212221
49	In	Cd	11131221	3113112211
50	Sn	In	13211	11131221
51	Sb	Pm Sn	3112221	13213211
52	Te	Eu Ca Sb	1322113312211	1113222123112221
53	I	Ho Te	311311222113111221	13211321322113312211
54	Xe	I	11131221131211	311311222113111221
55	Cs	Xe	13211321	11131221131211
56	Ba	Cs	311311	13211321
57	La	Ba	11131	311311
58	Ce	La H Ca Co	1321133112	11131221232112
59	Pr	Ce	31131112	1321133112
60	Nd	Pr	111312	31131112
61	Pm	Nd	132	111312
62	Sm	Pm Ca Zn	311332	13212312
63	Eu	Sm	1113222	311332
64	Gd	Eu Ca Co	13221133112	11132221232112
65	Tb	Ho Gd	3113112221131112	132113213221133112
66	Dy	Tb	111312211312	3113112221131112
67	Ho	Dy	1321132	111312211312
68	Er	Ho Pm	311311222	1321132132
69	Tm	Er Ca Co	11131221133112	3113112221232112
70	Yb	Tm	1321131112	11131221133112
71	Lu	Yb	311312	1321131112
72	Hf	Lu	11132	311312
73	Ta	Hf Pa H Ca W	13112221133211322112211213322113	11132132212312211322212221121123222113
74	W	Ta	312211322212221121123222113	13112221133211322112211213322113
75	Re	Ge Ca W	111312211312113221133211322112211213322113	3113112221131112211322212312211322212221121123222113
76	Os	Re	1321132122211322212221121123222113	111312211312113221133211322112211213322113
77	Ir	Os	3113112211322112211213322113	1321132122211322212221121123222113
78	Pt	Ir	111312212221121123222113	3113112211322112211213322113
79	Au	Pt	132112211213322113	111312212221121123222113
80	Hg	Au	31121123222113	132112211213322113
81	Tl	Hg	111213322113	31121123222113
82	Pb	Tl	123222113	111213322113
83	Bi	Pm Pb	3113322113	132123222113
84	Po	Bi	1113222113	3113322113
85	At	Po	1322113	1113222113
86	Rn	Ho At	311311222113	13211321322113
87	Fr	Rn	1113122113	311311222113
88	Ra	Fr	132113	1113122113
89	Ac	Ra	3113	132113
90	Th	Ac	1113	3113
91	Pa	Th	13	1113
92	U	Pa	3	13



*/

class LookAndSayTester : NumTester {
	
	private func Previous(n: BigUInt) -> BigUInt? {
		guard let seq = OEIS.shared.GetSequence(key: self.property()) else { return nil }
		var previus : BigUInt? = nil
		for p in seq {
			if p >= n { return previus }
			previus = BigUInt(p)
		}
		return previus
		
	}
	
	func isSpecial(n: BigUInt) -> Bool {
		if n <= 1 { return false }
		guard let seq = OEIS.shared.GetSequence(key: self.property()) else { return false }
		for p in seq {
			if p == n { return true }
			if p > n { return false }
		}
		return false
	}
	
	func getDesc(n: BigUInt) -> String? {
		if isSpecial(n: n) {
			return WikiLinks.shared.getLink(tester: self, n: n)
		}
		return ""
	}
	
	private func Say(rep: Int, repdigit: Int) -> String {
		let repstr = SpokenNumber.shared.spoken(n: BigUInt(rep))
		return "\\text{" + repstr + " " + String(repdigit) + " }"
	}
	
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		if n <= 1 { return nil }
		guard let prev = Previous(n: n) else { return nil }
		
		var latex = String(n) + "\\leftarrow "
		let s = String(prev)
		let c = Array(s)
		
		var rep = 0
		guard var repdigit = Int(String(c[0])) else { return nil }
		for i in 0..<c.count {
			let nextdigit = Int(String(c[i]))!
			if repdigit == nextdigit {
				rep = rep + 1
			} else {
				latex = latex + Say(rep: rep, repdigit: repdigit) + " "
				rep = 1
				repdigit = nextdigit
			}
		}
		latex = latex + Say(rep: rep, repdigit: repdigit) + " = " + String(prev)
		return latex
	}
	
	func property() -> String {
		return "look & say"
	}
}

