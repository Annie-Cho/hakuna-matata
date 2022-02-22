//
//  ViewController.swift
//  TodoList
//
//  Created by 조혜인 on 2022/02/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }


    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        //액션시트 : 밑에서 alert가 표시됨. alert : 가운데에 alert가 표시됨
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        //[weak self] -> 캡처 목록을 정의한 것.. 클로저의 선언부에 weak나 unknown키워드로 캡처목록을 정의하지 않고 클로저 본문에서 self키워드로 class의 인스턴스의 프로퍼티에 접근하게 되면 강한 순환참조가 발생해 메모리 누수가 발생할 수 있음!
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self]_ in
            //debugPrint("\(alert.textFields?[0].text)")       //textFields프로퍼티는 배열인데, 우리는 지금 하나 밖에 추가하지 않았으므로 0번째
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
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

extension ViewController: UITableViewDataSource {
    //UITableViewDataSource 프로토콜을 채택하게 되면 아래 두 메소드는 구현을 해야 함
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //각 세션에 표시할 행의 갯수
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeueReusableCell : 셀을 재사용. 지정된 재사용 식별자에 대한 재사용 가능한 table view 셀 객체를 반환하고 이를 tableView에 추가
        //queue를 사용해서 재사용
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
}

