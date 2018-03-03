//
//  DescCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 01.01.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt
//import FutureKit

class NumeralSequenceArtCell: BaseNrTableCell {
	private (set) var uiart = UIWordCloudView()
	override func setNeedsLayout() {
		uiart.DrawCloud()
	}
	private var refresh = true
	var tester : NumTester? = nil {
		didSet {
			if oldValue == nil {
				refresh = true
			}
			if tester == nil {
				return
			}
			if tester?.property() == oldValue?.property() {
				refresh = true
			}
		}
	}
	
	override var nr : BigUInt {
		
		didSet {
			if nr != oldValue {
				refresh = true
			}
			if !refresh { return }
			refresh = false
			uiart.Clear()
			var hit = 0
			for i in 0...200 {
				let seq = nr + BigUInt(i)
				if tester?.isSpecial(n: seq) ?? false {
					uiart.AppendString(s: String(seq))
					hit = hit + 1
					if hit > 10 { break }
				}
			}
			if hit == 1 {
				for i in 0...200 {
					let seq = BigUInt(i)
					if tester?.isSpecial(n: seq) ?? false {
						uiart.AppendString(s: String(seq))
						hit = hit + 1
						if hit > 10 { break }
					}
				}
			}
			uiart.DrawCloud()
		}
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		uiart.translatesAutoresizingMaskIntoConstraints = false
		self.selectionStyle = .none
		//uiart.contentMode = .center
		contentView.addSubview(uiart)
		LayoutUI()
	}
	
	override func LayoutUI() {
		//contentView.translatesAutoresizingMaskIntoConstraints = false
		if expanded {
			self.accessoryType = .none
		} else {
			self.accessoryType = .disclosureIndicator
		}
		
		uiart.leadingAnchor.constraint (equalTo: contentView.leadingAnchor,constant: 0.0).isActive = true
		uiart.trailingAnchor.constraint (equalTo: contentView.trailingAnchor,constant: 0.0).isActive = true
		uiart.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0.0).isActive = true
		uiart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 0.0).isActive = true
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

