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
			DispatchQueue.global().async {
				var images = self.CreateImages()
				if let last = images.last {
					let stillcount = images.count
					for _ in 0...stillcount {
						images.append(last)
					}
				}

				DispatchQueue.main.async(execute: {
					self.imageview.animationImages = images
					self.imageview.image = images.last
					self.imageview.animationDuration = TimeInterval(self.param.maxrekurs)
					self.imageview.animationRepeatCount = 4
					//self.imageview.isUserInteractionEnabled = true
					self.imageview.startAnimating()
				})
			}
		} else {
			let images = CreateImages()
			imageview.image = images.last
			imageview.animationDuration = 0
			imageview.animationRepeatCount = 1
			//imageview.isUserInteractionEnabled = true
		}
	}
	
	private func CreateImages()  -> [UIImage] {
		let rect = CGRect(x: 0, y: 0, width: 400.0, height: 400.0)
		var images : [UIImage] = []
		let drawer = param.CreateDrawer(rect)
		let maxrekurs = drawer.CalcRekursLevel()
		print("Drawing:",String(self.nr))
		
		do {
			for k in 0...maxrekurs {
				self.param.imagenr = k				//Only for ulam
				self.param.imagemax = maxrekurs		//Only for ulam
				self.param.maxrekurs = UInt64(k)
				self.param.rectLimit = 64
				self.param.rect = rect
				UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
				let context = UIGraphicsGetCurrentContext()
				if (k > 0) && (self.param.type != .circle) {
					images[k-1].draw(in: rect)
					//CGContextDrawImage(context, rect, self.ulamimage?.CGImage)
				}
				context!.setStrokeColor(UIColor.black.cgColor)
				context!.setLineWidth(1.0);
				context!.beginPath()
				let drawer = self.param.CreateDrawer(rect)
				drawer.drawFaktor(rect,context: context!)
				
				let newimage  = UIGraphicsGetImageFromCurrentImageContext()
				images.append(newimage!)
				UIGraphicsEndImageContext()
			}
		}
		return images
	}
}



