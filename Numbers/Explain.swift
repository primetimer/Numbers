//
//  Explain.swift
//  Numbers
//
//  Created by Stephan Jancar on 07.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation

class Explain {
	
	static let shared = Explain()
	
	private var dict : [Int:Explanation] = [:]
	private init() {
		dict[0] = Explanation(nr: 0)
		dict[1] = Explanation(nr: 1)
	}
	
	func GetExplanation(nr : Int) -> Explanation {
		if let ex = dict[nr] {
			return ex
		}
		return Explanation(nr: nr)
	}	
}

class Explanation {
	
	internal (set) var nr : Int
	internal (set) var desc = ""
	internal (set) var latex = ""
	
	init(nr: Int) {
		self.nr = nr
		switch nr {
		case 0:
			Zero()
		case 1:
			One()
		case 2:
			Two()
		case 3:
			Three()
		case 4:
			Four()
		case 5:
			Five()
		case 6:
			Six()
		case 7:
			Seven()
		case 8:
			Eight()
		case 9:
			Nine()
		case 10:
			Ten()
		case 11:
			Eleven()
		case 12:
			Twelve()
		case 13:
			Thirteen()
		case 14:
			Fourteen()
		case 15:
			Fifteen()
		case 16:
			Sixteen()
		case 17:
			Seventeen()
		case 18:
			EightTeen()
		case 19:
			Nineteen()
		case 20:
			N20()
		case 21:
			N21()
		case 22:
			N22()
		case 23:
			N23()
		case 24:
			N24()
		case 25:
			N25()
		case 26:
			N26()
		case 27:
			N27()
		case 28:
			N28()
		case 29:
			N29()
		case 30:
			N30()
		case 31:
			N31()
		case 32:
			N32()
		case 33:
			N33()
		case 34:
			N34()
		case 35:
			N35()
		case 36:
			N36()
		default:
			desc = String(nr)
		}
		
		if Tester.shared.isSpecial(n: nr) {
			desc = desc + "\n" + Tester.shared.getDesc(n: nr)!
			latex = latex + "\\\\" + Tester.shared.getLatex(n: nr)!
		}
	}
	
	private func Zero() {
		nr = 0
		
		desc = desc + "Zero (0) is the first natural number."
		desc = desc + "Zero is the the additive neutral element."
		desc = desc + "\nIf you add zero to any number n, the reuslt is n itself."
		desc = desc + "\nIf you multiply any number by Zero, the result is zero."
		
		latex = "\\forall n \\in \\mathbb{N} : n = n + 0"
	}


	private func One() {
		nr = 1
		desc = "One (1) is the succesor of Zero."
		desc = desc + "\nIf you multiply any number n by One, the result is n itself."
		
		latex = "\\forall n \\in \\mathbb{N} : n = n\\cdot{1}"
	}
	
	private func Two() {
		nr = 2
		
		desc = desc + "Two (2) is the first prime number."
		desc = desc + "\n2 is the smallest prime nummber and the only even prime number."
		
		latex = latex + "2 = 1 + 1\\\\"
		latex = latex + "n>0, n+n = n\\cdot{n}  \\Rightarrow n = 2"
		latex = latex + "\\\\ \\sum_{k=0}^\\infty 1/2^k = 2 "
	}
	
	private func Three() {
		nr = 3
		
		desc = desc + "Three (3) is the first odd prime number."
		
		latex = latex + "3 = 1 + 2\\\\"
		latex = latex + "F_0 = 2^{2^{0}} + 1 = 3 \\\\"
		latex = latex + "M_2 = 2^{2} - 1 = 3 \\\\ "
	}
	
	private func Four() {
		nr = 4
		
		desc = desc + "Four (4) is a square number."
		desc = desc + "\nIt is the smallest composite number."
		
		latex = latex + "4 = 2+2 = 2\\cdot{2} = 2^2\\\\"
	}
	
	private func Five() {
		nr = 5
		
		desc = desc + "Five (5) is a prime number."
		desc = desc + "\nFive is a Fibonacci number."
		
		latex = latex + "5 = 2+3 \\\\"
		latex = latex + "F_1 = 2^{2^{1}} + 1"
	}
	
	private func Six() {
		nr = 6
		desc = desc + "Six (6) is the smallest number which is neither a square nor a prime."
		latex = latex + "6 = 1\\cdot{2}\\cdot{3} = 3! \\\\"
		latex = latex + "2^1\\cdot({2^2-1}) = 6 "
	}
	
	private func Seven () {
		nr = 7
		desc = desc + "Seven (7) is a Mersenne prime"
		desc = desc + "\nThe heptagon can not be constructed by ruler and compass"
		
		latex = latex + "7 = M_3 = 2^3 - 1\\\\"
	}
	
	private func Eight () {
		nr = 8
		desc = desc + "Eight (8) is a cube number. Eight is the only Fibonacci Number, which is a cube."
		
		latex = latex + "8 = 2^3 \\\\"
		latex = latex + "8 = 3+5 \\\\"

	}
	
