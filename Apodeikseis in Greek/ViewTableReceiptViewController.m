//
//  ViewTableReceiptViewController.m
//  Forologia
//
//  Created by Aggelos Papageorgiou on 1/9/12.
//  Copyright (c) 2012 Aggelos Papageorgiou. All rights reserved.
//

#import "ViewTableReceiptViewController.h"
#import "TableList.h"
#import "MyTableList.h"

@interface ViewTableReceiptViewController ()
@property (retain,nonatomic) IBOutlet UITextField *CompanyField;
@property (retain,nonatomic) IBOutlet UITextField *DateField;
@property (retain,nonatomic) IBOutlet UITextField *AmmountField;
@property (weak, nonatomic) IBOutlet UITextField *VATField;
@property (retain,nonatomic) IBOutlet UIImageView *imageView;
@property (retain,nonatomic) MyTableList* receipTable;
@property (weak, nonatomic) IBOutlet UITextField *CatField;


@end

@implementation ViewTableReceiptViewController
@synthesize CompanyField;
@synthesize DateField;
@synthesize AmmountField;
@synthesize imageView;
@synthesize indexselected;

-(MyTableList*)receipTable{
    
    if(!_receipTable){
        _receipTable=[[MyTableList alloc]init];
    }
    return _receipTable;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int index=[prefs integerForKey:@"tag"];
    NSMutableArray* currentReceipt=[self.receipTable getReceipt];
    [CompanyField setText:((TableList*)[currentReceipt objectAtIndex:index]).mainName];
    NSDate* Date=[[NSDate alloc] init];
    Date=((TableList*)[currentReceipt objectAtIndex:index]).mainDate ;
    [_VATField setText:[NSString stringWithFormat:@"%d",((TableList*)[currentReceipt objectAtIndex:index]).mainAfm]];
    NSDateFormatter* mainFormat=[[NSDateFormatter alloc]init];
    [mainFormat setDateFormat:@"dd-MM-yyyy"];
    [_CatField setText:((TableList*)[currentReceipt objectAtIndex:index]).mainCategory];
    [DateField setText:[mainFormat stringFromDate:Date]];
    [AmmountField setText:[NSString stringWithFormat:@"%.2lf",((TableList*)[currentReceipt objectAtIndex:index]).mainAmmount]];
    NSString* imagePath=((TableList*)[currentReceipt objectAtIndex:index] ).image;
    NSFileManager* imageManager=[[NSFileManager alloc]init];
    if ([imageManager fileExistsAtPath:imagePath]){
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:((TableList*)[currentReceipt objectAtIndex:index]).image];
        UIImage* receiptImage=[[UIImage alloc]initWithData:imageData];
    
        [imageView setImage:receiptImage];
    }
    UIScrollView* tempView=(UIScrollView*)  self.view;
    tempView.contentSize=CGSizeMake(320, 416);
    tempView.bounces=NO;
  
    
    
    
	// Do any additional setup after loading the view.
}


- (void)dismissKeyboardToolBar:(id)  sender {
    
    
    //[UIView beginAnimations:@"MoveOut" context:nil];
    
    UIScrollView* tempscroll=(UIScrollView*)self.view;
    
    tempscroll.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    
    tempscroll.scrollIndicatorInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    [CompanyField resignFirstResponder];
    [AmmountField resignFirstResponder];
    
    
    
    
    
}



- (IBAction)invokeDate:(id)sender {
    
    
    
    UIDatePicker* datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    UIToolbar* controlToolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height+88, 320, 44)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboardToolBar:)] ;
    
    UIBarButtonItem *nextbutton=[[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextfield:)];
    
    
    UIBarButtonItem *prevbutton=[[UIBarButtonItem alloc]initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(prevfield:)];
    [controlToolbar setItems:[NSArray arrayWithObjects: prevbutton,nextbutton,spacer, doneButton, nil]];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216+44, 320, 216);
    [UIView beginAnimations:@"MoveIn" context:nil];
 
    datePicker.frame = datePickerTargetFrame;
    
    
    
    [UIView commitAnimations];
}



- (void)viewDidUnload
{
    [self setCompanyField:nil];
    [self setDateField:nil];
    [self setAmmountField:nil];
    [self setImageView:nil];
    [self setVATField:nil];
    [self setCatField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
