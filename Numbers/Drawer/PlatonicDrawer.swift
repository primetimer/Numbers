//
//  SquareDrawer.swift
//  Numbers
//
//  Created by Stephan Jancar on 15.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import SwiftyGif


class PlatonicView : DrawNrImageView {
	init () {
		super.init(frame: CGRect.zero)
		

		//imageview.image = imageURL
		//let imageView3 = UIImageView(image: imageURL)
		//self.imageview.frame = CGRect(x: 20.0, y: 390.0, width: self.view.frame.size.width - 40, height: 150.0)
		//view.addSubview(imageView3)
		
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override var frame : CGRect {
		didSet {
			imageview.frame = frame
			self.setNeedsDisplay()
		}
	}
	
	private var gif : UIImage {
		switch (self.nr) {
		case 4:
			return UIImage(gifName: "Tetrahedron.gif")
		case 6:
			return UIImage(gifName: "Hexahedron.gif")
		case 8:
			return UIImage(gifName: "Octahedron.gif")
		case 12:
			return UIImage(gifName: "Dodecahedron.gif")
		case 14:
			return UIImage(gifName: "Cuboctahedron.gif")
			
		//case 18:
			//return UIImage(gifName: "Truncatedtetrahedron.gif")
		case 20:
			return UIImage(gifName: "Icosahedron.gif")
		case 26:
			return UIImage(gifName: "Rhombicuboctahedron.gif")
		case 32:
			return UIImage(gifName: "Icosidodecahedron.gif")
		case 38:
			return UIImage(gifName: "Snubhexahedronccw.gif")
		case 62:
			return UIImage(gifName: "Rhombicosidodecahedron.gif")
		case 92:
			return UIImage(gifName: "Snubdodecahedronccw.gif")
		default:
			if nr % 3 == 0 && nr % 2 == 1 {
				return UIImage(gifName: "impossible.gif")
			} else {
				return UIImage(gifName: "Great_stellated_dodecahedron_truncations.gif")
				
			}
		}
	}
	override func StartImageWorker(rect:CGRect) {
		
		imageview.setGifImage(gif)
	}
	
}

/*
class PlatonicDrawer : NSObject
{
	private var context : CGContext!
	private var nr : UInt64 = 1
	private var rect : CGRect!
	
	init(nr : UInt64, rect : CGRect) {
		super.init()
		self.nr = nr
		self.rect = rect
	}
	
	private func colorWithGradient(frame: CGRect, colors: [UIColor]) -> UIColor {
		
		// create the background layer that will hold the gradient
		let backgroundGradientLayer = CAGradientLayer()
		backgroundGradientLayer.frame = frame
		
		// we create an array of CG colors from out UIColor array
		let cgColors = colors.map({$0.cgColor})
		
		backgroundGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
		backgroundGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
		backgroundGradientLayer.colors = cgColors
		
		UIGraphicsBeginImageContext(backgroundGradientLayer.bounds.size)
		backgroundGradientLayer.render(in: UIGraphicsGetCurrentContext()!)
		let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return UIColor(patternImage: backgroundColorImage!)
	}
	
	private func Font(base : Int, fontsize : CGFloat) -> UIFont {
		if base != 20 {
			return UIFont.systemFont(ofSize: fontsize)
		}
		
		if let font = UIFont(name: "mayan", size: fontsize) {
				return font
		}
		return UIFont.systemFont(ofSize: fontsize)
	}
	
	private func Attributes(base : Int, fontsize : CGFloat, color : UIColor ) -> [NSAttributedStringKey: Any] {
		let font = Font(base:base,fontsize:fontsize)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center

		let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
						  NSAttributedStringKey.font: font,
						  NSAttributedStringKey.foregroundColor : color]
		return attributes
	}
	
	func DrawNumber(context : CGContext)
	{
		let ptester = PalindromicTester()
		let base = ptester.PalindromicBase(n: BigUInt(self.nr))
		if base.count == 0 { return }
		self.context = context
		let w = rect.width
		
		
		let dy = rect.height / CGFloat(base.count) 
		var y0 : CGFloat = 0
		for  b in base {
			var myText = BigUInt(nr).asString(toBase : b)
			if b == 2 { myText = myText + "₂" } // "₀ " //₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉
			if b == 16 { myText = myText + "₁₆" }
			
			var fontSize : CGFloat = 12.0
			var prevFontSize : CGFloat = fontSize
			
			while true {
				let attributes = Attributes(base: b, fontsize: fontSize, color : .red)
				let attrString = NSAttributedString(string: myText,attributes: attributes)
				let size = attrString.size()
				if size.width > w || size.height > dy {
					let halfrect = CGRect(x:0 , y:y0 , width: w, height: dy)
					let color = colorWithGradient(frame: halfrect, colors: [.red,.blue])
					
					fontSize = prevFontSize
					let drawattributes = Attributes(base: b, fontsize: fontSize, color: color)
					let drawString = NSAttributedString(string: myText,attributes: drawattributes)
					let drawsize = drawString.size()
					let y = (dy - drawsize.height) / 2.0
					let rt = CGRect(x: 0, y: y + y0 , width: w, height: dy)
					drawString.draw(in: rt)
					break
				}
				prevFontSize = fontSize
				fontSize = fontSize + 2.0
			}
			y0 = y0 + dy
		}
	}
}
*/





