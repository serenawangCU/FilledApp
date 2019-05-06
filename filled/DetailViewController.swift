//
//  DetailViewController.swift
//  kc673_p5
//
//  Created by kaishuo cheng on 4/14/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import AudioToolbox
class DetailViewController: UIViewController {
weak var helikedelegate : ChangelikeDelegate?
    var guestperson: briefUser
    var homeperson: User
    var picture: UIImageView
    var username: UITextField
    var chat: UIButton!
    var like : UIButton!
    var age: UITextField!
    var height: UITextField!
    init(homeperson : User, guestperson: briefUser){
        self.homeperson = homeperson
       self.guestperson = guestperson
        let imagedata = NSData(base64Encoded: guestperson.Picture!, options: NSData.Base64DecodingOptions(rawValue:0))
       
        picture = UIImageView()
        picture.image = UIImage(data: imagedata! as Data)
        username = UITextField()
        age = UITextField()
        height = UITextField()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(picture)
        
        
        username.text = "Name: \(guestperson.username)"

        username.textColor = .black
        username.translatesAutoresizingMaskIntoConstraints = false
        username.font = UIFont.systemFont(ofSize: 25)
        picture.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(username)
        username.backgroundColor = .white
       
        age.textColor = .black
        age.translatesAutoresizingMaskIntoConstraints = false
        age.font = UIFont.systemFont(ofSize: 25)
        picture.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(age)
        age.backgroundColor = .white
        
        age.text = "Age : \(guestperson.age)"
        
        height.textColor = .black
        height.translatesAutoresizingMaskIntoConstraints = false
        height.font = UIFont.systemFont(ofSize: 25)
        picture.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(height)
        height.backgroundColor = .white
  
        height.text = "Height: \(guestperson.height)"
        chat = UIButton()
        chat.setBackgroundImage(UIImage(named: "chat"), for: .normal)
        chat.translatesAutoresizingMaskIntoConstraints = false
        chat.addTarget(self, action: #selector(popchat), for: .touchUpInside)
        view.addSubview(chat)
        
        like = UIButton()
        
        like.translatesAutoresizingMaskIntoConstraints = false
        let checkliked = homeperson.helike.contains{element in
            if element.id == guestperson.id{
                return true}
            else{
                return false
            }}
        if checkliked{
            like.isSelected = true
            
        }
        like.setBackgroundImage(UIImage(named: "heart"), for: .selected)
        like.setBackgroundImage(UIImage(named: "emptyheart"), for: .normal)
        like.addTarget(self, action: #selector(updatelike), for: .touchUpInside)
        view.addSubview(like)
        setupconstrainst()
        // Do any additional setup after loading the view.
    }
    

    func setupconstrainst(){
        NSLayoutConstraint.activate([
            picture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 30),
            picture.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            picture.widthAnchor.constraint(equalToConstant: 300),
            picture.heightAnchor.constraint(equalToConstant: 300)
            ])
        NSLayoutConstraint.activate([
            username.topAnchor.constraint(equalTo: picture.bottomAnchor, constant: 40),
            username.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            username.widthAnchor.constraint(equalToConstant: 200),
            username.heightAnchor.constraint(equalToConstant: 40)
            ])
        NSLayoutConstraint.activate([
            age.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 15),
            age.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            age.widthAnchor.constraint(equalToConstant: 200),
            age.heightAnchor.constraint(equalToConstant: 40)
            ])
        NSLayoutConstraint.activate([
            height.topAnchor.constraint(equalTo: age.bottomAnchor, constant: 15),
            height.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            height.widthAnchor.constraint(equalToConstant: 200),
            height.heightAnchor.constraint(equalToConstant: 40)
            ])
        NSLayoutConstraint.activate([
            like.topAnchor.constraint(equalTo: height.bottomAnchor, constant: 40),
            like.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            like.widthAnchor.constraint(equalToConstant: 80),
            like.heightAnchor.constraint(equalToConstant: 80)
            
            ])
        NSLayoutConstraint.activate([
            chat.topAnchor.constraint(equalTo: like.topAnchor),
            chat.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            chat.heightAnchor.constraint(equalToConstant: 80),
            chat.widthAnchor.constraint(equalToConstant: 80)
            ])
    }
    @objc func popchat(){
        AudioServicesPlaySystemSound(1000);
        var firstid = homeperson.id
        var secondid = guestperson.id
        if homeperson.id > guestperson.id{
            firstid = guestperson.id
            secondid = homeperson.id
        }
        UserNetworkManager.createchat(id1:firstid, id2:secondid) { () in
            
        }
        let chatview = ChatViewController(homeuser: homeperson, guestuser: guestperson)
        navigationController?.pushViewController(chatview, animated: true)
    }
    @objc func updatelike(){
        
        if like.isSelected == true{
            AudioServicesPlaySystemSound(0x450);
            like.isSelected = false
            UserNetworkManager.dislike(homeuserid: homeperson.id, guestuserid: guestperson.id) {
                
            }
            let newlist = homeperson.helike.filter{element in
                if (element.id != guestperson.id){
                    return true
                }
                else{
                    return false
                }
                
            }
            homeperson.helike = newlist
            helikedelegate?.likeChanged(homeperson: homeperson)
   
        }
        else{
            like.isSelected = true
            AudioServicesPlaySystemSound(1020);
            UserNetworkManager.like(homeuserid: homeperson.id ,guestuserid: guestperson.id) {
                
            }
            homeperson.helike.append(guestperson)

            helikedelegate?.likeChanged(homeperson: homeperson)
            
        }
        
        }
        
    }


