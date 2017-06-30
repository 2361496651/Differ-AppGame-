//
//  DifferNetwork.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DifferNetwork.h"
#import "GlobelConst.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "DiffUtil.h"
#import "NSError+DfExtension.h"

@implementation DifferNetwork
static DifferNetwork *g_differ;

//baseURL使用这个类
//@"http://games-planet.test.appgame.com


+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_differ = [[DifferNetwork alloc]initWithBaseURL:[NSURL URLWithString:differ_base_service]];
        
    });
    return g_differ;
}

// 利用access_token获取用户信息
- (RACSignal*)requestUserInformationParamet:(NSDictionary *)parameter
{
    return [self getOfDiffer:@"/api/user" params:parameter];
}

// 利用access_token 修改用户信息
- (RACSignal*)requestChangeUserInformationParamet:(NSDictionary *)parameter
{
    return [self postOfDiffer:@"/api/user" params:parameter];
}


// 上传用户头像
- (void)updateUserIconImage:(UIImage *)image accessToken:(NSString *)access_token success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    NSString *url = @"/api/user/avatar";
    NSData *imageData = UIImagePNGRepresentation(image);
    NSData *data = [imageData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *dict = @{
                           @"access_token":access_token,
                           @"image_data":data
                           };
    [self updateImage:image url:url params:dict success:^(id responseObj) {
        success(responseObj);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

// 获取用户评价列表 && 用户关注 && 用户粉丝 列表
- (RACSignal*)getUserPropertyListWithURL:(NSString *)url Paramet:(NSDictionary *)parameter
{
    return [self getOfDiffer:url params:parameter];
}

// 关注或取消关注
- (RACSignal*)followOrCancelFollowWithId:(NSString *)followId action:(NSString *)action
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    NSString *url = @"/api/user/follow";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"follow_id"] = followId;
    
    if (action) {
        dict[@"action"] = action;
    }
    
    return [self postOfDiffer:url params:dict];
}

// 获取首页信息
- (RACSignal*)getHomeDataSuccess
{
    NSString *url = @"api/columns";
    
    NSString *lastGameID = [DiffUtil getSearchGameIdString];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if(lastGameID != nil){
        dict[@"game_id"] = lastGameID;
    }else{
        dict = nil;
    }
    
    return [self getOfDiffer:url params:dict];
}

// 获取今日推荐列表
- (RACSignal*)getRecommendSuccess
{
    NSString *url = @"/api/columns/recommend";
    DifferAccount *account = [DifferAccountTool account];
    
    NSString *searchIds = [DiffUtil getSearchGameIdString];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    if (account != nil) {
        parameter[@"access_token"] = account.access_token;
    }
    if (searchIds && ![searchIds isEqualToString:@""]) {
        parameter[@"search_ids"] = searchIds;
    }
    return [self getOfDiffer:url params:parameter];
}

// 喜欢/取消喜欢游戏
- (RACSignal*)collectionGameWithId:(NSString *)gameId action:(NSString *)action
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    
    NSString *url = @"/api/user/collection";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"game_id"] = gameId;
    if(action){
        dict[@"type"] = action;
    }
    
    return [self postOfDiffer:url params:dict];
}

// 探索游戏
- (RACSignal*)searchGameWithParameter:(NSDictionary *)paramet
{
    NSString *url = @"/api/games/search";
    return [self getOfDiffer:url params:paramet];
}


// 获取日报列表
- (RACSignal*)getDailyListWithParameter:(NSDictionary *)paramet
{
    NSString *url = @"/api/columns/daily";
    return [self getOfDiffer:url params:paramet];
}

// 获取标签列表
- (RACSignal*)getTagsWithParameter:(NSDictionary *)paramter
{
    NSString *url = @"/api/tags";
    return [self getOfDiffer:url params:paramter];
}

// 获取评论列表
- (RACSignal*)getCommentsWithParameter:(NSDictionary *)paramter
{
    NSString *url = @"/api/comments";
    return [self getOfDiffer:url params:paramter];
}

// 用户顶/取消顶标签
- (RACSignal*)thumbTagWithId:(NSString *)tagId type:(NSString *)type
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    NSString *url = @"/api/tags/thumb";
    DifferAccount *account = [DifferAccountTool account];
    NSDictionary *dict = @{
                           @"access_token":account.access_token,
                           @"tag_id":tagId,
                           @"type":type
                           };
    
    
    return [self postOfDiffer:url params:dict];
}

// 用户贴标签 或 评论
- (RACSignal*)addTagOrCommentWithTarget:(NSString *)target targetId:(NSString *)targetId name:(NSString *)content isTag:(BOOL)isTag
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    NSString *url = nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (isTag) {
        url = @"/api/tags";
        dict[@"name"] = content;
    }else{
        url = @"/api/comments";
        dict[@"content"] = content;
    }
    DifferAccount *account = [DifferAccountTool account];
    dict[@"access_token"]=account.access_token;
    dict[@"target"]=target;
    dict[@"target_id"]=targetId;
    
    return [self postOfDiffer:url params:dict];
}

