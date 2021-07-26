//
//  GameHistoryViewController.swift
//  TicTacToe
//
//  Created by Amit Kremer on 22/07/2021.
//

import UIKit

class GameHistoryViewController: UIViewController {
    @IBOutlet weak var backBTN: UIButton!
    var userName: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName = UserDefaults.standard.string(forKey: Constants.Strings.userName);
        
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}
