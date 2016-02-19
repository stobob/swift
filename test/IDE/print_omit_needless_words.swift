// RUN: rm -rf %t
// RUN: mkdir -p %t

// REQUIRES: objc_interop

// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk-nosource -I %t) -emit-module -o %t -enable-omit-needless-words -enable-strip-ns-prefix %S/../Inputs/clang-importer-sdk/swift-modules-without-ns/ObjectiveC.swift
// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk-nosource -I %t) -emit-module -o %t -enable-omit-needless-words -enable-strip-ns-prefix %S/../Inputs/clang-importer-sdk/swift-modules-without-ns/CoreGraphics.swift
// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk-nosource -I %t) -emit-module -o %t -enable-omit-needless-words  -enable-strip-ns-prefix %S/../Inputs/clang-importer-sdk/swift-modules-without-ns/Foundation.swift

// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk-nosource -I %t) -emit-module -o %t -enable-omit-needless-words  -enable-strip-ns-prefix %S/../Inputs/clang-importer-sdk/swift-modules-without-ns/AppKit.swift

// RUN: %target-swift-ide-test(mock-sdk: -sdk %S/../Inputs/clang-importer-sdk -I %t) -print-module -source-filename %s -module-to-print=ObjectiveC -function-definitions=false -prefer-type-repr=true -enable-omit-needless-words  -enable-strip-ns-prefix -enable-infer-default-arguments > %t.ObjectiveC.txt
// RUN: FileCheck %s -check-prefix=CHECK-OBJECTIVEC -strict-whitespace < %t.ObjectiveC.txt

// RUN: %target-swift-ide-test(mock-sdk: -sdk %S/../Inputs/clang-importer-sdk -I %t) -print-module -source-filename %s -module-to-print=Foundation -function-definitions=false -prefer-type-repr=true -enable-omit-needless-words  -enable-strip-ns-prefix -skip-parameter-names -enable-infer-default-arguments > %t.Foundation.txt
// RUN: FileCheck %s -check-prefix=CHECK-FOUNDATION -strict-whitespace < %t.Foundation.txt

// RUN: %target-swift-ide-test(mock-sdk: -sdk %S/../Inputs/clang-importer-sdk -I %t) -print-module -source-filename %s -module-to-print=AppKit -function-definitions=false -prefer-type-repr=true -enable-omit-needless-words  -enable-strip-ns-prefix -skip-parameter-names -enable-infer-default-arguments > %t.AppKit.txt
// RUN: FileCheck %s -check-prefix=CHECK-APPKIT -strict-whitespace < %t.AppKit.txt

// RUN: %target-swift-ide-test(mock-sdk: -sdk %S/../Inputs/clang-importer-sdk -I %t -I %S/../ClangModules/Inputs/custom-modules) -print-module -source-filename %s -module-to-print=CoreCooling -function-definitions=false -prefer-type-repr=true -enable-omit-needless-words  -enable-strip-ns-prefix -skip-parameter-names -enable-infer-default-arguments > %t.CoreCooling.txt
// RUN: FileCheck %s -check-prefix=CHECK-CORECOOLING -strict-whitespace < %t.CoreCooling.txt

// RUN: %target-swift-ide-test(mock-sdk: -sdk %S/../Inputs/clang-importer-sdk -I %t -I %S/Inputs/custom-modules) -print-module -source-filename %s -module-to-print=OmitNeedlessWords -function-definitions=false -prefer-type-repr=true -enable-omit-needless-words  -enable-strip-ns-prefix -skip-parameter-names -enable-infer-default-arguments > %t.OmitNeedlessWords.txt 2> %t.OmitNeedlessWords.diagnostics.txt
// RUN: FileCheck %s -check-prefix=CHECK-OMIT-NEEDLESS-WORDS -strict-whitespace < %t.OmitNeedlessWords.txt
// RUN: FileCheck %s -check-prefix=CHECK-OMIT-NEEDLESS-WORDS-DIAGS -strict-whitespace < %t.OmitNeedlessWords.diagnostics.txt


