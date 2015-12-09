//
//  SurveyViewController.m
//  FieldTripOpen
//
//  Created by Colin Gormley on 04/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import "SurveyViewController.h"
#import "SurveyFactory.h"


@interface SurveyViewController ()

@property (strong, nonatomic) Survey *survey;

@end

@implementation SurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)awakeFromNib{
    [self initialise];
}

- (void)initialise {
    // Get survey json from loopback API and store in CouchDB
    NSURL *url = [NSURL URLWithString:@"https://rawgit.com/rgamez/accb2404e7f5ebad105c/raw/a78781321400feeeeabb5f57098622dd908059ea/survey-proposal-arrrays-everywhere.json"];
    SurveyFactory *sf = [[SurveyFactory alloc ]init];
    [sf createSurveyFromUrl:url withCompletion:^(Survey *survey) {
        self.survey = survey;
        
        // Render XLForm
        self.form = [self.survey form];
        NSLog(@"Survey object created.");
    }];
}

#pragma mark - XLForms
- (void)initializeForm{
    
   /* NSString *const kSwitchBool = @"switchBool";
    NSString *const kSwitchCheck = @"switchCheck";
    NSString *const kStepCounter = @"stepCounter";
    NSString *const kSlider = @"slider";
    NSString *const kSegmentedControl = @"segmentedControl";
    NSString *const kCustom = @"custom";
    NSString *const kInfo = @"info";
    NSString *const kButton = @"button";
    NSString *const kImage = @"image";
    NSString *const kButtonLeftAligned = @"buttonLeftAligned";
    NSString *const kButtonWithSegueId = @"buttonWithSegueId";
    NSString *const kButtonWithSegueClass = @"buttonWithSegueClass";
    NSString *const kButtonWithNibName = @"buttonWithNibName";
    NSString *const kButtonWithStoryboardId = @"buttonWithStoryboardId";
    
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"Other Cells"];
    XLFormSectionDescriptor * section;
    
    // Basic Information
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Other Cells"];
    section.footerTitle = @"OthersFormViewController.h";
    [form addFormSection:section];
    
    // Switch
    [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:kSwitchBool rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Switch"]];
    
    // check
    [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:kSwitchCheck rowType:XLFormRowDescriptorTypeBooleanCheck title:@"Check"]];
    
    // step counter
    XLFormRowDescriptor * row = [XLFormRowDescriptor formRowDescriptorWithTag:kStepCounter rowType:XLFormRowDescriptorTypeStepCounter title:@"Step counter"];
    row.value = @50;
    [row.cellConfigAtConfigure setObject:@YES forKey:@"stepControl.wraps"];
    [row.cellConfigAtConfigure setObject:@10 forKey:@"stepControl.stepValue"];
    [row.cellConfigAtConfigure setObject:@10 forKey:@"stepControl.minimumValue"];
    [row.cellConfigAtConfigure setObject:@100 forKey:@"stepControl.maximumValue"];
    [section addFormRow:row];
    
    // Segmented Control
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSegmentedControl rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"Fruits"];
    row.selectorOptions = @[@"Apple", @"Orange", @"Pear"];
    row.value = @"Pear";
    [section addFormRow:row];
    
    
    // Slider
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSlider rowType:XLFormRowDescriptorTypeSlider title:@"Slider"];
    row.value = @(30);
    [row.cellConfigAtConfigure setObject:@(100) forKey:@"slider.maximumValue"];
    [row.cellConfigAtConfigure setObject:@(10) forKey:@"slider.minimumValue"];
    [row.cellConfigAtConfigure setObject:@(4) forKey:@"steps"];
    [section addFormRow:row];
    
    // Image
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kImage rowType:XLFormRowDescriptorTypeImage title:@"Image"];
    row.value = [UIImage imageNamed:@"default_avatar"];
    [section addFormRow:row];
    
    // Info cell
    XLFormRowDescriptor *infoRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kInfo rowType:XLFormRowDescriptorTypeInfo];
    infoRowDescriptor.title = @"Version";
    infoRowDescriptor.value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [section addFormRow:infoRowDescriptor];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Buttons"];
    section.footerTitle = @"Blue buttons will show a message when Switch is ON";
    [form addFormSection:section];
    
    // Button
    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:kButton rowType:XLFormRowDescriptorTypeButton title:@"Button"];
    buttonRow.action.formSelector = @selector(didTouchButton:);
    [section addFormRow:buttonRow];
    
    
    // Left Button
    XLFormRowDescriptor * buttonLeftAlignedRow = [XLFormRowDescriptor formRowDescriptorWithTag:kButtonLeftAligned rowType:XLFormRowDescriptorTypeButton title:@"Button with Block"];
    [buttonLeftAlignedRow.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
    [buttonLeftAlignedRow.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    
    __typeof(self) __weak weakSelf = self;
    buttonLeftAlignedRow.action.formBlock = ^(XLFormRowDescriptor * sender){
        if ([[sender.sectionDescriptor.formDescriptor formRowWithTag:kSwitchBool].value boolValue]){
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Switch is ON", nil)
                                                              message:@"Button has checked the switch value..."
                                                             delegate:weakSelf
                                                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                    otherButtonTitles:nil];
            [message show];
#else
            if ([UIAlertController class]) {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Switch is ON", nil)
                                                                                          message:@"Button has checked the switch value..."
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else{
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Switch is ON", nil)
                                                                  message:@"Button has checked the switch value..."
                                                                 delegate:weakSelf
                                                        cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                        otherButtonTitles:nil];
                [message show];
            }
#endif
        }
        [weakSelf deselectFormRow:sender];
    };
    [section addFormRow:buttonLeftAlignedRow];
    
    // Another Left Button with segue
//    XLFormRowDescriptor * buttonLeftAlignedWithSegueRow = [XLFormRowDescriptor formRowDescriptorWithTag:kButtonWithSegueClass rowType:XLFormRowDescriptorTypeButton title:@"Button with Segue Class"];
//    buttonLeftAlignedWithSegueRow.action.formSegueClass = NSClassFromString(@"UIStoryboardPushSegue");
//    buttonLeftAlignedWithSegueRow.action.viewControllerClass = [MapViewController class];
//    [section addFormRow:buttonLeftAlignedWithSegueRow];
    
    
    // Button with SegueId
    XLFormRowDescriptor * buttonWithSegueId = [XLFormRowDescriptor formRowDescriptorWithTag:kButtonWithSegueClass rowType:XLFormRowDescriptorTypeButton title:@"Button with Segue Idenfifier"];
    buttonWithSegueId.action.formSegueIdenfifier = @"MapViewControllerSegue";
    [section addFormRow:buttonWithSegueId];
    
    
    // Another Button using Segue
    XLFormRowDescriptor * buttonWithStoryboardId = [XLFormRowDescriptor formRowDescriptorWithTag:kButtonWithStoryboardId rowType:XLFormRowDescriptorTypeButton title:@"Button with StoryboardId"];
    buttonWithStoryboardId.action.viewControllerStoryboardId = @"MapViewController";
    [section addFormRow:buttonWithStoryboardId];
    
    // Another Left Button with segue
    XLFormRowDescriptor * buttonWithNibName = [XLFormRowDescriptor formRowDescriptorWithTag:kButtonWithNibName
                                                                                    rowType:XLFormRowDescriptorTypeButton
                                                                                      title:@"Button with NibName"];
    buttonWithNibName.action.viewControllerNibName = @"MapViewController";
    [section addFormRow:buttonWithNibName];
    
    */
    
    
    
    
    
    
    /*
    NSString *const kHobbies = @"hobbies";
    NSString *const kSport = @"sport";
    NSString *const kFilm = @"films1";
    NSString *const kFilm2 = @"films2";
    NSString *const kMusic = @"music";
    
    
    
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Blog Example: Hobbies"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Hobbies"];
    [form addFormSection:section];
    
    XLFormRowDescriptor* hobbyRow = [XLFormRowDescriptor formRowDescriptorWithTag:kHobbies
                                                                          rowType:XLFormRowDescriptorTypeMultipleSelector
                                                                            title:@"Select Hobbies"];
    hobbyRow.selectorOptions = @[@"Sport", @"Music", @"Films"];
    hobbyRow.value = @[];
    [section addFormRow:hobbyRow];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Some more questions"];
    section.hidden = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"$%@.value.@count == 0", hobbyRow]];
    section.footerTitle = @"BlogExampleViewController.m";
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSport
                                                rowType:XLFormRowDescriptorTypeTextView
                                                  title:@"Your favourite sportsman?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sport'", hobbyRow];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFilm
                                                rowType:XLFormRowDescriptorTypeTextView
                                                  title:@"Your favourite film?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@ contains 'Films'", hobbyRow];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFilm2
                                                rowType:XLFormRowDescriptorTypeTextView
                                                  title:@"Your favourite actor?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@ contains 'Films'", hobbyRow];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMusic
                                                rowType:XLFormRowDescriptorTypeTextView
                                                  title:@"Your favourite singer?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@ contains 'Music'", hobbyRow];
    [section addFormRow:row];
    
    */
    
    
    
    
    
    
    
    
    
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Survey"];
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Section 1"];
    
    [form addFormSection:section];
    
    // Title
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Title" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Title" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    // Location
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"location" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Location" forKey:@"textField.placeholder"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // All-day
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"all-day" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"All-day"];
    [section addFormRow:row];
    
    // Starts
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"starts" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Starts"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    [section addFormRow:row];
    
    // Ends
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ends" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Ends"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*25];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Repeat
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"repeat" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Repeat"];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Never"];
    row.selectorTitle = @"Repeat";
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Never"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Every Day"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Every Week"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"Every 2 Weeks"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"Every Month"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(5) displayText:@"Every Year"],
                            ];
    [section addFormRow:row];
    
    
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Alert
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"alert" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Alert"];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"None"];
    row.selectorTitle = @"Event Alert";
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"None"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"At time of event"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"5 minutes before"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"15 minutes before"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"30 minutes before"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(5) displayText:@"1 hour before"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(6) displayText:@"2 hours before"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(7) displayText:@"1 day before"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(8) displayText:@"2 days before"],
                            ];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Show As
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"showAs" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Show As"];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Busy"];
    row.selectorTitle = @"Show As";
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Busy"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Free"]];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // URL
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"url" rowType:XLFormRowDescriptorTypeURL];
    [row.cellConfigAtConfigure setObject:@"URL" forKey:@"textField.placeholder"];
    [section addFormRow:row];
    
    // Notes
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"notes" rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"Notes" forKey:@"textView.placeholder"];
    [section addFormRow:row];
    
    
    
    
    
    
    
    
    
   /* NSString *const kPred = @"pred";
    NSString *const kPredDep = @"preddep";
    NSString *const kPredDep2 = @"preddep2";
    
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    XLFormRowDescriptor * pred, *pred3, *pred4;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Predicates example"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Independent rows"];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPredDep rowType:XLFormRowDescriptorTypeAccount title:@"Text"];
    [row.cellConfigAtConfigure setObject:@"Type disable" forKey:@"textField.placeholder"];
    pred = row;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPredDep2 rowType:XLFormRowDescriptorTypeInteger title:@"Integer"];
    row.hidden = [NSString stringWithFormat:@"$switch==0"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"switch" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Boolean"];
    row.value = @1;
    pred3 = row;
    [section addFormRow:row];
    
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Dependent section"];
    section.footerTitle = @"Type disable in the textfield, a number between 18 and 60 in the integer field or use the switch to disable the last row. By doing all three the last section will hide.\nThe integer field hides when the boolean switch is set to 0.";
    [form addFormSection:section];
    
    // Predicate Disabling
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPred rowType:XLFormRowDescriptorTypeDateInline title:@"Disabled"];
    row.value = [NSDate new];
    [section addFormRow:row];
    
    row.disabled = [NSString stringWithFormat:@"$%@ contains[c] 'disable' OR ($%@.value between {18, 60}) OR ($%@.value == 0)", pred, kPredDep2, pred3];
    //[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"($%@.value contains[c] %%@) OR ($%@.value between {18, 60}) OR ($%@.value == 0)", pred, pred2, pred3],  @"disable"] ];
    pred4 = row;
    
    section.hidden = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"($%@.value contains[c] 'disable') AND ($%@.value between {18, 60}) AND ($%@.value == 0)", pred, kPredDep2, pred3]];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"More predicates..."];
    section.footerTitle = @"This row hides when the row of the previous section is disabled and the textfield in the first section contains \"out\"\n\nPredicateFormViewController.m";
    [form addFormSection:section];
    
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"thirds" rowType:XLFormRowDescriptorTypeAccount title:@"Account"];
    [section addFormRow:row];
    row.hidden = [NSString stringWithFormat:@"$%@.isDisabled == 1 AND $%@.value contains[c] 'Out'", pred4, pred];
    
    typeof(self) __weak weakself = self;
    row.onChangeBlock = ^(id oldValue, id newValue, XLFormRowDescriptor* __unused rowDescriptor){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Account Field changed" message:[NSString stringWithFormat:@"Old value: %@\nNew value: %@", oldValue, newValue ] preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
        [weakself.navigationController presentViewController:alert animated:YES completion:nil];
    };*/
    
    
    
      self.form = form;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
