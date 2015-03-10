//
//  Converter.m
//  Roman
//
//  Created by Rob on 25/10/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import "Converter.h"


@implementation Converter

@synthesize performConversionCheck, arabicResult, romanResult, calculatedRomanValue, calculatedArabicValue, romanCalculationValues, arabicCalculationValues, conversionResult;

- (id)init
{
	self = [super init];
	self.romanCalculationValues = [NSArray arrayWithObjects:
								   @"M", @"CM", @"D", @"CD", @"C", @"XC", @"L", @"XL", @"X", @"ⅠX", @"V", @"ⅠV", @"Ⅰ", nil];
    self.arabicCalculationValues = [NSArray arrayWithObjects:
                                    @"1000", @"900", @"500", @"400", @"100", @"90", @"50", @"40", @"10", @"9", @"5", @"4", @"1", nil];
	self.performConversionCheck = NO;
	self.conversionResult = Valid; // used if no conversion check
	return self;
}

- (NSString *)performSimpleConversionToRoman:(NSString *) arabic {
    int arabicLabelValue = [arabic intValue];
	
    NSArray *romanCharacterCalculationValues = [NSArray arrayWithObjects:
     @"M", @"CM", @"D", @"CD", @"C", @"XC", @"L", @"XL", @"X", @"IX", @"V", @"IV", @"I", nil];
    
    NSString *romanValue = nil;
	
	NSMutableString *resultString = [NSMutableString stringWithCapacity:128];
	
	int arrayCount = (int)[romanCalculationValues count];
	// We need to iterate through all of the roman values
	int i;
	for (i = 0; i < arrayCount; i++)
	{
		// Get the roman value at position i
		romanValue = [romanCharacterCalculationValues objectAtIndex:i];
		// along with the corresponding arabic value
		int arabicValue = [[arabicCalculationValues objectAtIndex:i] intValue];
		
		// Let's div and mod the arabic string
		int div = arabicLabelValue / arabicValue;
		//int mod = arabicLabelValue % arabicValue;
		
		//debugLog(@"Checking: %i", arabicValue);
		//debugLog(@"div: %i", div);
		//debugLog(@"mod: %i", mod);
		
		if (div > 0)
		{
			int j = 0;
			for (j = 0; j < div; j++)
			{
				//debugLog(@"Should add: %@ to string", romanValue);
				[resultString appendString: romanValue];
				arabicLabelValue = arabicLabelValue - arabicValue;
			}
			//debugLog(@"String is now: %@", resultString);
		}
	}
    
    NSString *result = [[NSString alloc] initWithFormat:@"%@", resultString];
	
    return result;
}

@end
