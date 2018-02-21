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
	var cells : [NumeralCell] = []
	
	init() {
		for i in 0..<NumeralCellType.allValues.count {
			let cell = NumeralCell()
			cell.type = NumeralCellType.allValues[i]
			cells.append(cell)
		}
	}
	
	private var _nr : BigUInt = 0
	var nr : BigUInt {
		set {
			if newValue == _nr { return }
			_nr = newValue
			for c in cells {
				c.nr = _nr
			}
		}
		get { return _nr }
	}
}

enum NumeralCellType : Int {
	case None = -1
	case Spoken = 0
	case Latin = 1
	case Roman
	case Indian
	case Abjad
	case Duodezimal
	case Egyptian
	case Phonician
	case Greek
	case Hebraian
	case Babylon
	case Chinese
	case Maya
	
	static let allValues : [NumeralCellType] = [.Spoken, .Roman,.Indian,.Abjad,.Duodezimal,.Egyptian,.Phonician,.Greek,.Hebraian,.Babylon,.Chinese,.Maya]
}

extension BigUInt {
	func getNumeral(type : NumeralCellType) -> String {
		switch type {
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
			return self.Egytian()
		case .Phonician:
			return self.Phonician()
		case .Greek:
			return self.Greek()
		case .Hebraian:
			return self.Hebraian()
		case .Babylon:
			return self.Keilschrift()
		}
	}
}


class NumeralCell: BaseNrTableCell {
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		uilabel.lineBreakMode = .byWordWrapping
		uilabel.numberOfLines = 0
		contentView.addSubview(uilabel)
	}
	
	private (set) var uilabel = UILabel()
	private var _type : NumeralCellType = .None
	private var _expanded : Bool = false
	private (set) var isSpecial : Bool = false
	private (set) var numtester : NumTester? = nil
	var expanded : Bool {
		set {
			if newValue == _expanded {return }
			_expanded = newValue
			LayoutUI()
		}
		get {
			return _expanded
		}
	}
	var type : NumeralCellType {
		set {
			if newValue == _type { return }
			_type = newValue
			uilabel.text = nr.getNumeral(type: _type)
			LayoutUI()
		}
		get {
			return _type
		}
	}
	override var nr : BigUInt {
		set {
			if newValue == nr { return }
			super.nr = newValue
			if type == .Maya {
				let mayafont = UIFont(name: "Mayan", size: 20)
				uilabel.font = mayafont
			}
			else {
				let deffont = UIFont.systemFont(ofSize: 28.0 ) //UIFont.labelFontSize)
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

	private func LayoutUI() {
		uilabel.translatesAutoresizingMaskIntoConstraints = false
		//uilabel.frame = CGRect(x: height * 3 / 2, y: 0 , width : self.contentView.width, height: 40.0)
		uilabel.leadingAnchor.constraint (equalTo: contentView.leadingAnchor,constant: 40.0).isActive = true
		uilabel.trailingAnchor.constraint (equalTo: contentView.trailingAnchor,constant: -40.0).isActive = true
		//uilabel.heightAnchor.constraint(equalTo: contentView).he
		//uilabel.leftAnchor.constraint(equalTo:contentView.leftAnchor).isActive = true
		//uilabel.rightAnchor.constraint(equalTo:contentView.rightAnchor).isActive = true
		self.accessoryType = .disclosureIndicator
	}
}

