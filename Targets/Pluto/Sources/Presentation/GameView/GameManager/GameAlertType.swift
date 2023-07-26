//
//  GameAlertType.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

enum GameAlertType {
    case success
    case fail
    case pause
    case tutorial(activate: [TutorailView.Activate], bottomString: String, topString: String, imageName: String, isLast: Bool)
    
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        case .pause:
            return UIColor(red: 0, green: 0.18, blue: 0.996, alpha: 0.75)
        case .fail:
            return UIColor(red: 0, green: 0.044, blue: 0.242, alpha: 0.85)
        default:
            return .clear
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .success:
            return UIColor(red: 0, green: 0.18, blue: 0.996, alpha: 1)
        case .fail, .pause:
            return .white
        default:
            return .clear
        }
    }
    
    var title: String {
        switch self {
        case .success:
            return "Nice Flight!"
        case .fail:
            return "oh..no"
        case .pause:
            return "paused"
        default:
            return ""
        }
    }
    
    var upButtonTitle: String {
        switch self {
        case .success:
            return "next stage"
        case .fail:
            return "try again"
        case .pause:
            return "resume"
        default:
            return ""
        }
    }
    
    var downButtonTitle: String {
        switch self {
        case .success, .fail:
            return "return to main"
        case .pause:
            return "end game"
        default:
            return ""
        }
    }
    
    var upButtonIcon: UIImage {
        switch self {
        case .success:
            return UIImage(systemName: "arrow.right")!
        case .fail:
            return UIImage(systemName: "arrow.counterclockwise")!
        case .pause, .tutorial:
            return UIImage()
            
        }
    }
    
    var titleImage: UIImage {
        switch self {
        case .success:
            return UIImage(named: "SuccessImage")!
        case .fail:
            return UIImage(named: "FailImage")!
        case .pause:
            return UIImage(named: "PauseImage")!
        default:
            return UIImage()
        }
    }
    
    var hasStroke: Bool {
        switch self {
        case .success:
            return true
        case .fail, .pause:
            return false
        default:
            return false
        }
    }
}

let tutorialPages = [page0, page1, page2, page3, page4, page5, page6, page7, page8, page9, page10, page11, page12, page13, page14, page15, page16, page17]

let page0 = [
    GameAlertType.tutorial(activate: [], bottomString: "지금부터 우주여행 규칙을 설명해줄게.", topString: "지금부터 우주여행 규칙을 설명해줄게.", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "우선 주인공이 벽에 닿으면 게임이 종료되니 주의해줘.", topString: "우선 주인공이 벽에 닿으면 게임이 종료되니 주의해줘.", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [/*pauseButton*/], bottomString: "게임을 진행하다가 잠깐 중지하고 싶은 경우에는 이 버튼을 누르면 일시정지 할 수 있어.", topString: "게임을 진행하다가 잠깐 중지하고 싶은 경우에는 이 버튼을 누르면 일시정지 할 수 있어.", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "버튼을 설명해줄게.", topString: "버튼을 설명해줄게.", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.turnClockWise, TutorailView.Activate.turnCounterClockWise], bottomString: "왼쪽에 화살표가 있는 버튼을 누르면 thrust 기능을 쓸 수 있어.", topString: "왼쪽에 화살표가 있는 버튼을 누르면 thrust 기능을 쓸 수 있어.", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.turnClockWise, TutorailView.Activate.turnCounterClockWise], bottomString: "이 버튼을 누르면 반시계 방향으로 방향을 전환할 수 있어.", topString: "이 버튼을 누르면 반시계 방향으로 방향을 전환할 수 있어.", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.turnClockWise, TutorailView.Activate.turnCounterClockWise], bottomString: "이 thrust 버튼은 연료가 닳기 때문에 아껴 써야해~", topString: "이 thrust 버튼은 연료가 닳기 때문에 아껴 써야해~", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.turnClockWise, TutorailView.Activate.turnCounterClockWise, /*thrustGauge*/], bottomString: "버튼에 있는 게이지를 보면 연료가 얼마나 남았는지 확인할 수 있어.", topString: "버튼에 있는 게이지를 보면 연료가 얼마나 남았는지 확인할 수 있어.", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.turnClockWise, TutorailView.Activate.turnCounterClockWise, /*thrustGauge*/], bottomString: "대신 소행성에 탑승한 동안에는 연료가 충전되니까 참고해!", topString: "대신 소행성에 탑승한 동안에는 연료가 충전되니까 참고해!", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "주인공과 같은 색의 소행성에 닿으면 소행성 궤도에 탈 수 있어.", topString: "주인공과 같은 색의 소행성에 닿으면 소행성 궤도에 탈 수 있어.", imageName: "circle_70_blue", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "흰색인 상태로 소행성 궤도에 닿으면 어떻게 되는지 볼까?", topString: "흰색인 상태로 소행성 궤도에 닿으면 어떻게 되는지 볼까?", imageName: "OBS_circle_70_blue", isLast: true)
]

