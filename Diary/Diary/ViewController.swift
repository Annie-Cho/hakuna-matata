//
//  ViewController.swift
//  Diary
//
//  Created by 조혜인 on 2022/03/14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]() {
        didSet {                                //프로퍼티 옵저버
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDiaryList()
    }
    
    //콜렉션 뷰의 속성
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //collectionView에 표시되는 contents의 위,아래,좌우간격이 10만큼 됨
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    //일기 작성 화면의 이동은 segue way를 통해서 이동하기 때문에 prepare메소드를 오버라이드 해야함
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
        }
    }
    
    //date타입을 전달받으면 문자열로 만들어주는 메소드
    private func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    //등록된 일기가 사라지지 않도록 구현 -> UserDefaults(데이터 저장소, 단일 데이터 값에 적합)에 dictionary형태로 저장하려고 함
    private func saveDiaryList() {
        let date = self.diaryList.map {
            [
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: "diaryList")
    }
    
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        //object메소드는 any타입으로 리턴되기 때문에 dictionary 배열형태로 타입캐스팅을 해줘야 함.
        
        self.diaryList = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }    //$0 : 축약인자
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }
        
        self.diaryList = self.diaryList.sorted(by: {
            //배열의 왼쪽($0)과 오른쪽($1) 값과 비교.
            $0.date.compare($1.date) == .orderedDescending      //내림차순 -> 최신순으로 정렬
        })
    }

}

//가져온 Diary를 diaryList에 넣기
extension ViewController: WriteDiaryViewDelegate {
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
        self.diaryList = self.diaryList.sorted(by: {
            //배열의 왼쪽($0)과 오른쪽($1) 값과 비교.
            $0.date.compare($1.date) == .orderedDescending      //내림차순 -> 최신순으로 정렬
        })
        self.collectionView.reloadData()        //일기가 추가될 때마다 collectionView에 일기 목록이 표시됨
    }
}

//콜렉션 뷰에서 데이터소스는 콜렉션 뷰로 보여지는 컨텐츠 관리하는 객체
extension ViewController: UICollectionViewDataSource {
    //지정된 섹션에 표시할 셀의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    //컬렉션 뷰에 지정된 위치에 표시할 셀을 요청하는 메소드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }      //스토리보드에서 구성한 커스텀 셀을 가져온다
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    //셀의 사이즈를 설정하는 역할. 표시할 셀의 사이즈를 CGSize로 정의하고 return해주면 설정한 size대로 표시됨
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
        //UIScreen.main.bounds.width : 아이폰 화면의 너비 값, 20 : left, right 간격(각 10씩)
    }
}
