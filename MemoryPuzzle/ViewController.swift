//
//  ViewController.swift
//  MemoryPuzzle
//
//  Created by Taiga Hashimoto on 2019/02/25.
//  Copyright © 2019 Geeksalon. All rights reserved.
//

import UIKit
import BubbleTransition
import AMColorPicker

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, AMColorPickerViewControllerDelegate {
    func colorPickerViewController(colorPickerViewController: AMColorPickerViewController, didSelect color: UIColor) {
        // Newボタンの色をテーマカラーに設定
        NewGameButton.backgroundColor = color
    }
    
    // Newボタンのカスタマイズ
    @IBOutlet weak var NewGameButton: CustomButton!
    let transition = BubbleTransition()
    
    // 背景画像のインスタンス
    @IBOutlet weak var titleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景画像を設定
        titleImage.image = UIImage(named: "jigsawpuzzle.png")
        // 最背面に表示
        self.view.sendSubviewToBack(titleImage)
        
        // Newボタンを正方形にする
        NewGameButton.frame.size.height = NewGameButton.frame.width
        NewGameButton.layer.cornerRadius = NewGameButton.frame.width/2
        
        // ボタンの文字に影をつける
        NewGameButton.titleLabel?.shadowOffset = CGSize(width: 1.0, height: 1.0)
        NewGameButton.setTitleShadowColor(UIColor.black, for: UIControl.State.normal)

    }
    
    // colorPicker
    @IBAction func colorPickerButton(_ sender: Any) {
        let colorPickerViewController = AMColorPickerViewController()
        colorPickerViewController.selectedColor = view.backgroundColor!
        colorPickerViewController.delegate = self
        present(colorPickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func NewGame() {

        // appDelegateのインスタンスを取得
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        // appDelegateのselectedColorを操作
        appDelegate.selectedColor = NewGameButton.backgroundColor
        
    }
    
    // 画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ViewController2 {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
        }
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = NewGameButton.center
        transition.bubbleColor = NewGameButton.backgroundColor!
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = NewGameButton.center
        transition.bubbleColor = NewGameButton.backgroundColor!
        return transition
    }
}