// RUN: %target-swift-ide-test(mock-sdk: -sdk %S/../Inputs/clang-importer-sdk -I %t) -print-module -source-filename %s -module-to-print=errors -function-definitions=false -prefer-type-repr=true -enable-omit-needless-words  -enable-strip-ns-prefix -skip-parameter-names -enable-infer-default-arguments > %t.errors.txt
// RUN: FileCheck %s -check-prefix=CHECK-ERRORS -strict-whitespace < %t.errors.txt

// Note: SEL -> "Selector"
// CHECK-FOUNDATION: func makeObjectsPerform(_: Selector)

// Note: "with" parameters.
// CHECK-FOUNDATION: func makeObjectsPerform(_: Selector, with: AnyObject?)
// CHECK-FOUNDATION: func makeObjectsPerform(_: Selector, with: AnyObject?, with: AnyObject?)

// Note: id -> "Object".
// CHECK-FOUNDATION: func indexOf(_: AnyObject) -> Int

// Note: Class -> "Class"
// CHECK-OBJECTIVEC: func isKindOf(aClass: AnyClass) -> Bool

// Note: Pointer-to-struct name matching; preposition splitting.
//
// CHECK-FOUNDATION: func copy(with _: Zone = nil) -> AnyObject!

// Note: Objective-C type parameter names.
// CHECK-FOUNDATION: func object(for _: Copying) -> AnyObject?
// CHECK-FOUNDATION: func removeObject(for _: Copying)

// Note: Don't drop the name of the first parameter in an initializer entirely.
// CHECK-FOUNDATION: init(array: [AnyObject])

// Note: struct name matching; don't drop "With".
// CHECK-FOUNDATION: class func withRange(_: NSRange) -> Value

// Note: built-in types.
// CHECK-FOUNDATION: func add(_: Double) -> Number

// Note: built-in types.
// CHECK-FOUNDATION: func add(_: Bool) -> Number

// Note: builtin-types.
// CHECK-FOUNDATION: func add(_: UInt16) -> Number

// Note: builtin-types.
// CHECK-FOUNDATION: func add(_: Int32) -> Number

// Note: Typedefs with a "_t" suffix".
// CHECK-FOUNDATION: func subtract(_: Int32) -> Number

// Note: Respect the getter name for BOOL properties.
// CHECK-FOUNDATION: var isMakingHoney: Bool

// Note: multi-word enum name matching; "with" splits the first piece.
// CHECK-FOUNDATION: func someMethod(_: DeprecatedOptions = [])

// Note: class name matching; don't drop "With".
// CHECK-FOUNDATION: class func withString(_: String!) -> Self!

// Note: lowercasing enum constants.
// CHECK-FOUNDATION: enum ByteCountFormatterCountStyle : Int {
// CHECK-FOUNDATION: case file
// CHECK-FOUNDATION-NEXT: case memory
// CHECK-FOUNDATION-NEXT: case decimal
// CHECK-FOUNDATION-NEXT: case binary

// Note: Make sure NSURL works in various places
// CHECK-FOUNDATION: open(_: URL!, completionHandler: ((Bool) -> Void)!)

// Note: property name stripping property type.
// CHECK-FOUNDATION: var uppercase: String

// Note: don't map base name down to a keyword.
// CHECK-FOUNDATION: func doSelector(_: Selector)

// Note: Strip names preceded by a gerund.
// CHECK-FOUNDATION: func startSquashing(_: Bee)
// CHECK-FOUNDATION: func startSoothing(_: Bee)
// CHECK-FOUNDATION: func startShopping(_: Bee)

// Note: Removing plural forms when working with collections
// CHECK-FOUNDATION: func add(_: [AnyObject])

// Note: Int and Index match.
// CHECK-FOUNDATION: func slice(from _: Int, to: Int) -> String

// Note: <context type>By<gerund> --> <gerund>.
// CHECK-FOUNDATION: func appending(_: String) -> String

// Note: <context type>By<gerund> --> <gerund>.
// CHECK-FOUNDATION: func withString(_: String) -> String

