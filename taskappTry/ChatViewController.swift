//
//  ChatViewController.swift
//  taskappTry
//
//  Created by 田村崚 on 2017/06/03.
//  Copyright © 2017年 ryo.tamura. All rights reserved.
//

import UIKit
import RealmSwift
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var category = ""
    
    var categoryArray = try! Realm().objects(CategoryData.self)///カテゴリ新規追加用
    var chatDataArray = try! Realm().objects(ChatData.self)///後で条件指定
    var setDataArray = try! Realm().objects(SetData.self)///後で条件指定
    
    var messages: [JSQMessage] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        senderDisplayName = "M"
        senderId = "Me"
        ///後で修正
        let predicate = NSPredicate(format: "category = %@", "\(category)")
        chatDataArray = chatDataArray.filter(predicate)
        setDataArray = setDataArray.filter(predicate)
        
        print("カテゴリー「\(category)」には\(chatDataArray.count)個のデータがあります。")
        
        for chatdata in chatDataArray{
            let message:JSQMessage = JSQMessage(senderId: chatdata.senderId, displayName: "M", text: chatdata.message)
            messages.append(message)
            print("append success")
        }
        
        self.collectionView.reloadData()
        print(chatDataArray)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.row].senderId == senderId {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(
                with: UIColor(red: 112/255, green: 192/255, blue:  75/255, alpha: 1))
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(
                with: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell
        if messages[indexPath.row].senderId == senderId {
            cell?.textView?.textColor = UIColor.white
        } else {
            cell?.textView?.textColor = UIColor.darkGray
        }
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return JSQMessagesAvatarImageFactory.avatarImage(
            withUserInitials: messages[indexPath.row].senderDisplayName,
            backgroundColor: UIColor.lightGray, textColor: UIColor.white,
            font: UIFont.systemFont(ofSize: 10), diameter: 30)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        inputToolbar.contentView.textView.text = ""
        
        ///新規カテゴリ作成
        if chatDataArray.count == 0{
            let category = CategoryData()
            category.categoryName = text
            category.date = date as! NSDate
            let realm = try! Realm()
            try! realm.write {
                realm.add(category)
            }
        }
        ///ここまで
        
        let chatData = ChatData()
        
        if chatDataArray.count != 0{
        chatData.category = category
        }else{
            chatData.category = text
            category = text
        }
        
        if text.characters.count >= 5{
        chatData.senderId = senderId
        }else{
            chatData.senderId = "You"
        }
        
        chatData.message = text
        chatData.date = date as! NSDate
        chatData.senderDisplayName = senderDisplayName
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(chatData)
        }
        
        let message:JSQMessage = JSQMessage(senderId: chatData.senderId, displayName: "M", text: chatData.message)
        messages.append(message)
        
        self.collectionView.reloadData()
        
        
        
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