	private func Nine () {
		nr = 9
		desc = desc + "Nine (9) is a square number."
		desc = desc + "The smallest even composite number"
		latex = latex + "9 = 3^2 = 3\\cdot{3} \\\\"
	}
	
	private func Ten () {
		nr = 10
		desc = desc + "Ten (10) is the sum of the first three primes"
		latex = latex + "10 = 2 + 3 + 5 \\\\"
		latex = latex + "10 = 0! + 1! + 2! +3! \\\\"
		latex = latex + "10 =  \\{ a>0 : \\forall n \\in \\mathbbmin{N}: n - \\phi(n) \\neq a  \\} \\\\"
		latex = latex + "\\phi(n) = | \\{ x \\in  \\mathbb{N} :  1\\leq x\\leq n  \\land gcd(x,n) = 1  \\} |"
		
	}
	
	private func Eleven () {
		nr = 11
		desc = desc + "Eleven (11) is the smallest two digit prime number."
		latex = latex + "M_{11} = 2^{11} - 1 = 2047 = 23 \\cdot{89} \\\\"
		
	}
	
	private func Twelve () {
		nr = 12
		desc = desc + "Twelve (12) is the smallest two digit prime number."
		latex = latex + "12 = 1! \\cdot{2!} \\cdot{3!}  \\\\"
		
	}
	
	private func Thirteen () {
		nr = 13
		desc = desc + "Thirteen (13) is the smallest mirp prime. A prime is a mirp prime, when the reversed digits form a prime number. mirp(13) = 31."
		latex = latex + "13 = 5 + 8 \\text{ (Fibonacci number)}  \\\\"
	}
	
	private func Fourteen() {
		nr = 14
		desc = desc + "Fourteen (14) is the lowest even n for which the equation φ(x) = n has no solution, making it the first even nontotient."
		latex = latex + "14 =  min \\{ n \\in \\mathbb{N} | \\forall x \\in \\mathbb{N} : \\phi(x) \\neq n  \\} \\\\"
		latex = latex + "\\phi(n) = | \\{ x \\in  \\mathbb{N} :  1\\leq x\\leq n  \\land gcd(x,n) = 1  \\} |"
	}
	
	private func Fifteen() {
		nr = 15
		desc = desc + "Fifteen (15) is the product of the first odd primes.\n"
		desc = desc + "Thera are exactly 15 supersingular primes. A prime number is called supersingular if it divides the order of the Monster group. The monster group is the largest spradic simple group."
		latex = latex + "15 =  3 \\cdot{5} \\\\"
		latex = latex + "15 =  1 + 2 + 3 + 4 + 5 \\\\"
		latex = latex + "15 = |\\{ p \\in \\mathbb{P} : p\\ |\\  |M| \\},\\\\"
		latex = latex + "|M| = 2^{46}·\\cdot{3^{20}}·\\cdot{5^{9}}·\\cdot{7^{6}}·\\cdot{11^{2}}·\\cdot{13^3}\\cdot{} \\\\"
		latex = latex + "\\cdot{17}\\cdot{19}\\cdot{23}\\cdot{29}\\cdot{31}\\cdot{41}·\\cdot{47}·\\cdot{59}\\cdot{71}\\\\"
		
	}
	
	private func Sixteen() {
		nr = 16
		desc = desc + "Sixteen (16) is the fourth power of two"
		latex = latex + "16 = 2^4 = 4^2 \\\\"
		latex = latex + "n = a^b = b^a, a \\neq b  \\Rightarrow n = 16\\\\"
		latex = latex + "16 = 2^{2^2} \\\\"
	}
	
	private func Seventeen() {
		nr = 17
		desc = desc + "Seventeen (17) is the second Fermat prime. Due to this fact, the heptadacagon can be constructed by ruler and compass."
		latex = latex + "17 = 2^{2^{2}} + 1 = F_2 \\\\"
		latex = latex + "\\forall n<17-1 : n^2+n+17 \\in \\mathbb{P}  \\\\"
	}
	
	private func EightTeen() {
		nr = 18
		desc = desc + "Eightteen (18) is the only number n, with a checksum equal to the double of n"
		latex = latex + "18 = 2 \\cdot{(1+8)} \\\\"
		latex = latex + "n = \\sum_{k=0}^m a_k10^k = 2 \\sum_{k=0}^m a_k \\Rightarrow n = 18 \\\\"
	}
	
	private func Nineteen() {
		nr = 19
		desc = desc + "Every number can be representes as the sum of nineteen (19) quartic numbers."
		latex = latex + "\\forall n\\in \\mathbb{N} :  \\exists a_k : n=\\sum_{k=1}^{19} a_k^{2^{2}}\\\\"
	}
	
	private func N20() {
		nr = 20
		desc = desc + "Twenty (20) ist a tetahedral number."
		latex = latex + "20 = min \\{n:\\sum_{d|n} d < n, \\neg 3 \\mid  n \\}   \\\\"
	}
	