// Note: Noun phrase puts preposition inside.
// CHECK-FOUNDATION: func url(withAddedString _: String) -> URL?

// Note: CalendarUnits is not a set of "Options".
// CHECK-FOUNDATION: class func forCalendarUnits(_: CalendarUnit) -> String!

// Note: <property type>By<gerund> --> <gerund>.
// CHECK-FOUNDATION: var deletingLastPathComponent: URL? { get }

// Note: <property type><preposition> --> <preposition>.
// CHECK-FOUNDATION: var withHTTPS: URL { get }

// Note: lowercasing option set values
// CHECK-FOUNDATION: struct EnumerationOptions
// CHECK-FOUNDATION: static var concurrent: EnumerationOptions
// CHECK-FOUNDATION: static var reverse: EnumerationOptions

// Note: usingBlock -> body
// CHECK-FOUNDATION: func enumerateObjects(_: ((AnyObject!, Int, UnsafeMutablePointer<ObjCBool>) -> Void)!)
// CHECK-FOUNDATION: func enumerateObjects(_: EnumerationOptions = [], using: ((AnyObject!, Int, UnsafeMutablePointer<ObjCBool>) -> Void)!)

// Note: WithBlock -> body, nullable closures default to nil.
// CHECK-FOUNDATION: func enumerateObjectsRandomly(_: ((AnyObject!, Int, UnsafeMutablePointer<ObjCBool>) -> Void)? = nil)

// Note: id<Proto> treated as "Proto".
// CHECK-FOUNDATION: func doSomething(_: Copying)

// Note: NSObject<Proto> treated as "Proto".
// CHECK-FOUNDATION: func doSomethingElse(_: protocol<Copying, ObjectProtocol>)

// Note: Function type -> "Function".
// CHECK-FOUNDATION: func sort(_: @convention(c) (AnyObject, AnyObject) -> Int)

// Note: Plural: NSArray without type arguments -> "Objects".
// CHECK-FOUNDATION: func remove(_: [AnyObject])

// Note: Skipping "Type" suffix.
// CHECK-FOUNDATION: func doSomething(_: UnderlyingType)

// Don't introduce default arguments for lone parameters to setters.
// CHECK-FOUNDATION: func setDefaultEnumerationOptions(_: EnumerationOptions)

// CHECK-FOUNDATION: func normalizingXMLPreservingComments(_: Bool)

// Collection element types.
// CHECK-FOUNDATION: func adding(_: AnyObject) -> Set<Object>

// Boolean properties follow the getter.
// CHECK-FOUNDATION: var empty: Bool { get }
// CHECK-FOUNDATION: func nonEmpty() -> Bool
// CHECK-FOUNDATION: var isStringSet: Bool { get }
// CHECK-FOUNDATION: var wantsAUnion: Bool { get }
// CHECK-FOUNDATION: var watchesItsLanguage: Bool { get }
// CHECK-FOUNDATION: var appliesForAJob: Bool { get }
// CHECK-FOUNDATION: var setShouldBeInfinite: Bool { get }

// "UTF8" initialisms.
// CHECK-FOUNDATION: init?(utf8String: UnsafePointer<Int8>)

// Lowercasing after prefix stripping.
// CHECK-FOUNDATION: let globalConstant: String
// CHECK-FOUNDATION: func globalFunction()

// Cannot strip because we end up with something that isn't an identifier
// CHECK-FOUNDATION: func NS123()

// Strip prefix, but don't lowercase ALL_CAPS.
// CHECK-FOUNDATION: func YELLING()

// Strip prefix along with '_', but don't lowercase ALL_CAPS.
// CHECK-FOUNDATION: func SCREAMING()

// Don't leave just a '_'.
// CHECK-FOUNDATION: func NS_()

// Lowercasing initialisms.
// CHECK-FOUNDATION: let httpRequestKey: String

// Lowercasing initialisms with plurals.
// CHECK-FOUNDATION: var urlsInText: [URL] { get }

// Prefix stripping for macro names.
// CHECK-FOUNDATION: var timeIntervalSince1970: Double { get }
// CHECK-FOUNDATION: var DO_SOMETHING: Int

