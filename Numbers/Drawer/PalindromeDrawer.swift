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

class PalindromeView : DrawNrView {
	init () {
		super.init(frame: CGRect.zero)
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
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		imageview.stopAnimating()
		if let image = NumberImage(rect: rect) {
			imageview.image = image
			var transform = CATransform3DIdentity;
			transform.m34 = 1.0 / 500.0;
			let t1 = CATransform3DRotate(transform, CGFloat(-1 * Double.pi), 0, 1, 0)
			let t2 = CATransform3DRotate(transform, CGFloat(-0.5 * Double.pi ), 0, 1, 0)
			let t3 = CATransform3DRotate(transform, CGFloat(+0.5 * Double.pi ), 0, 1, 0)
			let t4 = CATransform3DRotate(transform, CGFloat(1 * Double.pi ), 0, 1, 0)
			
			//imageview.layer.transform = transform
			/*
			let animation = CABasicAnimation(keyPath: "transform")
			animation.fromValue = NSValue(caTransform3D: t1)
			animation.toValue = NSValue(caTransform3D:t2)
			animation.duration = 3
			animation.repeatCount = .infinity
			*/
			let animation = CAKeyframeAnimation(keyPath: "transform")
			animation.values = [t1,t2,t3,t4]
			animation.duration = 3
			animation.repeatCount = .infinity
			
			
			imageview.layer.add(animation, forKey: "transform")

	

			
			/*
			imageview.animationImages = Blend(image: image, rect: rect)
			imageview.animationRepeatCount = 0
			imageview.animationDuration = 2.0
			imageview.startAnimating()
			*/
		}
	}
	
	private func Blend(image1 : UIImage, image2 : UIImage, rect: CGRect, alpha : CGFloat) -> UIImage? {
		if alpha == 0.0 { return image1 }
		if alpha == 1.1 { return image2 }
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		image1.draw(in: rect)
		image2.draw(in: rect, blendMode: .multiply, alpha: alpha)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		return image
		
	}
	private func Blend(image : UIImage, rect : CGRect) -> [UIImage] {
		var images : [UIImage] = [image]
		let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: UIImageOrientation.upMirrored)
		
		let blendmax = 10
		for i in 0...blendmax {
			let alpha = CGFloat(i) / CGFloat(blendmax)
			guard let blend = Blend(image1: image, image2: flippedImage, rect: rect, alpha: alpha) else { return images }
			images.append(blend)
		}
		let reversed = images.reversed()
		for r in reversed {
			images.append(r)
		}
		return images
	}
	
	private func NumberImage(rect : CGRect) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		
		context.setStrokeColor(UIColor.black.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		let draw = PalindromeDrawer(nr: self.nr, rect: rect)
		draw.DrawNumber(context : context)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		return image
	}
	/*
		}
		
		if let srcImage  =
		{
			let flippedImage = UIImage(cgImage: srcImage.cgImage!, scale: srcImage.scale, orientation: UIImageOrientation.upMirrored)
			//UIGraphicsEndImageContext()
			//UIGraphicsBeginImageContext(rect.size)
			srcImage.draw(in: rect)
			#if false
			//let fliprect = CGRect(x:rect.minX,y:rect.minY + rect.height / 2.0, width: rect.width,height: rect.height)
			let fliprect = rect
			flippedImage.draw(in: fliprect, blendMode: .normal, alpha: 0.5)
				#endif
			let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
			//UIGraphicsEndImageContext()
			imageview.image = newImage
		}
	}
	*/
}

class PalindromeDrawer : NSObject
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
		
		
		let dy = rect.height / CGFloat(base.count+1) 
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





