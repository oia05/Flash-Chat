//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    var messages: [Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = getTitleView()
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        messageTextfield.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.register(UINib(nibName: K.youCellNibName, bundle: nil), forCellReuseIdentifier: K.youCellIdentifier)
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { snapshot, error in
            if let error {
                print("Error fetching documents: \(error)")
            } else {
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }
                self.messages = documents.map {
                    let data = $0.data()
                    let sender = data[K.FStore.senderField] as! String
                    let message = data[K.FStore.bodyField] as! String
                    return Message(sender: sender, body: message)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    private func getTitleView() -> UILabel {
        let titleView = UILabel()
        titleView.text = K.appName
        titleView.textColor = .white
        titleView.font = .systemFont(ofSize: 30, weight: .bold)
        return titleView
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let sender = Auth.auth().currentUser?.email {
            messageTextfield.text = nil
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: sender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { error in
                if let e = error {
                    print("There was a problem saving data to firestore: \(e)")
                } else {
                    print("Data saved successfully")
                }
            }
        }
        
    }
}


// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.sender == Auth.auth().currentUser?.email {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
            cell.messageLabel.text = messages[indexPath.row].body
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.youCellIdentifier, for: indexPath) as! YouMessageCell
            cell.messageLabel.text = messages[indexPath.row].body
            cell.selectionStyle = .none
            return cell
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
