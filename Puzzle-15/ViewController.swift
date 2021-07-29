//
//  ViewController.swift
//  Puzzle-15
//
//  Created by Shahzod Rajabov on 25/06/21.
//

import UIKit

class Action {
    var btn: UIButton?
    var btnCenter: CGPoint?
    var emptyCenter: CGPoint?
    var counter: Int? = 0
//    var recordlist2: String?
}

class ViewController: UIViewController {

    var counter = 0
    let btnH = 90
    var contBtn = 4
    var bool1 = false
    var recordString = "Hello!"


    var actionsUndo = [Action]()
    var actionsRedo = [Action]()
//    var recordLists = [Action]()
    let containerView = UIView()
    let counterLabel = UILabel()
    let quitBtn = UIButton()
    let restartBtn = UIButton()
    let udoBtn = UIButton()
    let winLabel = UILabel()
    let recordBtn = UIButton()
    let recordsTextWiew = UITextView()

    let alert = UIAlertController(title: "Congratulations!", message: "You Win!", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow


        createTopBtns()
        createBtns()
        alert2()

    }

    func createBtns() {
        let containerH = 4 * btnH
        print(bool1)
        containerView.frame = CGRect(x: 30, y: 100, width: containerH, height: containerH)
        containerView.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        containerView.backgroundColor = .white
        containerView.tag = 1000
        view.addSubview(containerView)

        counterLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        counterLabel.center = CGPoint(x: view.frame.size.width / 2, y: containerView.frame.origin.y - 50)
        counterLabel.font = UIFont(name: "Arial", size: 30)
        counterLabel.textAlignment = .center
        counterLabel.text = "Your steps: \(counter)"
        view.addSubview(counterLabel)

        winLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        winLabel.center = CGPoint(x: view.frame.size.width / 2, y: containerView.frame.origin.y - 100)
        winLabel.font = UIFont(name: "Arial", size: 50)
        winLabel.textAlignment = .center
        winLabel.text = "You Win!"
        winLabel.alpha = 0
        view.addSubview(winLabel)

        recordBtn.frame = CGRect(x: 0, y: 0, width: 250, height: 45)
        recordBtn.center = CGPoint(x: view.frame.size.width / 2, y: containerView.frame.origin.y + 430)
        recordBtn.titleLabel?.font = UIFont(name: "Arial", size: 30)
        recordBtn.setTitle("Records Board", for: .normal)
        recordBtn.backgroundColor = .brown
        recordBtn.layer.cornerRadius = 12
        recordBtn.addTarget(self, action: #selector(showRecList), for: .touchUpInside)
//        view.addSubview(recordBtn)

        var index = 0
        var top = 0
        var left = 0
        var arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        arr = arr.shuffled()
//        arr = [1,5,9,13,2,6,10,14,3,7,11,15,4,8,12,16]
        arr.append(16)
        for i in 1...4 {
            for j in 1...4 {
                let color = UIColor(red: CGFloat(i * 50) / 255.0, green: CGFloat(j * 50) / 255.0, blue: CGFloat((i - j) * 50) / 255.0, alpha: 1.0)
                let btn = UIButton()
                btn.frame = CGRect(x: top, y: left, width: btnH, height: btnH)
                btn.backgroundColor = color
                if index == 15 {
                    containerView.insertSubview(btn, at: 0)
                } else {
                    containerView.addSubview(btn)
                }
                left += btnH
                btn.tag = arr[index]
                let text = index == 15 ? " " : "\(arr[index])"
                btn.setTitle(text, for: .normal)
                index += 1
                btn.titleLabel?.font = UIFont(name: "Arial", size: 35)
                btn.addTarget(self, action: #selector(userClicked(_:)), for: .touchUpInside)
            }
            left = 0
            top += btnH
        }
    }

    func createTopBtns() {
        let btnArr = ["Quit", "Redo", "Undo", "Restart"]
        var mTag = 100
        let mBtnW: CGFloat = 80
        var mBtnH: CGFloat = 0
        let minter: CGFloat = 9

        for item in btnArr {
            let mBtns = UIButton()
            mBtns.frame = CGRect(x: (view.frame.size.width - 4 * (mBtnW) - 3 * minter) / 2 + mBtnH, y: 30, width: mBtnW, height: 40)
            mBtns.backgroundColor = .blue
            mBtns.setTitle(item, for: .normal)
            mBtns.layer.cornerRadius = 12
            mBtns.titleLabel?.font = UIFont(name: "Arial", size: 20)
            mBtns.tag = mTag
            view.addSubview(mBtns)
            mTag += 1
            mBtnH += (mBtnW + minter)
        }
        (self.view.viewWithTag(100) as? UIButton)?.addTarget(self, action: #selector(quit), for: .touchUpInside)
        (self.view.viewWithTag(101) as? UIButton)?.addTarget(self, action: #selector(redo), for: .touchUpInside)
        (self.view.viewWithTag(102) as? UIButton)?.addTarget(self, action: #selector(undo), for: .touchUpInside)
        (self.view.viewWithTag(103) as? UIButton)?.addTarget(self, action: #selector(restart), for: .touchUpInside)
        (self.view.viewWithTag(101) as? UIButton)?.alpha = 0
        (self.view.viewWithTag(102) as? UIButton)?.alpha = 0
        (self.view.viewWithTag(100) as? UIButton)?.alpha = 0

    }

    func undoCoordinate() {
        if (self.view.viewWithTag(101) as? UIButton)?.alpha == 0 && (self.view.viewWithTag(102) as? UIButton)?.alpha == 1 {
            var frame = (self.view.viewWithTag(102) as? UIButton)?.frame
            frame?.origin.x = self.view.frame.origin.x / 2 * 3
            (self.view.viewWithTag(102) as? UIButton)?.frame = frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        } else {
            var frame = (self.view.viewWithTag(102) as? UIButton)?.frame
            frame?.origin.x = 192.0
            (self.view.viewWithTag(102) as? UIButton)?.frame = frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }

    @objc func showRecList() {
        recordsTextWiew.frame = CGRect(x: containerView.frame.origin.x - 200,
                y: containerView.frame.origin.y,
                width: containerView.frame.size.width,
                height: containerView.frame.size.height + 200)
        recordsTextWiew.center = containerView.center
        recordsTextWiew.backgroundColor = .systemOrange
        recordsTextWiew.font = UIFont(name: "Arial", size: 30)
        recordsTextWiew.text = "Your steps: \(counter)"
        view.addSubview(recordsTextWiew)
    }

    @objc func userClicked(_ sender: UIButton) {
        let emptyBtn = sender.superview?.viewWithTag(16) as? UIButton
        let x1 = emptyBtn?.frame.origin.x ?? 0
        let y1 = emptyBtn?.frame.origin.y ?? 0
        let x = sender.frame.origin.x
        let y = sender.frame.origin.y
        if x1 == x {
            if abs(y - y1) == sender.frame.size.width {
                replaceBtns(btn: sender)
            }
        }
        if y1 == y {
            if abs(x - x1) == sender.frame.size.width {
                replaceBtns(btn: sender)
            }
        }
    }

    func alert2() {
        let restart = UIAlertAction(title: "Restart", style: .default, handler: { action in
            self.restart()
        })
        alert.addAction(restart)
        if bool1 {
            DispatchQueue.main.async(execute: {
                self.present(self.alert, animated: true)
            })
        }
    }

    func replaceBtns(btn: UIButton?) {
        let emptyBtn = btn?.superview?.viewWithTag(16) as? UIButton
        let center1 = emptyBtn?.center
        let center2 = btn?.center
        let action = Action()
        action.btn = btn
        action.btnCenter = center2
        action.emptyCenter = center1
        action.counter = counter
        actionsUndo.append(action)
        (self.view.viewWithTag(102) as? UIButton)?.alpha = 1
        counter += 1
        counterLabel.text = "Your steps: \(counter)"
        UIView.animate(withDuration: 0.2) {
            btn?.center = center1 ?? CGPoint()
            emptyBtn?.center = center2 ?? CGPoint()
        }
        youWin()
        undoCoordinate()
    }

    @objc func undo() {
        if let last = actionsUndo.last {
            let btn = last.btn!
            let btnCenter = last.btnCenter ?? CGPoint()
            let emptyCenter = last.emptyCenter ?? CGPoint()
            let emptyBtn = btn.superview?.viewWithTag(16) as? UIButton
            UIView.animate(withDuration: 0.3) {
                emptyBtn?.center = emptyCenter
                btn.center = btnCenter
            }
            actionsRedo.append(last)
            actionsUndo.removeLast()
            if last.counter! > 0 {
                last.counter! -= 1
            }
            counterLabel.text = "Your steps: \(last.counter!)"

            (self.view.viewWithTag(101) as? UIButton)?.alpha = 1
            undoCoordinate()
        }
    }

    @objc func redo() {
        if let last = actionsRedo.last {
            let btn = last.btn!
            let btnCenter = last.btnCenter ?? CGPoint()
            let emptyCenter = last.emptyCenter ?? CGPoint()
            if last.counter! >= 0 {
                last.counter! += 1
            }
            let emptyBtn = btn.superview?.viewWithTag(16) as? UIButton
            UIView.animate(withDuration: 0.3) {
                emptyBtn?.center = btnCenter
                btn.center = emptyCenter
            }
            actionsUndo.append(last)
            actionsRedo.removeLast()
            counterLabel.text = "Your steps: \(last.counter!)"
        }
    }

    func youWin() {
        var x1 = Double(btnH) / 2
        var y1 = Double(btnH) / 2
        var k = 1
        var win = 0

        for _ in 1...4 {
            for _ in 1...4 {
                let a = ((self.view.viewWithTag(k) as? UIButton)?.center)!
                let b = CGPoint(x: x1, y: y1)
                if a == b {
                    win += 1
                } else {
                    break
                }
                k += 1
                x1 += Double(btnH)
            }
            x1 = Double(btnH) / 2
            y1 += Double(btnH)
        }
        if win == 16 {
//            let action = Action()
//            action.recordlist2 = "Your steps: \(counter)"
            winLabel.alpha = 1
            bool1 = true
            show(alert, sender: nil)
        } else {
            win = 0
        }
    }

    @objc func quit() {
        dismiss(animated: true, completion: nil)
    }

    @objc func restart() {
        for subView in containerView.subviews {
            subView.removeFromSuperview()
        }
        createBtns()
        winLabel.alpha = 0
        counter = 0
        actionsUndo = [Action]()
        actionsRedo = [Action]()
//        recordLists = [Action]()
        counterLabel.text = "Your steps: \(counter)"
        recordsTextWiew.alpha = 0
        (self.view.viewWithTag(101) as? UIButton)?.alpha = 0
        (self.view.viewWithTag(102) as? UIButton)?.alpha = 0
    }

}


