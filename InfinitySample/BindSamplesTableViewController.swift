//
//  BindSamplesTableViewController.swift
//  InfiniteSample
//
//  Created by Danis on 15/12/24.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit
import Infinity

class BindSamplesTableViewController: UITableViewController {
    
    var type: BindAnimatorType = .Default
    var items = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = type.description
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SampleCell")
        tableView.supportSpringBounces = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.setInsetType(withTop: .navigationBar , bottom: .tabBar)
        
        bindPullToRefresh(type: type)
        addInfiniteScroll(type: type)
        
        tableView.scrollToTopImmediately = false
        tableView.infiniteStickToContent = true // Default
    }
    
    deinit {
        tableView.removePullToRefresh()
        tableView.removeInfiniteScroll()
    }
    
    // MARK: - Add PullToRefresh
    func bindPullToRefresh(type: BindAnimatorType) {
        switch type {
        case .Default:
            let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: animator)
            bindPullToRefreshWithAnimator(animator: animator)
        case .GIF:
            let animator = GIFRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            // Add Images for Animator
            var refreshImages = [UIImage]()
            for index in 0..<21 {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    refreshImages.append(image)
                }
            }
            var animatedImages = [UIImage]()
            for index in 21...29 {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    animatedImages.append(image)
                }
            }
            for index in 0..<21 {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    animatedImages.append(image)
                }
            }
            animator.refreshImages = refreshImages
            animator.animatedImages = animatedImages
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: animator)
            bindPullToRefreshWithAnimator(animator: animator)
        case .Circle:
            let animator = CircleRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: animator)
            bindPullToRefreshWithAnimator(animator: animator)
        case .Arrow:
            let animator = ArrowRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: animator)
            bindPullToRefreshWithAnimator(animator: animator)
        }
    }
    func bindPullToRefreshWithAnimator(animator: CustomPullToRefreshAnimator) {
        tableView.bindPullToRefresh(toAnimator: animator, action: { [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self?.tableView?.endRefreshing()
            }
        })
    }
    // MARK: - Add InfiniteScroll
    func addInfiniteScroll(type: BindAnimatorType) {
        switch type {
        case .Default:
            let animator = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            addInfiniteScrollWithAnimator(animator: animator)
        case .GIF:
            let animator = GIFInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            var animatedImages = [UIImage]()
            for index in 0..<29 {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    animatedImages.append(image)
                }
            }
            animator.animatedImages = animatedImages
            addInfiniteScrollWithAnimator(animator: animator)
        case .Circle:
            let animator = CircleInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            addInfiniteScrollWithAnimator(animator: animator)

        default:
            break
        }
    }
    func addInfiniteScrollWithAnimator(animator: CustomInfiniteScrollAnimator) {
        tableView.addInfiniteScroll(animator: animator, action: { [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self?.items += 15
                self?.tableView.reloadData()
                self?.tableView?.endInfiniteScrolling()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleCell", for: indexPath)
        
        cell.textLabel?.text = "Cell"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = UIViewController()
        newVC.view.backgroundColor = .red
        
        self.show(newVC, sender: self)
    }

}
