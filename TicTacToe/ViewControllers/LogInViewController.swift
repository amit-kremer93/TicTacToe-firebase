//
//  LogInViewController.swift
//  TicTacToe
//
//  Created by Amit Kremer on 25/07/2021.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    @IBOutlet weak var registerBTN: UIButton!
    @IBOutlet weak var signInBTN: UIButton!
    @IBOutlet weak var emailTXT: UITextField!
    @IBOutlet weak var passwordTXT: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }
    
    func moveToMainScreen() -> Void {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "mainCV") as? UIViewController {
                self.present(viewController, animated: true, completion: nil)
            }
    }

    @IBAction func signIn(_ sender: UIButton) {
        let email = emailTXT.text
        let password = passwordTXT.text
        Auth.auth().signIn(withEmail: email!, password: password!) { authResult, error in
            if (error != nil){
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{action in
                        }))
                        self.present(alert, animated: true, completion: nil)
            }else {
                //move to next screen
                print("moved")
                self.moveToMainScreen()
            }
        }
    }
    @IBAction func register(_ sender: UIButton) {
        let email = emailTXT.text
        let password = passwordTXT.text
        Auth.auth().createUser(withEmail: email!, password: password!) { authResult, error in
            if (error != nil){
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{action in
                        }))
                        self.present(alert, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "Welcome!", message: "Let's start play!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Let's go!", style: UIAlertAction.Style.default, handler:{action in
                        }))
                self.present(alert, animated: true) {
                    //move to next screen
                    print("moved")
                    self.moveToMainScreen()
                }
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
