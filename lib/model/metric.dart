class Metric {
  int? dailyActiveUsers;
  int? monthlyActiveUsers;
  int? userCount;

  Metric({this.dailyActiveUsers, this.monthlyActiveUsers, this.userCount});

  Metric.fromJson(Map<String, dynamic> json) {
    dailyActiveUsers = json['daily_active_users'];
    monthlyActiveUsers = json['monthly_active_users'];
    userCount = json['user_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['daily_active_users'] = dailyActiveUsers;
    data['monthly_active_users'] = monthlyActiveUsers;
    data['user_count'] = userCount;
    return data;
  }
}