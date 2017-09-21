//
//  NewReceiptView.m
//  Forologia
//
//  Created by Aggelos Papageorgiou on 10/8/12.
//  Copyright (c) 2012 Aggelos Papageorgiou. All rights reserved.
//

#import "NewReceiptView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MyTableList.h"
#import "TableList.h"

#import "MBProgressHUD.h"


@interface NewReceiptView ()


@property (retain,nonatomic) IBOutlet UITextField *CompanyField;
@property (weak, nonatomic) IBOutlet UITextField *VATField;
@property (retain,nonatomic) IBOutlet UIButton *dateBut;
@property (retain,nonatomic) IBOutlet UITextField *AmmountField;
@property   (retain,nonatomic) MyTableList* receiptToSave;

@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *saveButton;



@end



@implementation NewReceiptView

@synthesize CompanyField = _CompanyField;
@synthesize dateBut = _dateBut;
@synthesize AmmountField = _AmmountField;
@synthesize imageView = _imageView;
@synthesize saveButton = _saveButton;




-(MyTableList*)receiptToSave{
    if (!_receiptToSave) {
        _receiptToSave=[[MyTableList alloc]init];
        
    }
    return _receiptToSave;
}




UIDatePicker *datePicker;

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_AmmountField==textField) {
        static NSString *numbers = @"0123456789";
        static NSString *numbersPeriod = @"$01234567890.";
        static NSString *numbersComma = @"€0123456789,";
        
        //NSLog(@"%d %d %@", range.location, range.length, string);
        if (range.length > 0 && [string length] == 0) {
            if (range.location<1) {
                return NO;
                
            }
            
            // enable delete
            return YES;
        }
        
        NSString *symbol = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
        if (range.location == 0 && [string isEqualToString:symbol]) {
            // decimalseparator should not be first
            return NO;
        }
        NSCharacterSet *characterSet;
        NSRange separatorRange = [textField.text rangeOfString:symbol];
        if (separatorRange.location == NSNotFound) {
            if ([symbol isEqualToString:@"."]) {
                characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersPeriod] invertedSet];
            }
            else {
                characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersComma] invertedSet];
            }
        }
        else {
            // allow 2 characters after the decimal separator
            
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
        }
        return ([[string stringByTrimmingCharactersInSet:characterSet] length] > 0);
    }else{
        return YES;
    }
    return NO;
    
    
}

- (IBAction)keyboardToolbar:(UITextField*)sender {
    
    
        [self dismissDatePicker:self];
    
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+88, 320, 44)] ;
    toolBar.tag = 15;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboardToolBar:)] ;
    
    UISegmentedControl* nextPrev=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Previous", nil),NSLocalizedString(@"Next", nil), nil]];
    [nextPrev addTarget:self action:@selector(prevfield:) forControlEvents:UIControlEventValueChanged];
    [nextPrev setTag:[sender tag]];
    [nextPrev setSegmentedControlStyle:UISegmentedControlStyleBar];
    [nextPrev setTintColor:[UIColor blackColor]];
    UIBarButtonItem* segmentButton=[[UIBarButtonItem alloc]initWithCustomView:nextPrev];
    
    [toolBar setItems:[NSArray arrayWithObjects: segmentButton,spacer, doneButton, nil]];
    [doneButton setTag:200];
    UIScrollView *tempScrollView=(UIScrollView*)self.view;
    
    [sender setInputAccessoryView:toolBar ];
   
    tempScrollView.contentInset=UIEdgeInsetsMake(0, 0, 248, 0);
    
    tempScrollView.scrollIndicatorInsets=UIEdgeInsetsMake(0, 0, self.view.bounds.size.height-216+60, 0);
    if (sender.tag==6) {
        [tempScrollView setContentOffset:CGPointMake(tempScrollView.bounds.origin.x,sender.frame.origin.y-88) animated:YES];
        [nextPrev setEnabled:NO forSegmentAtIndex:1];
    }
    
    
}





- (void)removeViews:(id)object {

    [[self.view.superview viewWithTag:10] removeFromSuperview];
    [[self.view.superview viewWithTag:11] removeFromSuperview];
    
    

}


- (void)dismissKeyboardToolBar:(id)  sender {
    
    
   
 
    UIScrollView* tempscroll=(UIScrollView*)self.view;
   
    tempscroll.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    
    tempscroll.scrollIndicatorInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view endEditing:YES];
    
    

    
    
}


- (void)dismissDatePicker:(id)sender {
    
   
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.superview.bounds.size.height+88, self.view.bounds.size.width, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216+20);
    [UIView beginAnimations:@"MoveOut" context:nil];

    [self.navigationController.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.navigationController.view viewWithTag:11].frame = toolbarTargetFrame;
    [self.navigationController setToolbarHidden:NO animated:YES];

    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
    [[self.navigationController.view viewWithTag:10]removeFromSuperview];
    [[self.navigationController.view viewWithTag:11]removeFromSuperview];

    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    dateformat.dateStyle=NSDateFormatterShortStyle;
    [dateformat setDateFormat:@"dd.MM.yyyy"];

    [_dateBut setTitle:[dateformat stringFromDate:[datePicker date]] forState:UIControlStateNormal];
    UIScrollView* tempScrollView=(UIScrollView*)self.view;
    tempScrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    
    tempScrollView.scrollIndicatorInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    
}








