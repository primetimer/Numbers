//
//  DescCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 01.01.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit

class DescTableCell: BaseNrTableCell , UIWebViewDelegate {
	private (set) var uidesc = UIWebView()
	private var parentvc : UIViewController? = nil
	func setParentVC(vc : UIViewController) {
		self.parentvc = vc
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
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
			uidesc.frame = CGRect(x: 10.0, y: 0, width: self.frame.width, height: self.frame.height)
			
			uidesc.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
			uidesc.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
			uidesc.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
			uidesc.dataDetectorTypes = []
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
		tableparent?.beginUpdates()
		//webView.frame.size = webView.sizeThatFits(.zero)
		tableparent?.endUpdates()
	}
	
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		switch navigationType {
		case .linkClicked:
			// Open links
			guard let url = request.url else { return true }
			//let subvc = WikiVC()
			let subvc = WikiTVC()
			subvc.SetWikiURL(url: url.absoluteString, nr: self.nr)
			parentvc?.navigationController?.pushViewController(subvc, animated: true)
			return false
		default:
			// Handle other navigation types...
			return true
		}
	}
}

