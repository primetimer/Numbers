//
//  NumerHTML.swift
//  Numbers
//
//  Created by Stephan Jancar on 01.01.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class OEIS {
	
	let oeisdefault = "https://oeis.org"
	static var shared = OEIS()
	private (set) var oeis : [String:String] = [:]
	private (set) var seq : [String:[BigUInt]] = [:]
	
	private init() {
		Add(PrimeTester().property(),"A000040",
			[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271])
		
		Add(TriangleTester().property(),"A000217",
			[0, 1, 3, 6, 10, 15, 21, 28, 36, 45, 55, 66, 78, 91, 105, 120, 136, 153, 171, 190, 210, 231, 253, 276, 300, 325, 351, 378, 406, 435, 465, 496, 528, 561, 595, 630, 666, 703, 741, 780, 820, 861, 903, 946, 990, 1035, 1081, 1128, 1176, 1225, 1275, 1326, 1378, 1431 ])
		Add(SquareTester().property(),"A000290",
			[0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324, 361, 400, 441, 484, 529, 576, 625, 676, 729, 784, 841, 900, 961, 1024, 1089, 1156, 1225, 1296, 1369, 1444, 1521, 1600, 1681, 1764, 1849, 1936, 2025, 2116, 2209, 2304, 2401, 2500])
		Add(CubeTester().property(),"A000578",
			[0, 1, 8, 27, 64, 125, 216, 343, 512, 729, 1000, 1331, 1728, 2197, 2744, 3375, 4096, 4913, 5832, 6859, 8000, 9261, 10648, 12167, 13824, 15625, 17576, 19683, 21952, 24389, 27000, 29791, 32768, 35937, 39304, 42875, 46656, 50653, 54872, 59319, 64000]
			)
		Add(PerfectTester().property(),"A000578",
			[	6, 28, 496, 8128, 33550336, 8589869056, 137438691328, BigUInt("2305843008139952128")!, BigUInt("2658455991569831744654692615953842176")!,
				BigUInt("191561942608236107294793378084303638130997321548169216")!
			]
		)

		#if false
		AddWiki("perfect","https://en.wikipedia.org/wiki/Perfect_number")
		AddWiki("pentagonal","https://en.wikipedia.org/wiki/Pentagonal_number")
		AddWiki("hexagonal","https://en.wikipedia.org/wiki/Hexagonal_number")
		AddWiki("abundant","https://en.wikipedia.org/wiki/Abundant_number")
		AddWiki("Carmichael","https://en.wikipedia.org/wiki/Carmichael_number")
		AddWiki("superabundant","https://en.wikipedia.org/wiki/Superabundant_number")
		AddWiki("lucky","https://en.wikipedia.org/wiki/Lucky_number")
		AddWiki("highly composite","https://en.wikipedia.org/wiki/Highly_composite_number")
		AddWiki("prime","https://en.wikipedia.org/wiki/Prime_number")
		AddWiki("twin prime","https://en.wikipedia.org/wiki/Twin_prime")
		AddWiki("cousin prime","https://en.wikipedia.org/wiki/Cousin_prime")
		AddWiki("sexy prime","https://en.wikipedia.org/wiki/Sexy_prime")
		AddWiki("Sophie Germain prime","https://en.wikipedia.org/wiki/Sophie_Germain_prime")
		AddWiki("safe prime","https://en.wikipedia.org/wiki/Safe_prime")
		AddWiki("palindromic","https://en.wikipedia.org/wiki/Palindromic_number")
		AddWiki("nontotient","https://en.wikipedia.org/wiki/Nontotient")
		AddWiki("Mersenne","https://en.wikipedia.org/wiki/Mersenne_prime")
		AddWiki("Fermat","https://en.wikipedia.org/wiki/Fermat_number")
		AddWiki("Fibonacci","https://en.wikipedia.org/wiki/Fibonacci_number")
		AddWiki("Lucas","https://en.wikipedia.org/wiki/Lucas_number")
		AddWiki("tetrahedral","https://en.wikipedia.org/wiki/Tetrahedral_number")
		AddWiki("Sierpinski","https://en.wikipedia.org/wiki/Sierpinski_number")
		AddWiki("Catalan","https://en.wikipedia.org/wiki/Catalan_number")
		AddWiki("Proth","https://en.wikipedia.org/wiki/Proth_number")
		AddWiki("power of two","https://en.wikipedia.org/wiki/Power_of_two")
		AddWiki("sum of two squares","https://en.wikipedia.org/wiki/Fermat%27s_theorem_on_sums_of_two_squares")
		AddWiki("sum of two cubes","https://en.wikipedia.org/wiki/Sums_of_powers")
		AddWiki("dull","https://en.wikipedia.org/wiki/Interesting_number_paradox")
		AddWiki("supersingular","https://en.wikipedia.org/wiki/Supersingular_prime_(moonshine_theory)")
		AddWiki("Smith","https://en.wikipedia.org/wiki/Smith_number")
		AddWiki("semiprime","https://en.wikipedia.org/wiki/Semiprime")
		#endif
	}
	
	func OEISNumber(key :String) -> String? {
		if let oeis = oeis[key] {
			return oeis
		}
		return nil
	}
	
	private func Add(_ key : String, _ linkval: String, _ sequence : [BigUInt] = [])  {
		oeis[key] = linkval
		seq[key] = sequence
	}
	
	func Address(_ key : String) -> String {
		if let oeis = OEISNumber(key: key) {
			return "https://oeis.org/" + oeis + "/list"
		}
		return oeisdefault
	}
	
	func Link(key: String) -> String {
		let adress = Address(key)
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
		for s in oeis {
			if s.value.contains(link) {
				property = s.key
				break
			}
		}
		if property.isEmpty {
			return nil
		}
		
		for t in Tester.testers {
			if t.property() == property {
				return t
			}
		}
		for t in Tester.xtesters {
			if t.property() == property {
				return t
			}
		}
		return nil
	}
}
