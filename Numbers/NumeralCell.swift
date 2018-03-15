//
//  DrawCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 17.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt

enum NumeralCellType : Int {
	case None = -1, FormatUS = 0, Spoken, Latin, Roman
	case Indian, Abjad, Egyptian, Phonician, Greek, Hebraian
	case Babylon, Chinese, ChineseFinancial, Maya, Scientific, Duodezimal, Rod
	
	static let allValues : [NumeralCellType] = [FormatUS, .Spoken, .Roman,.Indian,.Abjad,.Egyptian,.Greek,.Hebraian,.Babylon,.Chinese,.ChineseFinancial, .Scientific,.Maya,.Rod]
	
	static private let str = [ "hindu-arabian", "short scale", "arabian (west) ", "roman", "arabian (east)", "arabian (abjad)", "egyptian", "phoenician", "greek", "hebrew", "babylonian", "chinese","chinese financial", "maya", "scientific", "dozenal", "rod" ]
	
	static private let wikis = ["https://en.wikipedia.org/wiki/Hindu–Arabic_numeral_system",
							   "https://en.wikipedia.org/wiki/Long_and_short_scales",
							   "https://en.wikipedia.org/wiki/Hindu–Arabic_numeral_system",	//Latin unformatted
							   "https://en.wikipedia.org/wiki/Roman_numerals",
							   "https://en.wikipedia.org/wiki/Eastern_Arabic_numerals",
							   "https://en.wikipedia.org/wiki/Abjad_numerals",
							   "https://en.wikipedia.org/wiki/Egyptian_numerals",
							   "",
							   "https://en.wikipedia.org/wiki/Greek_numerals",
							   "https://en.wikipedia.org/wiki/Hebrew_numerals",
							   "https://en.wikipedia.org/wiki/Babylonian_numerals",
							   "https://en.wikipedia.org/wiki/Chinese_numerals",
							   "https://en.wikipedia.org/wiki/Chinese_numerals",	//doppel financial
							    "https://en.wikipedia.org/wiki/Maya_numerals",
							   "https://en.wikipedia.org/wiki/Scientific_notation",
							   "https://en.wikipedia.org/wiki/Duodecimal",
							   "https://en.wikipedia.org/wiki/Counting_rods"]
	
	func asString() -> String {
		if self.rawValue >= 0 {
			return NumeralCellType.str[self.rawValue]
		}
		return ""
	}
	
	func asWiki() -> String {
		if self.rawValue >= 0 {
			return NumeralCellType.wikis[self.rawValue]
		}
		return "https://en.wikipedia.org/wiki/Numeral_system"
		
	}
	
}

class NumeralCells {
	static let wikiheight : CGFloat = 600.0
	private var startcell = NumeralCell()
	private var artcell = NumeralArtCell()
	private var ncells : [NumeralCell] = []
	private var wikicells : [WikiTableCell] = []
	
	private var expanded : Bool = false {
		didSet {
			artcell.expanded = expanded
			if !expanded {
				artcell.accessoryType = .disclosureIndicator
				for cell in ncells { cell.expanded = false; cell.isHidden = true }
				for cell in wikicells { cell.expanded = false; cell.isHidden = true }
			} else {
				artcell.accessoryType = .none
				for cell in ncells { cell.expanded = false; cell.isHidden = false }
			}
		}
	}
	
	func Expand(row : Int) {
		let cell = getCell(row: row)
		if let _ = cell as? NumeralArtCell {
			expanded = !expanded
			for cell in ncells { cell.expanded = false; cell.isHidden = !expanded }
			for cell in wikicells { cell.expanded = false;  cell.isHidden = true }
		}
		if let cell = cell as? NumeralCell {
			guard let wikicell = getCell(row: row+1) as? WikiTableCell else { return }
			let wascellexpanded = cell.expanded
			for cell in ncells { cell.expanded = false; cell.isHidden = false }
			for cell in wikicells { cell.isHidden = true }
			if !wascellexpanded {
				cell.expanded = true
				wikicell.isHidden = false
			}
		}
	}
	
	func getCell(row : Int) -> UITableViewCell {
		if row == 0 { return artcell }
		if row % 2 == 1 {
			return ncells[row / 2 + 1]
		}
		return wikicells[row / 2 ]
	}
	func getRowHeight(row: Int) -> CGFloat {
		var height = CGFloat(20)
		let cell = getCell(row: row)
		if cell is NumeralArtCell {
			let h = expanded ? cell.contentView.width : 150.0
			return h
		}
		if cell is WikiTableCell {
			if cell.isHidden { return 0 }
			return NumeralCells.wikiheight

		}
		if let cell = cell as? NumeralCell {
			if cell.isHidden { return 0 }
			//if !cell.expanded { return 0.0 }
			if let label = cell.textLabel {
				let width = label.width
				label.sizeToFit()
				height = max(height,label.sizeThatFits(CGSize(width:width, height: CGFloat.greatestFiniteMagnitude)).height)
			}
		}
		return height + 20.0
	}
	
	init() {
		startcell.type = .FormatUS
		for type in NumeralCellType.allValues {
			//let type = NumeralCellType.allValues[i]
			//if type != .FormatUS {
			let cell = NumeralCell()
			cell.type = type
			cell.isHidden = true
			ncells.append(cell)
			let wiki = WikiTableCell()
			wiki.isHidden = true
			wiki.accessoryType = .none
			wikicells.append(wiki)
			wiki.SetWikiUrl(wiki: type.asWiki())
			//}
		}
	}
	
