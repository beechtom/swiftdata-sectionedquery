# SectionedQuery

A property wrapper that fetches a set of SwiftData models, grouped into
sections, and keeps those models in sync with the underlying data.

## Table of Contents

- [Intent](#intent)
- [Features](#features)
- [Supported Platforms](#supported-platforms)
- [Example Usage](#example-usage)
- [Usage Notes](#usage-notes)
- [License](#license)

## Intent

Originally announced at WWDC 2023, SwiftData makes it easy to persist
data using declarative code. The framework includes a new `@Query` property
wrapper that fetches a set of models, similar to the `@FetchRequest`
property wrapper used with a CoreData stack.

However, SwiftData does not currently include a property wrapper that
fetches models grouped into sections, similar to the `@SectionedFetchRequest`
property wrapper used with a CoreData stack.

This package fills this gap in the SwiftData framework by providing a
`@SectionedQuery` property wrapper and `SectionedResults` type that makes
it easy to write sectioned queries and use the data in your views.

## Features

- **Multiple Initializers**

  Initializers for `@SectionedQuery` that match those for `@Query`,
  making it easy to build your queries using any mix of predicates, sort
  descriptors, animations, and more.

- **Automatic View Updates**

  `@SectionedQuery` will automatically trigger an update of the view when the
  underlying data changes, so there's no need to trigger a manual refresh.

- **Iterable Result Type**

  The `SectionedResults` type conforms to `RandomAccessCollection`, making it
  easy to iterate over each section and its elements without any complex code.

## Supported Platforms

The following platforms are supported:

- iOS 17.0+
- macOS 14.0+
- tvOS 13.0+
- watchOS 10.0+
- visionOS 1.0+

## Example Usage

Use `@SectionedQuery` in your SwiftUI views to fetch data, just like you would
with `@Query`. Simply specify the property of your model to section results by
and set the type to `SectionedResults<SectionIdentifier, Result>`.

```swift
import SwiftData
import SectionedQuery


@Model
class Item {

    @Attribute(.unique) var name: String
    var kind: String

}


struct ContentView: View {

    @SectionedQuery(\.kind) private var results: SectionedResults<String, Item>

    var body: some View {
        List(results) { section in
            Section(section.id) {
                ForEach(section) { item in
                    Text(item.name)
                }
            }
        }
    }

}
```

If you want to support dynamic sectioned queries, you can set the property from
the view's initializer, passing in any relevant parameters.

```swift
import SwiftData
import SectionedQuery


@Model
class Item {

    @Attribute(.unique) var name: String
    var kind: String

}


struct DynamicContentView: View {

    @SectionedQuery private var results: SectionedResults<String, Item>

    var body: some View {
        List(results) { section in
            Section(section.id) {
                ForEach(section) { item in
                    Text(item.name)
                }
            }
        }
    }
    
    init(order: SortOrder) {
        _results = SectionedQuery(\.kind, order: order)
    }

}
```

## Usage Notes

When using the `@SectionedQuery` property wrapper, there are a few important
things to keep in mind:

- The model property that you section results by must conform to `Hashable`.

- The `SectionedResults<SectionIdentifier, Result>` type must be specialized:

    - `SectionIdentifier` must match the type of the model property you section
      results by. It must conform to `Hashable`.

    - `Result` must match the type of the model you are querying. It must
      conform to `PersistentModel`.

Because `SectionedResults` conforms to `RandomAccessCollection`, you can easily
use it with SwiftUI views like `List` and `ForEach`.

## License

This package is distributed under [The MIT License](./LICENSE).
