//
//  KeilSchrift.swift
//  Numbers
//
//  Created by Stephan Jancar on 17.02.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

extension BigUInt {
	func Duodezimal() -> String {
		var ans = ""
		var stellen = self
		while stellen > 0 {
			let digit = Int(stellen % 12)
			ans = Digit12(digit: digit) + ans
			stellen = stellen / 12
		}
		return ans
	}
	
	private func Digit12(digit: Int) -> String {
		switch digit {
		case 10:
			return "ᘔ"
		case 11:
			return "Ɛ"
		default:
			return String(digit)
		}
	}
}

extension BigUInt {
	
	func IndianArabian() -> String {
		
		let arabian = ["\u{0660}","\u{0661}","\u{0662}","\u{0663}","\u{0664}","\u{0665}","\u{0666}","\u{0667}","\u{0668}","\u{0669}"]
		var ans = ""
		var stellen = self
		while stellen > 0 {
			let digit = Int(stellen % 10)
			ans = arabian[digit] + ans
			stellen = stellen / 10
		}
		return ans
	}
}

extension BigUInt {
	
	private func GreekUpto10000() ->String {
		let greek = ["α","β","γ","δ","ε","ϛ","ζ","η","θ","ι","κ","λ","μ","ν","ξ","ο","π","ϟ","ρ","σ","τ","υ","φ","χ","ψ","ω","ϡ","͵α", "͵β","͵γ","͵δ","͵ε","͵ϛ","͵ζ","͵η","͵θ"]
		// Maybe use "ϙ" instead of "ϟ"
		
		var index = 0
		var stellen = self
		var ans = ""
		while stellen > 0 {
			let digit = Int(stellen % 10)
			if digit > 0 {
				let g = (digit + index - 1) % greek.count
				ans = greek[g] + ans
			}
			stellen = stellen / 10
			index = index + 9
		}
		return ans
		
	}
	
	func Greek() -> String {
		var ans = ""
		var stellen = self
		var powindex = 0
		
		while stellen>0 {
			let mod10000 = stellen % 10000
			if mod10000 > 0 {
				
				if powindex > 0 {
					ans = mod10000.GreekUpto10000() + " " + ans
					let mpowgreek = BigUInt(powindex).Greek() + "M"
					ans = mpowgreek + ans
				} else {
					ans = mod10000.GreekUpto10000()
				}
			}
			powindex = powindex + 1
			stellen = stellen / 10000
		}
		return ans
	}
	
	func Hebraian() -> String {
		let aleph = "א"
		
		let thousand = "׳"
		let hebraian = [aleph,"ב","\u{05D2}","\u{05D3}","\u{05D4}","\u{05D5}","\u{05D6}","\u{05D7}","\u{05D8}","\u{05D9}",
						/* "\u{05DA}" Kaph end not used */
			"\u{05DB}","\u{05DC}",
			/* "\u{05DD}" */
			"\u{05DE}",
			/* "\u{05DF}" */
			"\u{05E0}","\u{05E1}",
			"\u{05E2}",
			/* "\u{05E3}" */
			"\u{05E4}", /* "\u{05E5}", */
			"\u{05E6}","\u{05E7}","\u{05E8}",
			"\u{05E9}","\u{05EA}",
			"\u{05DA}",
			"\u{05DD}",
			"\u{05DF}",
			"\u{05E3}",
			"\u{05E5}"]
		var ans = ""
		var stellen = self
		var index = 0
		while stellen > 0 {
			let digit = Int(stellen % 10)
			
			//Special case 15 and 16
			if stellen % 100 == 15 && index == 0 {
				ans = hebraian[9-1] + hebraian[5] + ans
				stellen = stellen / 100
				index = 18
				continue
			} else if stellen % 100 == 16 && index == 0 {
				ans = hebraian[9-1] + hebraian[6]
				stellen = stellen / 100
				index = 18
				continue
			} else if digit > 0 {
				let g = (digit + index - 1) % hebraian.count
				ans = hebraian[g] + ans
			}
			
			stellen = stellen / 10
			index = index + 9
			if index >= hebraian.count && stellen > 0 {
				index = 0
				ans = thousand + ans
			}
		}
		return ans
		
	}
	
