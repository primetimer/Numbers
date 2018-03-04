//
//  ViewController.swift
//  Numbers
//
//  Created by Stephan Jancar on 03.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import UIKit
import iosMath
import BigInt
import PrimeFactors
import YouTubePlayer

class BaseNrCollectionCell : UICollectionViewCell {
	var nr : BigUInt = 0
	var tableparent : UICollectionView? = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
class BaseNrTableCell : UITableViewCell {
	var nr : BigUInt = 0
	var tableparent : UITableView? = nil
	internal var expanded : Bool = false
	
	
	//internal func LayoutUI() {}
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.accessoryType = .disclosureIndicator
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class FormTableCell: BaseNrTableCell {
	private (set) var uimath = MTMathUILabel()
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.accessoryType = .none
		uimath.fontSize = 18.0
		uimath.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(uimath)
		uimath.leadingAnchor.constraint (equalTo: contentView.leadingAnchor,constant: 10.0).isActive = true
		uimath.trailingAnchor.constraint (equalTo: contentView.trailingAnchor,constant: 0.0).isActive = true
		uimath.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0.0).isActive = true
		uimath.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 0.0).isActive = true
		//uimath.frame = CGRect(x: 10.0, y: 10.0, width: self.frame.width, height: self.frame.height)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class CustomTableViewHeader: UITableViewHeaderFooterView {
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		//contentView.backgroundColor = .orange
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

