//
//  ViewController.swift
//  LLNative
//
//  Created by Ruris on 02/02/2021.
//  Copyright (c) 2021 Ruris. All rights reserved.
//

import UIKit
import LLNative
import WKWebViewJavascriptBridge
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    private lazy var bridge = WKWebViewJavascriptBridge(webView: webView)
    
    private var isBundlePage: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bridge.registerLLNative("99fd6b62bc270c9bc820dc111f370acd")
        
//        print(UIApplication.shared.delegate?.window)
//        print(UIApplication.shared.keyWindow)

        print(NSHomeDirectory())
    }

    @IBAction func reloadWebView(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    func keyWindow() -> UIWindow? {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow
        }
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes.lazy
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first(where: { $0.isKeyWindow })
        } else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let host = UserDefaults.standard.value(forKey: "host") as? String,
              let hostURL = URL(string: host) {
            if hostURL.path != webView.url?.path {
                webView.load(URLRequest(url: hostURL))
            }
        } else {
            guard let bundlePath = Bundle.main.path(forResource: "H5", ofType: "bundle"),
                  let filePath = Bundle(path: bundlePath)?.path(forResource: "index", ofType: "html"),
                  let html = try? String(contentsOfFile: filePath, encoding: .utf8) else {
                return
            }
            if isBundlePage == false {
                webView.loadHTMLString(html, baseURL: nil)
                isBundlePage = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
