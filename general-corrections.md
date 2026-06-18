# General Corrections & Recommendations

> Comprehensive audit of the AppleWatchStore codebase
> Generated: 2026-04-10

## Summary

| Severity | Count |
|----------|-------|
| Critical (crash / data loss) | 6 |
| High (correctness / UX) | 12 |
| Medium (quality / architecture) | 15 |
| Low (polish / nice-to-have) | 10 |
| Missing Considerations | 8 |

---

## Critical Issues

### C1. `preconditionFailure` in `ProductsFilter.remove(spec:)` -- app crash on filter deselect race

**File:** `Filter/ProductsFilter.swift`, line 40

```swift
func remove(spec: ProductSpecs) {
    guard let index = productFilterSpecs.firstIndex(where: { $0 == spec })
    else { preconditionFailure("Error") }
    productFilterSpecs.remove(at: index)
}
```

**Why:** `preconditionFailure` terminates the process in all builds (debug and release). If a user rapidly taps a filter toggle, or if `fetchSaved(filters:)` runs concurrently and clears the array, the spec may not be found and the app crashes.

**Fix:** Replace with a safe guard-return, or use `removeAll(where:)`:

```swift
func remove(spec: ProductSpecs) {
    productFilterSpecs.removeAll(where: { $0 == spec })
}
```

---

### C2. `preconditionFailure` in `ShoppingCart.update(product:)` and `decrement(product:)` -- crash in release builds

**File:** `Models/ShoppingCart.swift`, lines 50 and 60

Both methods call `preconditionFailure(...)` when a product is not found. These will crash the shipping app.

**Fix:** Replace with guard-return or handle gracefully. Also note the typo "Unable to fid product" (should be "find").

---

### C3. Division by zero in `Product.ratingAverage`

**File:** `Models/SwiftData/Product.swift`, lines 111-117

```swift
var ratingAverage: Float {
    let total = self.reviews.map { $0.rating }.reduce(0, +)
    return total / Float(self.reviews.count)
}
```

**Why:** When `reviews` is empty, `self.reviews.count` is 0, causing a division by zero that produces `Float.nan`. While the calling code in `ProductDetailDescriptionView` guards with `product.reviews.count > 0`, any future caller that forgets this check will display `NaN`.

**Fix:** Guard against empty reviews:

```swift
var ratingAverage: Float {
    guard !reviews.isEmpty else { return 0 }
    let total = reviews.map { $0.rating }.reduce(0, +)
    return total / Float(reviews.count)
}
```

---

### C4. `try! ModelContainer(...)` force-try in `DataManager` crashes if schema migration fails

**File:** `Networking/DataManager.swift`, line 22

```swift
let modelContainer = try! ModelContainer(for: Product.self, ProductFilter.self, Review.self)
```

**Why:** If the SwiftData schema changes between app versions and no migration plan is provided, `ModelContainer` initialization will throw, crashing the app on launch.

**Fix:** Use a do-catch and present a recovery path, or at minimum provide a `ModelConfiguration` with migration options.

---

### C5. `PaymentHandler.startPayment` loop creates multiple payment controllers

**File:** `Utilities/PaymentHandler.swift`, lines 46-84

```swift
func startPayment(products: [CartProduct], total: Int, completion: @escaping PaymentCompletionHandler) {
    ...
    products.forEach { product in
        let item = PKPaymentSummaryItem(...)
        paymentSummaryItems.append(item)
        
        let total = PKPaymentSummaryItem(...)
        paymentSummaryItems.append(total)
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        ...
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.present(...)
    }
}
```

**Why:** The `PKPaymentRequest` creation and `paymentController?.present(...)` are **inside** the `forEach` loop. This means:
1. A new `PKPaymentAuthorizationController` is created and presented for each cart product, overwriting the previous one.
2. `paymentSummaryItems` accumulates duplicates because it appends in every iteration without clearing.
3. A "Total" summary item is added inside the loop per product, but Apple Pay expects exactly one total item at the end.

