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

class DrawNrView : UIView {

	internal var _imageview : UIImageView? = nil
	var imageview : UIImageView {
		get {
			if _imageview == nil {
				_imageview = UIImageView()
				_imageview?.backgroundColor = self.backgroundColor
				_imageview?.translatesAutoresizingMaskIntoConstraints = false
				addSubview(_imageview!)
				_imageview!.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
				_imageview!.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
				_imageview!.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
				_imageview!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
			}
			return _imageview!
		}
	}
	/* 8.3.2018 not needed
	override var frame : CGRect {
		set {
			super.frame = newValue
			imageview.frame = CGRect(origin: .zero, size: newValue.size) #
		}
		get { return super.frame }
	}
	*/

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
	
