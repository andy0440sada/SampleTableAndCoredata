# 概要
TableViewControllerとCoredataを使用した簡単なアプリのサンプルです。

# サンプルに含まれている機能
- Coredataの追加、削除、参照
- NSFetchResultControllerによるTableViewの更新
- UnwindSegueによる画面遷移

# 解説
## Coredataの追加、削除、参照
 Coredataはリレーショナルデータベースとオブジェクトの間を上手に取り持ってくれるO/Rマッピングツール。
 オブジェクト指向でエンティティを作成し、メインプログラムからオブジェクトとして読み書きするロジックを書けば、勝手に最適化してリレーショナルデータベース（SQLite）とやりとりしてくれる。
 他にもModelControllerとして動作するNSFetchResultController等を搭載し、特にUITableViewControllerでは欠かせない存在になっている。

## Coredataを理解するには
まずは以下の公式ドキュメントを熟読。

[Coredataプログラミングガイド](https://developer.apple.com/jp/documentation/CoreData.pdf)

そして、当サンプルソースを解読すれば理解が進むと思う。

## その他
NSFetchedResultControllerクラスのobjectAtIndexPathメソッドは、通常だと特定Entityへのダウンキャストができない。
以下の手順でCoreDataの設定とNSManagedObjectを修正するとダウンキャストが出来るようになる。

1. CoreDataの対象Entityのプロパティについて、「Class」属性をEntity名に変更
1. 対象EntityのNSManagedObjectに@Objc(Entity)を追加

詳細はstackOverflow参照  
http://stackoverflow.com/questions/26613971/swift-coredata-warning-unable-to-load-class-named
