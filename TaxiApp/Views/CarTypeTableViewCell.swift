//
//  CarTypeTableViewCell.swift
//  TaxiApp
//
//  Created by Loay on 6/23/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

class CarTypeTableViewCell: UITableViewCell {

    lazy var backView: UIView = {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 65))
        return view
    }()
    
//    lazy var settingImage: UIImageView = {
//
//        let imageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
    
    lazy var cellLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: self.frame.width, height: 30))
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir Next", size: 13)
        return label
    }()
    
    lazy var cellLabelDesc: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 0, y: 41, width: self.frame.width, height: 20))
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.font = UIFont(name: "Avenir Next", size: 11)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        addSubview(backView)
        //backView.addSubview(settingImage)
        backView.addSubview(cellLabel)
        backView.addSubview(cellLabelDesc)
    }

}