**Fix:** Build the summary items array first, then create and present the payment controller once:

```swift
func startPayment(products: [CartProduct], total: Int, completion: @escaping PaymentCompletionHandler) {
    completionHandler = completion
    paymentSummaryItems = products.map {
        PKPaymentSummaryItem(label: $0.name, amount: NSDecimalNumber(string: "\($0.caseAmount)"), type: .final)
    }
    paymentSummaryItems.append(PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "\(total)"), type: .final))
    
    let paymentRequest = PKPaymentRequest()
    paymentRequest.paymentSummaryItems = paymentSummaryItems
    // ... rest of config ...
    paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
    paymentController?.present { ... }
}
```

---

### C6. Payment total truncates to Int, losing decimal precision

**File:** `Models/ShoppingCart.swift`, line 111

```swift
paymentHandler.startPayment(products: products, total: Int(total)) { ... }
```

**Why:** `total` is `Double` but is cast to `Int`, dropping any cents. A cart total of 399.99 becomes 399.

**File:** `Utilities/PaymentHandler.swift`, line 46 -- parameter is `total: Int`

**Fix:** Change the `total` parameter to `Double` (or `Decimal`) and format properly in the `NSDecimalNumber`.

---

## High Priority

### H1. `ProductDetailView.reset()` double-toggles `hasAddedToCart`

**File:** `Views/ProductDetail/ProductDetailView.swift`, lines 120-138

```swift
var addToCart: some View {
    Button(action: {
        cart.addCartProduct(...)
        productDetail.hasAddedToCart.toggle()  // sets to true
        reset()
    }) { ... }
}

func reset() {
    ...
    productDetail.hasAddedToCart.toggle()  // sets back to false
}
```

**Why:** `hasAddedToCart` is toggled to `true` then immediately toggled back to `false` in `reset()`. This means the flag is always `false` and any UI relying on it will never observe the "added" state.

**Fix:** Remove the duplicate toggle -- either set it explicitly (`= true`) before `reset()` or remove the toggle inside `reset()`.

---

### H2. `addCartProduct` allows adding with nil case/wrist size silently

**File:** `Models/ShoppingCart.swift`, lines 85-108

When `caseSize` or `wristSize` is nil, the entire `if let` block is skipped silently. The "Add To Cart" button in `ProductDetailView` does not check `productDetail.addToCartCheck()` before calling `addCartProduct`.

**Fix:** Either disable the button using `addToCartCheck()` or show user feedback when required selections are missing.

---

### H3. `HttpClient` missing `host` in URLComponents

**File:** `Networking/Base/HttpClient.swift`, lines 16-21

```swift
var urlComponents = URLComponents()
urlComponents.scheme = endpoint.schema
urlComponents.path = endpoint.path
urlComponents.port = endpoint.port
// host is never set!
```

**Why:** `urlComponents.host` is never assigned. The `EndPoint` protocol defines `host` returning `"127.0.0.1"`, but it is never used. The resulting URL will be malformed (e.g., `http:///products:3000` instead of `http://127.0.0.1:3000/products`).

**Fix:** Add `urlComponents.host = endpoint.host`.

---

### H4. `HttpClient` never applies `method`, `header`, or `body` from the endpoint

**File:** `Networking/Base/HttpClient.swift`, lines 24

```swift
let request = URLRequest(url: url)
```

**Why:** The `URLRequest` is created with only a URL. The `EndPoint` protocol defines `method`, `header`, and `body` properties, but none of them are applied to the request. Currently all requests are effectively GET with no headers.

**Fix:**

```swift
var request = URLRequest(url: url)
request.httpMethod = endpoint.method.rawValue
request.allHTTPHeaderFields = endpoint.header
// encode body if present
```

---

### H5. Network errors mapped to wrong `RequestError` cases

**File:** `Networking/Base/HttpClient.swift`, line 46

```swift
catch {
    return .failure(.invalidURL)
}
```

