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

import FirebaseDatabase
import SwiftLCS

open class FirebaseArray<T : FirebaseModel>: NSObject, Collection {
    
    public typealias SortOrderBlock = (T, T) -> ComparisonResult
    public typealias FilterBlock = (T) -> Bool
    public typealias Index = Int
    
    /**
     * The delegate object that array changes are surfaced to, which conforms to the
     * [FirebaseArrayDelegate Protocol](FirebaseArrayDelegate).
     */
    open weak var delegate: FirebaseArrayDelegate?
    
    /**
     * The query on a Firebase reference that provides data to populate the instance of FirebaseArray.
     */
    private(set) var query: FIRDatabaseQuery
    
    /**
     * The block with which the snapshots are filtered. If filterBlock is nil, the array reflects all
     * results from the Firebase Query or Reference.
     */
    var filterBlock: FilterBlock?
    
    
    /**
     * The block with which the snapshots are sorted. If sortOrderBlock is nil, the array is sorted
     * in the order specified by the Firebase Query or Reference.
     */
    var sortOrderBlock: SortOrderBlock?
    
    // TODO: Write documentation
    
    public convenience init(ref: FIRDatabaseReference) {
        self.init(query: ref)
    }
    
    public convenience init(query: FIRDatabaseQuery) {
        self.init(query: query, sortOrderBlock: nil, filterBlock: nil)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?) {
        self.init(query: query,
                  sortOrderBlock: FirebaseArray.getSortOrderBlock(from: sortDescriptors),
                  filterBlock: FirebaseArray.getFilterBlock(from: predicate))
    }
    
    public convenience init(query: FIRDatabaseQuery, sortDescriptors: [NSSortDescriptor]?, filterBlock: FilterBlock?) {
        self.init(query: query, sortOrderBlock: FirebaseArray.getSortOrderBlock(from: sortDescriptors), filterBlock: filterBlock)
    }
    
    public convenience init(query: FIRDatabaseQuery, sortOrderBlock: SortOrderBlock?, predicate: NSPredicate?) {
        self.init(query: query, sortOrderBlock: sortOrderBlock, filterBlock: FirebaseArray.getFilterBlock(from: predicate))
    }
    
    public init(query: FIRDatabaseQuery, sortOrderBlock: SortOrderBlock?, filterBlock: FilterBlock?) {
        self.query = query
        self.filterBlock = filterBlock
        self.sortOrderBlock = sortOrderBlock ?? { (t1, t2) in
            return t1.key < t2.key ? .orderedAscending : .orderedDescending
        }
        super.init()
        self.initListeners(for: query)
    }
    
    deinit {
        for handle in observerHandles {
            query.removeObserver(withHandle: handle)
        }
    }
    
    // MARK: - internal API methods
    
    var models = [T]()
    lazy var hiddenModels = [String : T]()
    private var isInitialized = false
    lazy var observerHandles = [UInt]()
    lazy var keys = Set<String>()
    
