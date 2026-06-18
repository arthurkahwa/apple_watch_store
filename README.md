# Apple Watch Store

**A premium iOS e-commerce experience for browsing and purchasing Apple Watch products.**

![Swift](https://img.shields.io/badge/Swift-5.9+-F05138?style=for-the-badge&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-17.5+-000000?style=for-the-badge&logo=apple&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-blue?style=for-the-badge&logo=swift&logoColor=white)
![SwiftData](https://img.shields.io/badge/SwiftData-purple?style=for-the-badge&logo=swift&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Dependencies](https://img.shields.io/badge/Dependencies-0-brightgreen?style=for-the-badge)

Built entirely with Apple-native frameworks. Zero external dependencies. 69 Swift files of clean, pattern-driven architecture.

---

## Screenshots

<table>
  <tr>
    <td align="center" width="25%">
      <img src="screenshots/en/dark/home.png" width="200" alt="Home" /><br>
      <sub><b>Home</b></sub>
    </td>
    <td align="center" width="25%">
      <img src="screenshots/en/dark/products.png" width="200" alt="Products" /><br>
      <sub><b>Products</b></sub>
    </td>
    <td align="center" width="25%">
      <img src="screenshots/en/light/cart.png" width="200" alt="Shopping Cart" /><br>
      <sub><b>Shopping Cart</b></sub>
    </td>
  </tr>
</table>

---

## Features

| Feature | Description |
|---------|-------------|
| :mag: **Product Browsing** | List and grid layout toggle with smooth transitions |
| :gear: **Advanced Filtering** | Filter by material, finish, and band type using Decorator + Strategy patterns |
| :watch: **Product Details** | Case size, wrist size, and connectivity selectors |
| :shopping_cart: **Shopping Cart** | Quantity management with 19% GST tax calculation |
| :credit_card: **Apple Pay** | Full PassKit integration with billing contact support |
| :heart: **Favorites** | Wishlist functionality for saved products |
| :star: **Reviews** | Product reviews with star ratings |
| :bulb: **Onboarding Tips** | Guided user experience with TipKit |
| :globe_with_meridians: **11 Languages** | en, de, es, fr, ja, zh-Hans, pt-BR, ru, hi, bn, ar |
| :iphone: **Dynamic Type** | Full accessibility with ScaledFont and UIFontMetrics |

---

## Architecture

The app follows **MVVM with Observable State Management**, organized into four distinct layers.

```mermaid
flowchart TD
    subgraph View["View Layer — 28 SwiftUI Views"]
        direction LR
        V1["ProductListView"]
        V2["ProductDetailView"]
        V3["CartView"]
        V4["FavoritesView"]
        V5["ReviewsView"]
    end

    subgraph State["State Layer — @Observable Classes"]
        direction LR
        S1["DataManager"]
        S2["ProductsFilter"]
        S3["ProductDetail"]
        S4["ShoppingCart"]
    end

    subgraph Service["Service Layer — Protocol-Based"]
        direction LR
        SV1["ProductServiceable"]
        SV2["HttpClient Protocol"]
        SV3["async/await + Result"]
    end

    subgraph Data["Data Layer — SwiftData Models"]
        direction LR
        D1["Product"]
        D2["Review"]
        D3["CaseSize"]
        D4["WristSize"]
        D5["ProductFilter"]
    end

    subgraph API["Remote API"]
        direction LR
        A1["GET /products"]
        A2["GET /product-filters"]
    end

    View -->|"@Environment injection"| State
    View -->|"@Query"| Data
    State -->|"calls"| Service
    Service -->|"URLSession async/await"| API
    Service -->|"JSON decode"| State
    State -->|"initializeData()"| Data

    style View fill:#1a73e8,color:#fff
    style State fill:#e8710a,color:#fff
    style Service fill:#0d904f,color:#fff
    style Data fill:#9334e6,color:#fff
    style API fill:#555,color:#fff
```

### Data Flow

```
API  →  HttpClient.request()  →  Service  →  DataManager.initializeData()
  →  Map Codable structs to @Model  →  ModelContainer  →  @Query in Views
```

`@Observable` instances are passed into the SwiftUI environment via `@Environment`, providing reactive state management without Combine boilerplate.

---

## Design Patterns

### Decorator + Strategy Pattern Implementation

```mermaid
classDiagram
    class ProductFilterStrategy {
        <<protocol>>
        +filter(products: [Product], specs: [ProductSpecs]) [Product]
    }

    class MaterialFilter {
        +filter(products: [Product], specs: [ProductSpecs]) [Product]
    }

    class FinishFilter {
        +filter(products: [Product], specs: [ProductSpecs]) [Product]
    }

    class BandFilter {
        +filter(products: [Product], specs: [ProductSpecs]) [Product]
    }

    ProductFilterStrategy <|.. MaterialFilter
    ProductFilterStrategy <|.. FinishFilter
    ProductFilterStrategy <|.. BandFilter

    class ProductFilterDecorator {
        <<abstract>>
        -wrapped: ProductFilterDecorator?
        +apply(products: [Product], specs: [ProductSpecs]) [Product]
    }

    class BaseDecorator {
        +apply(products: [Product], specs: [ProductSpecs]) [Product]
    }

    class MaterialDecorator {
        -strategy: MaterialFilter
        +apply(products: [Product], specs: [ProductSpecs]) [Product]
    }

    class FinishDecorator {
        -strategy: FinishFilter
        +apply(products: [Product], specs: [ProductSpecs]) [Product]
    }

    class BandDecorator {
        -strategy: BandFilter
        +apply(products: [Product], specs: [ProductSpecs]) [Product]
    }

    ProductFilterDecorator <|-- BaseDecorator
    ProductFilterDecorator <|-- MaterialDecorator
    ProductFilterDecorator <|-- FinishDecorator
    ProductFilterDecorator <|-- BandDecorator

    MaterialDecorator --> MaterialFilter : uses
    FinishDecorator --> FinishFilter : uses
    BandDecorator --> BandFilter : uses

    class ProductSpecs {
        <<enum>>
        +material
        +finish
        +bandType
    }
```

### All Patterns at a Glance

| Pattern | Where | Purpose |
|---------|-------|---------|
| **Decorator** | `ProductFilterDecorator` chain | Composable filter pipeline: Band -> Finish -> Material -> Base |
| **Strategy** | `ProductFilterStrategy` protocol | Interchangeable filtering algorithms per category |
| **Protocol-Based Services** | `ProductServiceable` | Decoupled service layer, testable via protocol conformance |
| **Enum-Driven Architecture** | `ProductSpecs` | Type-safe filter specifications with exhaustive switching |
| **Observable State** | `@Observable` + `@Environment` | Reactive state injection without Combine |
| **Endpoint Enum** | API endpoint definitions | Type-safe URL construction and request configuration |

---

## Class Diagram — SwiftData Models

```mermaid
classDiagram
    class Product {
        +String name
        +String description
        +String image
        +String category
        +caseSizes: [CaseSize]
        +wristSizes: [WristSize]
        +reviews: [Review]
    }

    class CaseSize {
        +String size
        +Double price
        +Int amount
        +Int order
    }

    class WristSize {
        +String size
        +Int order
    }

    class Review {
        +String title
        +String summary
        +Int rating
        +String name
        +Date creationDate
    }

    class ProductFilter {
        +String category
        +String title
        +String type
        +Bool isSelected
    }

    Product "1" --> "*" CaseSize : caseSizes\n(cascade delete)
    Product "1" --> "*" WristSize : wristSizes\n(cascade delete)
    Product "1" --> "*" Review : reviews\n(cascade delete)

    note for Product "@Model — root entity"
    note for ProductFilter "@Model — standalone filter state"
```

---

## Tech Stack

| Framework | Purpose |
|-----------|---------|
| **SwiftUI** | Declarative UI with list/grid layouts, navigation, sheets |
| **SwiftData** | Persistent storage with `@Model`, `@Query`, `ModelContainer` |
| **Observation** | `@Observable` macro for reactive state management |
| **PassKit** | Apple Pay integration with payment sheet and billing contact |
| **TipKit** | Contextual user onboarding tips |
| **URLSession** | Async/await networking with `data(for:)` |
| **Foundation** | JSON decoding, localization, date formatting |
| **Combine** | Supporting reactive patterns where needed |

---

## Highlights

### Modern SwiftUI
- Declarative views with `@Query` for SwiftData integration
- `@Environment` injection for observable state
- List/grid toggle with smooth layout transitions

### Modern Swift
- `@Observable` macro replacing `ObservableObject` / `@Published`
- `@Model` macro for SwiftData persistence
- Generic protocol extensions with default implementations

### Structured Concurrency
- `async/await` throughout the networking layer
- `Task` blocks for bridging sync and async contexts
- `@MainActor` for UI-bound state mutations
- `Result<T, RequestError>` for typed error handling

### Localization
- 11 languages: English, German, Spanish, French, Japanese, Simplified Chinese, Brazilian Portuguese, Russian, Hindi, Bengali, Arabic
- `Localizable.strings` in dedicated `.lproj` directories

### Apple Pay
- Full PassKit integration with `PKPaymentAuthorizationViewController`
- Billing contact collection
- Merchant ID configuration
- Secure payment data handling (no card data touches the app)

### SwiftData Persistence
- `@Model` entities with relationship cascading
- `ModelContainer` configuration at app entry point
- `@Query` macro for reactive fetching in views

### Design Patterns
- Decorator chain for composable product filtering
- Strategy protocol for swappable filter algorithms
- Protocol-based service layer for testability
- Enum-driven type safety across filter specifications

---

## Requirements

| Requirement | Version |
|-------------|---------|
| **iOS** | 17.5+ |
| **Xcode** | 15.4+ |
| **Swift** | 5.9+ |

---

## License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.

---

<p align="center">
  Built with SwiftUI and SwiftData
  <br>
  <strong>Zero dependencies. Pure Apple frameworks.</strong>
</p>
