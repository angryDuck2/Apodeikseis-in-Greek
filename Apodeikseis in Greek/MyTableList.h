//
//  MyTableList.h
//  Forologia
//
//  Created by Aggelos Papageorgiou on 1/9/12.
//  Copyright (c) 2012 Aggelos Papageorgiou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface MyTableList : NSObject{
    sqlite3* db;
    
}
@property (nonatomic,retain) NSMutableArray* receiptsArray;

-(NSMutableArray*) getReceipt;
-(int) getRowCount;
-(NSString *) GetDocumentDirectory;
-(void)InsertRecords:(NSString*)CompanyName:(NSDate*) receiptDate:(double)ammount:(NSString*)img:(NSInteger*)vat;
-(void)UpdateRecords:(NSString *)txt :(NSMutableString *)utxt;
-(void)DeleteRecords:(int)primaryKey;
@end
