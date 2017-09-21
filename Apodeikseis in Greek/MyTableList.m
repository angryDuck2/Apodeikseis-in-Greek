//
//  MyTableList.m
//  Forologia
//
//  Created by Aggelos Papageorgiou on 1/9/12.
//  Copyright (c) 2012 Aggelos Papageorgiou. All rights reserved.
//

#import "MyTableList.h"
#import "TableList.h"
@implementation MyTableList

@synthesize receiptsArray;
-(NSMutableArray*) getReceipt{
    receiptsArray=[[NSMutableArray alloc]init];
    
       @try {
        NSFileManager* receiptsManager=[NSFileManager defaultManager];
        
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"apodikseis.sqlite"];
        BOOL success =[receiptsManager fileExistsAtPath:dbPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT ap_main_id, ap_main_name, ap_main_afm, ap_main_ammount, ap_main_img, ap_main_date, ap_main_receiptdate, ap_cat_name FROM ap_main1, ap_cat WHERE ap_cat_id = ap_main_category";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
           
        
           if (sqlite3_open([dbPath UTF8String],&db)==SQLITE_OK)
           {
               
                if (sqlite3_prepare_v2(db,sql,-1,&sqlStatement,NULL)==SQLITE_OK)
               {
                   while(sqlite3_step(sqlStatement) == SQLITE_ROW)
                   {
                       int i=0;
                       TableList* MyTableList = [[TableList alloc]init];
                       MyTableList.mainReceiptId = sqlite3_column_int(sqlStatement, 0);
                       MyTableList.mainAfm = sqlite3_column_int(sqlStatement, 2);
                       MyTableList.mainAmmount= sqlite3_column_int(sqlStatement, 3);
                       MyTableList.image =  [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
                       MyTableList.mainCategory =  [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,7)];
                       NSString* tempString=  [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,6)];
                       NSDateFormatter* mainFormat=[[NSDateFormatter alloc]init];
                       [mainFormat setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
                       MyTableList.mainDate=[mainFormat dateFromString:tempString];
                       MyTableList.mainName= [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
                       [receiptsArray insertObject:MyTableList atIndex:i];
                       i++;
                   }     
                   
               }   
               
               sqlite3_finalize(sqlStatement);
               
               
           }   

        
            
            
       
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        NSLog(@"could not open file %@" , [exception reason]);
    }
    @finally {
        
        sqlite3_close(db);
        return receiptsArray;
        
    }
        
    
    
        
}

-(int) getRowCount{

int articlescount=0;
@try {
    NSFileManager* receiptsManager=[NSFileManager defaultManager];
    
    NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"apodikseis.sqlite"];
    BOOL success =[receiptsManager fileExistsAtPath:dbPath];
    
    if(!success)
    {
        NSLog(@"Cannot locate database file '%@'.", dbPath);
    }
    if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
    {
        NSLog(@"An error has occured.");
    }
    const char *sql = "SELECT ap_main_id FROM ap_main1";
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Problem with prepare statement");
    }
    
    
    
    while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
        
        articlescount++;
    }
    sqlite3_finalize(sqlStatement);

    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        NSLog(@"could not open file %@" , [exception reason]);
    }
    @finally {
        sqlite3_close(db);
        return articlescount;
        
    }
}



-(void)UpdateRecords:(NSString *)txt :(NSMutableString *)utxt{
    
    
    sqlite3_stmt *stmt=nil;
    
    
    
    //insert
    const char *sql = "Update data set ap_main_name";
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"apodikseis.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &db);
    sqlite3_prepare_v2(db, sql, 1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [utxt UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    
}

-(NSString *)GetDocumentDirectory{
   
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
}




-(void)InsertRecords:(NSString*)CompanyName:(NSDate*) receiptDate:(double)ammount:(NSString*)img:(NSInteger*)vat{
    
   
    
    
    NSString* tempstring =[[NSString alloc]init];
    NSDateFormatter* origFormat=[[NSDateFormatter alloc]init];
    [origFormat setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    tempstring=[origFormat stringFromDate:receiptDate];
    
    NSString* dbPath=[self.GetDocumentDirectory stringByAppendingPathComponent:@"apodikseis.sqlite"];
    
        
    //insert
  
    sqlite3_stmt    *statement;
        
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO ap_main1 ( ap_main_afm,ap_main_name, ap_main_ammount, ap_main_img,ap_main_receiptdate,ap_main_category) VALUES (\"%d\",\"%@\", \"%.2lf\", \"%@\",\"%@\",\"1\")" ,vat,CompanyName,ammount,img,tempstring];
                                                              
        const char *insert_stmt = [insertSQL UTF8String];
                                                              
        sqlite3_prepare_v2(db, insert_stmt,-1, &statement, NULL);
                                                         
        if (sqlite3_step(statement) == SQLITE_DONE)
                                                              
        {
            
            sqlite3_get_autocommit(db);
            
                                                                          
        } else {
                                                                
            NSLog(@"oh oh %s",sqlite3_errmsg(db));
        }
                                                              
        sqlite3_finalize(statement);
                                                              
        sqlite3_close(db);
                                                              
    }
    
}


-(void)DeleteRecords:(int)primaryKey{
    
    sqlite3_stmt* delete_statement=nil;
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE  FROM ap_main1 WHERE ap_main_id=\"%d\"" ,primaryKey];
    const char* sql=[deleteSQL UTF8String];
    NSString* dbPath=[self.GetDocumentDirectory stringByAppendingPathComponent:@"apodikseis.sqlite"];;
    if(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK)
    {
    
    if ((sqlite3_prepare_v2(db, sql, -1, &delete_statement, NULL))) {
        NSLog( @"Failed to initialize statement  %s", sqlite3_errmsg(db));
    }
   
    if (!(sqlite3_step(delete_statement)==SQLITE_DONE)) {
        NSLog( @"Failed to write to database %s", sqlite3_errmsg(db));
    }
    sqlite3_finalize(delete_statement);
    sqlite3_close(db);
    }
}





@end
