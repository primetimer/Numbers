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
	
	static var shared = WikiLinks()
	private (set) var dict : [String:String] = [:]
	private let wiki = "https://en.wikipedia.org/wiki/"
	private init() {
		AddWiki("triangle","https://en.wikipedia.org/wiki/Triangular_number")
		AddWiki("square","https://en.wikipedia.org/wiki/Square_number")
		AddWiki("cube","https://en.wikipedia.org/wiki/Cube_(algebra)")
		AddWiki("perfect","https://en.wikipedia.org/wiki/Perfect_number")
		AddWiki("pentagonal","https://en.wikipedia.org/wiki/Pentagonal_number")
		AddWiki("hexagonal","https://en.wikipedia.org/wiki/Hexagonal_number")
		AddWiki("abundant","https://en.wikipedia.org/wiki/Abundant_number")
		AddWiki("superabundant","https://en.wikipedia.org/wiki/Superabundant_number")
		AddWiki("lucky","https://en.wikipedia.org/wiki/Lucky_number")
		AddWiki("highly composite","https://en.wikipedia.org/wiki/Highly_composite_number")
		AddWiki("prime","https://en.wikipedia.org/wiki/Prime_number")
		AddWiki("twin prime","https://en.wikipedia.org/wiki/Twin_prime")
		AddWiki("cousin prime","https://en.wikipedia.org/wiki/Cousin_prime")
		AddWiki("sexy prime","https://en.wikipedia.org/wiki/Sexy_prime")
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
	}
	
	func Link(key :String) -> String {
		if let link = dict[key] {
			return link
		}
		return ""
	}
	
	private func AddWiki(_ key : String, _
		linkval: String) {
		var link = "<a href=\""
		link = link + linkval + "\">"
		link = link + key + "</a>"
		dict[key] = link
	}
	
	func getLink(tester : NumTester, n: BigUInt) -> String {
		var desc = ""
		desc = String(n) + " is a "
		let link = Link(key: tester.property())
		desc = desc + link
		desc = desc + " number."
		return desc
	}
	
}
