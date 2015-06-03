//
//  MHTextField.h
//
//  Created by Mehfuz Hossain on 4/11/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTextField;

@protocol MHTextFieldDelegate <NSObject>

@optional
- (MHTextField*) textFieldAtIndex:(int)index;
- (int) numberOfTextFields;

-(void)editComplete;
@end

@interface MHTextField : UITextField<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *pickerV;
    BOOL gendersChangeFlag;
}
@property (nonatomic) BOOL required;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, setter = setDateField:) BOOL isDateField;
@property (nonatomic, setter = setEmailField:) BOOL isEmailField;
@property (nonatomic, setter = setGendersField:) BOOL isGendersField;
@property (nonatomic, setter = setCityField:) BOOL isCityField;

- (void) doneButtonIsClicked:(id)sender;
- (void)setup;
@property (nonatomic, assign) id<MHTextFieldDelegate> textFieldDelegate;

- (BOOL) validate;

@end