-(void)prevfield:(UISegmentedControl*)selector{
    if (selector.selectedSegmentIndex==0) {
        
    
    NSInteger prevTag = [selector tag]- 1;
    // Try to find next responder
    UIResponder* nextResponder = [self.view.superview viewWithTag:prevTag];
    if (prevTag==4) {
        // Found next responder, so set it.
        [self dismissKeyboardToolBar:_AmmountField];
        [self callDP:_dateBut];
        [nextResponder becomeFirstResponder];
        
    }else if (prevTag==3){
        
        UIScrollView* temp=(UIScrollView*)self.view;
        
        [self dismissDatePicker:self];
        [temp setContentOffset:CGPointMake(0,0)animated:YES ];
        [nextResponder becomeFirstResponder];
    }else{
        UIScrollView* temp=(UIScrollView*)self.view;
        if (prevTag==2) {
            [temp setContentOffset:CGPointMake(0,0)animated:YES ];
        }else{
            [temp setContentOffset:CGPointMake(temp.bounds.origin.x, [temp viewWithTag:prevTag].frame.origin.y+44)animated:YES ];
        }
        
        [nextResponder becomeFirstResponder];
    }
   
    }else {
        NSInteger nextTag = [selector tag]+1;
        // Try to find next responder
        UIResponder* nextResponder = [self.view.superview viewWithTag:nextTag];
        if (nextTag==4) {
            // Found next responder, so set it.
            [self dismissKeyboardToolBar:_CompanyField];
            [self callDP:_dateBut];
           
          
            [nextResponder becomeFirstResponder];
            
        }
        else if (nextTag==2||nextTag==5||nextTag==6||nextTag==3){
            
            [self dismissDatePicker:self];
            UIScrollView* temp=(UIScrollView*)self.view;
            
            [temp setContentOffset:CGPointMake(temp.bounds.origin.x, [temp viewWithTag:nextTag].frame.origin.y-44)animated:YES ];

            [nextResponder becomeFirstResponder];
        }

        
    }



}






- (IBAction)callDP:(id)sender {
    
    [self.CompanyField resignFirstResponder];
    [self.AmmountField resignFirstResponder];
   
    
    CGRect toolbarTargetFrame = CGRectMake(0,self.view.superview.bounds.size.height-216+64, self.view.bounds.size.width, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216+44+64, self.view.bounds.size.width, 216);
    
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, self.view.bounds.size.width, 216)] ;
    datePicker.tag = 10;
       
    datePicker.datePickerMode=UIDatePickerModeDate;
    [datePicker becomeFirstResponder];
    NSDateFormatter* tempForSettingDateToDatePicker=[[NSDateFormatter alloc]init];
    [tempForSettingDateToDatePicker setDateFormat:@"dd.MM.yyyy"];
    [datePicker setDate:[ tempForSettingDateToDatePicker dateFromString:_dateBut.titleLabel.text]];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.superview.bounds.size.height+88, self.view.bounds.size.width, 44)] ;
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)] ;

    UISegmentedControl* nextPrev=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Previous", nil),NSLocalizedString(@"Next", nil), nil]];
    [nextPrev addTarget:self action:@selector(prevfield:) forControlEvents:UIControlEventValueChanged];
    [nextPrev setTag:[sender tag]];
    [nextPrev setSegmentedControlStyle:UISegmentedControlStyleBar];
    [nextPrev setTintColor:[UIColor clearColor]];
    [nextPrev setAlpha:0.6];
    UIBarButtonItem* segmentButton=[[UIBarButtonItem alloc]initWithCustomView:nextPrev];
    if (sender==_CompanyField) {
        [nextPrev setEnabled:NO forSegmentAtIndex:0];
    }
    
    [toolBar setItems:[NSArray arrayWithObjects: segmentButton,spacer, doneButton, nil]];

    UIScrollView *tempScrollView=(UIScrollView*)self.view;
    


    
    
    [tempScrollView setContentMode:UIViewContentModeBottomLeft ];
    
    tempScrollView.contentInset=UIEdgeInsetsMake(0, 0, 200+48, 0);
    
    tempScrollView.scrollIndicatorInsets=UIEdgeInsetsMake(0, 0, self.view.bounds.size.height-216+104, 0);
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController.view addSubview:datePicker];
    [self.navigationController.view addSubview:toolBar];
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    
   
    [UIView commitAnimations];
        
 
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.CompanyField) {
        [self dismissKeyboardToolBar:self];
        [textField resignFirstResponder];
        [self callDP:_dateBut];
        return NO;
                
    }
    
    return YES;

}





