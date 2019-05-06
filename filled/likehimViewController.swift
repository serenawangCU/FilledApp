//
//  likehim.swift
//  filled
//
//  Created by kaishuo cheng on 4/30/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class likehimViewController: UIViewController {
let layoutforcollectionview = UICollectionViewFlowLayout()
    var display: UICollectionView!
    let likehimreusecellidentifier = "likehimreusecellidentifier"
    var people: [briefUser]
    var homeperson: User
    init(homeperson: User){
        
        self.homeperson = homeperson
        self.people = homeperson.likedhim
        display = UICollectionView(frame: .zero, collectionViewLayout: layoutforcollectionview)
        display.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        display.translatesAutoresizingMaskIntoConstraints = false
        display.backgroundColor = .white
        display.dataSource = self
        display.delegate = self
        display.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: likehimreusecellidentifier)
        view.addSubview(display)
        
        
        setupconstrainst()
        // Do any additional setup after loading the view.
    }
    
    
    func setupconstrainst(){
        NSLayoutConstraint.activate([
            display.topAnchor.constraint(equalTo: view.topAnchor),
            display.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            display.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            display.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
    }
    
}
extension likehimViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: likehimreusecellidentifier, for: indexPath) as! PersonCollectionViewCell
        let person = people[indexPath.item]
        cell.configure(for: person)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return people.count}
    
}

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
//        if collectionView != filterbar{
//            headerView.frame.size.height = 0.0
//            headerView.frame.size.width = 0.0
//        }
//        return headerView
//        }
//
//







extension likehimViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let length = (collectionView.frame.width - padding) / 2.0
        return CGSize(width: length, height: 2*length)
        
        
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return CGSize(width: collectionView.frame.width, height: headerHeight)
    //    }
    
}
extension likehimViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let user = people[indexPath.row]
        let ViewController = DetailViewController(homeperson: homeperson, guestperson: user)
        navigationController?.pushViewController(ViewController, animated: true)
        
        
        
    }
    
}
