//
//  ViewController.swift
//  UIImageViewLettersSampleSwift
//
//  Created by Tom Bachant on 1/28/17.
//  Copyright © 2017 Thomas Bachant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Simple example with a random background color
        let randomImage: UIImageView = UIImageView.init(frame: CGRect(x: self.view.bounds.midX - 40, y: self.view.bounds.midY - 80 - 40, width: 80, height: 80))
        self.view.addSubview(randomImage)
        
        randomImage.setImageForName(string: "Hello World", circular: true, textAttributes: nil, gradient: true)
        
        // More specific option with bg color and font specified
        let customImage: UIImageView = UIImageView.init(frame: CGRect(x: self.view.bounds.midX - 40, y: self.view.bounds.midY + 40, width: 80, height: 80))
        self.view.addSubview(customImage)
        
        customImage.setImageForName(string: "Custom Font", backgroundColor: .blue, circular: true, textAttributes: [NSFontAttributeName: UIFont(name: "AmericanTypewriter-Bold", size: 30)!, NSForegroundColorAttributeName: UIColor.init(white: 1.0, alpha: 0.5)])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