	private func OldArabiakUpto999() ->String {
		//https://en.wikipedia.org/wiki/Abjad_numerals
		let onetonine = ["\u{0627}","\u{0628}","\u{062C}","\u{062F}","\u{0647}","\u{0648}","\u{0632}","\u{062D}","\u{0637}"]
		let tens = ["\u{0649}","\u{0643}","\u{0644}","\u{0645}","\u{0646}","\u{0633}","\u{0639}","\u{0641}","\u{0635}"]
		let hundreds = ["\u{0642}","\u{0631}","\u{0634}","\u{062A}","\u{062B}","\u{062E}","\u{0630}","\u{0636}","\u{0638}"]
		let thousand = "\u{063A}"
		var index = 0
		var (stellen,digit,ans) = (self,Int(self % 10),"")
		if self == 0 { return "" }
		
		if digit > 0 { ans = onetonine[digit-1] }
		stellen = stellen / 10
		digit = Int(stellen % 10)
		if digit > 0 { ans = ans + tens[digit-1] }
		stellen = stellen / 10
		digit = Int(stellen % 10)
		if digit > 0 { ans = ans + hundreds[digit-1] }
		
		return ans
	}
	
	func Abjad() -> String {
		var powindex = 0
		var stellen = self
		var ans = ""
		while stellen > 0 {
			let mod1000 = stellen % 1000
			var tpow = ""
			if powindex > 0 {
				for _ in 0..<powindex {
					let thousand = "\u{063A}"
					tpow = tpow + thousand
				}
			}
			if mod1000 == 1 && stellen < 1000 && powindex > 0 {
				ans = ans + tpow
			} else if mod1000 > 0 {
				ans = ans + tpow + mod1000.OldArabiakUpto999() //+ tpow + ans
			}
			stellen = stellen / 1000
			powindex = powindex + 1
		}
		return String(ans.reversed())
	}
	
	private func PhonicianUpto9() ->String {
		//https://en.wikipedia.org/wiki/Phoenician_alphabet#Numerals
		let one = "\u{10916}"
		let two = "\u{1091A}"
		let three = "\u{1091B}"
		
		if self == 0 { return "" }
		if self == 1 { return one }
		if self == 2 { return two }
		return three + (self-3).PhonicianUpto9()
	}
	
	private func PhonicianUpto9999(hundredsign : String, withprefix : Bool = false) -> String {
		let ten = "\u{10917}"
		let twenty = "\u{10918}"
		
		
		if self >= 100 && self < 200 && withprefix == false {
			let mod100 = self % 100
			return hundredsign + mod100.PhonicianUpto9999(hundredsign: "")
		}
		if self >= 100 {
				let div100 = self / 100
				let mod100 = self % 100
				return div100.PhonicianUpto9999(hundredsign: "") + hundredsign + mod100.PhonicianUpto9999(hundredsign : "")
		}
		if self < 100 {
			let mod10 = self % 10
			let ans = mod10.PhonicianUpto9()
			
			var div10 = self / 10
			switch Int(div10) {
			case 1:
				return ten + ans
			case 2:
				return twenty + ans
			case 3:
				return twenty + ten + ans
			case 4:
				return twenty + twenty + ans
			case 5:
				return twenty + twenty + ten + ans
			case 6:
				return twenty + twenty + twenty + ans
			case 7:
				return twenty + twenty + twenty + ten + ans
			case 8:
				return twenty + twenty + twenty + twenty + ans
			case 9:
				return twenty + twenty + twenty + twenty + ten + ans
			default:
				return ans
			}
		}
		return ""
	}
	
