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
	
	static var shared = NumberphileLinks()
	private (set) var dict : [String:String] = [:]
	private let wiki = "https://en.wikipedia.org/wiki/"
	private init() {
		AddTube("prime","https://youtu.be/ctC33JAV4FI?list=PL0D0BD149128BB06F")
		
		AddTube("1","https://www.youtube.com/watch?v=IQofiPqhJ_s")
		AddTube("129","https://www.youtube.com/watch?v=YQw124CtvO0&t=28s")
		AddTube("4669","https://www.youtube.com/watch?v=ETrYE4MdoLQ&t=13s")
		AddTube("33","https://www.youtube.com/watch?v=wymmCdLdPvM")
		AddTube("196","https://www.youtube.com/watch?v=bN8PE3eljdA")
		AddTube("5040","https://www.youtube.com/watch?v=2JM2oImb9Qg&t=106s")
		AddTube("74","https://www.youtube.com/watch?v=_-M_3oV75Lw&t=3s")
		AddTube("17","https://www.youtube.com/watch?v=MlyTq-xVkQE2")
		AddTube("5","https://www.youtube.com/watch?v=QTrM-UVcgBY")
		AddTube("137","https://www.youtube.com/watch?v=yu_aqA7mw7E")
		AddTube("163","https://www.youtube.com/watch?v=DRxAVA6gYMM&t=35s")
		AddTube("1729","https://www.youtube.com/watch?v=LzjaDKVC4iY")
		AddTube("12","https://www.youtube.com/watch?v=w-I6XTVZXww&t=156s")
		AddTube("70","https://www.youtube.com/watch?v=vkMXdShDdtY")
		AddTube("70000000","https://www.youtube.com/watch?v=vkMXdShDdtY")

		
		
		/*
		AddTube("triangle","https://en.wikipedia.org/wiki/Triangular_number")
		AddTube("square","https://en.wikipedia.org/wiki/Square_number")
		AddTube("cube","https://en.wikipedia.org/wiki/Cube_(algebra)")
		AddTube("perfect","https://en.wikipedia.org/wiki/Perfect_number")
		AddTube("pentagonal","https://en.wikipedia.org/wiki/Pentagonal_number")
		AddTube("hexagonal","https://en.wikipedia.org/wiki/Hexagonal_number")
		AddTube("abundant","https://en.wikipedia.org/wiki/Abundant_number")
		AddTube("superabundant","https://en.wikipedia.org/wiki/Superabundant_number")
		AddTube("lucky","https://en.wikipedia.org/wiki/Lucky_number")
		AddTube("highly composite","https://en.wikipedia.org/wiki/Highly_composite_number")
		
		AddTube("twin prime","https://en.wikipedia.org/wiki/Twin_prime")
		AddTube("cousin prime","https://en.wikipedia.org/wiki/Cousin_prime")
		AddTube("sexy prime","https://en.wikipedia.org/wiki/Sexy_prime")
		AddTube("palindromic","https://en.wikipedia.org/wiki/Palindromic_number")
		AddTube("nontotient","https://en.wikipedia.org/wiki/Nontotient")
		AddTube("Mersenne","https://en.wikipedia.org/wiki/Mersenne_prime")
		AddTube("Fermat","https://en.wikipedia.org/wiki/Fermat_number")
		AddTube("Fibonacci","https://en.wikipedia.org/wiki/Fibonacci_number")
		AddTube("Lucas","https://en.wikipedia.org/wiki/Lucas_number")
		AddTube("tetrahedral","https://en.wikipedia.org/wiki/Tetrahedral_number")
		AddTube("Sierpinski","https://en.wikipedia.org/wiki/Sierpinski_number")
		AddTube("Catalan","https://en.wikipedia.org/wiki/Catalan_number")
		AddTube("Proth","https://en.wikipedia.org/wiki/Proth_number")
		AddTube("power of two","https://en.wikipedia.org/wiki/Power_of_two")
		AddTube("sum of two squares","https://en.wikipedia.org/wiki/Fermat%27s_theorem_on_sums_of_two_squares")
		AddTube("sum of two cubes","https://en.wikipedia.org/wiki/Sums_of_powers")
		AddTube("dull","https://en.wikipedia.org/wiki/Interesting_number_paradox")
		*/
	}
	
	private func Link(key :String) -> String {
		if let link = dict[key] {
			return link
		}
		return ""
	}
	
	private func AddTube(_ key : String, _ linkval: String) {
		dict[key] = linkval
	}
	
	private func getTubeNr(n: BigUInt) -> String? {
		let str = String(n)
		let link = Link(key: str)
		if link.isEmpty { return nil }
		return link
	}
	
	func getTube(n: BigUInt) -> String {
		if let link = getTubeNr(n: n) {
			return link
		}
		for t in Tester.testers {
			if t.isSpecial(n: n) {
				if let link = getLink(tester: t) {
					return link
				}
			}
		}
		return "https://www.youtube.com/watch?v=1EGDCh75SpQ"
	}
	
	private func getLink(tester : NumTester) -> String? {
		let linkprop = Link(key: tester.property())
		if !linkprop.isEmpty { return linkprop }
		return nil
	}
}
