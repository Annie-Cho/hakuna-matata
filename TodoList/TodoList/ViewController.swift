//
//  ViewController.swift
//  TodoList
//
//  Created by 조혜인 on 2022/02/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem! //weak가 되어버리면 왼쪽 네비게이션 아이템을 done으로 바꿨을 때 edit버튼이 메모리에서 해제가 되어 더이상 재사용할 수 없게 된다!
    var doneButton: UIBarButtonItem?
    
    var tasks = [Task]() {
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
    }
    
    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }


    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }       //task가 비어있을 때는 편집모드로 들어갈 필요 없음
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
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
            self?.tableView.reloadData()        //할일이 추가될 때마다 갱신
        })
        let cancleButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancleButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해주세요."
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
    }
    
    
    /*
    func saveTasks() {
        //할 일들을 딕셔너리 배열 형태로 저장
        let data = self.tasks.map {
            [
                "title": $0.title,          //key : title, title key의 task인스턴스 : $0.title, 축약인자($0)로 dictionary에 접근
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")     //value와 key가 쌍으로 저장. value = 할일들이 저장되어 있는 data, key = tasks로 지정
        //set 메소드를 이용하면 userDefaults에 할일들이 저장됨
        
        func loadTasks() {
            let userDefaults = UserDefaults.standard
            guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
            //데이터를 저장할 때 설정한 key값을 넣어주면 됨
            //object는 any타입으로 리턴되기 때문에 dictionary 배열 형태로 데이터를 저장했으므로 dictionary 배열 형태로 타입 캐스팅을 해줘야 함

            //다시 task에 저장하기
            self.tasks = data.compactMap {
                guard let title = $0["title"] as? String else { return nil }
                guard let done = $0["done"] as? Bool else { return nil }
                return Task(title: title, done: done)       //task 타입이되게 인스턴스화 한다.
            }
        }
    }
    */
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
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    //편집모드에서 삭제버튼을 눌렀을 때 삭제버튼이 눌러진 셀이 어떤 셀인지 알려주는 메소드
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)        //tasks 배열에 할일이 삭제되도록
        tableView.deleteRows(at: [indexPath], with: .automatic)     //셀이 테이블 뷰에서 삭제되고 편집모드를 안들어가도 스와이프로 삭제 가능
        
        if self.tasks.isEmpty {           //모든 삭제들이 삭제되면 편집모드를 빠져나오도록 함
            self.doneButtonTap()
        }
    }
    
    //편집모드에서 할일 순서 바꾸기 - 행이 다른 위치로 이동하면 sourceIndexPath를 통해 원래 있었던 위치를 알려주고 destinationIndexPath를 통해
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //여기 안에서 재정렬되면 할일을 저장하는 배열도 재정렬 되어야 하므로 구현해줌
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)       //원래의 위치에 있던 할일 삭제
        tasks.insert(task, at: destinationIndexPath.row)        //배열의 요소에 접근한 할일 넘겨줌
        self.tasks = tasks      //변경된 tasks를 대입
    }
}

extension ViewController: UITableViewDelegate {
    //어떤 셀을 선택하였는지 알려주는 메소드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]        //indexPath.row가 첫 번째 줄일 때 0, 두 번째 줄일 때 1
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

