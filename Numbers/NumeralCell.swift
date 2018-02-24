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

class NumeralCells {
	
	private var startcell = NumeralCell()
	private var artcell = NumeralArtCell()
	private var cells : [NumeralCell] = []
	
	private var _expanded : Bool = false
	var expanded : Bool {
		get {
			return _expanded
		}
		set {
			_expanded = newValue
			artcell.uiart.needcomputing = true
			artcell.uiart.setNeedsDisplay()
			artcell.expanded = _expanded
			for cell in cells {
				cell.expanded = _expanded
			}
		}
	}
	
	func getCell(row : Int) -> UITableViewCell {
		if row == 0 { return artcell }
		//if row == 0 { return startcell }
		if row-1 < cells.count {
			return cells[row-1]
		}
		return UITableViewCell()
	}
	func getRowHeight(row: Int) -> CGFloat {
		var height = CGFloat(20)
		if let cell = getCell(row: row) as? NumeralArtCell {
			if expanded { return cell.contentView.width }
			return 100.0
		}
		/*
		if row == 0 {
			let label = startcell.uilabel
			let width = label.width
			label.sizeToFit()
			height = max(height,label.sizeThatFits(CGSize(width:width, height: CGFloat.greatestFiniteMagnitude)).height)
			return height + 10.0
		}
		*/
		
		if let cell = getCell(row: row) as? NumeralCell {
			if !cell.expanded { return 0.0 }
			let label = cell.uilabel
			let width = label.width
			label.sizeToFit()
			height = max(height,label.sizeThatFits(CGSize(width:width, height: CGFloat.greatestFiniteMagnitude)).height)
		}
		return height + 10.0
	}
	
	init() {
		startcell.type = .FormatUS
		for type in NumeralCellType.allValues {
			//let type = NumeralCellType.allValues[i]
			//if type != .FormatUS {
			let cell = NumeralCell()
			cell.type = type
			cells.append(cell)
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
			for c in cells {
				c.nr = _nr
			}
		}
		get { return _nr }
	}
}

enum NumeralCellType : Int {
	case None = -1
	case FormatUS = 0
	case Spoken = 1
	case Latin
	case Roman
	case Indian
	case Abjad
	
	case Egyptian
	case Phonician
	case Greek
	case Hebraian
	case Babylon
	case Chinese
	case Maya
	case Scientific
	case Duodezimal
	case Rod
	
	
	static let allValues : [NumeralCellType] = [FormatUS, .Spoken, .Roman,.Indian,.Abjad,.Egyptian,.Phonician,.Greek,.Hebraian,.Babylon,.Chinese,.Scientific,.Maya,.Rod]
	
	func asString() -> String {
		switch self {
		case .None:
			return ""
		case .Scientific:
			return "scientific"
		case .FormatUS:
			return "hindu-arabian"
		case .Spoken:
			return "short scale"
		case .Latin:
		    return "hindu-arabian"
		case .Roman:
			return "roman"
		case .Indian:
			return "arabian (east)"
		case .Abjad:
			return "arabian (abjad)"
		case .Duodezimal:
			return "dozenal"
		case .Egyptian:
			return "egyptian"
		case .Phonician:
			return "phoenician"
		case .Greek:
			return "greek"
		case .Hebraian:
			return "hebrew"
		case .Babylon:
			return "babylon"
		case .Chinese:
			return "chinese"
		case .Maya:
			return "maya"
		case .Rod:
			return "counting rods"
		}
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
		Number.formatter.positiveFormat = "0.###E+0"
		Number.formatter.exponentSymbol = "e"
		let number = NSNumber(value: self)
		return Number.formatter.string(from :number) ?? description
	}
}

extension BigUInt {
	func scientific() -> String {
		let dot = "\u{22C5}"
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
		case .Indian:
			return self.IndianArabian()
		case .Maya:
			return self.Vingesimal()
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
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		uilabel.lineBreakMode = .byWordWrapping
		uilabel.numberOfLines = 0
		contentView.addSubview(uinumeraltype)
		contentView.addSubview(uilabel)
	}
	
	private (set) var uilabel = UILabel()
	private var uinumeraltype = UITextView()
	private var _type : NumeralCellType = .None
	private (set) var isSpecial : Bool = false
	private (set) var numtester : NumTester? = nil
	
	var type : NumeralCellType {
		set {
			if newValue == _type { return }
			_type = newValue
			uilabel.text = nr.getNumeral(type: _type)
			uinumeraltype.isUserInteractionEnabled = false
			uinumeraltype.text = type.asString()
			uinumeraltype.textAlignment = .right
			
			LayoutUI()
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
				let font = UIFont(name: "Mayan", size: 20)
				uilabel.font = font
			case .Rod:
				let font = UIFont(name: "symbola", size: 20)
				uilabel.font = font
			case .Egyptian:
				let fonthigher = UIFont.systemFont(ofSize: 24.0 ) //UIFont.labelFontSize)
				uilabel.font = fonthigher
			default:
				let deffont = UIFont.systemFont(ofSize: 12.0 ) //UIFont.labelFontSize)
				uilabel.font = deffont
			}
			uilabel.text = nr.getNumeral(type: type)
			
			LayoutUI()
		}
		get {
			return super.nr
		}
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func LayoutUI() {
		uilabel.translatesAutoresizingMaskIntoConstraints = false
		uinumeraltype.translatesAutoresizingMaskIntoConstraints = false
		uilabel.leadingAnchor.constraint (equalTo: contentView.leadingAnchor,constant: 40.0).isActive = true
		uilabel.trailingAnchor.constraint (equalTo: contentView.trailingAnchor,constant: -40.0).isActive = true
		//uilabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -40.0).isActive = true
		//uilabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 40.0).isActive = true
		uilabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8.0).isActive = true
		uilabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -0.0).isActive = true
		
		do {
			let w = contentView.width - uinumeraltype.contentSize.width - 10.0
			uinumeraltype.leadingAnchor.constraint (equalTo: contentView.leadingAnchor,constant: w).isActive = true
			uinumeraltype.trailingAnchor.constraint (equalTo: contentView.trailingAnchor,constant: -10.0).isActive = true
			uinumeraltype.font = UIFont.systemFont(ofSize: 8.0 ) //UIFont.labelFontSize)
			let h = uinumeraltype.contentSize.height;
			uinumeraltype.heightAnchor.constraint(equalToConstant: h).isActive = true
			uinumeraltype.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -1.0).isActive = true
		}
		
			self.accessoryType = .none
	}
}

