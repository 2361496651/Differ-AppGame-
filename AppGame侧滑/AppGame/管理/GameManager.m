//
//  GameManager.m
//  AppGame
//
//  Created by supozheng on 2017/6/2.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameManager.h"
#import "GameModel.h"
#import "DifferNetwork.h"
#import "GameListGroup.h"

@implementation GameManager


-(RACSignal*)getGameList:(NSString*)requestAction position:(NSString*)position
{
    
//    return [[[DifferNetwork shareInstance] getMineCollections:requestAction position:position] subscribeNext:^(id x) {
//            
//            NSDictionary *responseDict = (NSDictionary *)responseObj;
//            NSArray *dataArr = responseDict[@"data"];
//            NSMutableArray *games = [[NSMutableArray alloc] init];
//            if(dataArr.count > 0 ){
//                for (NSDictionary *dic in dataArr) {
//                    GameListGroup *gameGroup = [GameListGroup mj_objectWithKeyValues:dic];
//                    gameGroup.game.game_id = gameGroup.game.uid;
//                    [games addObject:gameGroup];
//                }
//            }else{
//                [subscriber sendNext:games];
//                [subscriber sendCompleted];
//            }
//            
//        } failure:^(NSError *error) {
//            
//        } error:^(NSError *error) {
//            [subscriber sendError:<#(NSError *)#>];
//        }];
    return nil;
}

@end
