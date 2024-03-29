//
//  BNoteXmlConstants.h
//  BeNote
//
//  Created by kristin young on 8/26/12.
//
//

#import <Foundation/Foundation.h>

extern NSString *const kBeNoteXmlFile;

extern NSString *const kBeNoteOpen;
extern NSString *const kBeNoteClose;
extern NSString *const kCreated;
extern NSString *const kLastUpdated;
extern NSString *const kText;
extern NSString *const kNote;
extern NSString *const kSubject;
extern NSString *const kSummary;
extern NSString *const kTopic;
extern NSString *const kAssociatedTopicName;
extern NSString *const kKeyPoint;
extern NSString *const kPhoto;
extern NSString *const kLocation;
extern NSString *const kDecision;
extern NSString *const kQuestion;
extern NSString *const kAnswer;
extern NSString *const kActionItem;
extern NSString *const kDueDate;
extern NSString *const kCompletedDate;
extern NSString *const kResponsibility;
extern NSString *const kFirstName;
extern NSString *const kLastName;
extern NSString *const kEmail;
extern NSString *const kTopicColor;
extern NSString *const kAttendee;
extern NSString *const kTopicTitle;

typedef enum {
    TextNode,
    DueDateNode,
    CompletedDateNode,
    CreatedDateNode,
    LastUpdatedDateNode,
    QuestionAnswerNode,
    TopicTitleNode,
    SummaryNode,
    SubjectNode,
    TopicColorNode,
    FirstNameNode,
    LastNameNode,
    EmailNode,
    LocationNode,

    NoNode
} CurrentNode;


@interface BNoteXmlConstants : NSObject

+ (NSString *)colorToString:(long)color;
+ (long)longFromString:(NSString *)color;

+ (NSString *)toString:(NSTimeInterval)time;
+ (NSTimeInterval)toTimeInterval:(NSString *)time;

@end
