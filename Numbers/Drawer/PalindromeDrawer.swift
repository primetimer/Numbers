//
//  SquareDrawer.swift
//  Numbers
//
//  Created by Stephan Jancar on 15.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit

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
	/*
	private var _imageview : UIImageView? = nil
	var imageview : UIImageView {
		get {
			if _imageview == nil {
				let rect = CGRect(x: 0, y: 0 , width: frame.width, height: frame.height)
				_imageview = UIImageView(frame:rect)
				_imageview?.backgroundColor = self.backgroundColor
				addSubview(_imageview!)
			}
			return _imageview!
		}
	}
	*/
	
	override var frame : CGRect {
		set {
			super.frame = newValue
			imageview.frame = CGRect(origin: .zero, size: newValue.size)
		}
		get { return super.frame }
	}
	
	/*
	private var nr : UInt64 = 1
	func SetNumber(_ nextnr : UInt64) {
		self.nr = nextnr
	}
	*/
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		CreateImages(rect)
	}
	
	private func CreateImages(_ rect : CGRect)  {
		//var images : [UIImage] = []
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
		
		self.context = context
		let w = rx / 2
		let h = ry 
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .right
		
		let myText = String(nr)
		
		var fontSize : CGFloat = 12.0
		var prevFontSize : CGFloat = fontSize
		
		while true {
			let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
						  NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize),
						  NSAttributedStringKey.foregroundColor : UIColor.red,
			]
		
			let attrString = NSAttributedString(string: myText,attributes: attributes)
			let size = attrString.size()
			if size.width > w {
				let halfrect = CGRect(x:0 , y:0 , width: w, height: h)
				let color = colorWithGradient(frame: halfrect, colors: [.red,.blue])
				
				fontSize = prevFontSize
				let drawattributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
								  NSAttributedStringKey.font            :   UIFont.systemFont(ofSize:prevFontSize),
								  NSAttributedStringKey.foregroundColor : color,
								  ]
				let drawString = NSAttributedString(string: myText,attributes: drawattributes)
				let drawsize = drawString.size()
				let y = (h - drawsize.height) / 2.0 // - drawsize.height / 2.0
				
			
				let rt = CGRect(x: 0, y: y, width: w, height: h)
				drawString.draw(in: rt)
				break
			}
			prevFontSize = fontSize
			fontSize = fontSize + 2.0
		}
	}
}





