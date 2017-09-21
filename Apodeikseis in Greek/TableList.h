//
//  TableList.h
//  Forologia
//
//  Created by Aggelos Papageorgiou on 1/9/12.
//  Copyright (c) 2012 Aggelos Papageorgiou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableList : NSObject{
    
    NSInteger mainReceiptId;
    NSInteger mainAfm;
    NSString* mainName;
    double mainAmmount;
    NSString* image;
    NSString* mainCategory;
    NSDate* mainDate;
    
    
}


@property (nonatomic,assign) NSInteger mainReceiptId;

@property(nonatomic,assign) NSInteger mainAfm;

@property (nonatomic,retain) NSString* mainName;

@property (nonatomic,assign) double mainAmmount;

@property (nonatomic,retain) NSString* image;

@property (nonatomic,retain) NSString* mainCategory;

@property (nonatomic,retain) NSDate* mainDate;




@end
