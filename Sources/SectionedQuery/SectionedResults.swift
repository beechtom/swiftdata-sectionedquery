//
//  SectionedResults.swift
//  
//  Created by Thomas Magis-Agosta on 9/27/23.
//

import SwiftData
import SwiftUI

/// A collection of models retrieved from a SwiftData persistent store, grouped into sections.
///
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, visionOS 1, *)
public struct SectionedResults<SectionIdentifier, Result>: RandomAccessCollection
where SectionIdentifier: Hashable, Result: PersistentModel {

    /// A type that represents an element in the collection.
    public typealias Element     = SectionedResults<SectionIdentifier, Result>.Section
    /// A type that represents a position in the collection.
    public typealias Index       = Int
    /// A type that represents the indices that are valid for subscripting the collection, in ascending order.
    public typealias Indices     = Range<Int>
    /// A type that provides the collection’s iteration interface and encapsulates its iteration state.
    public typealias Iterator    = IndexingIterator<SectionedResults<SectionIdentifier, Result>>
    /// A collection representing a contiguous subrange of this collection’s elements. The subsequence shares indices with the original collection.
    public typealias SubSequence = Slice<SectionedResults<SectionIdentifier, Result>>

    /// The key path that the system uses to group results into sections.
    public var sectionIdentifier: KeyPath<Result, SectionIdentifier>
    /// The collection of results that share a specified identifier.
    public var sections: [Section]
    /// The index of the first section in the results collection.
    public var startIndex: Int = 0
    /// The index that’s one greater than that of the last section.
    public var endIndex: Int { sections.count }


    /// Gets the section at the specified index.
    public subscript(position: Int) -> Section {
        get { sections[position] }
    }


    internal init(sectionIdentifier: KeyPath<Result, SectionIdentifier>, results: [Result]) {
        self.sectionIdentifier = sectionIdentifier
        
        let groupedResults = Dictionary(grouping: results) { result in
            result[keyPath: sectionIdentifier]
        }
        
        let identifiers = results.map { result in
            result[keyPath: sectionIdentifier]
        }.uniqued()
        
        self.sections = identifiers.compactMap { identifier in
            guard let elements = groupedResults[identifier] else { return nil }
            return Section(id: identifier, elements: elements)
        }
    }


    /// The collection of models that share a specified identifier.
    ///
    public struct Section: RandomAccessCollection, Identifiable {

        /// A type that represents an element in the collection.
        public typealias Element     = Result
        /// A type that represents the ID of the collection.
        public typealias ID          = SectionIdentifier
        /// A type that represents a position in the collection.
        public typealias Index       = Int
        /// A type that represents the indices that are valid for subscripting the collection, in ascending order.
        public typealias Indices     = Range<Int>
        /// A type that provides the collection’s iteration interface and encapsulates its iteration state.
        public typealias Iterator    = IndexingIterator<SectionedResults<SectionIdentifier, Result>.Section>
        /// A collection representing a contiguous subrange of this collection’s elements. The subsequence shares indices with the original collection.
        public typealias SubSequence = Slice<SectionedResults<SectionIdentifier, Result>.Section>

        /// The section identifier.
        public var id: ID
        /// The collection of results for the section.
        public var elements: [Element]
        /// The index of the first element in the results collection.
        public var startIndex: Int = 0
        /// The index that’s one greater than that of the last element.
        public var endIndex: Int { elements.count }


        /// Gets the element at the specified index.
        public subscript(position: Int) -> Result {
            get { elements[position] }
        }


        internal init(id: ID, elements: [Element]) {
            self.id       = id
            self.elements = elements
        }

    }

}
