//
//  RoundButton.swift
//  Calculator_Test
//
//  Created by 조혜인 on 2022/02/21.
//

import UIKit

//@IBDesignable : 변경된 설정값을 스토리보드 상에서 실시간을 확인할 수 있도록 해줌. 그래야 아래에 isRound값을 확인할 수 있음
@IBDesignable
class RoundButton: UIButton {
        //@IBInspectable -> 스토리보드에서도 isRound 프로퍼티의 설정 값을 변경할 수 있도록 함.
        //여기서 Inspecter란? 오른쪽에서 이것저것 설정할 수 있는 창이 Inspecter임
        @IBInspectable var isRound: Bool = false {
        didSet {            //연산 프로퍼티가 되게 만듬
            if isRound {
                //정사각형 버튼이 원이 됨. 정사각형이 아닌 버튼들은 모서리가 둥글게 변함.
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
}