	func Phonician() -> String {
		
		let hundred = "\u{10919}"
		var powstr = hundred
		
		let mod10000 = self % 10000
		var prefix = (self > 10000)
		var ans = mod10000.PhonicianUpto9999(hundredsign: hundred,withprefix: prefix)
		
		var stellen = self / 10000
		while stellen>0 {
			prefix = (stellen >= 100)
			powstr = powstr + hundred
			let mod100 = stellen % 100
			if mod100 == 1 && prefix == false {
				ans = powstr + ans
			} else if mod100 > 0 {
				ans = mod100.PhonicianUpto9999(hundredsign: hundred,withprefix: prefix) + powstr + ans
			}
			stellen = stellen / 100
		}
		return String(ans.reversed())
		
	}
	
	func Egytian() -> String {
		let zero = "𓂜"
		let ones = ["𓐄","𓐅","𓐆","𓐇","𓐈","𓐉","𓐊","𓐋","𓐌"]
		let tens = ["𓎆","𓎇","𓎈","𓎉","𓎊","𓎋","𓎌","𓎍","𓎎"]
		let hundreds = ["𓍢","𓍣","𓍤","𓍥","𓍦","𓍧","𓍨","𓍩","𓍪"]
		let thousands = ["𓆼","𓆽","𓆾","𓆿","𓇀","𓇁","𓇂","𓇃","𓇄"]
		let tenthousands = ["𓂭","𓂮","𓂯","𓂰","𓂱","𓂲","𓂳","𓂴","𓂵"]
		let hundredthousands = ["𓆐","𓆐𓆐","𓆐𓆐𓆐","𓆐𓆐𓆐𓆐","𓆐𓆐𓆐𓆐𓆐","𓆐𓆐𓆐𓆐𓆐𓆐","𓆐𓆐𓆐𓆐𓆐𓆐𓆐","𓆐𓆐𓆐𓆐𓆐𓆐𓆐𓆐","𓆐𓆐𓆐𓆐𓆐𓆐𓆐𓆐𓆐"]
		let million = "𓁨"
		
		let powers = [ones,tens,hundreds,thousands,tenthousands,hundredthousands]
		if self == 0 {
			return zero
		}
		if self >= 1000000 {
			return million
		}
		var ans = ""
		var stellen = self
		var powindex = 0
		while stellen > 0
		{
			let digit = Int(stellen % 10)
			if digit > 0 {
				ans = powers[powindex][digit-1] + ans
			}
			powindex = powindex + 1
			stellen = stellen / 10
		}
		return ans
	}
	
	func Vingesimal() -> String {
		let symbols = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T"]
		var stellen = self
		var ans = ""
		if self == 0 { return symbols[0] }
		while stellen > 0 {
			let digit = Int(stellen % 20)
			ans = symbols[digit] + ans
			stellen = stellen / 20
		}
		return ans
	}
	
	func ChineseOmmitted() -> String {
		let chinese = ["〇","一","二","三","四","五","六","七","八","九"]
		var ans = ""
		if self == 0 {
			return "零"
		}
		var stellen = self
		while stellen > 0 {
			let digit = Int(stellen % 10)
			ans = chinese[digit] + ans
			stellen = stellen / 10
		}
		return ans		
	}
	