// 用户 回复
- (RACSignal*)commentReplyWithCommentId:(NSString *)commentId content:(NSString *)content isReplied:(BOOL)isReply replyId:(NSString *)replyId replyUserId:(NSString *)replyUserId
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    NSString *url = @"/api/replies";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"access_token"]=account.access_token;
    dict[@"comment_id"]=commentId;
    dict[@"content"]=content;
    if (isReply) {
        dict[@"is_replied"]=isReply ? @"0" : @"1"; // 回复为0
        dict[@"reply_id"] = replyId;
        dict[@"reply_user_id"] = replyUserId;
    }
    return [self postOfDiffer:url params:dict];
}

// 用户评论点赞
- (RACSignal*)commentThumbWithCommentId:(NSString *)commentId type:(NSString *)type
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    
    NSString *url = @"/api/comments/thumb" ;
    DifferAccount *account = [DifferAccountTool account];
    NSDictionary *dict = @{
                           @"access_token":account.access_token,
                           @"comment_id":commentId,
                           @"type":type
                           };
    
    return [self postOfDiffer:url params:dict];
}

//获取玩家动态
- (RACSignal*)getGamerDynamics:(NSString *)user_id
{
//    用户的ID，如果为空，则显示玩家动态栏目数据
    NSString *url = @"/api/dynamics";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (user_id) {
        dict[@"user_id"] = user_id;
    }else{
        dict = nil;
    }
    return [self getOfDiffer:url params:dict];
}

// 获取用户留言列表
- (RACSignal*)getUserGuestUserId:(NSString *)user_id
{
    NSString *url = @"/api/user/guest";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    if (user_id) { //可选；用户的ID，如果为本用户，则不需要本参数
        dict[@"user_id"] = user_id;
    }
    
    return [self getOfDiffer:url params:dict];
}

//获取收藏列表
- (RACSignal*)getMineCollections:(NSString*)type position:(NSString*)position{
    NSString *url = @"api/user/collections";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"position"] = position;
    dict[@"page_size"] = @"12";
    dict[@"type"] = type;
    return [self getOfDiffer:url params:dict];
    
}

//游戏评价列表
-(RACSignal*)getCommentsList:(NSString*)appraiseId position:(NSString*)position pageSize:(NSString*)pageSize
{
    NSString *url = @"/api/appraises/comments";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appraise_id"] = account.access_token;
    dict[@"position"] = position;
    dict[@"page_size"] = pageSize;
    
    return [self getOfDiffer:url params:dict];
}

//用户回复评价
-(RACSignal*)postGameComments:(NSString*)appraiseId content:(NSString*)content
{
    NSString *url = @"/api/appraises/comment";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"appraise_id"] = appraiseId;
    dict[@"content"] = content;
    
    return [self postOfDiffer:url params:dict];
}

//用户点赞/踩
-(RACSignal*)postThumb:(NSString*)appraiseId type:(NSString*)type isCancel:(NSString*)isCancel
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    NSString *url = @"/api/appraises/thumb";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"appraise_id"] = appraiseId;
    dict[@"type"] = type;
    dict[@"is_cancel"] = isCancel;

    return [self postOfDiffer:url params:dict];
}

//获取游戏详情
-(RACSignal*)getGameDetail:(NSString*)gameId
{
    NSString *url = @"/api/game";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"game_id"] = gameId;
    
    return [self getOfDiffer:url params:dict];
}

//游戏评价列表
-(RACSignal*)getGameComment:(NSString*)gameId position:(NSString*)position pageSize:(NSString*)pageSize order:(NSString*)order
{
    NSString *url = @"/api/appraises";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"game_id"] = gameId;
    dict[@"position"] = position;
    dict[@"page_size"] = pageSize;
    dict[@"order"] = order;
    
    return [self getOfDiffer:url params:dict];
}

//用户评价游戏
-(RACSignal*)postGameComment:(NSString*)appraiseId gameId:(NSString*)gameId content:(NSString*)content tags:(NSString*)tags start:(NSString*)start
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    NSString *url = @"/api/appraises";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"game_id"] = gameId;
    dict[@"star"] = start;
    dict[@"content"] = content;
    dict[@"tags"] = tags;
    dict[@"appraise_id"] = appraiseId;
    
    return [self postOfDiffer:url params:dict];
}

//获取攻略关键词
-(RACSignal*)getKeyWords:(NSString*)gameId pageSize:(NSString*)pageSize page:(NSString*)page
{
    NSString *url = @"/api/tips/keywords";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"page"] = page;
    dict[@"game_id"] = gameId;
    dict[@"page_size"] = pageSize;
    
    return [self getOfDiffer:url params:dict];
}

