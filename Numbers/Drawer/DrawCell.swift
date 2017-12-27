//
//  DrawCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 17.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit

class DrawNrView : UIView {

	internal var _imageview : UIImageView? = nil
	var imageview : UIImageView {
		get {
			if _imageview == nil {
				let rect = CGRect(x: 0, y: 0 , width: frame.width, height: frame.height)
				_imageview = UIImageView(frame:rect)
				_imageview?.backgroundColor = self.backgroundColor
				addSubview(_imageview!)
			}
			return _imageview!
		}
	}
	override var frame : CGRect {
		set {
			super.frame = newValue
			imageview.frame = CGRect(origin: .zero, size: newValue.size)
		}
		get { return super.frame }
	}

	internal var nr : UInt64 = 1
	func SetNumber(_ nextnr : UInt64) {
		self.nr = nextnr
	}	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
	
class DrawingCells {
	var cells : [DrawTableCell] = []
	
	
	init() {
		for i in 0..<TableCellType.allValues.count {
			let cell = DrawTableCell()
			cell.type = TableCellType.allValues[i]
			cells.append(cell)
		}
	}
	
	private var _nr = 0
	var nr : Int {
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

enum TableCellType : Int {
	case None = -1
	case Prime = 0
	case Fibo = 1
	case Triangular = 2
	case Square = 3
	case Pentagonal = 4
	case Hexagonal = 5
	case Palindromic = 6
	case Abundant = 7
	case Faktor = 8
	case Lucas = 9
	case Catalan = 10
	
	static let allValues : [TableCellType] = [Prime, Fibo,Triangular,Square,Pentagonal,Hexagonal, Palindromic,Abundant,Faktor,Lucas,Catalan]
}


class DrawTableCell: BaseNrTableCell {
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(uilabel)
	}
	
	private var uilabel = UILabel()
	private var _uidraw : DrawNrView? = nil
	private var _type : TableCellType = .None
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
	var uidraw : UIView? {
		get { return _uidraw }
	}
	var type : TableCellType {
		set {
			if newValue == _type { return }
			if _uidraw != nil { return }
			_type = newValue
			//_uidraw?.removeFromSuperview()
			switch type {
			case .Fibo:
				_uidraw = FiboView() //FaktorView()
				numtester = FibonacciTester() // PrimeTester()
			case .Faktor:
				_uidraw = UlamView() // FaktorView()
				numtester = AbundanceTester()
			case .Triangular:
				_uidraw = PolygonalView(poly: 3)
				numtester = TriangleTester()
			case .Square:
				_uidraw = PolygonalView(poly: 4)
				numtester = SquareTester()
			case .Pentagonal:
				_uidraw = PolygonalView(poly: 5)
				numtester = PentagonalTester()
			case .Hexagonal:
				_uidraw = PolygonalView(poly: 6)
				numtester = HexagonalTester()
			case .Palindromic:
				_uidraw = PalindromeView()
				numtester = PalindromicTester()
			case .None:
				break
			case .Prime:
				_uidraw = UlamView()
				numtester = PrimeTester()
			case .Abundant:
				_uidraw = FaktorView()
				numtester = AbundanceTester()
			case .Lucas:
				_uidraw = LucasView()
				numtester = LucasTester()
			case .Catalan:
				_uidraw = CatalanView()
				numtester = CatalanTester()
			}
			if let test = numtester {
				isSpecial = test.isSpecial(n: nr)
			}
			contentView.addSubview(_uidraw!)
			LayoutUI()
		}
		get {
			return _type
		}
	}
	override var nr : Int {
		set {
			if newValue == nr { return }
			
			super.nr = newValue
			if let test = numtester  {
				isSpecial = test.isSpecial(n: nr)
			}
			if _uidraw == nil { return }
			if let view = _uidraw as? DrawNrView {
				view.SetNumber(UInt64(nr))
			}
			uilabel.text = numtester?.property()
			_uidraw?.setNeedsDisplay()
		}
		get {
			return super.nr
		}
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let smalldrawwidth : CGFloat = 40.0
	private func LayoutUI() {
		guard let draw = _uidraw else { return }
		if expanded {
			draw.frame = CGRect(x: 0.0, y: smalldrawwidth, width: self.frame.width, height: self.frame.width)
			draw.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
			draw.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
			//draw.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
			self.accessoryType = .none
		} else {
			uilabel.frame = CGRect(x: smalldrawwidth * 3 / 2, y: 0 , width : self.frame.width, height: smalldrawwidth)
			uilabel.leftAnchor.constraint(equalTo: draw.rightAnchor).isActive = true
			draw.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
			draw.frame = CGRect(x: 0.0, y: 0, width: smalldrawwidth, height: smalldrawwidth)
			draw.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
			//_uidraw?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
			draw.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
			self.accessoryType = .disclosureIndicator
		}
		_uidraw?.setNeedsDisplay()
		
	}
}