// 주인공이 흰색 소행성에 올라탐

let page1 = [
    GameAlertType.tutorial(activate: [], bottomString: "성공! 안전하게 궤도에 올라탔어!", topString: "성공! 안전하게 궤도에 올라탔어!", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "방금 같은 색의 소행성에 닿으면 궤도에 탈 수 있다고 했지?", topString: "방금 같은 색의 소행성에 닿으면 궤도에 탈 수 있다고 했지?", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "색을 바꾸면 소행성의 궤도에서 벗어날 수 있어.", topString: "색을 바꾸면 소행성의 궤도에서 벗어날 수 있어.", imageName: "", isLast: true)
]

// 초록색 소행성이 다가옴

let page2 = [
    GameAlertType.tutorial(activate: [TutorailView.Activate.changeGreen], bottomString: "그럼 지금 초록 버튼을 눌러볼까?", topString: "", imageName: "diamond_70_green", isLast: true)
]

// 초록색 소행성에 올라탐

let page3 = [
    GameAlertType.tutorial(activate: [], bottomString: "잘했어!", topString: "", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "다른 색인 상태로 소행성에 닿으면 게임이 끝나니까 주의해야해!", topString: "다른 색인 상태로 소행성에 닿으면 게임이 끝나니까 주의해야해!", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "다시 흰색 소행성 궤도에 타기 위해서, 초록 버튼을 눌러서 색을 원상태로 돌려보자.", topString: "", imageName: "", isLast: true),
]

// 흰색 소행성이 다가옴

let page4 = [
    GameAlertType.tutorial(activate: [TutorailView.Activate.changeGreen], bottomString: "지금 초록 버튼을 눌러봐!", topString: "", imageName: "triangle_70_blue", isLast: true)
]

// 흰색 소행성에 올라탐

let page5 = [
    GameAlertType.tutorial(activate: [], bottomString: "좋았어!", topString: "", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "", topString: "이번엔 네 차례야.", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "", topString: "같은 색의 소행성에 닿으면 궤도에 탈 수 있어.", imageName: "", isLast: true),
]

// 빨간 소행성이 날라옴

let page6 = [
    GameAlertType.tutorial(activate: [TutorailView.Activate.changeRed], bottomString: "", topString: "지금 빨간 버튼을 눌러볼까?", imageName: "circle_70_red", isLast: true)
]

// 빨간 소행성에 올라탐

let page7 = [
    GameAlertType.tutorial(activate: [], bottomString: "", topString: "정말 잘하는데?", imageName: "", isLast: true)
]

// 흰색 소행성이 다가옴

let page8 = [
    GameAlertType.tutorial(activate: [TutorailView.Activate.changeRed], bottomString: "", topString: "다시 흰색 소행성 궤도에 타기 위해서, 빨간 버튼을 눌러서 색을 원상태로 돌려봐.", imageName: "triangle_70_blue", isLast: true)
]

// 흰색 소행성에 올라탐

let page9 = [
    GameAlertType.tutorial(activate: [], bottomString: "", topString: "최고야!", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "이번엔 둘이 힘을 합쳐야만 해.", topString: "이번엔 둘이 힘을 합쳐야만 해.", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "잘 할 수 있지?", topString: "잘 할 수 있지?", imageName: "", isLast: true)
]

// 노란색 소행성이 다가옴