// 获取攻略列表
-(RACSignal*)getTipsList:(NSString*)gameId pageSize:(NSString*)pageSize page:(NSString*)page keyword:(NSString*)keyword
{
    NSString *url = @"/api/tips";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"page"] = page;
    dict[@"game_id"] = gameId;
    dict[@"page_size"] = pageSize;
    dict[@"keyword"] = keyword;
    
    return [self getOfDiffer:url params:dict];
}

//专题详情
-(RACSignal*)getTopicDetail:(NSString*)mid screenSize:(NSString*)screenSize
{
    NSString *url = @"/api/columns/topic";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = mid;
    dict[@"screen_size"] = screenSize;
    return [self getOfDiffer:url params:dict];
}

//版本查询
-(RACSignal*)getApiVersion:(NSString*)platform providerCode:(NSString*)providerCode
{
    NSString *url = @"/api/columns/topic";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"platform"] = platform;
    dict[@"provider_code"] = providerCode;
    return [self getOfDiffer:url params:dict];
}

//评论墙
-(RACSignal*)getEvaluationWall:(NSString*)position type:(NSString*)type
{
    NSString *url = @"/api/columns/appraise";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"position"] = position;
    dict[@"type"] = type;
    return [self getOfDiffer:url params:dict];
}


//用户评论
-(RACSignal*)postComment:(NSString*)appraiseId target:(NSString*)target targetId:(NSString*)targetId content:(NSString*)content
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    NSString *url = @"/api/comments";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"target"] = target;
    dict[@"target_id"] = targetId;
    dict[@"content"] = content;
    
    return [self postOfDiffer:url params:dict];
}

//获取用户评论
-(RACSignal*)getCommentList:(NSString*)position pageSize:(NSString*)pageSize target:(NSString*)target targetId:(NSString*)targetId
{
    NSString *url = @"/api/comments";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"position"] = position;
    dict[@"page_size"] = pageSize;
    dict[@"target"] = target;
    dict[@"target_id"] = targetId;
    return [self getOfDiffer:url params:dict];
}

//标签
-(RACSignal*)postTags:(NSString*)appraiseId target:(NSString*)target targetId:(NSString*)targetId name:(NSString*)name
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    NSString *url = @"/api/tags";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"target"] = target;
    dict[@"target_id"] = targetId;
    dict[@"name"] = name;
    
    return [self postOfDiffer:url params:dict];
}

//用户顶/取消顶标签
-(RACSignal*)postTagsThumb:(NSString*)tagId type:(NSString*)type
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    NSString *url = @"/api/tags/thumb";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"tag_id"] = tagId;
    dict[@"type"] = type;
    
    return [self postOfDiffer:url params:dict];
}

//获取关注列表
-(RACSignal*)getFollowingList:(NSString*)position pageSize:(NSString*)pageSize
{
    NSString *url = @"/api/user/following";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"position"] = position;
    dict[@"page_size"] = pageSize;

    return [self getOfDiffer:url params:dict];
}

//获取粉丝列表
-(RACSignal*)getFollowerList:(NSString*)position pageSize:(NSString*)pageSize
{
    NSString *url = @"/api/user/follower";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"position"] = position;
    dict[@"page_size"] = pageSize;
    
    return [self getOfDiffer:url params:dict];
}

//用户评论回复
-(RACSignal*)postRepliesComment:(NSString*)commentId content:(NSString*)content isReplied:(NSString*)isReplied replyId:(NSString*)replyId replyUserId:(NSString*)replyUserId
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    NSString *url = @"/api/replies";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"comment_id"] = commentId;
    dict[@"content"] = content;
    dict[@"is_replied"] = isReplied;
    dict[@"reply_id"] = replyId;
    dict[@"reply_user_id"] = replyUserId;
    
    return [self postOfDiffer:url params:dict];
}

//用户评论点赞
-(RACSignal*)postCommentsThumb:(NSString*)commentId type:(NSString*)type
{
    if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError df_errorWithCode:-1 description:@"程序未登录"]];
            return nil;
        }];
    }
    NSString *url = @"/api/comments/thumb" ;
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"comment_id"] = commentId;
    dict[@"type"] = type;
    
    return [self postOfDiffer:url params:dict];
}

//下载完成回调接口
-(RACSignal*)postAfterDownloadSuccess:(NSString*)commentId downlinkId:(NSString*)downlinkId
{
    NSString *url = @"/api/game/downloaded";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"downlink_id"] = downlinkId;
    
    return [self postOfDiffer:url params:dict];
}


//反馈
//#define API_FEEDBACKS_TYPES @"/api/feedbacks/types"
-(RACSignal*)getFeedbackTypes{
    NSString *url = @"/api/feedbacks/types";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    
    return [self getOfDiffer:url params:dict];
}

//提交反馈内容
-(RACSignal*)postFeedBack:(NSString*)gameId content:(NSString*)content typeId:(NSString*)typeId
{
    NSString *url = @"/api/feedbacks";
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"game_id"] = gameId;
    dict[@"content"] = content;
    dict[@"type_id"] = typeId;
    return [self postOfDiffer:url params:dict];
}

@end
