//
//  SMQuantityViewController.m
//  UnitsKit Example
//
//  Created by Steve Moser on 7/13/13.
//  Copyright (c) 2013 Steve Moser (http://stevemoser.org)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "SMQuantityViewController.h"

#import "SMQuantity.h"
#import "SMDerivedUnit.h"
#import "SMQuantityFormatter.h"
#import "SMQuantityEvaluator.h"

@interface SMQuantityViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *symbolsOneTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *symbolsTwoTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *symbolsThreeTableViewCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *nameTableViewCell;
@end

@implementation SMQuantityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SMQuantityFormatter *quantityFormatter = [[SMQuantityFormatter alloc] init];
    SMQuantityEvaluator *quantityEvaluator = [SMQuantityEvaluator sharedQuantityEvaluator];
    
    SMQuantity *threeNewtons = [[SMQuantity alloc] init];
    SMDerivedUnit *newtons = [[SMDerivedUnit alloc] init];
    newtons.baseUnitsWithDimensionExponents = @{(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"meter"]:@(1),(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"second"]:@(-2),(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"kilogram"]:@1};
    [threeNewtons setUnit:newtons];
    [threeNewtons setValue:@3];
    
    [self.symbolsOneTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:threeNewtons]];
    
    [quantityFormatter setSymbolSeparator:SMSymbolSeparatorNonbreakingSpaceStyle];
    [quantityFormatter setUsesSuperscriptForExponentForSymbolsForDisplay:NO];
    
    [self.symbolsTwoTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:threeNewtons]];

    [quantityFormatter setSymbolSeparator:SMSymbolSeparatorSpaceStyle];
    [quantityFormatter setUsesSolidusForSymbolsForDisplay:NO];
    
    [self.symbolsThreeTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:threeNewtons]];

    [quantityFormatter setDisplaysInTermsOfSymbols:NO];
    [self.nameTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:threeNewtons]];

    
}

@end
