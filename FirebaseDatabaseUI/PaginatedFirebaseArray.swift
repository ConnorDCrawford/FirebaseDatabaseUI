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

class PaginatedFirebaseArray<T : FirebaseModel>: FirebaseArray<T> {
    
    var pageSize: UInt
    var startValue: Any?
    var sortKey: String?
    var paginatedQuery: FIRDatabaseQuery
    var lastLoadedObject: T?
    var numberOfPages = 1
    lazy var pageEndValues = [Any?]()
    
    public convenience init(ref: FIRDatabaseReference,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?) {
        self.init(query: ref,
                  sortKey: sortKey,
                  pageSize: pageSize,
                  startValue: startValue)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?) {
        self.init(query: query,
                  sortKey: sortKey,
                  pageSize: pageSize,
                  startValue: startValue,
                  sortOrderBlock: nil,
                  filterBlock: nil)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            predicate: NSPredicate?) {
        self.init(query: query,
                  sortKey: sortKey,
                  pageSize: pageSize,
                  startValue: startValue,
                  sortOrderBlock: FirebaseArray.getSortOrderBlock(from: sortDescriptors),
                  filterBlock: FirebaseArray.getFilterBlock(from: predicate))
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            filterBlock: FilterBlock?) {
        self.init(query: query,
                  sortKey: sortKey,
                  pageSize: pageSize,
                  startValue: startValue,
                  sortOrderBlock: FirebaseArray.getSortOrderBlock(from: sortDescriptors),
                  filterBlock: filterBlock)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: SortOrderBlock?,
                            predicate: NSPredicate?) {
        self.init(query: query,
                  sortKey: sortKey,
                  pageSize: pageSize,
                  startValue: startValue,
                  sortOrderBlock: sortOrderBlock,
                  filterBlock: FirebaseArray.getFilterBlock(from: predicate))
    }
    
    public init(query: FIRDatabaseQuery,
                sortKey: String?,
                pageSize: UInt,
                startValue: Any?,
                sortOrderBlock: SortOrderBlock?,
                filterBlock: FilterBlock?) {
        self.sortKey = sortKey
        self.pageSize = pageSize
        self.startValue = startValue
        
        
        if let startValue = startValue {
            paginatedQuery = query.queryLimited(toFirst: pageSize).queryStarting(atValue: startValue)
        } else {
            paginatedQuery = query.queryLimited(toFirst: pageSize)
        }
        
        super.init(query: query, sortOrderBlock: sortOrderBlock, filterBlock: filterBlock)
    }
    
    override func initListeners(for query: FIRDatabaseQuery) {
        var query = query
        let pageNumber = self.numberOfPages
        
        // Do not init listeners for orignal query
        if query == self.query {
            query = paginatedQuery
        }
        
        let cancelHandler: (Error)->Void = { (error: Error) in
            self.delegate?.cancelled(with: error)
        }
        
        let valueHandler = { (snapshot: FIRDataSnapshot) in
            let children = snapshot.children.allObjects
            
            for (i, childSnap) in children.enumerated() {
                
                guard let childSnap = childSnap as? FIRDataSnapshot,
                    let object = T(snapshot: childSnap)
                    else { continue }
                
                // There should be no duplicate keys in the array
                if self.keys.contains(object.key) {
                    continue
                }
                
                let index = self.insertionIndex(of: object)
                self.keys.insert(object.key)
                
                // Check if result should be filtered
                if let filterBlock = self.filterBlock, !filterBlock(object) {
                    self.hiddenModels[object.key] = object
                } else {
                    self.models.insert(object, at: index)
                }
                
                guard let values = childSnap.value as? [String : Any] else { break }
                let value = self.sortKey == nil ? childSnap.key : values[self.sortKey!] as? String

                // Check if first value is loaded
                // We want to init an additional query to keep handle events for items that are added above
                // the current first item in the query.
                if self.startValue == nil {
                    self.startValue = value
                    self.initListeners(for: self.query.queryEnding(atValue: value))
                }
                
                if i == children.count - 1 {
                    self.lastLoadedObject = object
                    self.pageEndValues.append(value)
                }
            }
            
            self.delegate?.initialized()
        }
        
        let addHandler = { (snapshot: FIRDataSnapshot) in
            guard pageNumber <= self.pageEndValues.count, let object = T(snapshot: snapshot) else { return }
            
            // Check if result should be filtered
            if let filterBlock = self.filterBlock, !filterBlock(object) {
                self.hiddenModels[object.key] = object
                return
            }
            
            if !self.keys.contains(object.key) {
                self.keys.insert(object.key)
                let index = self.insertionIndex(of: object)
                self.models.insert(object, at: index)
                self.delegate?.added(child: object, at: index)
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
    
    open func load(pageNumber: Int) {
        if pageNumber >= 0 && pageNumber <= pageEndValues.count && numberOfPages == pageNumber {
            paginatedQuery = query.queryStarting(atValue: pageEndValues[pageNumber - 1]).queryLimited(toFirst: pageSize)
            initListeners(for: paginatedQuery)
            numberOfPages += 1
        }
    }
    
}
