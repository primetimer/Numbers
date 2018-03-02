//
//  WikiVC.swift
//  Numbers
//
//  Created by Stephan Jancar on 02.03.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit

class WikiVC : UIViewController , UIWebViewDelegate {
	
	var uiweb = UIWebView()
	
	override func viewDidLoad() {
		uiweb.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(uiweb)
		uiweb.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		uiweb.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		uiweb.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		uiweb.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
	
	func SetWikiUrl(wiki : String) {
		if let url = URL(string: wiki) {
			let request = URLRequest(url: url)
			uiweb.loadRequest(request)
			uiweb.delegate = self
		}
	}
	
	private var loaded : Bool = false
	func webViewDidFinishLoad(_ webView: UIWebView)
	{
		if loaded { return }
		loaded = true
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