// Note: class method name stripping context type.
// CHECK-APPKIT: class func red() -> NSColor

// Note: instance method name stripping context type.
// CHECK-APPKIT: func same() -> Self

// Note: Unsafe(Mutable)Pointers don't get defaulted to 'nil'
// CHECK-APPKIT: func getRGBAComponents(_: UnsafeMutablePointer<Int8>)

// Note: Skipping over "3D"
// CHECK-APPKIT: func drawInAir(at _: Point3D)

// Note: with<something> -> <something>
// CHECK-APPKIT: func draw(at _: Point3D, withAttributes: [String : AnyObject]? = [:])

// Note: Don't strip names that aren't preceded by a verb or preposition.
// CHECK-APPKIT: func setTextColor(_: NSColor?)

// Note: Splitting with default arguments.
// CHECK-APPKIT: func draw(in _: NSView?)

// Note: NSDictionary default arguments for "options"
// CHECK-APPKIT: func drawAnywhere(in _: NSView?, options: [Object : AnyObject] = [:])
// CHECK-APPKIT: func drawAnywhere(options _: [Object : AnyObject] = [:])

// Note: no lowercasing of initialisms when there might be a prefix.
// CHECK-CORECOOLING: func CFBottom() ->

// Note: "Ref" variants are unavailable.
// CHECK-CORECOOLING: @available(*, unavailable, renamed="CCPowerSupply", message="Not available in Swift")
// CHECK-CORECOOLING-NEXT: typealias CCPowerSupplyRef = CCPowerSupply

// Note: Skipping over "Ref"
// CHECK-CORECOOLING: func replace(_: CCPowerSupply!)

// Make sure we're removing redundant context type info at both the
// beginning and the end.
// CHECK-APPKIT: func reversing() -> NSBezierPath

// Make sure we're dealing with 'instancetype' properly.
// CHECK-APPKIT: func inventing() -> Self

// Make sure we're removing redundant context type info at both the
// beginning and the end of a property.
// CHECK-APPKIT: var flattening: NSBezierPath { get }

// CHECK-APPKIT: func dismiss(animated _: Bool)

// CHECK-APPKIT: func shouldCollapseAutoExpandedItems(forDeposited _: Bool) -> Bool

// Introducing argument labels and pruning the base name.
// CHECK-APPKIT: func rectForCancelButton(whenCentered _: Bool)

// CHECK-APPKIT: func openUntitledDocumentAndDisplay(_: Bool)

// Don't strip due to weak type information.
// CHECK-APPKIT: func setContentHuggingPriority(_: NSLayoutPriority)

// Look through typedefs of pointers.
// CHECK-APPKIT: func layout(at _: NSPointPointer)

// The presence of a property prevents us from stripping redundant
// type information from the base name.
// CHECK-APPKIT: func addGestureRecognizer(_: NSGestureRecognizer)
// CHECK-APPKIT: func removeGestureRecognizer(_: NSGestureRecognizer)
// CHECK-APPKIT: func favoriteView(for _: NSGestureRecognizer) -> NSView?
// CHECK-APPKIT: func addLayoutConstraints(_: Set<NSLayoutConstraint>)
// CHECK-APPKIT: func add(_: Rect)
// CHECK-APPKIT: class func conjureRect(_: Rect)

// CHECK-OMIT-NEEDLESS-WORDS: func jump(to _: URL)
// CHECK-OMIT-NEEDLESS-WORDS: func objectIs(compatibleWith _: AnyObject) -> Bool
// CHECK-OMIT-NEEDLESS-WORDS: func insetBy(x _: Int, y: Int)
// CHECK-OMIT-NEEDLESS-WORDS: func setIndirectlyToValue(_: AnyObject)
// CHECK-OMIT-NEEDLESS-WORDS: func jumpToTop(_: AnyObject)
// CHECK-OMIT-NEEDLESS-WORDS: func removeWithNoRemorse(_: AnyObject)
// CHECK-OMIT-NEEDLESS-WORDS: func bookmark(with _: [URL])
// CHECK-OMIT-NEEDLESS-WORDS: func save(to _: URL, forSaveOperation: Int)
// CHECK-OMIT-NEEDLESS-WORDS: func index(withItemNamed _: String)
// CHECK-OMIT-NEEDLESS-WORDS: func methodAndReturnError(_: AutoreleasingUnsafeMutablePointer<Error?>)

