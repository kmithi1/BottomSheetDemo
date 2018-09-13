//
//  FirstViewController.swift
//  BottomSheetDemo
//
//  Created by Mithilesh Kumar on 12/09/18.
//  Copyright © 2018 PhonePe. All rights reserved.
//

import UIKit

protocol StoreDiscoveryMapDelegate: class {
    
}

protocol ContainerViewControllerDelegate: class {
    func dismissViewController(animated: Bool)
    func showViewController(_ viewController: BottomSheetViewController, animated: Bool)
}

protocol StoreDiscoveryDataSource: class {
    
}

protocol BottomSheet: class {
    var scrollView: UIScrollView? {get}
    var navigationBar: UINavigationBar? {get}
    var containerViewControllerDelegate: ContainerViewControllerDelegate? {get set}
}

typealias BottomSheetViewController = UIViewController & BottomSheet

final class BottomSheetItem {
    var topDistance: CGFloat = 0
    weak var bottomSheetViewController: BottomSheetViewController?
    
    init(topDistance: CGFloat, bottomSheet: BottomSheetViewController) {
        self.topDistance = topDistance
        self.bottomSheetViewController = bottomSheet
    }
}

final class BottomSheetNavigationManager {
    
    private var sheets = [BottomSheetItem]()
    weak var containerView: ContainerView?
    
    init(containerView: ContainerView) {
        self.containerView = containerView
    }
    
    public func show(bottomSheetItem: BottomSheetItem, animated: Bool = false) {
        guard let vc = bottomSheetItem.bottomSheetViewController else {
            return
        }
        
        self.containerView?.show(bottomSheetViewController: vc)
    }
    
    public func dismiss(bottomSheetItem: BottomSheetItem, animated: Bool = false) {
        
    }
    
    public func dismissTopItem(animated: Bool = false) {
        
    }
}

class ContainerViewController: UIViewController {
    
    var mainViewController: MapViewController!
    var bottomViewController: BottomViewController!
    var defaultTopDistance: CGFloat {
        let distance = UIScreen.main.bounds.size.height * 0.8
        return distance
    }
    
    private lazy var containerView: ContainerView = {
        return ContainerView(mainViewController: mainViewController, bottomSheetViewController: nil)
    }()
    
    private lazy var navigationManager: BottomSheetNavigationManager = {
        return BottomSheetNavigationManager(containerView: self.containerView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainViewController = MapViewController()
        self.bottomViewController = BottomViewController()
        
        addChildViewController(mainViewController)
        addChildViewController(bottomViewController)
        
        self.view.addSubview(containerView)
       
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let vMainViewConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[bottomSheetContainerView]-0-|", options: .alignAllCenterX, metrics: nil, views: ["bottomSheetContainerView": containerView])
        let hMainViewConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bottomSheetContainerView]-0-|", options: .alignAllCenterX, metrics: nil, views: ["bottomSheetContainerView": containerView])
        self.view.addConstraints(vMainViewConstraint + hMainViewConstraint)
        
        mainViewController.didMove(toParentViewController: self)
        bottomViewController.didMove(toParentViewController: self)
        
        self.showViewController(self.bottomViewController)
        containerView.topDistance = defaultTopDistance
        setupPanGesture()
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        self.containerView.sheetBackgroundView?.addGestureRecognizer(panGesture)
    }

    @objc
    private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let gestureView = gestureRecognizer.view
        let point = gestureRecognizer.translation(in: gestureView)
        
        switch gestureRecognizer.state {
        case .began:
            self.bottomViewController.tableView.isScrollEnabled = false
            break
        case .changed:
            let newTopDistance = containerView.sheetBackgroundView!.frame.origin.y + point.y
            print("current top: \(containerView.topDistance) new: \(newTopDistance)")
            containerView.topDistance = min(max(0, defaultTopDistance) ,max(0, newTopDistance))
            gestureRecognizer.setTranslation(.zero, in: gestureView)
        case .ended, .cancelled:
            self.bottomViewController.tableView.isScrollEnabled = true
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureView = gestureRecognizer.view,
            let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer,
            gestureView == self.containerView.sheetBackgroundView,
            containerView.topDistance == 0 else {
            return true
        }
        
        let point = gestureRecognizer.translation(in: gestureView)
        let contentOffset = bottomViewController.tableView.contentOffset.y + bottomViewController.tableView.contentInset.top
        return contentOffset == 0 && point.y > 0
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ContainerViewController: ContainerViewControllerDelegate {
    func dismissViewController(animated: Bool = false) {
        
    }
    
    func showViewController(_ viewController: BottomSheetViewController, animated: Bool = false) {
        
        let bottomSheetItem = BottomSheetItem(topDistance: self.defaultTopDistance, bottomSheet: viewController)
        self.navigationManager.show(bottomSheetItem: bottomSheetItem)
    }
}
