//
//  FaktorView.swift
//  Numbers
//
//  Created by Stephan Jancar on 15.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit


class FaktorView: DrawNrView {
	
	var param = FaktorDrawerParam()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func SetNumber(_ nextnr : UInt64) {
		super.SetNumber(nextnr)
		param.nr = nextnr
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		param.withanimation = true
		if param.withanimation {
			CreateImages(rect)
			imageview.animationDuration = TimeInterval(param.maxrekurs)
			imageview.animationRepeatCount = 1
			imageview.isUserInteractionEnabled = true
			if param.withanimation {
				imageview.startAnimating()
			}
		} else {
			CreateImages(rect)
			imageview.animationDuration = 0
			imageview.animationRepeatCount = 1
			imageview.isUserInteractionEnabled = true
			
		}
	}
	
	private func CreateImages(_ rect : CGRect)  {
		var images : [UIImage] = []
		let drawer = param.CreateDrawer(rect)
		let maxrekurs = drawer.CalcRekursLevel()
		
		do {
			for k in 0...maxrekurs {
				param.maxrekurs = UInt64(k)
				param.rectLimit = 64
				param.rect = rect
				
				UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
				let context = UIGraphicsGetCurrentContext()
				
				if (k > 0) && (param.type != .circle) {
					images[k-1].draw(in: rect)
					//CGContextDrawImage(context, rect, self.ulamimage?.CGImage)
				}
				
				context!.setStrokeColor(UIColor.black.cgColor)
				context!.setLineWidth(1.0);
				context!.beginPath()
				let drawer = param.CreateDrawer(rect)
				drawer.drawFaktor(rect,context: context!)
				
				let newimage  = UIGraphicsGetImageFromCurrentImageContext()
				images.append(newimage!)
				UIGraphicsEndImageContext()
				
			}
			imageview.animationImages = images
			imageview.image = images.last
			
		}
	}
}



