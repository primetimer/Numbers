//
//  DrawCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 17.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit


class DrawingCells {
	var cells : [DrawTableCell] = []
	init() {
		for i in 0...4 {
			let cell = DrawTableCell()
			cell.type = i
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

class DrawTableCell: BaseNrTableCell {
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	private var _uidraw : UIView? = nil
	private var _type : Int = -1
	var uidraw : UIView? {
		get { return _uidraw }
	}
	var type : Int {
		set {
			if newValue == _type { return }
			if _uidraw != nil { return }
			_type = newValue
			//_uidraw?.removeFromSuperview()
			switch type {
			case 0:
				_uidraw = FaktorView()
			case 1:
				_uidraw = UlamView() // FaktorView()
			case 2:
				_uidraw = PolygonalView(poly: 3)
			case 3:
				_uidraw = PolygonalView(poly: 4)
			case 4:
				_uidraw = PolygonalView(poly: 5)
			case 5:
				_uidraw = PolygonalView(poly: 6)
			default:
				return
			}
			contentView.addSubview(_uidraw!)
			_uidraw?.frame = CGRect(x: 10.0, y: 0, width: self.frame.width, height: self.frame.height)
			_uidraw?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
			_uidraw?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
			_uidraw?.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
			_uidraw?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		}
		get {
			return _type
		}
	}
	override var nr : Int {
		set {
			if newValue == nr { return }
			super.nr = newValue
			if _uidraw == nil { return }
			if let view = _uidraw as? FaktorView {
				view.SetNumber(UInt64(nr))
			}
			if let view = _uidraw as? PolygonalView {
				view.SetNumber(UInt64(nr))
			}
			_uidraw?.setNeedsDisplay()
		}
		get {
			return super.nr
		}
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

