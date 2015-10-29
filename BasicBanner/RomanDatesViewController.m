/*
     File: TextViewController.m
 Abstract: A simple view controller that manages a content view and an ADBannerView.
  Version: 1.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
 */

#import "RomanDatesViewController.h"
#import "BannerViewController.h"
#import "Converter.h"
#import "RomanNumsActivityItemProvider.h"

@interface RomanDatesViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end


#pragma mark -

@implementation RomanDatesViewController
{
}

- (instancetype)init
{
    self = [super initWithNibName:@"RomanDatesViewController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBeginBannerViewActionNotification:) name:BannerViewActionWillBegin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishBannerViewActionNotification:) name:BannerViewActionDidFinish object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self convertDateToRoman];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[self stopTimer];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#endif


- (void)willBeginBannerViewActionNotification:(NSNotification *)notification
{
//    [self stopTimer];
}

- (void)didFinishBannerViewActionNotification:(NSNotification *)notification
{
//    [self startTimer];
}

#pragma mark - Actions

- (void)convertDateToRoman
{
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[_datePicker date]];
    
    NSString *day = [NSString stringWithFormat:@"%ld", (long)[components day]];
    NSString *month = [NSString stringWithFormat:@"%ld", (long)[components month]];
    NSString *year = [NSString stringWithFormat:@"%ld", (long)[components year]];
    
    Converter *converter = [[Converter alloc] init];
    
    NSString *romanDay = [converter performSimpleConversionToRoman:day];
    NSString *romanMonth = [converter performSimpleConversionToRoman:month];
    NSString *romanYear = [converter performSimpleConversionToRoman:year];
    
    if ([locale isEqualToString:@"en_US"]) {
        [_dateLabel setText:[NSString stringWithFormat:@"%@\u200B·\u200B%@\u200B·\u200B%@", romanMonth, romanDay, romanYear]];
        [_dateLabel setAccessibilityLabel:[NSString stringWithFormat:@"%@ - %@ - %@", romanMonth, romanDay, romanYear]];
    } else {
        [_dateLabel setText:[NSString stringWithFormat:@"%@\u200B·\u200B%@\u200B·\u200B%@", romanDay, romanMonth, romanYear]];
        [_dateLabel setAccessibilityLabel:[NSString stringWithFormat:@"%@ - %@ - %@", romanDay, romanMonth, romanYear]];
    }
    
    NSMutableString* spacedResult = [_dateLabel.text mutableCopy];
    [spacedResult enumerateSubstringsInRange:NSMakeRange(0, [spacedResult length])
                                     options:NSStringEnumerationByComposedCharacterSequences | NSStringEnumerationSubstringNotRequired
                                  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                      if (substringRange.location > 0)
                                          [spacedResult insertString:@". " atIndex:substringRange.location];
                                  }];
    
    [_dateLabel setAccessibilityLabel:spacedResult];
    
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"Result: %@", spacedResult]);
}

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    [self convertDateToRoman];
}

- (IBAction)shareAction:(id)sender {
    // Show different text for each service, see http://www.albertopasca.it/whiletrue/2012/10/objective-c-custom-uiactivityviewcontroller-icons-text/
    RomanNumsActivityItemProvider *activityItemProvider = [[RomanNumsActivityItemProvider alloc] initWithPlaceholderItem:[_dateLabel text]];
    
    NSArray *itemsToShare = @[activityItemProvider];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    //activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
