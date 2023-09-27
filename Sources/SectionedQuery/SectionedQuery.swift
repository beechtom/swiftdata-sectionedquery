//
//  SectionedQuery.swift
//
//  Created by Thomas Magis-Agosta on 9/27/23.
//

import SwiftData
import SwiftUI

/// A property wrapper that fetches a set of models, grouped into sections, and keeps those models
/// in sync with the underlying data.
///
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, visionOS 1, *)
@propertyWrapper
public struct SectionedQuery<SectionIdentifier, Element>: DynamicProperty
where SectionIdentifier: Hashable, Element: PersistentModel {

    /// A type that represents the results of the sectioned query.
    public typealias Results = SectionedResults<SectionIdentifier, Element>

    @Query private var elements: [Element]

    private let sectionIdentifier: KeyPath<Element, SectionIdentifier>


    /// An error encountered during the most recent attempt to fetch data.
    ///
    public var fetchError: (Error)? {
        _elements.fetchError
    }


    /// Current model context SectionedQuery interacts with.
    ///
    public var modelContext: ModelContext {
        _elements.modelContext
    }


    /// The most recent fetched result from the SectionedQuery.
    ///
    public var wrappedValue: Results {
        get {
            SectionedResults(sectionIdentifier: sectionIdentifier,
                             results: elements)
        }
    }


    /// Updates the underlying value of the stored value.
    ///
    public func update() {
        _elements.update()
    }


    /// Create a sectioned query.
    ///
    public init(_ sectionIdentifier: KeyPath<Element, SectionIdentifier>) {
        self.sectionIdentifier = sectionIdentifier
        _elements              = Query()
    }


    /// Create a sectioned query with a SwiftData predicate.
    ///
    public init(_ sectionIdentifier: KeyPath<Element, SectionIdentifier>,
                filter: Predicate<Element>) {
        self.sectionIdentifier = sectionIdentifier
        _elements              = Query(filter: filter)
    }


    /// Create a sectioned query with a predicate and a list of sort descriptors.
    ///
    public init(_ sectionIdentifier: KeyPath<Element, SectionIdentifier>,
                filter: Predicate<Element>? = nil,
                sort descriptors: [SortDescriptor<Element>] = [],
                transaction: Transaction? = nil) {
        self.sectionIdentifier = sectionIdentifier
        _elements              = Query(filter: filter,
                                       sort: descriptors,
                                       transaction: transaction)
    }


    /// Create a sectioned query with a predicate, a key path to a property for sorting,
    /// and the order to sort by.
    ///
    public init<Value>(_ sectionIdentifier: KeyPath<Element, SectionIdentifier>,
                       filter: Predicate<Element>? = nil,
                       sort keyPath: KeyPath<Element, Value>,
                       order: SortOrder = .forward,
                       transaction: Transaction? = nil) where Value: Comparable {
        self.sectionIdentifier = sectionIdentifier
        _elements              = Query(filter: filter,
                                       sort: keyPath,
                                       order: order,
                                       transaction: transaction)
    }


    /// Create a sectioned query with a predicate and a list of sort descriptors.
    ///
    public init(_ sectionIdentifier: KeyPath<Element, SectionIdentifier>,
                filter: Predicate<Element>? = nil,
                sort descriptors: [SortDescriptor<Element>] = [],
                animation: Animation) {
        self.sectionIdentifier = sectionIdentifier
        _elements              = Query(filter: filter,
                                       sort: descriptors,
                                       animation: animation)
    }


    /// Create a sectioned query with a predicate, a key path to a property for sorting,
    /// and the order to sort by.
    ///
    public init<Value>(_ sectionIdentifier: KeyPath<Element, SectionIdentifier>,
                       filter: Predicate<Element>? = nil,
                       sort keyPath: KeyPath<Element, Value>,
                       order: SortOrder = .forward,
                       animation: Animation = .easeInOut) where Value: Comparable {
        self.sectionIdentifier = sectionIdentifier
        _elements              = Query(filter: filter,
                                       sort: keyPath,
                                       order: order,
                                       animation: animation)
    }


    /// Create a sectioned query with a predicate, a key path to a property for sorting,
    /// and the order to sort by.
    ///
    public init<Value>(_ sectionIdentifier: KeyPath<Element, SectionIdentifier>,
                       filter: Predicate<Element>? = nil,
                       sort keyPath: KeyPath<Element, Value?>,
                       order: SortOrder = .forward,
                       transaction: Transaction? = nil) where Value: Comparable {
        self.sectionIdentifier = sectionIdentifier
        _elements              = Query(filter: filter,
                                       sort: keyPath,
                                       order: order,
                                       transaction: transaction)
    }


    /// Create a sectioned query with a SwiftData fetch descriptor.
    ///
    public init(_ sectionIdentifier: KeyPath<Element, SectionIdentifier>,
                fetchDescriptor: FetchDescriptor<Element>,
                transaction: Transaction? = nil) {
        self.sectionIdentifier = sectionIdentifier
        _elements              = Query(fetchDescriptor,
                                       transaction: transaction)
    }


    /// Create a sectioned query with a SwiftData fetch descriptor.
    ///
    public init(_ sectionIdentifier: KeyPath<Element, SectionIdentifier>,
                fetchDescriptor: FetchDescriptor<Element>,
                animation: Animation) {
        self.sectionIdentifier = sectionIdentifier
        _elements              = Query(fetchDescriptor,
                                       animation: animation)
    }

}
