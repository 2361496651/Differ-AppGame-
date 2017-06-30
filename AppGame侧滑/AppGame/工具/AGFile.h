//
//  AGFile.h
//  AGVideo
//
//  Created by Mao on 16/4/15.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGBaseModel.h"

typedef void (^AGDataResultBlock)(NSData *data, NSError *error);
typedef void (^AGImageResultBlock)(UIImage * image, NSError *error);
@interface AGFile : AGBaseModel
/*!
 The name of the file.
 */
@property (nonatomic, readonly, copy) NSString *name;

/*!
 The id of the file.
 */


/*!
 The url of the file.
 */
@property (readonly) NSString *url;

/*!
 The Qiniu bucket of the file.
 */
@property (nonatomic, readonly, copy) NSString *bucket;

/** @name Storing Data with LeanCloud */

/*!
 Whether the file has been uploaded for the first time.
 */
@property (readonly) BOOL isDirty;

/*!
 File metadata, caller is able to store additional values here.
 */
@property (readwrite, strong) NSMutableDictionary * metaData;


/*!
 Saves the file.
 @return whether the save succeeded.
 */
- (BOOL)save;

/*!
 Saves the file and sets an error if it occurs.
 @param error Pointer to an NSError that will be set if necessary.
 @return whether the save succeeded.
 */
- (BOOL)save:(NSError **)error;

/*!
 Saves the file asynchronously.
 @return whether the save succeeded.
 */
- (void)saveInBackground;

/*!
 Saves the file asynchronously and calls the given callback.
 @param target The object to call selector on.
 @param selector The selector to call. It should have the following signature: (void)callbackWithResult:(NSNumber *)result error:(NSError *)error. error will be nil on success and set if there was an error. [result boolValue] will tell you whether the call succeeded or not.
 */
- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector;

/** @name Getting Data from LeanCloud */

/*!
 Whether the data is available in memory or needs to be downloaded.
 */
@property (readonly) BOOL isDataAvailable;

/*!
 Gets the data from cache if available or fetches its contents from the LeanCloud
 servers.
 @return The data. Returns nil if there was an error in fetching.
 */
- (NSData *)getData;

/*!
 This method is like getData but avoids ever holding the entire AVFile's
 contents in memory at once. This can help applications with many large AVFiles
 avoid memory warnings.
 @return A stream containing the data. Returns nil if there was an error in
 fetching.
 */
- (NSInputStream *)getDataStream;

/*!
 Gets the data from cache if available or fetches its contents from the LeanCloud
 servers. Sets an error if it occurs.
 @param error Pointer to an NSError that will be set if necessary.
 @return The data. Returns nil if there was an error in fetching.
 */
- (NSData *)getData:(NSError **)error;

/*!
 This method is like getData: but avoids ever holding the entire AVFile's
 contents in memory at once. This can help applications with many large AVFiles
 avoid memory warnings. Sets an error if it occurs.
 @param error Pointer to an NSError that will be set if necessary.
 @return A stream containing the data. Returns nil if there was an error in
 fetching.
 */
- (NSInputStream *)getDataStream:(NSError **)error;

/*!
 Asynchronously gets the data from cache if available or fetches its contents
 from the LeanCloud servers. Executes the given block.
 @param block The block should have the following argument signature: (NSData *result, NSError *error)
 */
- (void)getDataInBackgroundWithBlock:(AGDataResultBlock)block;

/*!
 Asynchronously gets the data from cache if available or fetches its contents
 from the LeanCloud servers.
 @param target The object to call selector on.
 @param selector The selector to call. It should have the following signature: (void)callbackWithResult:(NSData *)result error:(NSError *)error. error will be nil on success and set if there was an error.
 */
- (void)getDataInBackgroundWithTarget:(id)target selector:(SEL)selector;

/** @name Interrupting a Transfer */

/*!
 Cancels the current request (whether upload or download of file data).
 */
- (void)cancel;

/*!
 Get a thumbnail URL for image saved on Qiniu.
 
 @param scaleToFit Scale the thumbnail and keep aspect ratio.
 @param width The thumbnail width.
 @param height The thumbnail height.
 @param quality The thumbnail image quality in 1 - 100.
 @param format The thumbnail image format such as 'jpg', 'gif', 'png', 'tif' etc.
 */
- (NSString *)getThumbnailURLWithScaleToFit:(BOOL)scaleToFit
                                      width:(int)width
                                     height:(int)height
                                    quality:(int)quality
                                     format:(NSString *)format;

/*!
 Get a thumbnail URL for image saved on Qiniu.
 @see -getThumbnailURLWithScaleToFit:width:height:quality:format
 
 @param scaleToFit Scale the thumbnail and keep aspect ratio.
 @param width The thumbnail width.
 @param height The thumbnail height.
 */
- (NSString *)getThumbnailURLWithScaleToFit:(BOOL)scaleToFit
                                      width:(int)width
                                     height:(int)height;

/*!
 Gets a thumbnail asynchronously and calls the given block with the result.
 
 @param scaleToFit Scale the thumbnail and keep aspect ratio.
 @param width The desired width.
 @param height The desired height.
 @param block The block to execute. The block should have the following argument signature: (UIImage *image, NSError *error)
 */
- (void)getThumbnail:(BOOL)scaleToFit
               width:(int)width
              height:(int)height
           withBlock:(AGImageResultBlock)block;


/*!
 Sets a owner id to metadata.
 
 @param ownerId The owner objectId.
 */
-(void)setOwnerId:(NSString *)ownerId;

/*!
 Gets owner id from metadata.
 
 */
-(NSString *)ownerId;


/*!
 Gets file size in bytes.
 */
-(NSUInteger)size;

/*!
 Gets file path extension from url, name or local file path.
 */
-(NSString *)pathExtension;

/*!
 Gets local file path.
 */
- (NSString *)localPath;


/*!
 Remove file in background.
 */
- (void)deleteInBackground;


/** @name Cache management */

/*!
 Clear file cache.
 */
- (void)clearCachedFile;

/**
 *  clear All Cached AVFiles
 *
 *  @return clear success or not
 */
+ (BOOL)clearAllCachedFiles;

/**
 *  clear All Cached AVFiles by days ago
 *
 *  @param numberOfDays number Of Days
 *
 *  @return clear success or not
 */
+ (BOOL)clearCacheMoreThanDays:(NSInteger)numberOfDays;


@end
