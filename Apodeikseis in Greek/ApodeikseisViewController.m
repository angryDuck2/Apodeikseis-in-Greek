//
//  ForoiViewController.m
//  Forologia
//
//  Created by Aggelos Papageorgiou on 10/8/12.
//  Copyright (c) 2012 Aggelos Papageorgiou. All rights reserved.
//

#import "ApodeikseisViewController.h"
#import "MenuViewController.h"

@interface ForoiViewController ()
@property (nonatomic,retain) MenuViewController* menuView;
@end

@implementation ForoiViewController
@synthesize menuView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:YES];
    [self CopyDbToDocumentsFolder];
    menuView=[[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
    //[menuView.view setHidden:YES];
    [self.navigationController.view.superview addSubview:menuView.view];
    [self.navigationController.view.superview sendSubviewToBack:menuView.view];
    
    
    UISwipeGestureRecognizer* menuRecognize=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(invokeMenu:)];
    NSArray* gestures=[[NSArray alloc]initWithObjects:menuRecognize, nil];
    [self.navigationController.navigationBar setGestureRecognizers:gestures];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)invokeMenu:(id)sender {
        CGRect destination = self.navigationController.view.frame;
    
    if (destination.origin.x > 0) {
        destination.origin.x = 0;
        
        

    } else {
        destination.origin.x += 254.5;
               
    }
    
    
    if (![menuView.view isHidden]) {
        
        [self.navigationController.view.superview sendSubviewToBack:[menuView view]];
        
        
    }else{
        
        [self.navigationController.view.superview bringSubviewToFront:[menuView view]];
    }

    
    [UIView animateWithDuration:0.25 animations:^{
        
        

        self.navigationController.view.frame = destination;
        
    } completion:^(BOOL finished) {
        
        self.view.userInteractionEnabled = !(destination.origin.x > 0);
        
        
    }];
    
        
    [menuView.view setFrame:CGRectMake(2*self.navigationController.view.bounds.origin.x, 20, 254, self.view.bounds.size.height+45)];
    
    
}

-(NSString *)GetDocumentDirectory{
    
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
}



-(void)CopyDbToDocumentsFolder{
    NSError *err=nil;
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSString *dbpath = [[[NSBundle mainBundle] resourcePath]
                        
                        stringByAppendingPathComponent:@"apodikseis.sqlite"];
    
    
    NSString *copydbpath = [self.GetDocumentDirectory
                            
                            stringByAppendingPathComponent:@"apodikseis.sqlite"];
    
    
    
    
    if(![fileMgr fileExistsAtPath:copydbpath])
    {
        if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err]){
            
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to copy database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [tellErr show];
        }
    }else{
        [fileMgr removeItemAtPath:dbpath error:&err];
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    UISwipeGestureRecognizer* menuRecognize=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(invokeMenu:)];
    NSArray* gestures=[[NSArray alloc]initWithObjects:menuRecognize, nil];
    [self.navigationController.navigationBar setGestureRecognizers:gestures];
    
    [self.navigationController setToolbarHidden:YES];
    [super viewWillAppear:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setGestureRecognizers:nil];
    [super viewWillDisappear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
