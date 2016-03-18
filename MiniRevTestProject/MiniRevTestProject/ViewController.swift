//
//  ViewController.swift
//  MiniRevTestProject
//
//  Created by Hugo Alonso on 3/17/16.
//  Copyright © 2016 Hugo Alonso. All rights reserved.
//

import UIKit
import MiniRev

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
            RateHandler.userHasOpenedDataView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rateAction(sender: AnyObject) {
        RateHandler.presentRateDialog(self)
    }
}

