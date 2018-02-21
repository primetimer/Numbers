//
//  SpokenNumber.swift
//  Numbers
//
//  Created by Stephan Jancar on 11.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class SpokenNumber {
	static let shared = SpokenNumber()
	private init() {
		
	}

	let small = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
	"ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen",
	"eighteen", "nineteen"]
	
	let tens = [ "", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety" ]
	let bigger = [ "", "thousand", "million", "billion" , "trillion", "quadrillion", "quintilion","sextillion","septillion","octillion","Nonillion","Decillion","Undecillion",   "Duodecillion","Tredecillion","Quattuordecillion","Quindecillion","Sexdecillion","Septendecillion","Octodecillion","Novemdecillion","Vigintillion"]
	let hundred = "hundred"
	
	func spoken(n: BigUInt) -> String {
		if n < 20 { return small[Int(n)] }
		if n < 100 {
			var str = tens[Int(n) / 10]
			if n % 10 > 0 {
				str = str + small[Int(n) % 10]
			}
			return str
		}
		if n < 1000 {
			var ans = small[Int(n) / 100] + " " + hundred
			if n % 100 > 0 {
				ans = ans + " and " + spoken(n: n % 100)
			}
			return ans
		}
		
		var (divisor,pot) = (BigUInt(1),0)
		while n / (1000*divisor) > 0 {
			divisor = divisor * 1000
			pot += 3
		}
		let nn = n / divisor
		var ans = spoken(n: nn) + " " + bigger[pot/3]
		if n % divisor > 0 {
			ans = ans + ", " + spoken(n: n % divisor)
		}
		return ans
	}
}
