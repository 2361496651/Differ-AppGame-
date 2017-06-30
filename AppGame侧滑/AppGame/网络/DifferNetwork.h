//
//  DifferNetwork.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DiffBaseNetwork.h"

@interface DifferNetwork : DiffBaseNetwork


+ (instancetype)shareInstance;

// 利用access_token获取用户信息 &&
- (RACSignal*)requestUserInformationParamet:(NSDictionary *)parameter;
// 修改用户信息
- (RACSignal*)requestChangeUserInformationParamet:(NSDictionary *)parameter;

// 上传用户头像
- (void)updateUserIconImage:(UIImage *)image
                accessToken:(NSString *)access_token
                    success:(void(^)(id responseObj))success
                    failure:(void(^)(NSError *error))failure;

// 获取用户评价列表 && 用户关注 && 用户粉丝 列表
- (RACSignal*)getUserPropertyListWithURL:(NSString *)url
                           Paramet:(NSDictionary *)parameter;

// 关注或取消关注
- (RACSignal*)followOrCancelFollowWithId:(NSString *)followId
                            action:(NSString *)action;

// 获取首页信息
- (RACSignal*)getHomeDataSuccess;

// 获取今日推荐列表
- (RACSignal*)getRecommendSuccess;

// 喜欢/取消喜欢游戏
- (RACSignal*)collectionGameWithId:(NSString *)gameId
                      action:(NSString *)action;

// 探索游戏
- (RACSignal*)searchGameWithParameter:(NSDictionary *)paramet;

// 获取日报列表
- (RACSignal*)getDailyListWithParameter:(NSDictionary *)paramet;



// 获取标签列表
- (RACSignal*)getTagsWithParameter:(NSDictionary *)paramter;

// 获取评论列表
- (RACSignal*)getCommentsWithParameter:(NSDictionary *)paramter;


// 用户顶/取消顶标签
- (RACSignal*)thumbTagWithId:(NSString *)tagId
                  type:(NSString *)type;

// 用户贴标签 或 评论
- (RACSignal*)addTagOrCommentWithTarget:(NSString *)target
                         targetId:(NSString *)targetId
                             name:(NSString *)tagName
                            isTag:(BOOL)isTag;



// 用户 回复
- (RACSignal*)commentReplyWithCommentId:(NSString *)commentId
                          content:(NSString *)content
                        isReplied:(BOOL)isReply
                          replyId:(NSString *)replyId
                      replyUserId:(NSString *)replyUserId;

// 用户评论点赞
- (RACSignal*)commentThumbWithCommentId:(NSString *)commentId
                             type:(NSString *)type;

//获取玩家动态
- (RACSignal*)getGamerDynamics:(NSString *)user_id;

// 获取用户留言列表
- (RACSignal*)getUserGuestUserId:(NSString *)user_id;

// by zhengxiaobo
// ------------------------------------------------------

- (RACSignal*)getMineCollections:(NSString*)type
                  position:(NSString*)position;

//游戏评价列表
-(RACSignal*)getCommentsList:(NSString*)appraiseId
              position:(NSString*)position
              pageSize:(NSString*)pageSize;

//用户回复评价
-(RACSignal*)postGameComments:(NSString*)appraiseId
                content:(NSString*)content;

//用户点赞/踩
-(RACSignal*)postThumb:(NSString*)appraiseId
            type:(NSString*)type
        isCancel:(NSString*)isCancel;

//获取游戏详情 api_game
-(RACSignal*)getGameDetail:(NSString*)gameId;

//游戏评价列表
-(RACSignal*)getGameComment:(NSString*)gameId
             position:(NSString*)position
             pageSize:(NSString*)pageSize
                order:(NSString*)order;

//用户评价游戏
-(RACSignal*)postGameComment:(NSString*)appraiseId
                gameId:(NSString*)gameId
               content:(NSString*)content
                  tags:(NSString*)tags
                 start:(NSString*)start;

//获取攻略关键词
-(RACSignal*)getKeyWords:(NSString*)gameId
          pageSize:(NSString*)pageSize
              page:(NSString*)page;

// 获取攻略列表
-(RACSignal*)getTipsList:(NSString*)gameId
          pageSize:(NSString*)pageSize
              page:(NSString*)page
           keyword:(NSString*)keyword;

//专题详情
-(RACSignal*)getTopicDetail:(NSString*)mid
           screenSize:(NSString*)screenSize;
//版本查询
-(RACSignal*)getApiVersion:(NSString*)platform
        providerCode:(NSString*)providerCode;

//评论墙
-(RACSignal*)getEvaluationWall:(NSString*)position
                    type:(NSString*)type;


//用户评论
-(RACSignal*)postComment:(NSString*)appraiseId
            target:(NSString*)target
          targetId:(NSString*)targetId
           content:(NSString*)content;

//获取用户评论
-(RACSignal*)getCommentList:(NSString*)position
             pageSize:(NSString*)pageSize
               target:(NSString*)target
             targetId:(NSString*)targetId;

//标签
-(RACSignal*)postTags:(NSString*)appraiseId
         target:(NSString*)target
       targetId:(NSString*)targetId
           name:(NSString*)name;

//用户顶/取消顶标签
-(RACSignal*)postTagsThumb:(NSString*)tagId
                type:(NSString*)type;

//获取关注列表
-(RACSignal*)getFollowingList:(NSString*)position
               pageSize:(NSString*)pageSize;

//获取粉丝列表
-(RACSignal*)getFollowerList:(NSString*)position
              pageSize:(NSString*)pageSize;

//用户评论回复
-(RACSignal*)postRepliesComment:(NSString*)commentId
                  content:(NSString*)content
                isReplied:(NSString*)isReplied
                  replyId:(NSString*)replyId
              replyUserId:(NSString*)replyUserId;

//用户评论点赞
-(RACSignal*)postCommentsThumb:(NSString*)commentId
                    type:(NSString*)type;

//下载完成回调接口
-(RACSignal*)postAfterDownloadSuccess:(NSString*)commentId
                     downlinkId:(NSString*)downlinkId;

//获取反馈类型
-(RACSignal*)getFeedbackTypes;

//提交反馈
-(RACSignal*)postFeedBack:(NSString*)gameId
                  content:(NSString*)content
                   typeId:(NSString*)typeId;
@end
