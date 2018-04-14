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

class PropertyCell: BaseNrTableCell, NumTesterEmission {

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		self.accessoryType = .detailDisclosureButton
	}
	
	private (set) var isSpecial : Bool? = nil
	lazy var drawcell : DrawTableCell = {
		var d = DrawTableCell()
		d.numtester = numtester
		d.nr = self.nr
		return d
	}()
	
	lazy var formulacell : FormTableCell = {
		var f = FormTableCell()
		if let latex = numtester?.getLatex(n: self.nr) {
			f.uimath.latex = latex
		}
		return f
	}()
	
	var numtester : NumTester? = nil {
		didSet {
			isSpecial = nil
			numtester?.TestSpecialAsync(n: nr, notify: self)
		}
	}
	
	func NotifySpecial(t: NumTester, nr: BigUInt, special: Bool) {
		self.isSpecial = special
		
		UpdateUI()
		
	}
	override var nr : BigUInt {
		didSet {
			if nr == oldValue { return }
			isSpecial = nil
			numtester?.TestSpecialAsync(n: nr, notify: self)

			if self.expanded {
				drawcell.nr = nr
				formulacell.nr = nr
			}
			
			UpdateUI()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func UpdateUI() {
		guard let tester = numtester else { return }
		
		if self.imageView?.image == nil {
			let rect = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
			let drawer = SequenceDrawer(nr : 1, tester : tester, emitter : nil, worker: nil)
			drawer.bgcolor = self.backgroundColor
			let image = drawer.DrawNrImage(rect: rect)
			self.imageView?.image = image
		}
		
		if let special = isSpecial {
			if special {
			textLabel?.text = tester.property()
			} else {
				textLabel?.text = "not " + tester.property()
			}
			
			if expanded {
				let latex = tester.getLatex(n: self.nr)
				formulacell.uimath.latex = latex
				formulacell.setNeedsLayout()
			}
		} else {
			textLabel?.text = tester.property() + "?"
		}
		
		let oeis = OEIS.shared.OEISNumber(key: tester.property())
		self.detailTextLabel?.text = oeis
		
		/*
		uiformula.latex = numtester?.getLatex(n: self.nr)
		
		self.uiformula.sizeToFit()
		let size : CGSize = self.uiformula.sizeThatFits(CGSize(width:1000.0, height: CGFloat.greatestFiniteMagnitude))
		//self.uipratt.removeFromSuperview()
		//self.uiscrollv.addSubview(self.uipratt)
		//self.uipratt.sizeToFit()
		self.uiscrollv.contentSize = CGSize(width: size.width, height: size.height+40.0)
		*/
	}
}

