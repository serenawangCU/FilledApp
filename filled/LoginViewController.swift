//
//  LoginViewController.swift
//  filled
//
//  Created by Kaishuo Cheng on 2019/4/26.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var account: UITextField! = UITextField()
    var password: UITextField! = UITextField()
    var login: UIButton! = UIButton()
    var signup: UIButton! = UIButton()
    var backgroundimage: UIImageView = UIImageView()
    var homeuser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "login")
        backgroundimage.image = image
        backgroundimage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundimage)
        
        // This could also be another view, connected with an outlet
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        account.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        login.translatesAutoresizingMaskIntoConstraints = false
//        account.text = "Type your email"
//        password.text = "Type your password"
        password.backgroundColor = .white
        account.backgroundColor = .white
        login.setTitle("Login", for: .normal)
        login.setTitleColor(.white, for: .normal)
        login.titleLabel?.font = UIFont.italicSystemFont(ofSize: 28.0)
        login.addTarget(self, action: #selector(loginaccount), for: .touchUpInside)
        signup.setTitle("Signup", for: .normal)
        signup.setTitleColor(.white, for: .normal)
        signup?.titleLabel?.font = UIFont.italicSystemFont(ofSize: 28.0)
        signup.translatesAutoresizingMaskIntoConstraints = false
        signup.addTarget(self, action: #selector(signupaccount), for: .touchUpInside)
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        let accountattributedPlaceHolder = NSAttributedString(string: "Type Your Email", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        let passwordattributedPlaceHolder = NSAttributedString(string: "Type Your Password", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        account.attributedPlaceholder = accountattributedPlaceHolder
        password.attributedPlaceholder = passwordattributedPlaceHolder
        
        view.addSubview(account)
        view.addSubview(password)
        view.addSubview(login)
        view.addSubview(signup)
        setupconstraints()
        
        // Do any additional setup after loading the view.
    }

    func setupconstraints(){
        NSLayoutConstraint.activate([
            backgroundimage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundimage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundimage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundimage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
        NSLayoutConstraint.activate([
            account.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            account.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:60 ),
            account.heightAnchor.constraint(equalToConstant: 40),
            account.widthAnchor.constraint(equalToConstant: 250)
            ])
        NSLayoutConstraint.activate([
            password.centerXAnchor.constraint(equalTo: account.centerXAnchor ),
            password.topAnchor.constraint(equalTo: account.bottomAnchor, constant: 20),
            password.heightAnchor.constraint(equalToConstant: 40),
            password.widthAnchor.constraint(equalToConstant: 250)
            ])
        NSLayoutConstraint.activate([
            signup.leadingAnchor.constraint(equalTo: password.leadingAnchor),
            signup.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 40),
            
            ])
        NSLayoutConstraint.activate([
            login.trailingAnchor.constraint(equalTo: password.trailingAnchor),
            login.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 40),
            ])
        
    }

    @objc func loginaccount() {
        if let em = account.text{
            if let pw = password.text{
                
                UserNetworkManager.login(email: em, password: pw) { user in
                    self.homeuser = user
                    let viewcontroller = ViewController(hp: self.homeuser)
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
//                    print("User with token  logged in !")
                }
                
            }
            
        }
    }
    @objc func signupaccount() {
        if let em = account.text{
            if let pw = password.text{
                UserNetworkManager.signup(email: em, password: pw) { user in
                    self.homeuser = user
                    let viewcontroller = ViewController(hp: self.homeuser)
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
//                    print("User with token  signed up !")
            }
                
        }
        
        }
    }

}

