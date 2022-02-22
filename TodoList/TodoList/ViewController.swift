//
//  ViewController.swift
//  TodoList
//
//  Created by 조혜인 on 2022/02/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        //액션시트 : 밑에서 alert가 표시됨. alert : 가운데에 alert가 표시됨
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { _ in
            debugPrint("\(alert.textFields?[0].text)")       //textFields프로퍼티는 배열인데, 우리는 지금 하나 밖에 추가하지 않았으므로 0번째
        })
        let cancleButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancleButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해주세요."
        })
        self.present(alert, animated: true, completion: nil)
    }
}

