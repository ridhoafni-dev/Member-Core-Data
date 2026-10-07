//
//  DetailMemberViewController.swift
//  Member Core Data
//
//  Created by User on 05/10/26.
//

import UIKit

class DetailMemberViewController: UIViewController {
    var memberId: Int = 0
    
    private lazy var memberProvider: MemberProvider = { return MemberProvider() }()

    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberFullName: UILabel!
    @IBOutlet weak var memberProfession: UILabel!
    @IBOutlet weak var memberEmail: UILabel!
    @IBOutlet weak var memberAbout: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMembers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveDetailToForm" {
            if let vc = segue.destination as? FormMemberViewController {
                vc.memberId = self.memberId
            }
        }
    }

    @IBAction func memberDelete(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this member?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            self.deleteMember()
        })
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func editMember(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Warning", message: "Do you want to change this member?", preferredStyle: .alert)
               
               alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                   self.performSegue(withIdentifier: "moveDetailToForm", sender: self)
               })
               
               alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
               
               self.present(alert, animated: true, completion: nil)
    }
    
    private func loadMembers() {
        memberProvider.getMember(memberId) { member in
            DispatchQueue.main.async {
                self.memberFullName.text = member.name
                self.memberProfession.text = member.profession
                self.memberEmail.text = member.email
                self.memberAbout.text = member.about
                if let image = member.image {
                    self.memberImage.image = UIImage(data: image)
                    self.memberImage.layer.cornerRadius = self.memberImage.frame.height / 2
                    self.memberImage.clipsToBounds = true
                }
            }
        }
            
    }
    
    private func deleteMember() {
        memberProvider.deleteMember(memberId) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Successful", message: "Member deleted.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
}