**Why:** Any network error (timeout, no connection, DNS failure) is reported as `.invalidURL`, which tells the user "The requested URL does not exist" -- completely misleading. The `.unknown` case exists but is never used.

**Fix:** Return `.unknown` or create a more appropriate error case for network failures.

---

### H6. `CaseSizeData.amount` uses `Float` with misleading default value

**File:** `Models/CaseSizeData.swift`, line 29-31

```swift
static var `default`: CaseSizeData {
    CaseSizeData(size: "65mm", ..., price: "279", amount: 2.79, order: 1)
}
```

**Why:** The `price` is "279" but the `amount` is 2.79. These represent the same value but are inconsistent by a factor of 100. If the API returns proper values this may only affect defaults/previews, but it's confusing and `Float` causes rounding errors for currency.

**Fix:** Use `Decimal` for monetary values and ensure `price` and `amount` are consistent.

---

### H7. `ProductDetail.selectedAppleCare` defaults to `.none` which visually selects "No Apple Care"

**File:** `Models/ProductDetail.swift`, line 32 and `Views/ProductDetail/SupportingViews/AppleCareView.swift`, line 39

The default `selectedAppleCare = .none` matches the `noAppleCare` button's condition (`== .none`), so "No Apple Care" appears pre-selected with a bold stroke. This is by design, but the enum `ProductAppleCzreType` has a typo ("Czre" instead of "Care").

---

### H8. `ProductDetailView.task` resets Tips datastore on every navigation

**File:** `Views/ProductDetail/ProductDetailView.swift`, lines 40-46

```swift
.task {
    try? Tips.resetDatastore()
    try? Tips.configure([...])
}
```

**Why:** Every time the user navigates to a product detail, the entire Tips datastore is reset and reconfigured. This destroys all tip dismissal history across the app, causing previously dismissed tips to reappear.

**Fix:** Move `Tips.configure()` to `AppleWatchStoreApp` (app-level, once). Remove `resetDatastore()` unless this is intentional for demo purposes only.

---

### H9. `CaseSize` equality comparison uses object identity by default

**File:** `Views/ProductDetail/SupportingViews/CaseSizesView.swift`, line 38

```swift
.stroke(productDetail.selectedCaseSize == size ? .baseStroke : .baseMediumGrey, ...)
```

**Why:** `CaseSize` is a `@Model` class. The `==` comparison uses SwiftData's default identity comparison (persistent model ID). Since `selectedCaseSize` is set from the same SwiftData context, this likely works, but if objects were from different contexts or re-created, it could fail silently.

---

### H10. `ShoppingCart.pay()` captures `self` strongly in closure -- potential retain cycle

**File:** `Models/ShoppingCart.swift`, lines 110-121

```swift
paymentHandler.startPayment(products: products, total: Int(total)) { success in
    if success {
        self.paymentSuccess = success
        self.products = []
    }
    ...
}
```

**Why:** `self` is captured strongly in the `@escaping` closure stored in `PaymentHandler.completionHandler`. Since `ShoppingCart` owns `paymentHandler` and `paymentHandler` stores a closure referencing `ShoppingCart`, this creates a retain cycle.

**Fix:** Use `[weak self]` in the closure.

---

### H11. `ShoppingCart` unused properties `quantity`, `cartTotal`, `productCount`

**File:** `Models/ShoppingCart.swift`, lines 15-17

```swift
var quantity: Int = 0
var cartTotal: Double = 0
var productCount: Int = 0
```

**Why:** `quantity` and `cartTotal` are never read anywhere. `productCount` is incremented in `addCartProduct` but never read or displayed. Meanwhile, `cartQuantity` (computed property) and `total` (computed property) are what the UI actually uses.

**Fix:** Remove unused properties to avoid confusion.

---

### H12. Loading overlay in `HomeView` uses hardcoded `.white` background

**File:** `Views/Home/HomeView.swift`, line 24

```swift
.background(.white)
```

