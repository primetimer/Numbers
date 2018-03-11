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
		Add(PentagonalTester().property(),"A000326",
			[	0, 1, 5, 12, 22, 35, 51, 70, 92, 117, 145, 176, 210, 247, 287, 330, 376, 425, 477, 532, 590, 651, 715, 782, 852, 925, 1001, 1080, 1162, 1247, 1335, 1426, 1520, 1617, 1717, 1820, 1926, 2035, 2147, 2262, 2380, 2501, 2625, 2752, 2882, 3015, 3151
			]
		)
		Add(HexagonalTester().property(),"A000384",
			[	0, 1, 6, 15, 28, 45, 66, 91, 120, 153, 190, 231, 276, 325, 378, 435, 496, 561, 630, 703, 780, 861, 946, 1035, 1128, 1225, 1326, 1431, 1540, 1653, 1770, 1891, 2016, 2145, 2278, 2415, 2556, 2701, 2850, 3003, 3160, 3321, 3486, 3655, 3828, 4005, 4186, 4371, 4560
			]
		)
		Add(AbundanceTester().property(),"A005101",
			[	12, 18, 20, 24, 30, 36, 40, 42, 48, 54, 56, 60, 66, 70, 72, 78, 80, 84, 88, 90, 96, 100, 102, 104, 108, 112, 114, 120, 126, 132, 138, 140, 144, 150, 156, 160, 162, 168, 174, 176, 180, 186, 192, 196, 198, 200, 204, 208, 210, 216, 220, 222, 224, 228, 234, 240, 246, 252, 258, 260, 264, 270
			]
		)
		Add(CarmichaelTester().property(),"A002997",
			[	561, 1105, 1729, 2465, 2821, 6601, 8911, 10585, 15841, 29341, 41041, 46657, 52633, 62745, 63973, 75361, 101101, 115921, 126217, 162401, 172081, 188461, 252601, 278545, 294409, 314821, 334153, 340561, 399001, 410041, 449065, 488881, 512461
			]
		)
		Add(ProbablePrimeTester().property(),"A001567",
			[	561, 1105, 1729, 2465, 2821, 6601, 8911, 10585, 15841, 29341, 41041, 46657, 52633, 62745, 63973, 75361, 101101, 115921, 126217, 162401, 172081, 188461, 252601, 278545, 294409, 314821, 334153, 340561, 399001, 410041, 449065, 488881, 512461
			]
		)
		Add("superabundant","A004394",
			[	1, 2, 4, 6, 12, 24, 36, 48, 60, 120, 180, 240, 360, 720, 840, 1260, 1680, 2520, 5040, 10080, 15120, 25200, 27720, 55440, 110880, 166320, 277200, 332640, 554400, 665280, 720720, 1441440, 2162160, 3603600, 4324320, 7207200, 8648640, 10810800, 21621600]
		)
		Add(HCNTester().property(),"A002182",
			[	1, 2, 4, 6, 12, 24, 36, 48, 60, 120, 180, 240, 360, 720, 840, 1260, 1680, 2520, 5040, 7560, 10080, 15120, 20160, 25200, 27720, 45360, 50400, 55440, 83160, 110880, 166320, 221760, 277200, 332640, 498960, 554400, 665280, 720720, 1081080, 1441440, 2162160]
		)
		Add(LuckyTester().property(),"A000959",
			[
			1, 3, 7, 9, 13, 15, 21, 25, 31, 33, 37, 43, 49, 51, 63, 67, 69, 73, 75, 79, 87, 93, 99, 105, 111, 115, 127, 129, 133, 135, 141, 151, 159, 163, 169, 171, 189, 193, 195, 201, 205, 211, 219, 223, 231, 235, 237, 241, 259, 261, 267, 273, 283, 285, 289, 297, 303]
		)
		Add(FibonacciTester().property(),"A000045",
			[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811, 514229, 832040, 1346269, 2178309, 3524578, 5702887, 9227465, 14930352, 24157817, 39088169, 63245986, 102334155]
		)
		
		Add(TaxiCabTester().property(),"A001235", [1729, 4104, 13832, 20683, 32832, 39312, 40033, 46683, 64232, 65728, 110656, 110808, 134379, 149389, 165464, 171288, 195841, 216027, 216125, 262656, 314496, 320264, 327763, 373464, 402597, 439101, 443889, 513000, 513856, 515375, 525824, 558441, 593047, 684019, 704977])
		
		Add(FermatTester().property(),"A000215", [3, 5, 17, 257, 65537, BigUInt("4294967297")!, BigUInt("18446744073709551617")!, BigUInt("340282366920938463463374607431768211457")!, BigUInt("11579208923731619542357098500868790785326998466564056403945758400791312963993")!])
		
		
		#if false
		AddWiki("twin prime","https://en.wikipedia.org/wiki/Twin_prime")
		AddWiki("cousin prime","https://en.wikipedia.org/wiki/Cousin_prime")
		AddWiki("sexy prime","https://en.wikipedia.org/wiki/Sexy_prime")
		AddWiki("Sophie Germain prime","https://en.wikipedia.org/wiki/Sophie_Germain_prime")
		AddWiki("safe prime","https://en.wikipedia.org/wiki/Safe_prime")
		AddWiki("palindromic","https://en.wikipedia.org/wiki/Palindromic_number")
		AddWiki("nontotient","https://en.wikipedia.org/wiki/Nontotient")
		AddWiki("Mersenne","https://en.wikipedia.org/wiki/Mersenne_prime")
		AddWiki("Fermat","https://en.wikipedia.org/wiki/Fermat_number")
		
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
		
		for t in Tester.shared.complete {
			if t.property() == property {
				return t
			}
		}
		return nil
	}
}