-(NSString*)saveImage:(UIImage*)image{
    
    NSString* path;
    if (image) {
     hud.progress+=0.05;
    NSDateFormatter* format=[[NSDateFormatter alloc]init];
        hud.progress+=0.05;
    [format setDateFormat:@"ddMMyyyy h:mm:ss"];
        hud.progress+=0.05;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
        hud.progress+=0.05;
    NSString *documentsDirectory = [paths objectAtIndex:0];
        hud.progress+=0.05;
    path= [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:[format stringFromDate:[NSDate date]]]];
    path=[path stringByAppendingString:@".png"];
        hud.progress+=0.05;
    
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];
        hud.progress+=0.05;
        }else{
        path=@"";
            hud.progress=0.88;
    }
    return path;

}

MBProgressHUD *hud;

- (IBAction)saveToDB:(id)sender {
    
    

    if (([_CompanyField.text isEqualToString:@""] || [_AmmountField.text isEqualToString:@""]) ) {
        
    } else{
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.animationType=MBProgressHUDAnimationFade;
        
        hud.labelText = @"Saving";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            hud.progress+=0.01;
            NSDateFormatter *newformat=[[NSDateFormatter alloc]init];
            hud.progress+=0.01;
            [newformat setDateFormat:@"dd.MM.yyyy" ];
            hud.progress+=0.01;
            NSDate* dateFromString=[newformat dateFromString:[_dateBut.titleLabel text]];
            hud.progress+=0.01;
            NSString* new=_CompanyField.text;
            double newdouble=[_AmmountField.text doubleValue];
            hud.progress+=0.01;
            NSString* imagePath=[self saveImage:_imageView.image];
            NSMutableString* temp=[[NSMutableString alloc]init];
            hud.progress+=0.01;
            [self.receiptToSave InsertRecords :new :dateFromString:newdouble :imagePath: [_VATField.text integerValue]];
            hud.progress+=0.01;
            [self.receiptToSave UpdateRecords:new :temp];
            hud.progress+=0.01;

            dispatch_async(dispatch_get_main_queue(), ^{
                [NSTimer scheduledTimerWithTimeInterval:2.0
                                                 target:self
                                               selector:@selector(hideHUD)
                                               userInfo:nil
                                                repeats:NO];
                
               
            });
        });
        
    }
   
}

-(void)hideHUD{
    
    
    hud.customView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode=MBProgressHUDModeCustomView;
    
    hud.labelText=@"Saved";
    [hud hide:YES afterDelay:2];
    

    
}

                   
                   
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackOpaque];
    [[UIApplication sharedApplication] sendAction:@selector(findAndResignFirstResponder) to:nil from:nil forEvent:nil];
    self.CompanyField.delegate = self;
    _AmmountField.delegate=self;
    [imageView init];
    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    
    [_saveButton setStyle:UIBarButtonItemStyleDone];
    [datePicker init];
    NSDateFormatter* nowDate=[[NSDateFormatter alloc]init];
    [nowDate setDateFormat:@"dd.MM.yyyy"];
    [_dateBut setTitle:[nowDate stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    NSFileManager* imagehandler=[NSFileManager defaultManager];
    NSError* err=[[NSError alloc]init];
    NSString* imagepath=[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"new.png"];
    NSString* imagetoPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    [imagetoPath stringByAppendingPathComponent:@"new.png"];
    
    [imagehandler copyItemAtPath:imagepath toPath:imagetoPath error:&err];
    UIImage* pattern=[[UIImage alloc]initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"new.png"]];
    [tempScrollView  setBackgroundColor:[UIColor colorWithPatternImage:pattern]];
        
    NSNumberFormatter* currencySymbol=[[NSNumberFormatter alloc]init];
    [currencySymbol setLocale:[NSLocale currentLocale]];

    [_AmmountField setText:[NSString stringWithFormat:@"%@",[currencySymbol currencySymbol]]];
    
    
   // Do any additional setup after loading the view.
}


//Image Picker initialization and use


-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
   
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        
        
        if (newMedia){
           //[_imageView initWithImage:image];
            [_imageView setImage:image];
        }
    }
     [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)useCamera:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController* imagePicker =
        [[UIImagePickerController alloc] init];
      imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        newMedia = YES;
    }
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    UIScrollView* tempView=(UIScrollView*)self.view;
    [tempView setContentSize: CGSizeMake(320,522) ];
    [super viewWillAppear:YES];
}






- (void)viewDidUnload
{
    [self setDateBut:nil];
    

    [self setDateBut:nil];
    [self setCompanyField:nil];
    [self setAmmountField:nil];

    

    [self setSaveButton:nil];
    [self setImageView:nil];
    [self setVATField:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




- (void)dealloc {
    
    
}
@end