**Why:** In dark mode, the loading overlay will be a white rectangle covering the content, which is visually jarring.

**Fix:** Use `Color(.systemBackground)` or `.background(.regularMaterial)`.

---

## Medium Priority

### M1. `import Combine` in files that don't use Combine

**Files:** `Filter/ProductsFilter.swift` (line 9), `Models/ShoppingCart.swift` (line 8)

Neither file uses any Combine types. These are dead imports.

---

### M2. Typo: `ProductAppleCzreType` should be `ProductAppleCareType`

**File:** `Models/ProductDetail.swift`, line 12

---

### M3. Typo: `fetchFilterDat()` should be `fetchFilterData()`

**File:** `Networking/DataManager.swift`, line 99

---

### M4. Typo: `selectedWristSSize` should be `selectedWristSize`

**File:** `Models/ProductDetail.swift`, line 30

---

### M5. Typo: "Ypur products" should be "Your products"

**File:** `Utilities/PaymentHandler.swift`, line 37

---

### M6. Typo: "Delovery" should be "Delivery"

**File:** `Utilities/PaymentHandler.swift`, line 35

---

### M7. Typo: "unable to get roduct r filter data" in debug print

**File:** `Networking/DataManager.swift`, line 47

---

### M8. Typo: "DADTABASE" in debug print

**File:** `Networking/DataManager.swift`, line 63

---

### M9. Typo: `casrtItem` should be `cartItem`

**File:** `Views/Home/Cart/CartView.swift`, line 51

---

### M10. Typo: `baseGraedientTop` should likely be `baseGradientTop`

**File:** `Utilities/Constants.swift`, line 13

---

### M11. `CaseSizeData` and `WristSizeData` generate new `UUID` on decode

**Files:** `Models/CaseSizeData.swift` (line 11), `Models/WristSizeData.swift` (line 11)

```swift
var id = UUID().uuidString
```

**Why:** When decoded from JSON, if the server does not provide an `id` field, a new UUID is generated. But if the server does provide `id`, the default initializer value is overwritten. The issue is that `CaseSizeData` is a `class` conforming to `Codable` with a mutable `id` default -- this is fragile. If the API does not send `id`, every decode creates a different ID for the same data, breaking any identity-based comparisons.

---

### M12. Filter decorator pattern creates new `Filter` and strategy objects on every call

**File:** `Filter/FilterDecorator.swift`

Each call to `filterProducts()` instantiates `ProductBaseFilter`, `ProductMaterialFilter`, `ProductFinishFilter`, `ProductBandFilter`, plus three `Filter` + strategy objects. For a list view that re-evaluates on scroll, this creates garbage collection pressure. The decorator pattern here adds complexity without clear benefit over a simple sequential filter pipeline.

---

### M13. `ProductFilterView.sections` duplicates on re-appearing

**File:** `Views/Home/Products/SupportingViews/ProductFilterView.swift`, lines 31-38

```swift
.task {
    filter.fetchSaved(filters: productFilters)
    categories.forEach { category in
        let filtersByCategry = productFilters.filter { $0.category == category }
        sections.append(filtersByCategry)
    }
}
```

**Why:** `.task` runs each time the view appears. If the user dismisses and re-opens the filter sheet, `sections` will append duplicate category groups (3, then 6, then 9...).

**Fix:** Clear `sections` before appending, or use `onAppear` with a guard, or compute `sections` as a derived property.

---

### M14. `CartView.authorizationChange` calls `cart.pay()` on every phase change

**File:** `Views/Home/Cart/CartView.swift`, lines 209-211

```swift
func authorizationChange(phase: PayWithApplePayButtonPaymentAuthorizationPhase) {
    cart.pay()
}
```

**Why:** `PayWithApplePayButtonPaymentAuthorizationPhase` has multiple phases. `cart.pay()` is called regardless of which phase triggered the callback, potentially initiating payment multiple times.

**Fix:** Check the phase before acting.

---