// "Of" associates left.
// CHECK-OMIT-NEEDLESS-WORDS: func typeOf(_: String)
// CHECK-OMIT-NEEDLESS-WORDS: func typeOf(namedString _: String)

// ... except for some properties of the result.
// CHECK-OMIT-NEEDLESS-WORDS: func type(ofTypeNamed _: String)

// Look for preposition prior to "of".
// CHECK-OMIT-NEEDLESS-WORDS: func append(contentsOf _: String)

// Leave subscripts alone
// CHECK-OMIT-NEEDLESS-WORDS: subscript(_: UInt) -> AnyObject { get }
// CHECK-OMIT-NEEDLESS-WORDS: func objectAtIndexedSubscript(_: UInt) -> AnyObject

// CHECK-OMIT-NEEDLESS-WORDS: func exportPresets(bestMatching _: String)
// CHECK-OMIT-NEEDLESS-WORDS: func isCompatibleWith(_: String)

// CHECK-OMIT-NEEDLESS-WORDS: func add(_: AnyObject)

// CHECK-OMIT-NEEDLESS-WORDS: func slobbering(_: String) -> OmitNeedlessWords

// Elements of C array types
// CHECK-OMIT-NEEDLESS-WORDS: func drawPolygon(_: UnsafePointer<Point>, count: Int)

// Typedef ending in "Array".
// CHECK-OMIT-NEEDLESS-WORDS: func drawFilledPolygon(_: PointArray, count: Int)

// Non-parameterized Objective-C class ending in "Array".
// CHECK-OMIT-NEEDLESS-WORDS: func draw(_: SEGreebieArray)

// Protocols as contexts
// CHECK-OMIT-NEEDLESS-WORDS: protocol OMWLanding {
// CHECK-OMIT-NEEDLESS-WORDS-NEXT: func flip()

// Verify that we get the Swift name from the original declaration.
// CHECK-OMIT-NEEDLESS-WORDS: protocol OMWWiggle
// CHECK-OMIT-NEEDLESS-WORDS-NEXT: func joinSub()
// CHECK-OMIT-NEEDLESS-WORDS-NEXT: func wiggle1()
// CHECK-OMIT-NEEDLESS-WORDS-NEXT: var wiggleProp1: Int { get }

// CHECK-OMIT-NEEDLESS-WORDS: protocol OMWWaggle
// CHECK-OMIT-NEEDLESS-WORDS-NEXT: func waggle1()
// CHECK-OMIT-NEEDLESS-WORDS-NEXT: var waggleProp1: Int { get }

// CHECK-OMIT-NEEDLESS-WORDS: class OMWSuper
// CHECK-OMIT-NEEDLESS-WORDS-NEXT: func jump()
// CHECK-OMIT-NEEDLESS-WORDS-NEXT: var wiggleProp1: Int { get }

// CHECK-OMIT-NEEDLESS-WORDS: class OMWSub
// CHECK-OMIT-NEEDLESS-WORDS-NEXT: func jump()
// CHECK-OMIT-NEEDLESS-WORDS-NEXT: func joinSub()

// CHECK-OMIT-NEEDLESS-WORDS-DIAGS: inconsistent Swift name for Objective-C method 'conflicting1' in 'OMWSub' ('waggle1()' in 'OMWWaggle' vs. 'wiggle1()' in 'OMWWiggle')
// CHECK-OMIT-NEEDLESS-WORDS-DIAGS: inconsistent Swift name for Objective-C property 'conflictingProp1' in 'OMWSub' ('waggleProp1' in 'OMWWaggle' vs. 'wiggleProp1' in 'OMWSuper')

// Don't drop the 'error'.
// CHECK-ERRORS: func tryAndReturnError(_: ()) throws
