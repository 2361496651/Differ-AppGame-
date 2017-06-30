//
//  DiffBaseNetwork.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


typedef NS_ENUM(NSUInteger, DifferNetError) {
    DifferNetError_Param = 1001, //=> '参数有误',
    DifferNetError_Param_Null = 1002 , //=> '图片数据为空',
    DifferNetError_Param_Data = 1003 , //=> '图片数据格式不正确',
    DifferNetError_Param_Image = 1004 , //=> '图片格式不正确',
    DifferNetError_Param_Save_Image = 1005 , //=> '保存图片失败',
    
    DifferNetError_Param_No_Token = 4001 , //=> '缺少参数 access_token',
    DifferNetError_Param_Expired_Token = 4002 , //=> 'access_token已过期',
    
/*
    //用户操作错误码
    DifferNetError_Param_No_User = 10001 , //=> '没有找到该用户',
    DifferNetError_Param_Save_User = 10002 , //=> '保存用户失败',
    DifferNetError_Param_ = 10003 , //=> '游戏名长度不能长于250个字符',
    DifferNetError_Param = 10004 , //=> '图片JSON格式不正确',
    DifferNetError_Param = 10005 , //=> '原始游戏ID错误',
    DifferNetError_Param = 10006 , //=> '保存推荐失败',
    DifferNetError_Param = 10007 , //=> '保存推荐图片失败',
    DifferNetError_Param = 10008 , //=> '图片说明长度必须少于250个字符',
    DifferNetError_Param = 10009 , //=> '游戏ID不正确',
    DifferNetError_Param = 10010 , //=> '删除失败, 收藏不存在',
    DifferNetError_Param = 10011 , //=> '收藏失败',
    DifferNetError_Param = 10012 , //=> '已经被收藏, 不能再次收藏',
    DifferNetError_Param = 10013 , //=> '收藏操作错误',
    
    //游戏操作
    DifferNetError_Param = 20001 , //=> '找不到指定游戏',
    DifferNetError_Param = 20002 , //=> '保存游戏下载链接错误',
    DifferNetError_Param = 20003 , //=> '游戏列表为空',
    
    //评价操作
    DifferNetError_Param = 30001 , //=> '游戏ID不存在',
    DifferNetError_Param = 30002 , //=> '不能重复评价',
    DifferNetError_Param = 30003 , //=> '评分必须在1~5之间',
    DifferNetError_Param = 30004 , //=> '评价内容不能为空',
    DifferNetError_Param = 30005 , //=> '标签格式错误',
    DifferNetError_Param = 30006 , //=> '找不到标签ID',
    DifferNetError_Param = 30007 , //=> '保存评价失败',
    DifferNetError_Param = 30008 , //=> '评价ID无效',
    DifferNetError_Param = 30009 , //=> 'thumb参数不正确, 只能是 0 或者 1',
    
    //论坛错误
    DifferNetError_Param = 40001 , //=> '标题或内容不能为空',
    DifferNetError_Param = 40002 , //=> '游戏ID不正确',
    DifferNetError_Param = 40003 , //=> '保存帖子失败',
    DifferNetError_Param = 40004 , //=> '帖子ID不正确',
    DifferNetError_Param = 40005 , //=> '保存回帖失败',
    DifferNetError_Param = 40006 , //=> '找不到指定的帖子',
    
    //攻略接口错误
    DifferNetError_Param = 50001 , //=> '缺少参数 game_id',
    
    //栏目接口错误
    DifferNetError_Param = 60001 , //=> '没有该栏目',
    
    //反馈接口错误
    DifferNetError_Param = 70001 , //=> '缺少参数 game_id',
    DifferNetError_Param = 70002 , //=> '缺少参数 type_id',
    DifferNetError_Param = 70003 , //=> '缺少参数 content',
    DifferNetError_Param = 70004 , //=> '保存反馈失败',
 */
};

@interface DiffBaseNetwork : AFHTTPSessionManager
// 网络请求单例
//+ (instancetype)shareInstance;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 */
- (RACSignal*)getOfDiffer:(NSString *)url params:(NSDictionary *)params;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 */
- (RACSignal *)postOfDiffer:(NSString *)url params:(NSDictionary *)params;

/**
 *  上传图片
 *  @param image   要上传的图片
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (void)updateImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;
@end
