import 'feedback.dart';
class FeedbackMaster{
  final List<FeedbackModel> feedbackList;
  final int userCount;

  const FeedbackMaster(this.feedbackList, this.userCount);


  FeedbackMaster.fromJson(Map<String,dynamic> json)
  :feedbackList=json['feedback_list'] as List<FeedbackModel>,
  userCount=json['user_count'] as int;

  Map<String,dynamic> toJson()=>{
    'feedback_list':feedbackList,
    'user_count':userCount
  };
}