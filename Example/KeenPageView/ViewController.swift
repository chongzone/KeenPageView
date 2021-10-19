//
//  ViewController.swift
//  KeenPageView
//
//  Created by chongzone on 03/13/2021.
//  Copyright (c) 2021 chongzone. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "KeenPageView"
        
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: UITableViewCell.className
        )
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 6 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        switch indexPath.row {
        case 0: cell.textLabel?.text = "default 模式"
        case 1: cell.textLabel?.text = "缩放 模式"
        case 2: cell.textLabel?.text = "遮盖 模式"
        case 3: cell.textLabel?.text = "下划线 模式"
        case 4: cell.textLabel?.text = "仿微博推荐标题栏"
        case 5: cell.textLabel?.text = "标题栏置于导航栏"
        default: cell.textLabel?.text = "其他 模式"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = NextVc()
        vc.type = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}
