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
import FutureKit

class NumeralArtCell: BaseNrTableCell {
	private (set) var uiart = UIWordCloudViewDeep()
	override var nr : BigUInt {
		get { return super.nr }
		set {
			if nr != newValue || nr == 0 {
				super.nr = newValue
				uiart.Clear()
				for type in NumeralCellType.allValues {
					let s = nr.getNumeral(type: type)
					let font = type == .Maya ? "mayan" : nil
					uiart.AppendString(s: s,font: font)
				}
				uiart.setNeedsDisplay()
			}
		}
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		uiart.translatesAutoresizingMaskIntoConstraints = false
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

