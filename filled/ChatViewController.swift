//
//  ChatViewController.swift
//  filled
//
//  Created by kaishuo cheng on 5/1/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import AudioToolbox
//        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(getMessage), userInfo: nil, repeats: true)
class ChatViewController: UIViewController {
    var homeuser: User
    var guestuser: briefUser
    var chatlist: [message]
    var chattableview: UITableView!
    var send: UIButton!
    var textzone: UITextField!
    let chatcellreuseidentifier = "chatcellreuseidentifer"
    init(homeuser: User, guestuser: briefUser){
        self.homeuser = homeuser
        self.guestuser = guestuser
        self.chatlist = []
       

        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {

        view.backgroundColor = .white
        super.viewDidLoad()
        self.title = "chat"
        var firstid = homeuser.id
        var secondid = guestuser.id
        if homeuser.id > guestuser.id{
            firstid = guestuser.id
            secondid = homeuser.id
        }
        UserNetworkManager.getMessage(id1:firstid, id2:secondid, completion: { (messages) in
            self.chatlist = messages.data
            self.chattableview.reloadData()

        })
        chattableview = UITableView(frame: .zero)
        chattableview.translatesAutoresizingMaskIntoConstraints = false
        chattableview.backgroundColor = .white
        chattableview.dataSource = self
        chattableview.delegate = self
        chattableview.register(MessageTableViewCell.self, forCellReuseIdentifier:chatcellreuseidentifier)
        
        send = UIButton()
        send.setTitle("send", for: .normal)
        send.setTitleColor(.white, for: .normal)
        send.backgroundColor = .blue
        send.translatesAutoresizingMaskIntoConstraints = false
        send.addTarget(self, action: #selector(sendmessage), for: .touchUpInside)
        
        textzone = UITextField()
        textzone.translatesAutoresizingMaskIntoConstraints = false
        textzone.backgroundColor = .gray
        view.addSubview(textzone)
        view.addSubview(send)
        view.addSubview(chattableview)
var  timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(getMessage), userInfo: nil, repeats: true)
        setupconstrainst()
        
    }
 
    func setupconstrainst(){
        NSLayoutConstraint.activate([
        chattableview.topAnchor.constraint(equalTo: view.topAnchor),
        chattableview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        chattableview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        chattableview.bottomAnchor.constraint(equalTo:  view.bottomAnchor, constant: -100) ])
        NSLayoutConstraint.activate([
        send.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        send.widthAnchor.constraint(equalToConstant: 40),
        send.heightAnchor.constraint(equalToConstant: 40),
        send.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)])
        NSLayoutConstraint.activate([textzone.topAnchor.constraint(equalTo: send.topAnchor),
                                     textzone.bottomAnchor.constraint(equalTo: send.bottomAnchor),
            textzone.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textzone.trailingAnchor.constraint(equalTo: send.leadingAnchor, constant: -20)
            ])
    }
    @objc func sendmessage(){
        if let thischat = textzone.text{
            if thischat != ""{
                AudioServicesPlaySystemSound(1001)
                let thismessage = message(chat: thischat, id: homeuser.id)
                self.chatlist.append(thismessage)
                var firstid = homeuser.id
                var secondid = guestuser.id
                if homeuser.id > guestuser.id{
                    firstid = guestuser.id
                    secondid = homeuser.id
                }
                UserNetworkManager.updateMessage(id1:firstid, id2:secondid,sender: homeuser.id, addingmessage: thismessage) {
                    
                }
                self.chattableview.reloadData()
                textzone.text = ""
            }
        }
    }
    @objc func getMessage(){
        var firstid = homeuser.id
        var secondid = guestuser.id
        if homeuser.id > guestuser.id{
            firstid = guestuser.id
            secondid = homeuser.id
        }
        UserNetworkManager.getMessage(id1: firstid, id2: secondid) { (messages) in
            self.chatlist = messages.data
            self.chattableview.reloadData()
        }
    }
}
    extension ChatViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: chatcellreuseidentifier, for: indexPath) as! MessageTableViewCell
            let singlemessage = chatlist[indexPath.item]
            var picture: UIImage
            var backgroundcolor : UIColor
            if homeuser.id == singlemessage.id{
                let data = NSData(base64Encoded: self.homeuser.Picture!, options: NSData.Base64DecodingOptions(rawValue: 0))
                picture = UIImage(data: data! as Data)!
    
                backgroundcolor = .green
            }
            else{
                let data = NSData(base64Encoded: self.guestuser.Picture!, options: NSData.Base64DecodingOptions(rawValue: 0))
                picture = UIImage(data: data! as Data)!
                
                backgroundcolor = .white
            }
            
            cell.configure(for: picture, info: singlemessage, color: backgroundcolor)
            cell.selectionStyle = .none
            
            return cell
        }

        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
                return chatlist.count}
        
        }
        
    
    

    

extension ChatViewController: UITableViewDelegate {


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 5*padding
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                return
            }
    



}

