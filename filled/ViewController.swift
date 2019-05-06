//
//  ViewController.swift
//  filled
//
//  Created by kaishuo cheng on 4/28/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation
let Data = UIImage(named: "blankuser")!.pngData() as! NSData
let picturestring = Data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

protocol ChangelikeDelegate: class {
    func likeChanged(homeperson: User)
}
let image: UIImage = UIImage(named: "billgates")!
let imageData:NSData = image.pngData()! as NSData
let imagestring = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
let Person1 = User(Picture: imagestring, age: 1, email: "zht1", gender: "he", height: "5'8", helike: [], id: 1,  likedhim: [], password: "male", username: "zht1")
let Person2 = User(Picture: imagestring, age: 1, email: "zht1", gender: "he", height: "5'8", helike: [], id: 1,  likedhim: [], password: "male", username: "zht1")
let Person3 = User(Picture: imagestring, age: 1, email: "zht1", gender: "he", height: "5'8", helike: [], id: 1,  likedhim: [], password: "male", username: "zht1")
let Person4 = User(Picture: imagestring, age: 1, email: "zht1", gender: "he", height: "5'8", helike: [], id: 1,  likedhim: [], password: "male", username: "zht1")

class ViewController: UIViewController {
    var homeperson: User
    init(hp: User){
        homeperson = hp
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var AudioPlayer = AVAudioPlayer()
    var stop = UIButton()
    var profileImage: UIImage!
    var text: UITextField!
    var timer : Timer!
    
    var collectionview: UICollectionView!
    
    let padding: CGFloat = 20
    let headerHeight: CGFloat = 30
    let userCellReuseIdentifier = "userCellReuseIdentifier"
    let headerReuseIdentifier = "headerReuseIdentifier"
    let filtercellreuseidentifer = "filtercellreuseidentifierå"
    let tableviewcellreuseidentifier = "tableviewcellreuseidentifer"
    let timebarcellreuseidentifer = "timecellreuseidentifer"
    var users: [briefUser]! = []
    
    
    let usertypes = Feature.allCases
    let timeslots = Type.allCases
   
    var tableview : UITableView = UITableView()
   var profileButton: UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
//        while self.users.count < 5 {
//
//            var flag = true
//            UserNetworkManager.getRandom { (response) in
//
//            for i in self.users{
//                if (i.id == response.id){
//                    flag  = false
//                }
//            }
//            if(flag){
//                self.users.append(response)
//                }}
//        }
//        print(self.users.count)
        view.backgroundColor = .white
        // Do any additional setup after loading the view, typically from a nib.
        title = "Filled"
        // construct users
        
        self.navigationController?.isNavigationBarHidden = false
        
        let layoutforcollectionview = UICollectionViewFlowLayout()
        // user grid view
        
        layoutforcollectionview.scrollDirection = .horizontal
        layoutforcollectionview.minimumInteritemSpacing = padding
        layoutforcollectionview.minimumLineSpacing = padding
        
        collectionview = UICollectionView(frame: .zero, collectionViewLayout: layoutforcollectionview)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.backgroundColor = .white
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: userCellReuseIdentifier)
        

        view.addSubview(collectionview)
       
        
        
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "background", ofType: "mp3")!)
        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer.prepareToPlay()
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.play()
        

        let layoutforfilterbar = UICollectionViewFlowLayout()
        layoutforfilterbar.scrollDirection = .horizontal
        layoutforfilterbar.minimumInteritemSpacing = padding/2

        let layoutfortimebar = UICollectionViewFlowLayout()
        layoutfortimebar.scrollDirection = .horizontal
        layoutfortimebar.minimumInteritemSpacing = padding/2

        profileButton.title = "Profile"
        profileButton.tintColor = .blue
        profileButton.target = self
        profileButton.action = #selector(pushPViewController)
        

        stop.setImage(UIImage(named: "pause"), for: .normal)
        stop.translatesAutoresizingMaskIntoConstraints = false
        stop.addTarget(self, action: #selector(stopclicked), for: .touchUpInside)
        view.addSubview(stop)
        
        self.navigationItem.leftBarButtonItem = profileButton
    UserNetworkManager.getRandom(completion: { (response) in
            self.users = response
        self.collectionview.reloadData()
          print(self.users.count)
        })
      
        setupConstraints()


    }
    func setupConstraints() {

        NSLayoutConstraint.activate([
            collectionview.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
            collectionview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            collectionview.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        NSLayoutConstraint.activate([
            stop.topAnchor.constraint(equalTo: collectionview.bottomAnchor,constant: 40),
            stop.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stop.widthAnchor.constraint(equalToConstant: 50),
            stop.heightAnchor.constraint(equalToConstant: 50)

            ])
        
    }
    
    
    @objc func pushPViewController() {
        let nViewController = ProfileViewController(person: homeperson)
        navigationController?.pushViewController(nViewController, animated: true)
        nViewController.delegate = self
    }
    
    @objc func stopclicked(){
        if AudioPlayer.isPlaying{
            AudioPlayer.stop()
        }
        else{
            AudioPlayer.play()
        }
    }
   
 

}
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userCellReuseIdentifier, for: indexPath) as! PersonCollectionViewCell
            let singleuser = users[indexPath.item]
            cell.configure(for: singleuser)
            return cell
        }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            return users.count}
        
    }
    





extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            let length = collectionView.frame.width
            return CGSize(width: length, height: length)
            
        
        
    }
    
  
    
}
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionview{
            
            let user = users[indexPath.row]
            let newViewController = DetailViewController(homeperson: homeperson, guestperson: user)
            navigationController?.pushViewController(newViewController, animated: true)
             newViewController.helikedelegate = self
        }
        
        
    }
    
}

extension ViewController: ChangelikeDelegate{
    func likeChanged(homeperson: User) {
        
        self.homeperson = homeperson
       
        
    }
    
    
}
