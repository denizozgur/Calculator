//
//  HistoryViewController.swift
//  Calculator
//
//  Created by Doe on 2/9/18.
//  Copyright © 2018 Doe. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
	var passedHistory = " "
    @IBOutlet weak var historyListLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        historyListLabel.text = passedHistory
		let swipeLeftgesture = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
		self.view.addGestureRecognizer(swipeLeftgesture)
		
    }
	


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindBackToVC1", sender: nil)
    }
	

}
