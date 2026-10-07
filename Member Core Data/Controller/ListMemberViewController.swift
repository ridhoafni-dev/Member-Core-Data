//
//  ViewController.swift
//  Member Core Data
//
//  Created by User on 04/10/26.
//

import UIKit

class ListMemberViewController: UIViewController {

    private var members: [MemberModel] = []
    private var memberId: Int = 0
    private lazy var memberProvider: MemberProvider = { return MemberProvider() }()
    @IBOutlet weak var memberTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMembers()
    }
    
    @IBAction func createMember(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "moveListToForm", sender: self)
    }
    
    private func loadMembers() {
        self.memberProvider.getAllMember { result in
            DispatchQueue.main.async {
                self.members = result
                self.memberTableView.reloadData()
            }
        }
    }
    
    private func setupView() {
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }

}

extension ListMemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as? MemberTableViewCell {
            let member = members[indexPath.row]
            cell.memberFullName.text = member.name
            cell.memberProfession.text = member.profession
            
            if let image = member.image {
                cell.memberImage?.image = UIImage(data: image)
                cell.memberImage?.layer.cornerRadius = cell.memberImage!.frame.height / 2
                cell.memberImage?.clipsToBounds = true
            }
            return cell
        } else {
            return UITableViewCell()
        }
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
}

extension ListMemberViewController: UITableViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetail" {
            if let vc = segue.destination as? DetailMemberViewController {
                vc.memberId = self.memberId
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = members[indexPath.row].id {
            memberId = Int(id)
        }
        self.performSegue(withIdentifier: "moveToDetail", sender: self)
    }
    
}


