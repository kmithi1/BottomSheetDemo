//
//  BottomViewController.swift
//  BottomSheetDemo
//
//  Created by Mithilesh Kumar on 12/09/18.
//  Copyright © 2018 PhonePe. All rights reserved.
//

import UIKit

class BottomViewController: UIViewController, BottomSheet {
    var scrollView: UIScrollView? {
        return self.tableView
    }
    
    var navigationBar: UINavigationBar? = nil
    
    var containerViewControllerDelegate: ContainerViewControllerDelegate?
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    init() {
        super.init(nibName: "BottomViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BottomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "defaultcell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 7 {
            cell.textLabel?.text = " ------- Dismiss --------"
        } else {
            cell.textLabel?.text = "Row - \(indexPath.row) - Open new sheet"
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 7 {
            self.containerViewControllerDelegate?.dismissViewController(animated: true)
            return
        }
        
        let anotherVC = BottomViewController()
        self.containerViewControllerDelegate?.showViewController(anotherVC, animated: true)
    }
}
