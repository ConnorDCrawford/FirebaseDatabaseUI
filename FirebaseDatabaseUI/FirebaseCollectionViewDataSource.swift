//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import FirebaseDatabase

class FirebaseCollectionViewDataSource<T: FirebaseModel>: FirebaseDataSource<T>, UICollectionViewDataSource {
    
    /// The reuse identifier for cells in the UICollectionView.
    open var reuseIdentifier: String
    
    /// The reuse identifier for section headers in the UICollectionView.
    open var headerReuseIdentifier: String = "Header"
    
    /**
     * The UITableView instance that operations (inserts, removals, moves, etc.) are
     * performed against.
     */
    open var collectionView: UICollectionView?
    
    /**
     * The callback to populate a subclass of UITableViewCell with an object
     * provided by the datasource.
     */
    open var populateCellBlock: ((UICollectionViewCell, T)->Void)?
    
    open var sectionNameBlock: ((T) -> String?)? {
        didSet {
            if sectionNameBlock != nil {
                updateSections()
            } else {
                sections.removeAll()
                sectionNames.removeAll()
            }
            collectionView?.reloadData()
        }
    }
    
    /// Need to call registerClass:forSupplementaryViewOfKind:withReuseIdentifier: before use
    open var sectionHeaderBlock: ((_ sectionName: String) -> UICollectionReusableView)? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    public convenience init(query: FIRDatabaseQuery, sortOrderBlock: FirebaseArray<T>.SortOrderBlock?, filterBlock: FirebaseArray<T>.FilterBlock?, cellClass: AnyClass?, cellReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortOrderBlock: sortOrderBlock, filterBlock: filterBlock)
        collectionView?.register(cellClass, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortOrderBlock: FirebaseArray<T>.SortOrderBlock?, filterBlock: FirebaseArray<T>.FilterBlock?, prototypeReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortOrderBlock: sortOrderBlock, filterBlock: filterBlock)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortOrderBlock: FirebaseArray<T>.SortOrderBlock?, filterBlock: FirebaseArray<T>.FilterBlock?, nibNamed nibName: String, cellReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortOrderBlock: sortOrderBlock, filterBlock: filterBlock)
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortDescriptors: [NSSortDescriptor]?, filterBlock: FirebaseArray<T>.FilterBlock?, cellClass: AnyClass?, cellReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortDescriptors: sortDescriptors, filterBlock: filterBlock)
        collectionView?.register(cellClass, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortDescriptors: [NSSortDescriptor]?, filterBlock: FirebaseArray<T>.FilterBlock?, prototypeReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortDescriptors: sortDescriptors, filterBlock: filterBlock)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortDescriptors: [NSSortDescriptor]?, filterBlock: FirebaseArray<T>.FilterBlock?, nibNamed nibName: String, cellReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortDescriptors: sortDescriptors, filterBlock: filterBlock)
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortOrderBlock: FirebaseArray<T>.SortOrderBlock?, predicate: NSPredicate?, cellClass: AnyClass?, cellReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortOrderBlock: sortOrderBlock, predicate: predicate)
        collectionView?.register(cellClass, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortOrderBlock: FirebaseArray<T>.SortOrderBlock?, predicate: NSPredicate?, prototypeReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortOrderBlock: sortOrderBlock, predicate: predicate)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortOrderBlock: FirebaseArray<T>.SortOrderBlock?, predicate: NSPredicate?, nibNamed nibName: String, cellReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortOrderBlock: sortOrderBlock, predicate: predicate)
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, cellClass: AnyClass?, cellReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortDescriptors: sortDescriptors, predicate: predicate)
        collectionView?.register(cellClass, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, prototypeReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortDescriptors: sortDescriptors, predicate: predicate)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, nibNamed nibName: String, cellReuseIdentifier: String, collectionView: UICollectionView?) {
        let array = FirebaseArray<T>(query: query, sortDescriptors: sortDescriptors, predicate: predicate)
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public init(array: FirebaseArray<T>, reuseIdentifier: String, collectionView: UICollectionView?) {
        self.reuseIdentifier = reuseIdentifier
        super.init(array: array)
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        self.collectionView = collectionView
    }
    
    // MARK: - FirebaseArrayDelegate
    
    override open func update(with block: (() -> Void)?) {
        collectionView?.performBatchUpdates(block, completion: nil)
    }
    
    override open func initialized() {
        collectionView?.reloadData()
    }
    
    override open func added<M : FirebaseModel>(child: M, at index: Int) {
        guard let child = child as? T else { return }
        if let sectionNameBlock = self.sectionNameBlock {
            // collectionView is sectioned
            let sectionName = sectionNameBlock(child) ?? ""
            if var insertionSection = self.sections[sectionName] {
                // Section exists, insert snapshot in correct index
                let index = insertionSection.insertionIndex(of: child, { (s1, s2) -> Bool in
                    return self.array.compare(model: s1, with: s2) == .orderedAscending
                })
                insertionSection.insert(child, at: index)
                self.sections[sectionName] = insertionSection
                
                let sectionIndex = self.sectionNames.index(of: sectionName)!
                let indexPath = IndexPath(row: index, section: sectionIndex)
                self.collectionView?.insertItems(at: [indexPath])
            } else {
                // Section does not exist, create new section
                var sectionIndex: Int!
                self.sections[sectionName] = [child]
                if index == 0 {
                    sectionIndex = 0
                    self.sectionNames.insert(sectionName, at: 0)
                } else {
                    sectionIndex = self.indexPath(of: self.array[index - 1].key)!.section + 1
                    self.sectionNames.insert(sectionName, at: sectionIndex)
                }
                self.collectionView?.insertSections([sectionIndex])
            }
        } else {
            // collectionView is not sectioned
            if self.collectionView?.numberOfSections == 0 {
                self.collectionView?.insertSections([0])
            } else {
                let indexPath = IndexPath(row: index, section: 0)
                self.collectionView?.insertItems(at: [indexPath])
            }
        }
    }
    
    override open func changed<M : FirebaseModel>(child: M, at index: Int) {
        guard let child = child as? T else { return }
        if let sectionNameBlock = self.sectionNameBlock {
            // collectionView is sectioned
            let sectionName = sectionNameBlock(child) ?? ""
            if var section = self.sections[sectionName] {
                // Section exists, find index of changed snapshot
                
                let index = section.index(where: { (snap) -> Bool in
                    return snap.key == child.key
                })!
                section[index] = child
                self.sections[sectionName] = section
                
                let sectionIndex = self.sectionNames.index(of: sectionName)!
                let indexPath = IndexPath(row: index, section: sectionIndex)
                self.collectionView?.reloadItems(at: [indexPath])
            }
        } else {
            // collectionView is not sectioned
            let indexPath = IndexPath(row: index, section: 0)
            self.collectionView?.reloadItems(at: [indexPath])
        }
    }

    override open func removed<M : FirebaseModel>(child: M, at index: Int) {
        guard let child = child as? T else { return }
        if let sectionNameBlock = self.sectionNameBlock {
            // tableView is sectioned
            let sectionName = sectionNameBlock(child) ?? ""
            if var section = self.sections[sectionName] {
                // Section exists, find index of removed snapshot
                let index = section.index(where: { (snap) -> Bool in
                    return snap.key == child.key
                })!
                section.remove(at: index)
                self.sections[sectionName] = section
                
                let sectionIndex = self.sectionNames.index(of: sectionName)!
                if section.isEmpty {
                    self.sectionNames.remove(at: sectionIndex)
                    self.sections.removeValue(forKey: sectionName)
                    self.collectionView?.deleteSections([sectionIndex])
                } else {
                    let indexPath = IndexPath(row: index, section: sectionIndex)
                    self.collectionView?.deleteItems(at: [indexPath])
                }
            }
        } else {
            // tableView is not sectioned
            let indexPath = IndexPath(row: index, section: 0)
            self.collectionView?.deleteItems(at: [indexPath])
        }
    }
    
    override open func moved<M : FirebaseModel>(child: M, from oldIndex: Int, to newIndex: Int) {
        guard let child = child as? T else { return }
        if let sectionNameBlock = self.sectionNameBlock {
            // tableView is sectioned
            let sectionName = sectionNameBlock(child) ?? ""
            if var section = self.sections[sectionName] {
                // Section exists, insert snapshot in correct index
                let oldIndex = section.index(where: { (model) -> Bool in
                    return model.key == child.key
                })!
                section.remove(at: oldIndex)
                let newIndex = section.insertionIndex(of: child, { (m1, m2) -> Bool in
                    return self.array.compare(model: m1, with: m2) == .orderedAscending
                })
                section.insert(child, at: newIndex)
                self.sections[sectionName] = section
                
                let sectionIndex = self.sectionNames.index(of: sectionName)!
                let oldIndexPath = IndexPath(row: oldIndex, section: sectionIndex), newIndexPath = IndexPath(row: newIndex, section: sectionIndex)
                self.collectionView?.moveItem(at: oldIndexPath, to: newIndexPath)
            } else {
                // Section does not exist, create new section
                self.sections[sectionName] = [child]
                let sectionIndex = self.sectionNames.count
                self.sectionNames.append(sectionName)
                self.collectionView?.insertSections([sectionIndex])
            }
        } else {
            // tableView is not sectioned
            let oldIndexPath = IndexPath(row: oldIndex, section: 0), newIndexPath =  IndexPath(row: newIndex, section: 0)
            self.collectionView?.moveItem(at: oldIndexPath, to: newIndexPath)
        }
    }
    
    override open func changedSortOrder() {
        self.updateSections()
        self.collectionView?.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.sectionNameBlock != nil {
            return self.sectionNames.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.sectionNameBlock == nil {
            return self.array.count
        }
        
        let sectionValue = self.sectionNames[section]
        if let section = self.sections[sectionValue] {
            return section.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        var object: T!
        
        if self.sectionNames.isEmpty {
            object = self.array[indexPath.row]
        } else {
            let sectionValue = self.sectionNames[indexPath.section]
            let section = self.sections[sectionValue]
            object = section![indexPath.row]
        }
        
        self.populateCellBlock?(cell, object)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionHeader {
            
            // Return user's section header if they have specified a section header block
            if let sectionHeaderBlock = sectionHeaderBlock {
                return sectionHeaderBlock(sectionNames[indexPath.section])
            }
            
            // Return a basic section header
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
            if v.subviews.count == 0 {
                v.addSubview(UILabel(frame:CGRect(x: 0, y: 0, width: 30, height: 30)))
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = (self.sectionNames)[indexPath.section]
            lab.textAlignment = .center
        }
        return v
    }
    
    // MARK: - open API methods
    
    /**
     * Returns an object at a specific index in the FirebaseArray.
     * @param indexPath The index path of the item to retrieve
     * @return The object at the given index path
     */
    override open func object(at indexPath: IndexPath) -> T? {
        if self.sectionNameBlock != nil {
            let sectionValue = self.sectionNames[indexPath.section]
            let section = self.sections[sectionValue]!
            return section[indexPath.row]
        }
        return super.object(at: indexPath)
    }
    
    open func indexPath(of key: String) -> IndexPath? {
        if self.sectionNameBlock != nil {
            for (value, section) in self.sections {
                for (index, item) in section.enumerated() {
                    if key == item.key {
                        let sectionIndex = self.sectionNames.index(of: value)!
                        return IndexPath(row: index, section: sectionIndex)
                    }
                }
            }
            return nil
        }
        guard let index = self.array.index(where: { (model: T) -> Bool in
            return key == model.key
        })
            else { return nil }
        return IndexPath(row: index, section: 0)
    }
    
    /**
     * Returns a Firebase reference for an object at a specific index in the FirebaseArray.
     * @param indexPath The index path of the item to retrieve a reference for
     * @return A Firebase reference for the object at the given index path
     */
    override open func ref(for indexPath: IndexPath) -> FIRDatabaseReference? {
        return self.object(at: indexPath)?.ref
    }
    
    open func populateCell(with block: ((UICollectionViewCell, T)->Void)?) {
        self.populateCellBlock = block
    }
    
    // MARK: - Private API methods
    
    private func updateSections() {
        self.sections.removeAll()
        self.sectionNames.removeAll()
        for object in self.array {
            let sectionName = self.sectionNameBlock?(object) ?? ""
            if self.sections[sectionName] != nil {
                self.sections[sectionName]!.append(object)
            } else {
                self.sections[sectionName] = [object]
                self.sectionNames.append(sectionName)
            }
        }
    }
    
}
