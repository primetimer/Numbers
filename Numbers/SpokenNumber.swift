//
//  SpokenNumber.swift
//  Numbers
//
//  Created by Stephan Jancar on 11.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation

class SpokenNumber {
	static let shared = SpokenNumber()
	private init() {
		
	}

	let small = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
	"ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen",
	"eighteen", "nineteen"]
	
	let tens = [ "", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety" ]
	let bigger = [ "", "thousand", "million", "billion" , "trillion", "quadrillion", "quintilion"]
	let hundred = "hundred"
	
	func spoken(n: Int) -> String {
		if n < 20 { return small[n] }
		if n < 100 {
			var str = tens[n / 10]
			if n % 10 > 0 {
				str = str + small[n % 10]
			}
			return str
		}
		if n < 1000 {
			var ans = small[n / 100] + " " + hundred
			if n % 100 > 0 {
				ans = ans + " and " + spoken(n: n % 100)
			}
			return ans
		}
		
		var (divisor,pot) = (1,0)
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
