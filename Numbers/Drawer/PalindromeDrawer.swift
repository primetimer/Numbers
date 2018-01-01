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

/*
func drawMyText(myText:String,textColor:UIColor, FontName:String, FontSize:CGFloat, inRect:CGRect){

let textFont = UIFont(name: FontName, size: FontSize)!
let textFontAttributes = [
NSFontAttributeName: textFont,
NSForegroundColorAttributeName: textColor,
] as [String : Any]

myText.draw(in: inRect, withAttributes: textFontAttributes)
}
*/

class PalindromeView : DrawNrView {
	
	init () {
		super.init(frame: CGRect.zero)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var frame : CGRect {
		set {
			super.frame = newValue
			imageview.frame = CGRect(origin: .zero, size: newValue.size)
		}
		get { return super.frame }
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		CreateImages()
	}
	
	private func CreateImages()  {
		//var images : [UIImage] = []
		let rect = CGRect(x: 0, y: 0, width: 400.0, height: 400)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		guard let context = UIGraphicsGetCurrentContext() else { return }
		context.setStrokeColor(UIColor.black.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		let draw = PalindromeDrawer(nr: self.nr, rect: rect)
		draw.DrawNumber(context : context)
		if let srcImage  = UIGraphicsGetImageFromCurrentImageContext()
		{
			let flippedImage = UIImage(cgImage: srcImage.cgImage!, scale: srcImage.scale, orientation: UIImageOrientation.upMirrored)
			UIGraphicsEndImageContext()
			UIGraphicsBeginImageContext(rect.size)
			srcImage.draw(in: rect)
			flippedImage.draw(in: rect, blendMode: .normal, alpha: 1.0)
			let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
			UIGraphicsEndImageContext()
			imageview.image = newImage
		}
	}
}

class PalindromeDrawer : NSObject
{
	private var context : CGContext!
	private var nr : UInt64 = 1
	internal var rect : CGRect!
	internal var rx : CGFloat = 0
	internal var ry : CGFloat = 0
	//private var sphere = SphereDrawer()
	
	init(nr : UInt64, rect : CGRect) {
		super.init()
		self.nr = nr
		self.rect = rect
		self.rx = rect.maxX - rect.minX
		self.ry = rect.maxY - rect.minY
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
	
	func DrawNumber(context : CGContext)
	{
		let ptester = PalindromicTester()
		let base = ptester.PalindromicBase(n: BigUInt(self.nr))
		if base.count == 0 { return }
		self.context = context
		let w = rx / 2
		let h = ry
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .right
		
		let dy = ry / CGFloat(base.count)
		var y0 : CGFloat = 0
		for  b in base {

			var myText = String(nr,radix : b)
			if b == 2 { myText = myText + "₂" } // "₀ " //₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉
			if b == 16 { myText = myText + "₁₆" }
			var fontSize : CGFloat = 12.0
			var prevFontSize : CGFloat = fontSize
			
			while true {
				let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
								  NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize),
								  NSAttributedStringKey.foregroundColor : UIColor.red]
				let attrString = NSAttributedString(string: myText,attributes: attributes)
				let size = attrString.size()
				if size.width > w {
					let halfrect = CGRect(x:0 , y:y0 , width: w, height: dy)
					let color = colorWithGradient(frame: halfrect, colors: [.red,.blue])
					
					fontSize = prevFontSize
					let drawattributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
										  NSAttributedStringKey.font            :   UIFont.systemFont(ofSize:prevFontSize),
										  NSAttributedStringKey.foregroundColor : color,
										  ]
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





