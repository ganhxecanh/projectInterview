//
//  ViewController.swift
//  Exercise2
//
//  Created by Hung Vuong on 5/27/20.
//  Copyright © 2020 Hung Vuong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var listImageTableView: UITableView!
    
    private var button: UIButton!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refreshCotrolLoadData), for: .valueChanged)
        return refreshControl
    }()
    
    var listAllImages = [ImageInfo]()
    
    var listImgageOfPage = [ImageInfo]()
    
    var extra = [ImageInfo]() {
        didSet {
            DispatchQueue.main.async {
                self.listImageTableView.reloadData()
            }
        }
    }
    
    private var number: Int = 1
    private var imagesQuantity: Int = 10
    private var rowNumber: Int = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        fetchListAllImage()
        fetchListImagePage1()
        setUpLoadMoreButton()
        listImageTableView.refreshControl = refresher
    }
    
    private func setUpLoadMoreButton() {
        button = UIButton(frame: CGRect(x: 0, y: 0, width: listImageTableView.bounds.width, height: 45))
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Load more movies", for: .normal)
    }
    
    private func setUpTableView() {
        listImageTableView.dataSource = self
        listImageTableView.delegate = self
        listImageTableView.register(UINib.init(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
    }
    
    @objc func refreshCotrolLoadData() {
        self.number = 1
        extra.removeAll()
        let deadLine = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
            self.fetchListImageOfPage(numberOfPage: self.number)
            self.refresher.endRefreshing()
        }
    }
    
    @objc func loadTable() {
        self.listImageTableView.reloadData()
    }
    
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extra.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listImageTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        let listImage = extra[indexPath.row]
        cell.configure(with: listImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController {
    func fetchListImagePage1() {
        let imageRequestData = ImageRequest.init(numberOfPage: 1, limit: 10)
        imageRequestData.getImage{ [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let images):
                self?.extra = images
            }
        }
    }
    
    func fetchListAllImage() {
        let imageRequestData = ImageRequest.init(numberOfPage: 1, limit: 100)
        imageRequestData.getImage{ [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let images):
                self?.listAllImages = images
            }
        }
    }
    
    func fetchListImageOfPage(numberOfPage number: Int) {
        let imageRequestData = ImageRequest.init(numberOfPage: number, limit: 10)
        imageRequestData.getImage{ [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let images):
                self?.listImgageOfPage = images
                self?.extra += self?.listImgageOfPage ?? [ImageInfo]()
            }
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom == height {
            self.number += 1
            fetchListImageOfPage(numberOfPage: number)
            self.rowNumber += 10
        }
    }
}

