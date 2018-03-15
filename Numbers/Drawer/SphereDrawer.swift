//
//  DrawUtil.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 14.08.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import Foundation
import UIKit

class SphereDrawer : NSObject
{
	func drawSphere(_ context : CGContext, xy: CGPoint, r : CGFloat, col : [UIColor])
	{
		var startPoint = CGPoint()
		startPoint.x = xy.x //- r * 0.5
		startPoint.y = xy.y //- r * 0.5
		var endPoint = CGPoint()
		endPoint.x = startPoint.x - r * 0.0
		endPoint.y = startPoint.y - r * 0.0
		
		let startRadius: CGFloat = 0
		var colors = [UIColor.white.cgColor,col[0].cgColor]
		if col.count>=2 {
			colors = [col[0].cgColor, col[1].cgColor]
		}
	
		let colorspace = CGColorSpaceCreateDeviceRGB()
		let locations: [CGFloat] = [0.0, 1.0]
		let gradient = CGGradient(colorsSpace: colorspace,colors: colors as CFArray, locations: locations)
		let endRadius : CGFloat = max(1.0,r )
		context.drawRadialGradient (gradient!, startCenter: xy,
									startRadius: startRadius, endCenter: endPoint, endRadius: endRadius,
									options: CGGradientDrawingOptions(rawValue: 0))
	}
}

class RingDrawer : NSObject {
	var starthue : CGFloat = 0.0
	var endhue : CGFloat = 1.0
	var endangle = CGFloat(Double.pi * 2.0)
	var startangle = CGFloat(0.0)
	func draw(_ c : CGContext,x: CGFloat, y: CGFloat, r: CGFloat, width : CGFloat) {
		if abs(endangle - startangle) > CGFloat(Double.pi) {
			let ring1 = RingDrawer()
			ring1.startangle = self.startangle
			ring1.endangle = (self.startangle + self.endangle) / 2.0
			ring1.endhue = (self.starthue + self.endhue) / 2.0
			ring1.starthue = self.starthue
			ring1.draw(c, x: x, y: y, r: r, width: width)
			
			let ring2 = RingDrawer()
			ring2.endangle = endangle
			ring2.startangle = (self.startangle + self.endangle) / 2.0
			
			ring2.endhue = self.endhue
			ring2.starthue = (self.starthue + self.endhue) / 2.0
			ring2.draw(c, x: x, y: y, r: r, width: width)
			return
		}
		let startCol = UIColor(hue: CGFloat(starthue),saturation: 1.0,brightness: 1.0, alpha: 1.0)
		let endCol = UIColor(hue: CGFloat(endhue),saturation: 1.0,brightness: 1.0, alpha: 1.0)
		
		let arc = CGMutablePath()
		let strokedArc =
			CGPath(__byStroking: arc, transform: nil, lineWidth: width, lineCap: .butt, lineJoin: .miter, miterLimit: 10)
		c.addPath(strokedArc!);
		c.setFillColor(startCol.cgColor)
		c.drawPath(using: .fill);
		let baseSpace = CGColorSpaceCreateDeviceRGB()
		let colors = [ startCol.cgColor , endCol.cgColor]
		let gradient = CGGradient(colorsSpace: baseSpace, colors: colors as CFArray, locations: nil);
		
		c.saveGState()
		c.addPath(strokedArc!)
		c.clip()
		
		let x0 = x + (r+width) * cos(startangle)
		let y0 = y + (r+width) * sin(startangle)
		let x1 = x + (r+width) * cos(endangle)
		let y1 = y + (r+width) * sin(endangle)
		
		let gradientStart = CGPoint(x: x0,y: y0);
		let gradientEnd   = CGPoint(x: x1,y: y1);
		let options = CGGradientDrawingOptions(rawValue : 0)
		
		c.drawLinearGradient(gradient!, start: gradientStart, end: gradientEnd, options: options);
		c.restoreGState();
	}
}


