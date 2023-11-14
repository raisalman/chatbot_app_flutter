
class FeedbackModel{
  final String comment;
  final String user;
  final String? datetime;

  const FeedbackModel(this.comment, this.user, this.datetime);

  FeedbackModel.fromJson(Map<String,dynamic> json)
  :comment=json['comment'] as String,
  user=json['user'] as String,
  datetime=json['datetime'];

  Map<String,dynamic> toJson()=>{
    'comment':comment,
    'user':user,
    'datetime':datetime
  };

}