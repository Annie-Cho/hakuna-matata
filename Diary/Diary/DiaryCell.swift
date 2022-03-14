//
//  DiaryCell.swift
//  Diary
//
//  Created by 조혜인 on 2022/03/14.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //다이어리 셀 테두리 만들기
    //UIView가 XIB(?)나 스토리보드에서 생성될 때 이 생성자를 통해 객체가 생성된다.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
}