	func Chinese() -> String {
		let chinese = ["零","一","二","三","四","五","六","七","八","九"]
		let powers = ["","十","百","千"] //,"十万","百万","千万","亿"]
		let powers4 = ["", "万","亿","兆","京","垓","秭","穰","沟","涧","正","载"]
		
		if self < 10 {
			return chinese[Int(self)]
		}
		if self == 10 {
			return powers[1]
		}
		if self < 20 {
			let mod10 = Int(self % 10)
			return powers[1] + chinese[mod10]
		}
		
		/*
		if self >= onehundredmillion * onehundredmillion {
		return ChineseOmmitted()
		}
		*/
		
		var powindex4 = 0
		var ans = ""
		var stellen = self
		var powindex = 0
		var started = false
		var islastzero = false
		while stellen > 0 {
			let digit = Int(stellen % 10)
			if digit > 0 {
				ans = chinese[digit] + powers[powindex % 4] + ans
				started = true
				islastzero = false
			} else {
				if started && islastzero == false {
					ans = chinese[0] + ans
					islastzero = true
				}
			}
			stellen = stellen / 10
			powindex = powindex + 1
			if powindex == 4 {
				powindex4 = powindex4 + 1
				powindex = 0
				if stellen % 10000 > 0 {
					if powindex4 >= powers4.count {
						return ChineseOmmitted()
					}
					ans = powers4[powindex4] + ans
				}
			}
		}
		return ans
	}
}

extension BigUInt {
	func Roman() -> String {
		
		let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
		let romanValues1000 = ["M̅", "C̅M̅", "D̅", "C̅D̅", "C̅", "X̅C̅", "L̅", "X̅L̅", "X̅", "I̅X̅", "V̅", "I̅V̅", "I̅̅"] 
		let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
		
		var romanValue = ""
		
		//This Block is a little bit of fantasy. Romans had no need for bigger numbers !?
		if self >= BigUInt(1000000) {
			let mod100000 = self % BigUInt(1000000)
			romanValue = mod100000.Roman()
			let div1000000 = self / BigUInt(1000000)
			romanValue = "[" + div1000000.Roman() + "] " + romanValue
			return romanValue
		}
		
		//This is the Usage with overlining
		var startingValue = self / 1000
		if self >= 4000 {
			for (index, romanChar) in romanValues1000.enumerated() {
				let arabicValue = arabicValues[index]
				let div = startingValue / BigUInt(arabicValue)
				
				if (div > 0) {
					for _ in 0..<div {
						romanValue = romanValue + romanChar
					}
					
					startingValue -= BigUInt(arabicValue) * div
				}
			}
		}
		
		//Fundamental Roman Numbers
		if self >= 4000 {
			startingValue = self % 1000
		} else {
			startingValue = self
		}
		for (index, romanChar) in romanValues.enumerated() {
			let arabicValue = arabicValues[index]
			let div = startingValue / BigUInt(arabicValue)
			
			if (div > 0)
			{
				for _ in 0..<div {
					romanValue = romanValue + romanChar
				}
				
				startingValue -= BigUInt(arabicValue) * div
			}
		}
		
		
		
		return romanValue
	}
}

extension BigUInt {
	func Keilschrift() -> String {
		var ans = ""
		var stellen = self
		while stellen > 0 {
			let digit = Int(stellen % 60)
			ans = Digit60(digit: digit) + "   " + ans
			stellen = stellen / 60
		}
		return ans
	}
	
	fileprivate func Digit60(digit : Int) -> String {
		
		let mod10 = digit % 10
		if (digit > 10) && (mod10 > 0) {
			let ans = Digit60(digit: digit - mod10) + Digit60(digit: mod10)
			return ans
		}
		
		switch digit {
		case 0:
			return "𒑊"
			
		case 1:
			return  "𒐕"
		case 2:
			return "𒐖"
		case 3:
			return "𒐗"
		case 4:
			return "𒐘"
		case 5:
			return "𒐙"
		case 6:
			return "𒐚"
		case 7:
			return "𒑂"
		case 8:
			return "𒑄"
		case 9:
			return "𒑆"
		case 10:
			return "𐏓"
		case 20:
			return "𐏓𐏓"
		case 30:
			return "𐏓𐏓𐏓"
		case 40:
			return "𒐏"
		case 50:
			return "𒐐"
		case 60:
			return "𒐑"
		case 70:
			return "𒐒"
		case 80:
			return "𒐓"
		case 90:
			return "𒐔"
		default:
			assert(false)
			return ""
		}
	}
}

