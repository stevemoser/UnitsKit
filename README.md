# UnitsKit

Note: UnitsKit is not under active development.

**Evaluates and Formats Units of Measurement**

`UnitsKit` is a based around the `SMQuantity` subclass which contains a value and a unit. A quantity can be constructed using a value wrapped in a `NSNumber` and a `NSString` the represents the name or symbol of a unit. Quantities can be combined by using an operator such as `add`,`subtract`,`multiply`, or `divide`.  Quantities can also be converted to other units. Finally Quantities can be formatted as an `NSString` by specifying how it should be displayed with options like names or symbols. 

## Demo

Build and run the `UnitsKit Example` project in Xcode to see an example of evaluating and formatting quantities.

---

### Example Usage

``` objective-c
SMQuantity *oneMeter = [[SMQuantity alloc] init];
[oneMeter setValue:@1];
[oneMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];

// Display in either symbols or names
[quantityFormatter stringFromQuantity:oneMeter] // 1 m
[quantityFormatter setDisplaysInTermsOfSymbols:NO];
[quantityFormatter stringFromQuantity:oneMeter]; //1 meter

// Add or multiply
[quantityEvaluator evaluateQuantity:oneMeter withQuantity: oneMeter usingOperator:@"add"]; // 2 m
[quantityEvaluator evaluateQuantity:oneMeter withQuantity: oneMeter usingOperator:@"multiply"]; // 1 m^2
```

---

## Contact

Steve Moser

- http://github.com/SteveMoser
- http://twitter.com/SteveMoser

## License

UnitsKit is available under the MIT license. See the LICENSE file for more info.
