//
//  WebVC.swift
//  forReddit
//
//  Created by jacappsios on 10/26/18.
//  Copyright © 2018 mdwdev. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {

    @IBOutlet weak var postView: WKWebView!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post, let url = URL(string: post.url) {
            postView.load(URLRequest(url: url))
            self.title = post.title
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
