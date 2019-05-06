//
//  RestaurantCollectionViewCell.swift
//  kc673_p5
//
//  Created by kaishuo cheng on 4/14/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

// restaurant collection view
class PersonCollectionViewCell: UICollectionViewCell {
    var photoImageView: UIImageView
    var name: UILabel!
    override init(frame: CGRect) {
       
        
        photoImageView = UIImageView(frame: .zero)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFit
        name = UILabel()
        name.font = name.font.withSize(60)
         super.init(frame: frame)
        contentView.addSubview(photoImageView)
        contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
        
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            name.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor)
            ])
    }
    func configure(for user: briefUser){
        let imagedata = NSData(base64Encoded: user.Picture!, options: NSData.Base64DecodingOptions(rawValue:0))
        photoImageView.image = UIImage(data: imagedata! as Data)
        name.text = user.username
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class MessageTableViewCell: UITableViewCell {
    var photoImageView: UIImageView
    var singlemessage: UILabel!
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        
        photoImageView = UIImageView(frame: .zero)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFit
        singlemessage = UILabel()
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photoImageView)
        contentView.addSubview(singlemessage)
        singlemessage.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
        
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 40)
            ])
        NSLayoutConstraint.activate([
           singlemessage.topAnchor.constraint(equalTo: contentView.topAnchor),
           singlemessage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ])
    }
    func configure(for picture: UIImage, info : message, color: UIColor){
       
        self.photoImageView.image = picture
        self.singlemessage.text = info.chat
        print("info.chat")
        self.singlemessage.backgroundColor = color
        self.singlemessage.textColor = .black
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

