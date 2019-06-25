//
//  ActionSheetExtension.swift
//  TaxiApp
//
//  Created by Loay on 6/25/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

class ActionSheet<Cell: CarTypeTableViewCell>: UIView, UITableViewDelegate, UITableViewDataSource {

// Variables
    
    let screenSize = UIScreen.main.bounds.size
    
    var mainView: UIView?
    var transparentView: UIView?
    var tableView: UITableView?
    var tableHeigh: CGFloat?
    var tableCellHeight: CGFloat?
    
    var arr1 = [String]()
    var arr2 = [String]()
    
// Functions
    
    init(tHeigh: CGFloat, tCellHeight: CGFloat, a1: [String], a2: [String]) {
        
        tableHeigh = tHeigh
        tableCellHeight = tCellHeight
        
        arr1 = a1
        arr2 = a2
        
        super.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        makeView()
        defineTableData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineTableData() {
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.register(Cell.self, forCellReuseIdentifier: "actionSheetCell")
    }
    
    private func makeView() {
    
        self.mainView = UIView()
        self.transparentView = UIView()
        self.tableView = UITableView()
        
        mainView!.backgroundColor = UIColor.clear
        mainView!.frame = frame
        transparentView!.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        transparentView!.frame = frame
        transparentView!.alpha = 0.0
        adjustTable()
        tableView!.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: tableHeigh!)
        
        addSubview(mainView!)
        mainView!.addSubview(transparentView!)
        mainView!.addSubview(tableView!)
        
        addCanelGesture()
        animateView()
    }
    
    private func animateView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.transparentView!.alpha = 0.65
            self.tableView!.frame = CGRect(x: 0, y: self.screenSize.height-self.tableHeigh!, width: self.screenSize.width, height: self.tableHeigh!)
        }, completion: nil)
    }
    
    private func adjustTable() {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 5))
        headerView.backgroundColor = UIColor.gray
        
        self.tableView!.tableHeaderView = headerView
        self.tableView!.separatorStyle = .none
        self.tableView!.tableFooterView = UIView()
    }
    
    private func addCanelGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView!.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onClickTransparentView() {
        
        print("hey")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.transparentView!.alpha = 0.0
            self.tableView!.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.tableHeigh!)
        }, completion: { (true) in

            self.removeFromSuperview()
        })
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arr1.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "actionSheetCell", for: indexPath) as? Cell else {fatalError("Unable to dequeue cell")}
        
        if arr1.count > 0 {
            cell.cellLabel.text = arr1[indexPath.row]
        }
        if arr2.count > 0 {
            cell.cellLabelDesc.text = arr2[indexPath.row]
        }
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableCellHeight!
    }
}
