//
//  WikiCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 02.03.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit

class WikiTableCell: BaseNrTableCell , UIWebViewDelegate {
	private (set) var uiweb = UIWebView()
	private var wikiurl : String = ""
	func SetWikiUrl(wiki : String) {
		if wiki == wikiurl {
			return
		}
		wikiurl = wiki
		if let url = URL(string: wiki) {
			let request = URLRequest(url: url)
			uiweb.loadRequest(request)
			uiweb.delegate = self
		}
	}
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(uiweb)
		//uidesc.font = UIFont(name: "Arial", size: 18.0)
		//uiweb.frame = CGRect(x: 10.0, y: 0, width: self.frame.width, height: NrViewController.wikiheight)
		uiweb.translatesAutoresizingMaskIntoConstraints = false
		uiweb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
		uiweb.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant : 0.0).isActive = true
		uiweb.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		uiweb.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	func webViewDidFinishLoad(_ webView: UIWebView)
	{
		let scrollPoint = CGPoint(x: 0, y: 48.0)
		uiweb.scrollView.setContentOffset(scrollPoint, animated: true)//Set false if you doesn't want animation

		/*
		if let table = self.superview as? UITableView {
		let idx = IndexPath(row: 0, section: 2)
		table.reloadRows(at: [idx], with: .automatic)
		}
		*/
	}
}

