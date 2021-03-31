//
//  HostViewController.swift
//  LLNative_Example
//
//  Created by ZHK on 2021/2/3.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class HostViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = UserDefaults.standard.value(forKey: "host") as? String
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        UserDefaults.standard.setValue(textView.text.lowercased().trimmingCharacters(in: CharacterSet.whitespaces), forKey: "host")
        UserDefaults.standard.synchronize()
        navigationController?.popViewController(animated: true)
    }

}
