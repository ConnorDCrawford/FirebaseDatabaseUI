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

extension Array {
    func insertionIndex(of element: Element, _ isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var min = 0
        var max = self.count - 1
        while min <= max {
            let mid = (min + max)/2
            if isOrderedBefore(self[mid], element) {
                min = mid + 1
            } else if isOrderedBefore(element, self[mid]) {
                max = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return min // not found, would be inserted at position min
    }
}
