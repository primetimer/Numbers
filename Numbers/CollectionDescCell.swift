//
//  DescCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 01.01.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit

class DescCollectionCell: BaseNrCollectionCell , UIWebViewDelegate {
	private (set) var uidesc = UIWebView()
	
	override init(frame: CGRect){
		super.init(frame: frame)
		contentView.addSubview(uidesc)
		#if false
			uidesc.isUserInteractionEnabled = false
			uidesc.font = UIFont(name: "Arial", size: 18.0)
			uidesc.frame = CGRect(x: 10.0, y: 0, width: self.frame.width, height: self.frame.height)
			
			uidesc.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
			uidesc.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
			uidesc.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
			uidesc.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		#else
			uidesc.isUserInteractionEnabled = false
			uidesc.frame = CGRect(x: 10.0, y: 0, width: self.frame.width, height: self.frame.height)
			
			uidesc.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
			uidesc.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
			uidesc.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
			//uidesc.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
			
		#endif
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private var _html = ""
	private var _loaded = false
	func SetHtmlDesc(html : String) {
		if html == _html { return }
		_html = html
		_loaded = false
		uidesc.delegate = self
		uidesc.loadHTMLString(html, baseURL: nil)
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView)
	{
		if _loaded { return }
		_loaded = true
		//tableparent?.beginUpdates()
		//tableparent?.endUpdates()
	}
	
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		switch navigationType {
		case .linkClicked:
			// Open links in Safari
			guard let url = request.url else { return true }
			
			if #available(iOS 10.0, *) {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			} else {
				// openURL(_:) is deprecated in iOS 10+.
				UIApplication.shared.openURL(url)
			}
			return false
		default:
			// Handle other navigation types...
			return true
		}
	}
}