### M15. `CustomTabBarItem` reads `@Environment(\.colorScheme)` in `init()` -- always gets default value

**File:** `Utilities/Theme.swift`, lines 43-57

```swift
struct CustomTabBarItem: ViewModifier {
    @Environment(\.colorScheme) var colorsScheme
    
    init(with itemColor: UIColor?) {
        UITabBarItem.appearance().setBadgeTextAttributes([
            ...
            NSAttributedString.Key.foregroundColor : colorsScheme == .dark ? UIColor.white : UIColor.black
        ], for: .normal)
    }
```

**Why:** `@Environment` values are not available during `init()` of a `ViewModifier`. `colorsScheme` will always be its default value (`.light`), so the dark mode branch will never execute during initialization.

**Fix:** Move the appearance configuration into `body` or use `UITraitCollection.current`.

---

## Low Priority

### L1. `UIScreen.main.bounds` deprecated in iOS 16+

**File:** `Views/Home/SupportingViews/BrowseSection.swift`, line 20

```swift
.frame(width: UIScreen.main.bounds.width - 32)
```

**Fix:** Use `GeometryReader` or `containerRelativeFrame`.

---

### L2. `RequestError` has both `.decode` and `.decodable` cases

**File:** `Networking/Base/RequestError.swift`

Only `.decodable` is used in `HttpClient`. The `.decode` case is dead code.

---

### L3. Placeholder color circles in `GridProductItem`, `WideProductItem`, and `ProductDetailView`

Multiple views render hardcoded `Circle()` elements with `ForEach(0..<3)` or `ForEach(0..<4)` as color swatches, but they all render default black circles with no actual color data.

---

### L4. "Shop" buttons on `CardView` have empty action closures

**File:** `Views/Home/CardView.swift`, line 32-34

```swift
Button(action: { }) { Text("Shop") ... }
```

---

### L5. `FeaturedProduct.default` uses literal placeholder strings

**File:** `Models/FeaturedProduct.swift`, lines 17-21 -- "defaultProduct.image", "defaultProduct.series" are not real asset names.

---

### L6. `Product.init` discards the original API `id` and generates a new UUID

**File:** `Models/SwiftData/Product.swift`, line 41

```swift
self.id = UUID().uuidString
```

**Why:** The API provides an `id` field (e.g., "unique-identifier-solo-loop-band") but it is replaced with a random UUID. This breaks any server-side identity matching and means the `@Attribute(.unique)` constraint is on a random value rather than the server's canonical ID.

---

### L7. `CartProduct.displayPrice` uses `FloatingPointFormatStyle` with no locale or currency formatting

**File:** `Models/CartProduct.swift`, line 36

```swift
self.displayPrice = String(caseSize.amount.formatted(FloatingPointFormatStyle()))
```

**Why:** This produces locale-dependent decimal formatting without currency symbol. Combined with the hardcoded Euro sign in UI, it could show "2,79" or "2.79" depending on locale.

---

### L8. `ShoppingCart` conforms to `Identifiable` unnecessarily

**File:** `Models/ShoppingCart.swift`, line 13

There is only one shopping cart instance. The `Identifiable` conformance with `let id = UUID()` serves no purpose.

---

### L9. `ContentView` preview missing required environment objects

**File:** `App/ContentView.swift`, line 45-47

```swift
#Preview {
    ContentView()  // Missing .environment(ShoppingCart()) etc.
}
```

This preview will crash at runtime.

---

### L10. `CartProduct.caseAmount` uses `Float`, losing precision for currency

**File:** `Models/CartProduct.swift`, line 27 and throughout `ShoppingCart`

Currency calculations mix `Float` and `Double`. `Float` has only ~7 digits of precision, which is insufficient for financial calculations.

---

## Missing Considerations

### MC1. No error state UI for network failures

When `DataManager.initializeData()` fails to fetch data, the error is only printed to console. The user sees an empty app with no explanation or retry option.