	private func N21() {
		nr = 21
		desc = desc + "Twentyone (21) ist a fibonacci number."
		latex = latex + "21 = 8 + 13 \\\\"
	}
	
	private func N22() {
		nr = 22
		desc = desc + "Twentytwo (22) ist a pentagonal number."
		latex = latex + "22 = \\frac{3\\cdot{4^2} - 4}{2} = p_g(4) \\\\"
		latex = latex + "p_g(n) = \\frac{3\\cdot{n^2} - n}{2} \\\\"
	}
	
	private func N23() {
		nr = 23
		desc = desc + "Twentythree (23) ist a prime number. It is the smallest prime, which ist not a twin prime"
		latex = latex + "23 = min \\{ p>2\\in\\mathbb{P} | p \\notin \\mathbb{P_2} \\} \\\\"
		//latex = latex + "\\mathbb{P}_2=\\{ p \\in \\mathbb{P} : p-2\\notin \\mathbb{P} \\land p+2 \\notin \\mathbb{P} \\}"
		latex = latex + "\\mathbb{P}_2=\\{ p \\in \\mathbb{P} | \\forall q \\in \\mathbb{P} :  p-q \\neq 2\\}"
	}
	private func N24() {
		nr = 24
		desc = desc + "Twentyfour (24) ist a highly composite number, having more divisors than any smaller number"
		latex = latex + "24 = 4! = 1\\cdot{2} \\cdot{3} \\cdot{4} \\\\"
		latex = latex + "24 = 2^3 \\cdot{3} \\\\"
		latex = latex + "2|24,3|24,4|24,6|24,8|24,12|24"
	}
	private func N25() {
		nr = 25
		desc = desc + "Twentyfive (25) ist a square number"
		latex = latex + "25 = 5^2 = 5 \\cdot{5} \\\\"
	}
	private func N26() {
		nr = 26
		desc = desc + "Twentysix (26) ist the only number, which is one greater than a square and one lower than a cube"
		latex = latex + "5^2+1 = 26 = 3^3 - 1 \\\\"
	}
	
	private func N27() {
		nr = 27
		desc = desc + "Twentyseven (27) ist a cube number"
		latex = latex + "27 = 3^3  \\\\"
	}
	
	private func N28() {
		nr = 28
		desc = desc + "Twentyeight (28) is the second perfect number. Due to euclid a a perfect number is a positive integer that is equal to the sum of its divisors"
		latex = latex + "28 = 2^{3-1} \\cdot{(2^3-1)} = 2^{n-1} \\cdot{M_n}  \\\\"
		latex = latex + "28 = 1 + 2 + 4 + 7 + 14 \\\\"
	}
	
	private func N29() {
		nr = 29
		desc = desc + "Twentynine (29) is a twin prime"
		latex = latex + "29 = 2^2 + 3^2 + 4^2 \\\\"
	}
	
	private func N30() {
		nr = 30
		desc = desc + "Thirty (30) is a square pyramidical number"
		latex = latex + "30 = 1^2 + 2^2 + 3^2 + 4^2 \\\\"
	}
	private func N31() {
		nr = 31
		desc = desc + "Thirtyone (31) is a twin prime and the third Mersenne prime"
		latex = latex + "31 = M_5 = 2^5-1 \\in \\mathbb{P}\\\\"
	}
	private func N32() {
		nr = 32
		desc = desc + "Thirtytwo (32) is a power of 2"
		latex = latex + "32 = 2^5"
	}
	
	private func N33() {
		nr = 33
		desc = desc + "Thirtythree (33) is a sum of consecutive factorials"
		latex = latex + "33 = 1! + 2! + 3! + 4! "
	}
	
	
	private func N34() {
		nr = 34
		desc = desc + "Thirtyfour (34) is a Fibonacci number"
		latex = latex + "34 = 13 + 21"
	}
	
	private func N35() {
		nr = 35
		desc = desc + "Thirtyfive (35) is a tetrahedral number"
		latex = latex + "35 = 1 + 3 + 6 + 10 + 15\\\\"
		latex = latex + "35 = \\sum_{k=1}^5 \\frac{k (\\cdot{k+1})}{2}"
	}
	
	private func N36() {
		nr = 36
		desc = desc + "Thirtysix (36) is a square number and a triangular number"
		latex = latex + "36 = 6^2 = 6 \\cdot{6} \\\\"
		latex = latex + "36 = \\frac{7\\cdot{8}}{2} \\\\"
		latex = latex + "36 = 1^3 + 2^3 + 3^3  \\\\"
		latex = latex + "36 = 17 + 19 \\\\"
		
	}
	
	private func N37() {
		nr = 37
		desc = desc + "Thirtyseven (37) is a prime number. 37 is the smallest prime, which is not a supersingular prime. "
		latex = latex + "36 = 6^2 = 6 \\cdot{6} \\\\"
		latex = latex + "36 = \\frac{7\\cdot{8}}{2} \\\\"
		latex = latex + "36 = 1^3 + 2^3 + 3^3  \\\\"
		latex = latex + "36 = 17 + 19 \\\\"
		
	}
}
