//
//  DetailTodoViewController.swift
//  TodoRealmApp
//
//  Created by 渡邉天彰 on 2020/06/12.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit
import RealmSwift
class DetailTodoViewController: UIViewController, UITextViewDelegate {

    //Realmをインスタンス化
    let realm = try! Realm()
    
    var todoList: Results<TodoItem>!
    
    @IBOutlet weak var todoDetailTitleLabel: UILabel!
    @IBOutlet weak var todoDetailTextView: UITextView!
    @IBOutlet weak var todoStatusCheckLabel: UILabel!
    @IBOutlet weak var todoStatusSwitch: UISwitch!

    //遷移元から値を引き継ぐ様の変数
    var titleLabel:String = ""
    var detailText:String = ""
    var switchStatus:Bool = false
    var indexNumber:Int?
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoList = realm.objects(TodoItem.self)
        
        
        //各オブジェクトに対象の配列の要素をセット
        todoDetailTitleLabel.text = todoList[indexNumber!].title
        todoDetailTextView.text = todoList[indexNumber!].todoDetail
        todoStatusSwitch.isOn = todoList[indexNumber!].checked
        
        //キーパッドの決定ボタンの種類を指定.done(決定）
        todoDetailTextView.returnKeyType = .done
        
        //Delegateメソッドを設定
        todoDetailTextView.delegate = self
        
        //todoDetailTitleLabelのview設定
        todoDetailTitleLabel.layer.borderColor = UIColor.systemGray.cgColor
        //todoDetailTextViewのview設定
        todoDetailTextView.layer.borderWidth = 1.0
        todoDetailTextView.layer.cornerRadius = 5.0
        todoDetailTextView.layer.borderColor = UIColor.systemGray3.cgColor
        
    }
    //switchでタスクの状態を管理するためのIBAction
    @IBAction func todoStatusSwitch(_ sender: UISwitch) {
        if sender.isOn{
            todoStatusCheckLabel.text = "タスク完了済み！"
            switchStatus = true
        }else{
            todoStatusCheckLabel.text = "タスク未完了"
            switchStatus = false
        }
    }
    
    
    //登録ボタンをタップした時の処理
    @IBAction func updateButton(_ sender: Any) {
        alertDisplay()
    }
    
    //レコードを上書きする処理
    func updateReamlRecord(){
        try! realm.write {
            todoList[indexNumber!].todoDetail = todoDetailTextView.text
            todoList[indexNumber!].checked = todoStatusSwitch.isOn
            
        }
    }
    
    //入力画面 or キーパットの外をタップした時にキーパットを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(todoDetailTextView.isFirstResponder){
            self.todoDetailTextView.resignFirstResponder()
        }
    }
    
    //alertを実装
    func alertDisplay(){
        let alert:UIAlertController = UIAlertController(title: "編集を保存", message: "タスク内容を上書きします。よろしいですか？", preferredStyle: .alert)
        
        let okAlert:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            self.updateReamlRecord()
            
            self.todoDetailTextView.endEditing(true)
            self.navigationController?.popViewController(animated: true)
            })
        
        let cancel:UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alert.addAction(okAlert)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
