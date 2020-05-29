//
//  ViewController.swift
//  Exercise3
//
//  Created by Hung Vuong on 5/26/20.
//  Copyright © 2020 Hung Vuong. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableViewUsers: UITableView!
    var responseEntity: [Users]?
    var usersOfRealmSwift: Results<Users>?
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromJsonFile()
        setUpTableView()
        setUpRealm()
        addData()
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    private func setUpTableView() {
        tableViewUsers.delegate = self
        tableViewUsers.dataSource = self
        tableViewUsers.register(UINib.init(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
    }
    
    func addData() {
        if usersOfRealmSwift?.count == 0 {
            for user in responseEntity! {
                RealmService.shared.create(user)
            }
        } else {
            print("Realm have data !")
        }
    }
    
    func setUpRealm() {
        let realm = RealmService.shared.realm
        usersOfRealmSwift = realm.objects(Users.self)
        notificationToken = realm.observe { (notification, realm) in
            self.tableViewUsers.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationToken?.invalidate()
        RealmService.shared.stopObservingErrors(in: self)
    }
    
}

// MARK: - PushInfo

extension ViewController {
    func pushToAddInformation(data: Users? = nil, indexPath: Int) {
        guard let view = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailUserViewController") as? DetailUserViewController else {
            return
        }
        if let user = usersOfRealmSwift?[indexPath] {
            view.data = user
        }
        
        self.present(view, animated: true) {
        }
    }
}

// MARK: - TableView
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToAddInformation(indexPath: indexPath.row)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersOfRealmSwift?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableViewUsers.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        if let user = usersOfRealmSwift?[indexPath.row] {
            cell.configure(with: user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

// MARK: - Parsing JSON
extension ViewController {
    
    private func getDataFromJsonFile() {
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let string = String(data: data, encoding: .utf8) ?? ""
                convertData(string)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    private func convertData(_ data: String) {
        let responseData = Data(data.utf8)
        let decoder = JSONDecoder()
        do {
            responseEntity = try decoder.decode([Users].self, from: responseData)
        } catch let error {
            print("Failed to decode JSON \(error)")
        }
    }
}


