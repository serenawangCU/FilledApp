//
//  ProfileViewController.swift
//  filled
//
//  ProfileViewController.swift
//  kc673_p5
//
//  Created by Kaishuo Cheng on 2019/4/29.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import AudioToolbox
class ProfileViewController: UIViewController {
    weak var delegate: ChangelikeDelegate?
    var profileImage: UIImageView
    
    var nameLabel: UILabel
    var nameText: UITextField
    var genderLabel: UILabel
    var genderText: UITextField
    var ageLabel: UILabel
    var ageText: UITextField
    var heightLabel: UILabel
    var heightText: UITextField
    var likeButton: UIButton
    var likeByOthersButton: UIButton
    var heliked: [briefUser]
    var likehim: [briefUser]
    var homeuser: User
    var save: UIButton!
    var updateimage: UIButton!
    init(person: User) {
        homeuser = person
        
        profileImage = UIImageView()
        nameLabel = UILabel()
        nameText = UITextField()
        genderLabel = UILabel()
        genderText = UITextField()
        ageLabel = UILabel()
        ageText = UITextField()
        heightText = UITextField()
        heightLabel = UILabel()
        likeButton = UIButton()
        likeByOthersButton = UIButton()
        heliked = person.helike
        likehim = person.likedhim
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
     

       
            profileImage = UIImageView(image: UIImage(named: "blankuser"))
        if let string = self.homeuser.Picture{
            if let data = NSData(base64Encoded: self.homeuser.Picture!, options: NSData.Base64DecodingOptions(rawValue: 0)){
                let image = UIImage(data: data as Data)
                if let Data = image?.pngData() {
                    self.profileImage.image = image
                }
            }}
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Name"
        
        
        nameText = UITextField()
        nameText.translatesAutoresizingMaskIntoConstraints = false
        nameText.backgroundColor = .white
        nameText.text = homeuser.username
        nameText.textColor = .blue
        
        genderLabel = UILabel()
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.text = "Gender"
        
        
        genderText = UITextField()
        genderText.translatesAutoresizingMaskIntoConstraints = false
        genderText.backgroundColor = .white
        genderText.text = homeuser.gender
        genderText.textColor = .blue
        
        ageLabel = UILabel()
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.text = "Age"
        
        
        ageText = UITextField()
        ageText.translatesAutoresizingMaskIntoConstraints = false
        ageText.backgroundColor = .white
        ageText.text = String(homeuser.age)
        ageText.textColor = .blue
        
        heightLabel = UILabel()
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.text = "Height"
        
        
        heightText = UITextField()
        heightText.translatesAutoresizingMaskIntoConstraints = false
        heightText.backgroundColor = .white
        heightText.text = homeuser.height
        heightText.textColor = .blue
        
        likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setTitle("People You Liked", for:.normal)
        likeButton.setTitleColor(.white, for: .normal)
        likeButton.addTarget(self, action: #selector(pushheliked), for: .touchUpInside)
        likeButton.setBackgroundImage(UIImage(named: "red"), for: .normal)
        
        likeByOthersButton = UIButton()
        likeByOthersButton.translatesAutoresizingMaskIntoConstraints = false
        likeByOthersButton.setTitle("Who Liked You", for: .normal)
        likeByOthersButton.setTitleColor(.white, for: .normal)
        likeByOthersButton.addTarget(self, action: #selector(pushlikehim), for: .touchUpInside)
        likeByOthersButton.setBackgroundImage(UIImage(named: "red"), for: .normal)
        
        save = UIButton()
        save.translatesAutoresizingMaskIntoConstraints = false
        save.setTitle("Save", for: .normal)
        save.setTitleColor(.blue, for: .normal)
        save.addTarget(self, action: #selector(saveclicked), for: .touchUpInside)
        
        updateimage = UIButton()
        updateimage.translatesAutoresizingMaskIntoConstraints = false
        updateimage.setTitle("UpdateImage", for: .normal)
        updateimage.setTitleColor(.blue, for: .normal)
        updateimage.addTarget(self, action: #selector(changeimage), for: .touchUpInside)
        view.addSubview(nameLabel)
        view.addSubview(profileImage)
        view.addSubview(nameText)
        view.addSubview(genderLabel)
        view.addSubview(genderText)
        view.addSubview(ageLabel)
        view.addSubview(ageText)
        view.addSubview(heightText)
        view.addSubview(heightLabel)
        view.addSubview(likeButton)
        view.addSubview(likeByOthersButton)
        view.addSubview(save)
        view.addSubview(updateimage)
        setupConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            profileImage.widthAnchor.constraint(equalToConstant: 150)
            ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 40),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50)
            ])
        
        NSLayoutConstraint.activate([
            nameText.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nameText.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 100),
            nameText.widthAnchor.constraint(equalToConstant: 150),
            nameText.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40),
            genderLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            genderText.centerYAnchor.constraint(equalTo: genderLabel.centerYAnchor),
            genderText.leadingAnchor.constraint(equalTo: nameText.leadingAnchor),
            genderText.widthAnchor.constraint(equalToConstant: 150),
            genderText.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 40),
            ageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            ageText.centerYAnchor.constraint(equalTo: ageLabel.centerYAnchor),
            ageText.leadingAnchor.constraint(equalTo: nameText.leadingAnchor),
            ageText.widthAnchor.constraint(equalToConstant: 150),
            ageText.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        NSLayoutConstraint.activate([
            heightLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 40),
            heightLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            heightText.centerYAnchor.constraint(equalTo: heightLabel.centerYAnchor),
            heightText.leadingAnchor.constraint(equalTo: nameText.leadingAnchor),
            heightText.widthAnchor.constraint(equalToConstant: 150),
            heightText.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -220),
            likeButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 60)
            ])
        
        NSLayoutConstraint.activate([
            likeByOthersButton.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 20),
            likeByOthersButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            likeByOthersButton.heightAnchor.constraint(equalToConstant: 60)
            ])
        NSLayoutConstraint.activate([
            save.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            save.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60),
            
            ])
        NSLayoutConstraint.activate([
            updateimage.topAnchor.constraint(equalTo: save.topAnchor),
            updateimage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60)
            ])
    }
    
    
    @objc func pushlikehim(){
        let newviewcontroller = likehimViewController(homeperson: homeuser)
        navigationController?.pushViewController(newviewcontroller, animated: true)
    }
    @objc func pushheliked(){
        let newviewcontroller = HelikedViewController(homeperson: homeuser)
        navigationController?.pushViewController(newviewcontroller, animated: true)
    }
    @objc func saveclicked(){
        AudioServicesPlaySystemSound(1100);
        let Data = profileImage.image?.pngData() as! NSData
        let picturestring = Data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        homeuser.Picture = picturestring
        var correctgender = ""
        var correctname = ""
        var correctage = 0
        var correctheight = ""
  
        if let thisgender = genderText.text{
            correctgender = thisgender
            homeuser.gender = thisgender}

        if let thisname = nameText.text{
            correctname = thisname
            homeuser.username = thisname}
        if let thisheight = heightText.text{
            correctheight = thisheight
            homeuser.height = thisheight}
        if let thisage = Int(ageText.text!){
            correctage = thisage
            homeuser.age = thisage

        delegate?.likeChanged(homeperson: homeuser)
        navigationController?.popViewController(animated: true)
            UserNetworkManager.updateUser(userid: self.homeuser.id, age: correctage, Picture: picturestring, height: correctheight, Username: correctname, gender: correctgender) {
            print("successfully updated")
        }
        
        }}
    @objc func changeimage(){
        ImagePickerManager().pickImage(self){ image in
           self.profileImage.image = image
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