### MC2. No offline / empty-data handling beyond ProgressView

If the local server is not running, the app silently fails and shows empty screens. There is no `ContentUnavailableView` or retry mechanism on any data-dependent screen except `CartView`.

### MC3. No input validation in `AddProductReview`

Users can submit reviews with empty title, name, or summary. The rating defaults to 3.0 but there is no minimum text requirement.

### MC4. Cart is in-memory only -- lost on app termination

`CartProduct` is not persisted. Users lose their cart when the app is killed. This is documented but worth noting as a UX gap.

### MC5. No accessibility labels on image-only elements

Watch face/band image composites, color circles, connectivity icons, and the heart favorite button lack accessibility labels. VoiceOver users will hear "image" or nothing.

### MC6. Hardcoded EUR currency and 19% GST tax

**Files:** `PaymentHandler.swift` (countryCode: "DE", currencyCode: "EUR"), `ShoppingCart.swift` (0.19 tax rate)

No configuration for different regions.

### MC7. No pagination or lazy loading for products

`@Query var products: [Product]` loads all products into memory. With a large product catalog, this could cause performance issues.

### MC8. `UserDefaults` key `"hasSetupDatabase"` is a plain string

Used in `DataManager` without a constant. If the key string is changed in one place but not the other, the database guard breaks silently.

---

## Recommendations by File

### `App/AppleWatchStoreApp.swift`
- Add `Tips.configure()` here instead of in `ProductDetailView` (see H8)
- Consider handling `ModelContainer` failure gracefully (see C4)

### `Networking/Base/HttpClient.swift`
- **BUG:** Add `urlComponents.host = endpoint.host` (see H3)
- Apply HTTP method, headers, body from endpoint (see H4)
- Map catch to `.unknown` not `.invalidURL` (see H5)

### `Networking/DataManager.swift`
- Replace `try!` with proper error handling (see C4)
- Fix typos in function name and debug prints (M3, M7, M8)
- Extract UserDefaults key to a constant (MC8)

### `Models/ShoppingCart.swift`
- Remove `preconditionFailure` calls (see C2)
- Fix retain cycle in `pay()` closure (see H10)
- Remove unused properties `quantity`, `cartTotal`, `productCount` (see H11)
- Change `total: Int` to `total: Double` in payment call (see C6)
- Remove dead `import Combine` (M1)

### `Utilities/PaymentHandler.swift`
- Move payment request creation outside the `forEach` loop (see C5)
- Fix typos: "Delovery", "Ypur products" (M5, M6)
- Accept `Double` for total parameter (see C6)

### `Filter/ProductsFilter.swift`
- Replace `preconditionFailure` with safe removal (see C1)
- Remove dead `import Combine` (M1)

### `Models/ProductDetail.swift`
- Fix typo: `ProductAppleCzreType` -> `ProductAppleCareType` (M2)
- Fix typo: `selectedWristSSize` -> `selectedWristSize` (M4)

### `Models/SwiftData/Product.swift`
- Guard against division by zero in `ratingAverage` (see C3)
- Consider preserving server-provided `id` (see L6)

### `Views/ProductDetail/ProductDetailView.swift`
- Fix double-toggle of `hasAddedToCart` (see H1)
- Guard cart addition with `addToCartCheck()` (see H2)
- Remove `Tips.resetDatastore()` call (see H8)

### `Views/Home/Products/SupportingViews/ProductFilterView.swift`
- Clear `sections` before re-populating in `.task` (see M13)

### `Views/Home/Cart/CartView.swift`
- Check payment phase before calling `cart.pay()` (see M14)
- Fix typo: `casrtItem` -> `cartItem` (M9)

### `Utilities/Theme.swift`
- Fix `CustomTabBarItem` environment read in init (see M15)

### `Utilities/Constants.swift`
- Fix typo: `baseGraedientTop` -> `baseGradientTop` (M10)

### `Views/Home/HomeView.swift`
- Use system background color instead of `.white` (see H12)
