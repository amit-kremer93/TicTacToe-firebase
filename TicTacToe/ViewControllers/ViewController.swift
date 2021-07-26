//
//  ViewController.swift
//  TicTacToe
//
//  Created by Amit Kremer on 06/06/2021.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    @IBOutlet weak var greetingsLBL: UILabel!
    
    @IBOutlet weak var helloLBL: UILabel!
//    var userName: String?
//    var userID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
//        userName = UserDefaults.standard.string(forKey: Constants.Strings.userName);
//        userID = UserDefaults.standard.string(forKey: Constants.Strings.userID);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            print(user?.email ?? "ff")
            self.greetingsLBL.text = "Hello \(user?.email ?? "ff")"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ngc = segue.destination as? NewGameViewController
        let btn: UIButton = sender as! UIButton
        if btn.titleLabel?.text == "New Game" {
            ngc?.isPlayer1 = true
        } else if btn.titleLabel?.text == "Join A Game" {
            ngc?.isPlayer1 = false
        }
    }
}

