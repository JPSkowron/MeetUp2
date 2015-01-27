//
//  Event.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"

@implementation Event


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.name = dictionary[@"name"];
        self.address = dictionary[@"address"];
        

        self.eventID = dictionary[@"id"];
        self.RSVPCount = [NSString stringWithFormat:@"%@",dictionary[@"yes_rsvp_count"]];
        self.hostedBy = dictionary[@"group"][@"name"];
        self.eventDescription = dictionary[@"description"];
        self.address = dictionary[@"venue"][@"address"];
        self.eventURL = [NSURL URLWithString:dictionary[@"event_url"]];
        self.photoURL = [NSURL URLWithString:dictionary[@"photo_url"]];

        self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_url"]]]];
    }
    return self;
}

+ (NSArray *)eventsFromArray:(NSArray *)incomingArray
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:incomingArray.count];
    
    for (NSDictionary *d in incomingArray) {
        Event *e = [[Event alloc]initWithDictionary:d];
        [newArray addObject:e];
        
    }
    return newArray;
}

+(void)retrieveMeetUpsWithKeyword:(NSString *)keyword andCompletion:(void(^)(NSArray *))complete {

    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=3803e4f78691614d7e70111a25e42", keyword]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                    if (!connectionError) {
                        NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:data
                                                                              options:NSJSONReadingAllowFragments
                                                                                error:nil]
                                                                        objectForKey:@"results"];
                        NSMutableArray *events = [NSMutableArray array];

                        for (NSDictionary *dictionary in jsonArray) {
                            Event *event = [[Event alloc] initWithDictionary:dictionary];
                            [events addObject:event];
                        }
                        complete(events);

            }
    }];


}
- (void)loadCommentData:(Event *)eventID andCompletion:(void(^)(NSArray *))complete;{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=%@&page=20&key=3803e4f78691614d7e70111a25e42", eventID.eventID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

                               NSArray *jsonArray = [dict objectForKey:@"results"];
                               jsonArray = [Comment objectsFromArray:jsonArray];
                               complete(jsonArray);


                           }];


}


@end
