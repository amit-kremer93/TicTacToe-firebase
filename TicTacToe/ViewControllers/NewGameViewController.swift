//
//  NewGameViewController.swift
//  TicTacToe
//
//  Created by Amit Kremer on 06/06/2021.
//

import UIKit
import Firebase

class NewGameViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var gameIDLBL: UILabel!
    @IBOutlet weak var turnsLBL: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var cahtTextField: UITextField!
    @IBOutlet weak var sendChatBTN: UIButton!
    @IBOutlet weak var chatTextView: UITextField!
    
    var currentPlayer = 0
    var player1 = [Int]()
    var player2 = [Int]()
    var ref: DatabaseReference!
    var gameUUID: String!
    var buttonsArray: [UIButton] = [UIButton]();
    var messages = [Message]()
    var isPlayer1: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupTable()
        self.buttonsArray = [self.btn1, self.btn2, self.btn3, self.btn4, self.btn5, self.btn6, self.btn7, self.btn8, self.btn9]
        ref = Database.database().reference()
        if isPlayer1 {
            self.renderGameForPlayer1()
        }else {
//            self.renderGameForPlayer2()
        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isPlayer1{
            showJoinToGameAlert()
        }
    }
    
    func renderGameForPlayer1() {
        self.setUUIDForGame()
        self.setChatListener()
        self.ref.child("games").child(gameUUID).child("currentPlayer").setValue(0);
        self.setRTDBListenersForPlayer1()
        
        
    }
   
    func renderGameForPlayer2() {
        self.setRTDBListenersForPlayer2()
    }
    
    func setChatListener() {
        _ = self.ref.child("games").child(gameUUID).child("chat").observe(DataEventType.value, with: { snapshot in
            if(snapshot.exists()){
                self.renderMessages(msgArr: snapshot.value as! NSArray)
            }
        })
    }
    
    func showJoinToGameAlert(){
        let alert = UIAlertController(title: "Join A Game!", message: "Please Enter The Game ID", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Let's Start!", style: UIAlertAction.Style.default, handler:{action in
            self.gameUUID = alert.textFields![0].text
            self.gameIDLBL.text = self.gameUUID;
            if(self.gameUUID == "" || self.gameUUID.isEmpty){
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    return
                }
            }
            self.ref.child("games").child(self.gameUUID).getData { Error, dataSnapshot in
                if((Error != nil) || !dataSnapshot.exists()) {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                if(dataSnapshot.exists()){
                    print("start to play")
                    self.renderGameForPlayer2()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func renderMessages(msgArr: NSArray) {
        for dic in msgArr {
            let msgAsDic = dic as! Dictionary<String, String>
            let txt = msgAsDic["message"]
            let side = msgAsDic["side"]
            let msg = Message(message: txt, side: side)
            if !messages.contains(msg) {
                messages.append(msg)
            }
            chatTableView.reloadData()
        }
        
    }
    
    func setUUIDForGame(){
        let uuid = UUID().uuidString
        gameUUID = String(uuid.prefix(8))
        gameIDLBL.text = gameUUID
    }
    func setRTDBListenersForPlayer1() {
        _ = self.ref.child("games").child(gameUUID).child("player2").observe(DataEventType.value, with: { snapshot in
            if(snapshot.exists()){
                for btn in (snapshot.value ?? [Int]()) as! NSArray {
                    let btnIndex = btn as! Int
                    self.buttonsArray[btnIndex].backgroundColor = UIColor(red: 32/255, green: 192/255, blue: 243/255, alpha: 0.5)
                    self.buttonsArray[btnIndex].setTitle("O", for: UIControl.State.normal)
                    self.buttonsArray[btnIndex].isEnabled = false
                    if(!self.player2.contains(btnIndex)){
                        self.player2.append(btnIndex)
                    }
                    self.ref.child("games").child(self.gameUUID).child("currentPlayer").setValue(self.currentPlayer+1);
                    self.findWinner()
                }
            }
        })
        _ = self.ref.child("games").child(gameUUID).child("currentPlayer").observe(DataEventType.value, with: { snapshot in
            if(snapshot.exists()){
                self.currentPlayer = snapshot.value as? Int ?? 0
                if(self.currentPlayer % 2 == 0){
                    self.turnsLBL.text = "Your turn"
                }else{
                    self.turnsLBL.text = "Opponent turn"
                }
            }
        })
    }
    
    func setRTDBListenersForPlayer2() {
        _ = self.ref.child("games").child(gameUUID).child("player1").observe(DataEventType.value, with: { snapshot in
            if(snapshot.exists()){
                for btn in (snapshot.value ?? [Int]()) as! NSArray {
                    let btnIndex = btn as! Int
                    self.buttonsArray[btnIndex].backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
                    self.buttonsArray[btnIndex].setTitle("X", for: UIControl.State.normal)
                    self.buttonsArray[btnIndex].isEnabled = false
                    if(!self.player1.contains(btnIndex)){
                        self.player1.append(btnIndex)
                    }
//                    self.ref.child("games").child(self.gameUUID).child("currentPlayer").setValue(self.currentPlayer+1);
                    self.findWinner()
                }
            }
        })
        _ = self.ref.child("games").child(gameUUID).child("currentPlayer").observe(DataEventType.value, with: { snapshot in
            if(snapshot.exists()){
                self.currentPlayer = snapshot.value as? Int ?? 0
                if(self.currentPlayer % 2 != 0){
                    self.turnsLBL.text = "Your turn"
                }else{
                    self.turnsLBL.text = "Opponent turn"
                }
            }
        })
        self.setChatListener()
    }
    
    func setupTable() {
        // config tableView
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.dataSource = self
        chatTableView.backgroundColor = .white
        chatTableView.tableFooterView = UIView()
        chatTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        // cell setup
        chatTableView.register(UINib(nibName: "RightViewCell", bundle: nil), forCellReuseIdentifier: "RightViewCell")
        chatTableView.register(UINib(nibName: "LeftViewCell", bundle: nil), forCellReuseIdentifier: "LeftViewCell")
        
    }
    
    
    @IBAction func BoardBTNClicked(_ sender: UIButton) {
        if currentPlayer % 2 == 0 {
            if isPlayer1{
                sender.setTitle("X", for: UIControl.State.normal)
                sender.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
                player1.append(sender.tag)
                self.ref.child("games").child(gameUUID).child("player1").setValue(player1);
                currentPlayer += 1
                self.ref.child("games").child(gameUUID).child("currentPlayer").setValue(currentPlayer);
                sender.isEnabled = false
                findWinner()
            }else{
                print("waiting for player 1...")
            }
        }else{
            if isPlayer1 {
                print("waiting for player 2...")
            }else {
                sender.setTitle("O", for: UIControl.State.normal)
                sender.backgroundColor = UIColor(red: 32/255, green: 192/255, blue: 243/255, alpha: 0.5)
                player2.append(sender.tag)
                self.ref.child("games").child(gameUUID).child("player2").setValue(player2);
                currentPlayer += 1
                self.ref.child("games").child(gameUUID).child("currentPlayer").setValue(currentPlayer);
                sender.isEnabled = false
                findWinner()
            }
        }
    }
    
    func findWinner()  {
        var winner = -1
        
        // row1
        if( player1.contains(0) &&  player1.contains(1) &&  player1.contains(2)){
            winner = 1
        }
        
        if( player2.contains(0) &&  player2.contains(1) &&  player2.contains(2)){
            winner = 2
        }
        
        // row2
        if( player1.contains(3) &&  player1.contains(4) &&  player1.contains(5)){
            winner = 1
        }
        
        if( player2.contains(3) &&  player2.contains(4) &&  player2.contains(5)){
            winner = 2
        }
        
        
        // row3
        if( player1.contains(6) &&  player1.contains(7) &&  player1.contains(8)){
            winner = 1
        }
        
        if( player2.contains(6) &&  player2.contains(7) &&  player2.contains(8)){
            winner = 2
        }
        
        
        // col1
        if( player1.contains(0) &&  player1.contains(3) &&  player1.contains(6)){
            winner = 1
        }
        
        if( player2.contains(0) &&  player2.contains(3) &&  player2.contains(6)){
            winner = 2
        }
        
        // col2
        if( player1.contains(1) &&  player1.contains(4) &&  player1.contains(7)){
            winner = 1
        }
        
        if( player2.contains(1) &&  player2.contains(4) &&  player2.contains(7)){
            winner = 2
        }
        
        // col3
        if( player1.contains(2) &&  player1.contains(5) &&  player1.contains(8)){
            winner = 1
        }
        
        if( player2.contains(2) &&  player2.contains(5) &&  player2.contains(8)){
            winner = 2
        }
        
        // allachson 1
        if( player1.contains(0) &&  player1.contains(4) &&  player1.contains(8)){
            winner = 1
        }
        
        if( player2.contains(0) &&  player2.contains(4) &&  player2.contains(8)){
            winner = 2
        }
        // allachson 12
        if( player1.contains(2) &&  player1.contains(4) &&  player1.contains(6)){
            winner = 1
        }
        
        if( player2.contains(2) &&  player2.contains(4) &&  player2.contains(6)){
            winner = 2
        }
        
        if winner != -1 {
            
            var msg = ""
            if winner == 1 {
               msg = " Player 1 is winner"
            }else{
              msg = " Player 2 is winner"
            }
            //show alert
            let alert = UIAlertController(title: "We Have A WINNER!", message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Finish", style: UIAlertAction.Style.default, handler: { UIAlertAction in
                self.dismiss(animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func dismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func sendChatClicked(_ sender: UIButton) {
        let messageTxt = self.chatTextView.text
        if(messageTxt == "" || messageTxt!.isEmpty == true){
            return
        }
        var msg: Message
        if isPlayer1{
            msg = Message(message: messageTxt! as String, side: .right)
        }else {
            msg = Message(message: messageTxt! as String, side: .left)
        }
        
        messages.append(msg)
        let arr = Utils.MessagesArrayForFireBase(msgArr: messages)
        self.ref.child("games").child(gameUUID).child("chat").setValue(arr)
        self.chatTextView.text = ""
    }
    
}

extension NewGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.side == .left {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftViewCell") as! LeftViewCell
            cell.configureCell(message: message)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightViewCell") as! RightViewCell
            cell.configureCell(message: message)
            return cell
        }
    }
    
}