let page10 = [
    GameAlertType.tutorial(activate: [], bottomString: "이번엔 노란색 소행성이 나타났어!", topString: "이번엔 노란색 소행성이 나타났어!", imageName: "circle_70_yellow", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.changeGreen, TutorailView.Activate.changeRed], bottomString: "이럴 때는 둘이 동시에 빨강, 초록 버튼을 눌러봐.", topString: "이럴 때는 둘이 동시에 빨강, 초록 버튼을 눌러봐.", imageName: "circle_70_yellow", isLast: true)
]

// 노란색 소행성에 올라탐

let page11 = [
    GameAlertType.tutorial(activate: [], bottomString: "정말 잘했어! 환상의 호흡이군!", topString: "정말 잘했어! 환상의 호흡이군!", imageName: "", isLast: true)
]

// 흰색 소행성이 다가옴

let page12 = [
    GameAlertType.tutorial(activate: [], bottomString: "이번에는 흰색 소행성이 나타났어.", topString: "이번에는 흰색 소행성이 나타났어.", imageName: "diamond_70_blue", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.changeGreen, TutorailView.Activate.changeRed], bottomString: "지금 둘 다 색을 빼서 주인공을 흰색으로 만들어볼까?", topString: "지금 둘 다 색을 빼서 주인공을 흰색으로 만들어볼까?", imageName: "diamond_70_blue", isLast: true),
]

// 일부러 약간 각도가 틀어지는 타이밍에 지시한다.

let page13 = [
    GameAlertType.tutorial(activate: [], bottomString: "이 방향으로 가면 소행성에 닿을 수 없을 것 같은데?", topString: "이 방향으로 가면 소행성에 닿을 수 없을 것 같은데?", imageName: "diamond_70_blue", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "이럴 때는 어떻게 해야할까?", topString: "이럴 때는 어떻게 해야할까?", imageName: "diamond_70_blue", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.turnClockWise, TutorailView.Activate.turnCounterClockWise], bottomString: "여기 thrust 라는 기능이 있어.", topString: "여기 thrust 라는 기능이 있어.", imageName: "diamond_70_blue", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.turnClockWise, TutorailView.Activate.turnCounterClockWise], bottomString: "이걸 누르면 진행 방향을 바꿀 수 있어.", topString: "이걸 누르면 진행 방향을 바꿀 수 있어.", imageName: "diamond_70_blue", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.turnClockWise], bottomString: "지금 thrust 버튼을 눌러서 소행성 쪽으로 이동해볼까?", topString: "", imageName: "diamond_70_blue", isLast: true)
]

// 흰색 소행성에 올라탐

let page14 = [
    GameAlertType.tutorial(activate: [], bottomString: "정말 잘했어!", topString: "", imageName: "", isLast: true)
]

// 빨간 소행성이 다가옴

let page15 = [
    GameAlertType.tutorial(activate: [], bottomString: "", topString: "이번에는 빨간색 소행성이 나타났어!", imageName: "circle_70_red", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.changeRed], bottomString: "", topString: "빨강 버튼을 눌러서 궤도를 타보자.", imageName: "circle_70_red", isLast: true)
]

// 일부러 약간 각도가 틀어지는 타이밍에 지시한다.

let page16 = [
    GameAlertType.tutorial(activate: [], bottomString: "", topString: "어? 이번에도 방향이 살짝 틀어졌네.", imageName: "circle_70_red", isLast: false),
    GameAlertType.tutorial(activate: [TutorailView.Activate.turnCounterClockWise], bottomString: "", topString: "thrust 버튼을 눌러서 각도를 살짝 조정해보자.", imageName: "OBS_circle_70_red", isLast: true)
]

// 빨간 소행성에 올라탐

let page17 = [
    GameAlertType.tutorial(activate: [], bottomString: "", topString: "좋았어!", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [/*progressBar*/], bottomString: "게임의 진행도를 확인하고 싶다면, 색 버튼 위에 있는 파란색 바를 확인하면 돼!", topString: "게임의 진행도를 확인하고 싶다면, 색 버튼 위에 있는 파란색 바를 확인하면 돼!", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "이제 우주여행을 할 준비가 모두 완료된 것 같군!", topString: "이제 우주여행을 할 준비가 모두 완료된 것 같군!", imageName: "", isLast: false),
    GameAlertType.tutorial(activate: [], bottomString: "게임을 시작해보자!", topString: "게임을 시작해보자!", imageName: "", isLast: true)
]
