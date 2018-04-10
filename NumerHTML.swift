//
//  NumerHTML.swift
//  Numbers
//
//  Created by Stephan Jancar on 01.01.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class WikiLinks {
	
	let wikidefault = "https://en.wikipedia.org/wiki/List_of_numbers"
	static var shared = WikiLinks()
	private (set) var dict : [String:String] = [:]
	
	private init() {
		AddWiki(TriangleTester().property(),"https://en.wikipedia.org/wiki/Triangular_number")
		AddWiki(SquareTester().property(),"https://en.wikipedia.org/wiki/Square_number")
		AddWiki(RamanujanNagellTester().property(),"https://en.wikipedia.org/wiki/Ramanujan–Nagell_equation")
		AddWiki(CubeTester().property(),"https://en.wikipedia.org/wiki/Cube_(algebra)")
		AddWiki("perfect","https://en.wikipedia.org/wiki/Perfect_number")
		AddWiki("pentagonal","https://en.wikipedia.org/wiki/Pentagonal_number")
		AddWiki("hexagonal","https://en.wikipedia.org/wiki/Hexagonal_number")
		AddWiki("abundant","https://en.wikipedia.org/wiki/Abundant_number")
		AddWiki("Carmichael","https://en.wikipedia.org/wiki/Carmichael_number")
		AddWiki(ProbablePrimeTester().property(),"https://en.wikipedia.org/wiki/Probable_prime")
		AddWiki("superabundant","https://en.wikipedia.org/wiki/Superabundant_number")
		AddWiki(LuckyTester().property(),"https://en.wikipedia.org/wiki/Lucky_number")
		AddWiki(HappyTester().property(),"https://en.wikipedia.org/wiki/Happy_number")
		AddWiki(AudioActiveTester().property(),"https://en.wikipedia.org/wiki/Look-and-say_sequence")
		AddWiki(LookAndSayTester().property(),"https://en.wikipedia.org/wiki/Look-and-say_sequence")
		AddWiki("highly composite","https://en.wikipedia.org/wiki/Highly_composite_number")
		AddWiki("prime","https://en.wikipedia.org/wiki/Prime_number")
		AddWiki("composite","https://en.wikipedia.org/wiki/Composite_number")
		AddWiki("twin prime","https://en.wikipedia.org/wiki/Twin_prime")
		AddWiki("cousin prime","https://en.wikipedia.org/wiki/Cousin_prime")
		AddWiki("sexy prime","https://en.wikipedia.org/wiki/Sexy_prime")
		AddWiki("Sophie Germain prime","https://en.wikipedia.org/wiki/Sophie_Germain_prime")
		AddWiki("safe prime","https://en.wikipedia.org/wiki/Safe_prime")
		AddWiki(PalindromicTester().property(),"https://en.wikipedia.org/wiki/Palindromic_number")
		AddWiki(PlatonicTester().property(),"https://en.wikipedia.org/wiki/Platonic_solid")
		AddWiki("nontotient","https://en.wikipedia.org/wiki/Nontotient")
		AddWiki(MersenneTester().property(),"https://en.wikipedia.org/wiki/Mersenne_prime")
		AddWiki(TitanicTester().property(),"https://en.wikipedia.org/wiki/Titanic_prime")
		AddWiki(FermatTester().property(),"https://en.wikipedia.org/wiki/Fermat_number")
		AddWiki(ConstructibleTester().property(),"https://en.wikipedia.org/wiki/Constructible_polygon")
		//AddWiki("Fermat","https://en.wikipedia.org/wiki/Fermat_number")
		AddWiki("Fibonacci","https://en.wikipedia.org/wiki/Fibonacci_number")
		AddWiki("Lucas","https://en.wikipedia.org/wiki/Lucas_number")
		AddWiki("tetrahedral","https://en.wikipedia.org/wiki/Tetrahedral_number")
		AddWiki("Sierpinski","https://en.wikipedia.org/wiki/Sierpinski_number")
		AddWiki("Catalan","https://en.wikipedia.org/wiki/Catalan_number")
		AddWiki("Proth","https://en.wikipedia.org/wiki/Proth_number")
		AddWiki("power of two","https://en.wikipedia.org/wiki/Power_of_two")
		AddWiki("sum of two squares","https://en.wikipedia.org/wiki/Fermat%27s_theorem_on_sums_of_two_squares")
		AddWiki(SumOfTwoCubesTester().property(),"https://en.wikipedia.org/wiki/Sums_of_powers")
		AddWiki(TaxiCabTester().property(),"https://en.wikipedia.org/wiki/Taxicab_number")
		AddWiki("dull","https://en.wikipedia.org/wiki/Interesting_number_paradox")
		AddWiki("supersingular","https://en.wikipedia.org/wiki/Supersingular_prime_(moonshine_theory)")
		AddWiki("Smith","https://en.wikipedia.org/wiki/Smith_number")
		AddWiki("semiprime","https://en.wikipedia.org/wiki/Semiprime")
		AddWiki(HeegnerTester().property(),"https://en.wikipedia.org/wiki/Heegner_number")
		AddWiki(MathConstantTester().property(),"https://en.wikipedia.org/wiki/List_of_mathematical_constants")
		AddWiki(LatticeTester().property(),"https://en.wikipedia.org/wiki/Gauss_circle_problem")
	}
	
	func Address(key :String) -> String {
		if let adress = dict[key] {
			return adress
		}
		return ""
	}
	
	func ExtractLinkToNumber(url: String) -> BigUInt?
	{
		if let range1 = url.range(of: "/wiki/"), let range2 = url.range(of: "_(number)") {
			let ans = url[range1.upperBound..<range2.lowerBound]
			let nr = BigUInt(ans)
			return nr
		}
		return nil
	}
	
	func NumberLink(nr: BigUInt) -> String {
		let ans = "https://en.wikipedia.org/wiki/" + String(nr) + "_(number)"
		return ans
	}
	
	private func AddWiki(_ key : String, _ linkval: String) {
		dict[key] = linkval
	}
	
	func Link(key: String) -> String {
		let adress = Address(key: key)
		if adress.isEmpty { return "" }
		var link = "<a href=\""
		link = link + adress + "\">"
		link = link + key + "</a>"
		return link
	}
	
	func getLink(tester : NumTester, n: BigUInt) -> String {
		var desc = ""
		desc = String(n) + " is a "
		let link = Link(key: tester.property())
		desc = desc + link
		desc = desc + " number."
		return desc
	}
	
	func getTester(link : String) -> NumTester? {
		var property = ""
		for s in dict {
			if s.value.contains(link) {
				property = s.key
				break
			}
		}
		for t in Tester.shared.completetesters {
			if t.property() == property {
				return t
			}
		}
		return nil
	}
	
}