	private var _nr : BigUInt = 0
	var nr : BigUInt {
		set {
			startcell.nr = newValue
			if newValue == _nr { return }
			
			_nr = newValue
			startcell.nr = _nr
			artcell.nr = newValue
			for c in ncells {
				c.nr = _nr
			}
		}
		get { return _nr }
	}
}



extension BigUInt {
	func formatUS() -> String {
		var stellen = self
		var ans = ""
		var index = 0
		if self == 0 { return "0" }
		while stellen > 0 {
			let digit = Int(stellen % 10)
			if index % 3 == 0 && index > 0 {
				ans = ",\u{200B}" + ans
			}
			ans = String(digit) + ans
			index = index + 1
			stellen = stellen / 10
		}
		return ans
	}
}

extension Double {
	struct Number {
		static var formatter = NumberFormatter()
	}
	var scientificStyle: String {
		Number.formatter.numberStyle = .scientific
		Number.formatter.positiveFormat = "0.000E0"
		Number.formatter.exponentSymbol = "e"
		let number = NSNumber(value: self)
		return Number.formatter.string(from :number) ?? description
	}
}

extension BigUInt {
	func scientific() -> String {
		//let dot = "\u{22C5}"
		let s = String(self)
		guard let d = Double(s) else { return "\u{221E}" }
		//if d.isZero { return "0" }
		let ans = d.scientificStyle
		let d2 = Double(ans)
		if d2 != d {
			return "\u{2248}" + ans
		}
		return ans
	}
}

extension BigUInt {
	func getNumeral(type : NumeralCellType) -> String {
		switch type {
		case .FormatUS:
			return self.formatUS()
		case .Scientific:
			return self.scientific()
		case .Spoken:
			return SpokenNumber.shared.spoken(n: self)
		case .Latin:
			return String(self)
		case .Roman:
			return self.Roman()
		case .Chinese:
			return self.Chinese()
		case .ChineseFinancial:
			return self.ChineseFinancial()
		case .Indian:
			return self.IndianArabian()
		case .Maya:
			return self.Vigesimal()
		case .None:
			return ""
		case .Abjad:
			return self.Abjad()
		case .Duodezimal:
			return self.Duodezimal()
		case .Egyptian:
			return self.Egyptian()
		case .Phonician:
			return self.Phonician()
		case .Greek:
			return self.Greek()
		case .Hebraian:
			return self.Hebraian()
		case .Babylon:
			return self.Keilschrift()
		case .Rod:
			return self.Rod()
		}
	}
}

class NumeralCell: BaseNrTableCell {
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		self.accessoryType = .detailButton // .disclosureIndicator
		
		textLabel?.lineBreakMode = .byWordWrapping
		textLabel?.numberOfLines = 0
		//textLabel.translatesAutoresizingMaskIntoConstraints = false
		//uinumeraltype.translatesAutoresizingMaskIntoConstraints = false
		//contentView.addSubview(uinumeraltype)
		//contentView.addSubview(uilabel)
		//LayoutUI()
	}
	
	//private (set) var uilabel = UILabel()
	//private var uinumeraltype = UITextView()
	private var _type : NumeralCellType = .None
	private (set) var isSpecial : Bool = false
	private (set) var numtester : NumTester? = nil
	
	var type : NumeralCellType {
		set {
			if newValue == _type { return }
			_type = newValue
			textLabel?.text = nr.getNumeral(type: _type)
			//uinumeraltype.isUserInteractionEnabled = false
			detailTextLabel?.text = type.asString()
			//uinumeraltype.textAlignment = .right
			
			//LayoutUI()
		}
		get {
			return _type
		}
	}
	
	override var expanded: Bool {
		get { return super.expanded }
		set {
			super.expanded = newValue
			self.isHidden = !expanded
		}
	}
	override var nr : BigUInt {
		set {
			if newValue == nr { return }
			super.nr = newValue
			switch type {
			case .Maya:
				let font = UIFont(name: "Mayan", size: 24)
				textLabel?.font = font
			case .Rod:
				let font = UIFont(name: "symbola", size: 24)
				textLabel?.font = font
			case .Egyptian:
				let fonthigher = UIFont.systemFont(ofSize: 24.0 ) //UIFont.labelFontSize)
				textLabel?.font = fonthigher
			default:
				let deffont = UIFont.systemFont(ofSize: 24.0 ) //UIFont.labelFontSize)
				textLabel?.font = deffont
			}
			textLabel?.text = nr.getNumeral(type: type)
			
			//LayoutUI()
		}
		get {
			return super.nr
		}
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
/*
	override var isHidden: Bool {
		didSet {
			uilabel.isHidden = isHidden
			uinumeraltype.isHidden = isHidden
		}
	}

	private func LayoutUI() {

		
		uilabel.leadingAnchor.constraint (equalTo: contentView.leadingAnchor,constant: 10.0).isActive = true
		uilabel.trailingAnchor.constraint (equalTo: contentView.trailingAnchor,constant: -40.0).isActive = true
		uilabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8.0).isActive = true
		//uilabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -0.0).isActive = true
		
		do {
			//let w = contentView.width - uinumeraltype.contentSize.width - 0.0
			uinumeraltype.leadingAnchor.constraint (equalTo: contentView.leadingAnchor,constant: 0).isActive = true
			uinumeraltype.trailingAnchor.constraint (equalTo: contentView.trailingAnchor,constant: -40.0).isActive = true
			uinumeraltype.font = UIFont.systemFont(ofSize: 8.0 ) //UIFont.labelFontSize)
			//let h = max(uinumeraltype.contentSize.height,0)
			//uinumeraltype.heightAnchor.constraint(equalToConstant: h).isActive = true
			uinumeraltype.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8.0).isActive = true

			//uinumeraltype.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -1.0).isActive = true
		}
	}
*/
}

