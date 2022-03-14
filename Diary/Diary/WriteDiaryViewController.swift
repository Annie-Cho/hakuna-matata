//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 조혜인 on 2022/03/14.
//

import UIKit

//이 메소드에 일기가 작성된 다이어리 객체를 전달
protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?        //datePicker에서 선택된 date를 저장할 프로퍼티
    
    weak var delegate: WriteDiaryViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.confirmButton.isEnabled = false        //처음 생성될 때 아직 text가 작성 안돼었으므로 등록버튼 비활성화
    }
    
    //viewDidLoad에서 호출이 되면 editingChanged가 되었을 때 아래 메소드들이 호출되게 만들어진다. 이 메소드는 viewdidload이후에 다시 진입 안함.
    private func configureInputField() {
        self.contentsTextView.delegate = self       //delegate에서 확인 중
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        //제목 텍스트 필드에 텍스트가 입력될 때마다 titleTextFieldDidChange메소드가 호출되게 구현
        
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
        //date 텍스트 필드에 텍스트가 입력될 때마다 호출. 그러나 date는 현재 텍스트로 가져오는 게 아니므로 datePickerValueDidChange에서 editingChanged를 알려줘야 함
    }
    
    //View의 border 추가해주기 (내용 view)
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/225, alpha: 1.0)
        //aplha : 투명도 값. 0.0 ~ 1.0사이의 값을 가지며 0.0과 가까워질수록 투명해진다
        //RGB값이 220/255인 이유 : 0.0 ~ 1.0사이의 값을 넣어줘야 하기 때문
        
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        //Layer관련된 color 설정 때는 UIColor가 아닌 cgColor로 설정해야 함
        
        self.contentsTextView.layer.borderWidth = 0.5   //너비
        self.contentsTextView.layer.cornerRadius = 5.0  //모서리를 둥글게 설정
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        //datePicker의 값이 바뀔 때마다 datePickerValueDidChange를 호출하게 되고, 메소드 파라미터를 통해 변경된 datePicker의 상태를 UIDatePicker 객체로 전달하게 됨.
        
        self.datePicker.locale = Locale(identifier: "ko_KR")
        
        self.dateTextField.inputView = self.datePicker
        //dateTextField에 키보드가 아닌 datePicker가 표시됨
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        self.delegate?.didSelectRegister(diary: diary)
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()     //날짜와 텍스트를 변환해주는 역할
        formatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.dateTextField.text = formatter.string(from: datePicker.date)
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    //User가 화면을 터치했을 때 키보드를 없애기 -> 이 메소드는 user가 화면을 터치하면 실행되는 메소드이다
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //등록버튼의 활성화 여부 판단하는 메소드
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}


extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {        //일기장 내용이 입력될 때마다 이 메소드 호출됨
        self.validateInputField()
    }
}