    func initListeners(for query: FIRDatabaseQuery) {
        
        let cancelHandler: (Error)->Void = { (error: Error) in
            self.delegate?.cancelled(with: error)
        }
        
        let valueHandler = { (snapshot: FIRDataSnapshot) in
            for childSnap in snapshot.children.allObjects {
                guard let childSnap = childSnap as? FIRDataSnapshot,
                    let model = T(snapshot: childSnap)
                    else { break }
                let index = self.insertionIndex(of: model)
                self.keys.insert(model.key)
                
                // Check if result should be filtered
                if let filterBlock = self.filterBlock, !filterBlock(model) {
                    self.hiddenModels[model.key] = model
                } else {
                    self.models.insert(model, at: index)
                }
                
            }
            self.delegate?.initialized()
            self.isInitialized = true
        }
        
        let addHandler = { (snapshot: FIRDataSnapshot) in
            guard self.isInitialized, let model = T(snapshot: snapshot) else { return }
            
            // Check if result should be filtered
            if let filterBlock = self.filterBlock, !filterBlock(model) {
                self.hiddenModels[model.key] = model
                return
            }
            
            if !self.keys.contains(model.key) {
                let index = self.insertionIndex(of: model)
                self.models.insert(model, at: index)
                self.delegate?.added(child: model, at: index)
            }
            
        }
        
        let removeHandler = { (snapshot: FIRDataSnapshot) in
            if let index = self.index(of: snapshot.key) {
                let model = self.models[index]
                self.keys.remove(model.key)
                self.models.remove(at: index)
                self.hiddenModels.removeValue(forKey: model.key)
                self.delegate?.removed(child: model, at: index)
            }
        }
        
        let changeHandler = { (snapshot: FIRDataSnapshot) in
            let index = self.index(of: snapshot.key)
            guard let model = T(snapshot: snapshot) else { return }
            
            if let filterBlock = self.filterBlock {
                let shouldFilterModel = !filterBlock(model)
                
                // Check if result should be filtered, remove from models and put in hiddenModels if so
                if shouldFilterModel {
                    self.hiddenModels[model.key] = model
                    
                    if let index = index {
                        self.models.remove(at: index)
                        self.keys.remove(model.key)
                        self.delegate?.removed(child: model, at: index)
                    }
                    return
                } else if self.hiddenModels[model.key] != nil {
                    // Model is currently hidden, but now should not be. Put in models and show.
                    let index = self.add(hiddenModel: model)
                    self.delegate?.added(child: model, at: index)
                }
            }
            
            if let index = index {
                let insertionIndex = self.sortOrderBlock == nil ? index : self.insertionIndex(of: model)
                self.models.remove(at: index)
                self.models.insert(model, at: insertionIndex)
                self.delegate?.changed(child: model, at: index)
                
                if self.sortOrderBlock != nil && index != insertionIndex {
                    self.delegate?.moved(child: model, from: index, to: insertionIndex)
                }
                
            }
            
        }
        
        let moveHandler = { (snapshot: FIRDataSnapshot) in
            if let oldIndex = self.index(of: snapshot.key), let model = T(snapshot: snapshot) {
                self.models.remove(at: oldIndex)
                let newIndex = self.insertionIndex(of: model)
                self.models.insert(model, at: newIndex)
                self.delegate?.moved(child: model, from: oldIndex, to: newIndex)
            }
        }
        
        query.observeSingleEvent(of: .value, with: valueHandler, withCancel: cancelHandler)
        let added = query.observe(.childAdded, with: addHandler, withCancel: cancelHandler)
        let changed = query.observe(.childChanged, with: changeHandler, withCancel: cancelHandler)
        let removed = query.observe(.childRemoved, with: removeHandler, withCancel: cancelHandler)
        let moved = query.observe(.childMoved, with: moveHandler, withCancel: cancelHandler)
        
        observerHandles.append(contentsOf: [added, changed, removed, moved])
    }
    
    func compare(model: T, with aModel: T) -> ComparisonResult? {
        let m1 = model
        let m2 = aModel
        
        if let sortOrderBlock = sortOrderBlock {
            return sortOrderBlock(m1, m2)
        }
        return m1.key.compare(m2.key)
    }
    
    func index(of key: String) -> Index? {
        return models.index(where: { (snapshot) -> Bool in
            if snapshot.key == key {
                return true
            }
            return false
        })
    }
    
    func insertionIndex(of object: T) -> Index {
        if sortOrderBlock != nil {
            return models.insertionIndex(of: object) { (s1, s2) -> Bool in
                return compare(model: s1, with: s2) == .orderedAscending
            }
        }
        return self.models.count
    }
    
    static func getFilterBlock(from predicate: NSPredicate?) -> FilterBlock? {
        var filterBlock: FilterBlock?
        
        if let predicate = predicate {
            filterBlock = { (model: T) -> Bool in
                return predicate.evaluate(with: model)
            }
        }
        
        return filterBlock
    }
    
