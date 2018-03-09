//
//  NumerHTML.swift
//  Numbers
//
//  Created by Stephan Jancar on 01.01.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class NumberphileLinks {
	
	private let philosophy = ["https://www.youtube.com/watch?v=vA2cdHLKYB8]",
					"https://www.youtube.com/watch?v=1EGDCh75SpQ",
					"https://youtu.be/p_Hqdqe84Uc",
					"https://youtu.be/SxP30euw3-0",
					"https://youtu.be/PFkZGpN4wmM",
					"https://youtu.be/CfoKor05k1I"
		]
	private func Philosophy() -> String {
		let n = Int(arc4random_uniform(UInt32(philosophy.count)))
		return philosophy[n]
	}
					
	static var shared = NumberphileLinks()
	private (set) var dict : [(key: String, val:String)] = []
	private let wiki = "https://en.wikipedia.org/wiki/"
	private init() {
		AddTube("prime","https://youtu.be/ctC33JAV4FI?list=PL0D0BD149128BB06F")
		AddTube("0","https://youtu.be/BRRolKTlF6Q")
		AddTube("2","https://youtu.be/pKwsPBeSiOc")
		//AddTube("4","https://youtu.be/pKwsPBeSiOc")
		//AddTube("8","https://youtu.be/pKwsPBeSiOc")
		//AddTube("16","https://youtu.be/pKwsPBeSiOc")
		//AddTube("32","https://youtu.be/pKwsPBeSiOc")
		//AddTube("64","https://youtu.be/pKwsPBeSiOc")
		//AddTube("128","https://youtu.be/pKwsPBeSiOc")
		//AddTube("256","https://youtu.be/pKwsPBeSiOc")
		//AddTube("1024","https://youtu.be/pKwsPBeSiOc")
		//AddTube("65536","https://youtu.be/pKwsPBeSiOc")
		AddTube("power of two","https://youtu.be/pKwsPBeSiOc")
		
		AddTube("1","https://www.youtube.com/watch?v=IQofiPqhJ_s")
		AddTube("1","https://youtu.be/x-fUDqXlmHM")
		AddTube("3","https://youtu.be/3P6DWAwwViU")
		AddTube("3","https://youtu.be/UfEiJJGv4CE")
		AddTube("4","https://youtu.be/Noo4lN-vSvw")
		AddTube("5","https://www.youtube.com/watch?v=QTrM-UVcgBY")
		AddTube("5","https://youtu.be/LNS1fabDkeA")
		AddTube("6","https://youtu.be/UkZqFtYtqaI")
		AddTube("666","https://youtu.be/UkZqFtYtqaI")
		AddTube("666","https://youtu.be/mlqAvhjxAjo")	//Smith number
		
		AddTube("82000","https://youtu.be/LNS1fabDkeA")
		
		AddTube("7","https://youtu.be/kC6YObu61_w")
		AddTube("8","https://youtu.be/fjEB_wbemQA")
		AddTube("9","https://youtu.be/FlndIiQa20o")
		
		AddTube("10","https://youtu.be/1GCf29FPM4k")
		AddTube("100","https://youtu.be/1GCf29FPM4k")
		AddTube("1000","https://youtu.be/1GCf29FPM4k")
		AddTube("10000","https://youtu.be/1GCf29FPM4k")
		AddTube("100000","https://youtu.be/1GCf29FPM4k")
		AddTube("1000000","https://youtu.be/1GCf29FPM4k")
		
		
		
		
		AddTube("11","https://youtu.be/sPFWfAxIiwg")
		AddTube("12","https://youtu.be/U6xJfP7-HCc")
		AddTube("12","https://www.youtube.com/watch?v=w-I6XTVZXww&t=156s")
		AddTube("14","https://youtu.be/bFfSfzjhfC8")
		AddTube("15","https://youtu.be/Oev332D0K0I")
		AddTube("16","https://youtu.be/mLQNvuZH3GU")
		//AddTube("17","https://www.youtube.com/watch?v=MlyTq-xVkQE2")
		AddTube("17","https://youtu.be/87uo2TPrsl8")
		AddTube("20","https://youtu.be/yF2J39Xny4Q")
		AddTube("23","https://youtu.be/a2ey9a70yY0")
		AddTube("27","https://youtu.be/euAHY9hqRN4")
		AddTube("29","https://youtu.be/-O4mYiP2zPQ")
		AddTube("31","https://youtu.be/sJVivjuMfWA")
		AddTube("314","https://youtu.be/sJVivjuMfWA")
		AddTube("31","https://youtu.be/UkKVT2aU6Yg")
		AddTube("314","https://youtu.be/UkKVT2aU6Yg")
		AddTube("31","https://youtu.be/HrRMnzANHHs")
		AddTube("314","https://youtu.be/HrRMnzANHHs")
		AddTube("31","https://youtu.be/ZoaEPXEcLFI")
		AddTube("314","https://youtu.be/ZoaEPXEcLFI")
		
		
		AddTube("33","https://www.youtube.com/watch?v=wymmCdLdPvM")
		AddTube("34","https://youtu.be/A25pxcYstHM")
		AddTube("37","https://youtu.be/EJRXWNWJOrQ")
		AddTube("41","https://youtu.be/3K-12i0jclM")
		AddTube("42","https://youtu.be/D6tINlNluuY")
		AddTube("52","https://youtu.be/Y2lXsxmBx7E")
		AddTube("58","https://youtu.be/l4bmZ1gRqCc2")
		AddTube("60","https://youtu.be/R9m2jck1f90")
		AddTube("70","https://www.youtube.com/watch?v=vkMXdShDdtY")
		
		AddTube("70000000","https://www.youtube.com/watch?v=vkMXdShDdtY")
		AddTube("74","https://www.youtube.com/watch?v=_-M_3oV75Lw&t=3s")
		AddTube("83","https://youtu.be/4mEk7d8oRho")
		
		AddTube("129","https://www.youtube.com/watch?v=YQw124CtvO0&t=28s")
		AddTube("137","https://www.youtube.com/watch?v=yu_aqA7mw7E")
		AddTube("137","https://youtu.be/yu_aqA7mw7E")
		AddTube("153","https://youtu.be/4aMtJ-V26Z4")
		AddTube("163","https://www.youtube.com/watch?v=DRxAVA6gYMM&t=35s")
		AddTube("163","https://youtu.be/DRxAVA6gYMM")
		AddTube("176","https://youtu.be/aTSYARnB-3Y")
		AddTube("196","https://www.youtube.com/watch?v=bN8PE3eljdA")
		AddTube("383","https://youtu.be/PQDvEJFdY1U")
		AddTube("399","https://youtu.be/yfr3BIk6KFc")
		
		AddTube("400","https://youtu.be/Cn3ogzLzxuM")
		AddTube("1729","https://www.youtube.com/watch?v=LzjaDKVC4iY")
		AddTube("1729","https://youtu.be/_o0cIpLQApk")

		AddTube("4669","https://www.youtube.com/watch?v=ETrYE4MdoLQ&t=13s")
		
		AddTube("5040","https://www.youtube.com/watch?v=2JM2oImb9Qg&t=106s")
		AddTube("8128","https://youtu.be/ZfKTD5lvToE")
			AddTube("78557","https://youtu.be/fcVjitaM3LY")
		AddTube("196883","https://youtu.be/jsSeoGpiWsw")
		AddTube("supersingular","https://youtu.be/jsSeoGpiWsw")
		/*
		AddTube("71","https://youtu.be/jsSeoGpiWsw")
		AddTube("59","https://youtu.be/jsSeoGpiWsw")
		AddTube("47","https://youtu.be/jsSeoGpiWsw")
		AddTube("41","https://youtu.be/jsSeoGpiWsw")
		AddTube("31","https://youtu.be/jsSeoGpiWsw")
		AddTube("29","https://youtu.be/jsSeoGpiWsw")
		AddTube("23","https://youtu.be/jsSeoGpiWsw")
		AddTube("19","https://youtu.be/jsSeoGpiWsw")
		AddTube("17","https://youtu.be/jsSeoGpiWsw")
		*/
		
		
		
		
		
		
		
		
		
		AddTube("8848","https://youtu.be/CMUI6m8ZMwg")

		AddTube("big","https://youtu.be/3P6DWAwwViU")
		AddTube("big","https://youtu.be/Lihh_lMmcDw")
		AddTube("big","https://youtu.be/txajrEOTkuY")
		AddTube("big","https://youtu.be/e0xJwdcpATM")
		AddTube("big","https://youtu.be/8GEebx72-qs")
		
		
		AddTube("scale","https://youtu.be/C-52AI_ojyQ")
		AddTube("pi","https://youtu.be/sJVivjuMfWA")
		AddTube("pi","https://youtu.be/UkKVT2aU6Yg")
		AddTube("pi","https://youtu.be/HrRMnzANHHs")
		AddTube("pi","https://youtu.be/ZoaEPXEcLFI")
		
		AddTube("triangle","https://youtu.be/xu-RSUGBgpA")
		AddTube("square","https://youtu.be/NoRjwZomUK0")
		AddTube("Proth","https://youtu.be/fcVjitaM3LY")
		AddTube("Catalan","https://youtu.be/eoofvKI_Okg")
		AddTube("twin prime","https://www.youtube.com/watch?v=vkMXdShDdtY")
		AddTube("cousin prime","https://www.youtube.com/watch?v=vkMXdShDdtY")
		AddTube("sexy prime","https://youtu.be/WJ12DYBuazY")
		
		AddTube("prime","https://youtu.be/BH1GMGDYndo")
		AddTube("twin prime","https://youtu.be/BH1GMGDYndo")
		AddTube("cousin prime","https://youtu.be/BH1GMGDYndo")
		AddTube("sexy prime","https://youtu.be/BH1GMGDYndo")
		AddTube("Smith","https://youtu.be/mlqAvhjxAjo")
			
		AddTube("Fibonacci","https://youtu.be/DRjFV_DETKQ")
		AddTube("perfect","https://youtu.be/T0xKHwQH-4I")
		AddTube("Mersenne","https://youtu.be/T0xKHwQH-4I")
		AddTube("Mersenne","https://youtu.be/lEvXcTYqtKU")
		AddTube("Mersenne","https://youtu.be/tlpYjrbujG0")
		AddTube("highly composite","https://youtu.be/PF2GtiApF3E")
		AddTube("Lucas","https://youtu.be/PeUbRXnbmms")
		AddTube("abundant","https://youtu.be/8Ag6Ao1PNbI")
		AddTube("superabundant","https://youtu.be/8Ag6Ao1PNbI")
		AddTube("nontotient","https://youtu.be/8Ag6Ao1PNbI")
		AddTube("perfect","https://youtu.be/ZfKTD5lvToE")
		AddTube("lucky","https://youtu.be/RxxDD2LWAyY")
		AddTube("palindrome","https://youtu.be/bN8PE3eljdA")
		
		AddTube("sum of two squares","https://youtu.be/yu_aqA7mw7E")
		AddTube("sum of two cubes","https://youtu.be/_o0cIpLQApk")
		AddTube("dull","https://youtu.be/ygqIfLHGTu4")
		AddTube("dull","https://youtu.be/_YysNM2JoFo")
		AddTube("dull","https://youtu.be/FK3kifY-geM")
		
		/*


		AddTube("pentagonal","https://en.wikipedia.org/wiki/Pentagonal_number")
		AddTube("hexagonal","https://en.wikipedia.org/wiki/Hexagonal_number")
		
		AddTube("palindromic","https://en.wikipedia.org/wiki/Palindromic_number")
		AddTube("","https://en.wikipedia.org/wiki/Nontotient")
		
		AddTube("Fermat","https://en.wikipedia.org/wiki/Fermat_number")
	
		AddTube("tetrahedral","https://en.wikipedia.org/wiki/Tetrahedral_number")
		AddTube("Sierpinski","https://en.wikipedia.org/wiki/Sierpinski_number")

		*/
	}
	
	private func Link(key :String) -> String {
		var possible : [String] = []
		for d in dict {
			if d.key == key {
				possible.append(d.val)
			}
		}
		if possible.isEmpty { return "" }
		let r = Int(arc4random_uniform(UInt32(possible.count)))
		return possible[r]
	}
	
	private func AddTube(_ key : String, _ linkval: String) {
		dict.append((key:key,val:linkval))
	}
	
	private func getTubeNr(n: BigUInt) -> String? {
		let str = String(n)
		let link = Link(key: str)
		if link.isEmpty { return nil }
		
		if n == 0 && arc4random_uniform(2) == 0 {
			return Philosophy()
		}
		return link
	}
	
	func getTube(n: BigUInt) -> String {
		if let link = getTubeNr(n: n) {
			return link
		}
		var possible : [String] = []
		for t in Tester.shared.complete {
			if t.isSpecial(n: n) {
				if let link = getLink(tester: t) {
					possible.append(link)
				}
			}
		}
		if possible.count == 0 {
			return Philosophy()
		}
		let r = Int(arc4random_uniform(UInt32(possible.count)))
		return possible[r]
	}
	
	private func getLink(tester : NumTester) -> String? {
		let linkprop = Link(key: tester.property())
		if !linkprop.isEmpty { return linkprop }
		return nil
	}
}
