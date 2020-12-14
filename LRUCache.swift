//
//  AFUserInfoCache.swift
//  Artefact
//
//  Created by 陈玉龙 on 2020/9/14.
//  Copyright © 2020 SceneConsole. All rights reserved.
//

import Foundation


typealias DoublyLinkedListNode<T> = DoublyLinkedList<T>.Node<T>

final class DoublyLinkedList<T> {
 
    private(set) var count: Int = 0
    
    private var head: Node<T>?
    private var tail: Node<T>?
    
    final class Node<T> {
        var data: T
        var previous: Node<T>?
        var next: Node<T>?
 
        init(data: T) {
            self.data = data
        }
    }
    
    
    func addHead(_ data: T) -> Node<T> {
        let node = Node(data: data)
        defer {
            head = node
            count += 1
        }
     
        guard let head = head else {
            tail = node
            return node
        }
     
        head.previous = node
     
        node.previous = nil
        node.next = head
     
        return node
    }
    
    
    func moveToHead(_ node: Node<T>) {
        if node === head { return }
        let previous = node.previous
        let next = node.next
     
        previous?.next = next
        next?.previous = previous
     
        node.next = head
        node.previous = nil
     
        if node === tail {
            tail = previous
        }
     
        self.head = node
    }
    
    
    func removeLast() -> Node<T>? {
        guard let tail = self.tail else { return nil }
        
        let previous = tail.previous
        previous?.next = nil
        self.tail = previous
        
        if count == 1 {
            head = nil
        }
        
        count -= 1
        
        return tail
    }

}


final class LRUCache<Key: Hashable, Value> {
 
    private let list = DoublyLinkedList<CacheData>()
    private var nodesDict = [Key: DoublyLinkedListNode<CacheData>]()
    
    
    private struct CacheData {
        let key: Key
        let value: Value
    }
    
    private let capacity: Int
     
    init(capacity: Int) {
        self.capacity = max(0, capacity)
    }
    
    
    func setValue(_ value: Value, for key: Key) {
        let data = CacheData(key: key, value: value)
     
        if let node = nodesDict[key] {
            node.data = data
            list.moveToHead(node)
        } else {
            let node = list.addHead(data)
            nodesDict[key] = node
        }
     
        if list.count > capacity {
            let nodeRemoved = list.removeLast()
            if let key = nodeRemoved?.data.key {
                nodesDict[key] = nil
            }
        }
    }
    
    
    func getValue(for key: Key) -> Value? {
        guard let node = nodesDict[key] else { return nil }
     
        list.moveToHead(node)
     
        return node.data.value
    }
    
}


