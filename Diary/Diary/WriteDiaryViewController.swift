//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 조혜인 on 2022/03/02.
//

import UIKit

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    //데이트 피커 사용하기
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?        //옵셔널 타입, 데이트 피커에서 선택된 date를 저장하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.confirmButton.isEnabled = false
    }
    
    //뷰의 테두리(border) 설정하기 -> 이걸 viewDidLoad에서 호출 안해주면 테두리가 안뜸
    private func configureContentsTextView() {
        //일기 등록 시 내용창 border 설정하기
        //220/255하는 이유 : red, green, blue에는 0.0 ~ 1.0사이의 값이 들어가야하기 때문에 나눠줘야 한다.
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5       //테두리 넓이
        self.contentsTextView.layer.cornerRadius = 5.0        //테두리를 둥글게
    }
    
    private func configureInputField() {
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date      //날짜만 나오게 설정
        self.datePicker.preferredDatePickerStyle = .wheels
        
        //UI controller객체가 이벤트에 응답하는 방식을 설정해주는 메소드
        //for파라미터로는 어떤 이벤트가 일어났을 때 action에 정의한 메소드를 호출할 것인지 정해주는 곳
        //.valueChanged -> date picker의 값이 바뀔 때마다 selector메소드를 호출
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        
        self.datePicker.locale = Locale(identifier: "ko-KR")
        self.dateTextField.inputView = self.datePicker      //dataPicker에서 선택된 날짜가 dateTextField에 표시됨
    }

    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
    }
    
    @objc private func datePickerValueDidChange(_ dataPicker: UIDatePicker) {
        let formmater = DateFormatter()         //date타입을 사람이 읽을 수 있는 형태로 변환해주거나 반대로 날짜형태에서 date타입으로 변환
        formmater.dateFormat = "yyyy년 MM월 dd일(EEEEE)"       //어떤 형태의 문자열로 변경할 건지 포맷을 정해준다
        formmater.locale = Locale(identifier: "ko_KR")       //한국어로 데이터 포맷이 표현되기 위함
        self.diaryDate = datePicker.date
        self.dateTextField.text = formmater.string(from: dataPicker.date)   //data를 formatter에서 지정한 문자열로 변경시켜서 표시되게 함
        
        self.dateTextField.sendActions(for: .editingChanged)        //날짜가 변경될 때마다 editingchanged를 발생시킴
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    //빈 화면을 터치했을 때 자판이나 datePicker가 사라지도록 만듬 -> 유저가 화면을 터치하면 호출되는 메소드!!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    //textView에 text가 입력될 때마다 호출되는 메소드
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()       //등록버튼 활성화 여부 판단
    }
}