    static func getSortOrderBlock(from sortDescriptors: [NSSortDescriptor]?) -> SortOrderBlock? {
        var sortOrderBlock: SortOrderBlock?
        if let sortDescriptors = sortDescriptors, !sortDescriptors.isEmpty {
            sortOrderBlock = { (m1: T, m2: T) -> ComparisonResult in
                if m1.key == m2.key {
                    return .orderedSame
                }
                
                var result = ComparisonResult.orderedSame
                for sortDescriptor in sortDescriptors {
                    result = sortDescriptor.compare(m1, to: m2)
                    if (result != .orderedSame) {
                        break
                    }
                }
                return result
                
            }
        }
        return sortOrderBlock
    }
    
    func add(hiddenModel: T) -> Index {
        hiddenModels.removeValue(forKey: hiddenModel.key)
        let index = insertionIndex(of: hiddenModel)
        models.insert(hiddenModel, at: index)
        keys.insert(hiddenModel.key)
        return index
    }
    
    // MARK: - open API methods
    
    open func setFilter(with filterBlock: FilterBlock?) {
        self.filterBlock = filterBlock
        
        let updateBlock = {
            if let filterBlock = filterBlock {
                // Hide visible models that should now be hidden
                for (index, model) in self.models.enumerated().reversed() {
                    if !filterBlock(model) {
                        self.hiddenModels[model.key] = model
                        self.models.remove(at: index)
                        self.keys.remove(model.key)
                        self.delegate?.removed(child: model, at: index)
                    }
                }
                
            }
            
            // Show hidden models that should now be visible
            let oldModels = self.models
//            var indices = [Index]()
            for (_, hidden) in self.hiddenModels {
                if filterBlock == nil || filterBlock!(hidden) {
                    _ = self.add(hiddenModel: hidden)
                }
            }
            let diff = oldModels.diff(self.models)
            for index in diff.addedIndexes {
                self.delegate?.added(child: self.models[index], at: index)
            }
        }
        
        delegate?.update(with: updateBlock)
    }
    
    open func setFilter(with predicate: NSPredicate?) {
        setFilter(with: FirebaseArray.getFilterBlock(from: predicate))
    }
    
    open func setSortOrder(with sortOrderBlock: SortOrderBlock?) {
        self.sortOrderBlock = sortOrderBlock
        if let sortOrderBlock = sortOrderBlock {
            self.models.sort(by: { (m1, m2) -> Bool in
                return sortOrderBlock(m1, m2) == .orderedAscending
            })
        } else {
            self.models.sort(by: { (m1, m2) -> Bool in
                return m1.key.compare(m2.key) == .orderedAscending
            })
        }
        delegate?.changedSortOrder()
    }
    
    open func setSortOrder(with sortDescriptors: [NSSortDescriptor]?) {
        setSortOrder(with: FirebaseArray.getSortOrderBlock(from: sortDescriptors))
    }
    
    /**
     * Returns a Firebase reference for an object at a specific index in the FirebaseArray.
     * @param index The index of the item to retrieve a reference for
     * @return A Firebase reference for the object at the given index
     */
    open func ref(for index: Index) -> FIRDatabaseReference {
        return models[index].ref
    }
    
    open var startIndex: Index {
        return 0
    }
    open var endIndex: Index {
        return count
    }
    
    /**
     * Returns the count of objects in the FirebaseArray.
     * @return The count of objects in the FirebaseArray
     */
    open var count: Int {
        return models.count
    }
    
    open subscript(index: Index) -> T {
        return models[index]
    }
    
    open subscript(key: String) -> T? {
        if let index = index(of: key) {
            return models[index]
        }
        return nil
    }
    
    open func index(after i: Index) -> Index {
        return i + 1
    }
    
}
