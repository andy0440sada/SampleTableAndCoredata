//
//  SampleTableViewController.swift
//  SampleTableAndCoredata
//
//  Created by 安東貞義 on 2015/06/30.
//  Copyright (c) 2015年 Andy Show. All rights reserved.
//

import UIKit
import CoreData

class SampleTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()

    @IBAction func addSampleData(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    // unwind segueを設定するときは、最初に以下のようなunwind用メソッドを追加する。そして、ボタン等から「control」を押下しながらEXITアイコンにドラッグして以下のメソッドにつなげる。すると以下のメソッドがコールバックされるようになる。
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
        
        // segueプロパティはsourceViewControllerが遷移元のViewControllerで、destinationViewControllerが遷移先のViewControllerとなる。unwindの場合は、遷移元がSampleDetailViewControllerなので、sourceViewControllerにより取得する。
        
        var viewController = segue.sourceViewController as! SampleDetailViewController
        let text = viewController.textField.text
        
        self.addEntity(text)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchedResultController = self.getFetchedResultController()
        self.fetchedResultController.delegate = self
        self.fetchedResultController.performFetch(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInsection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInsection!
    }
    
    func addEntity(addText: String) {
        // AppDelegateのシングルトンインスタンスからManagedObjectContextを取得
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        // ManagedObjectContextからEntityDescriptionのインスタンスを取得
        let entityDescription = NSEntityDescription.entityForName("Entity", inManagedObjectContext: managedObjectContext!)
        // Entityインスタンスを初期化（第一引数の外部名がentityになっているが指定するのはNSEntityDescription）
        let entity = Entity(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        // もしくは以下の記述でもOK
        // let entity = NSEntityDescription.insertNewObjectForEntityForName("Entity", inManagedObjectContext: context) as! Entity
        // Entityのインスタンス生成時に必ずオブジェクトをinsertするのであればこちらの方がシンプル
        
        entity.text = addText
        managedObjectContext?.save(nil)
    }
    
    // FetchedResultControllerインスタンスの生成と初期化
    func getFetchedResultController() -> NSFetchedResultsController {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        let sortDescriptor = NSSortDescriptor(key: "text", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        // NSFetchedResultControllerからindexPathを指定してオブジェクトを取得する
        // EntityクラスにダウンCastするためには以下の通りにCoreDataの設定とNSManagedObjectを修正する必要あり
        // 1.CoreDataの対象Entityのプロパティについて、「Class」属性をEntity名に変更
        // 2.対象EntityのNSManagedObjectに@Objc(Entity)を追加
        // http://stackoverflow.com/questions/26613971/swift-coredata-warning-unable-to-load-class-named
        
        let entity = fetchedResultController.objectAtIndexPath(indexPath) as! Entity
        cell.textLabel?.text = entity.text
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
}
