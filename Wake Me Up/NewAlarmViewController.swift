//
//  NewAlarmViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/8/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit

class NewAlarmViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBarBackground = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 153/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        statusBarBackground.backgroundColor = statusBarColor
        view.addSubview(statusBarBackground)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
