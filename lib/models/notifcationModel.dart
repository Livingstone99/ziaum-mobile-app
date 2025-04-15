class NotificationModel {
  final int? id;
  final List<String>? recipients;
  final String? subject;
  final String? message;
  final String? notificationType;
  final DateTime? createdAt;
  final bool? sendImmediately;
  final DateTime? scheduledTime;
  final bool? isRecurring;
  final DateTime? endTime;
  final bool? sendViaSms;
  final bool? sendViaEmail;

  NotificationModel({
    this.id,
    this.recipients,
    this.message,
    this.subject,
    this.notificationType,
    this.createdAt,
    this.sendImmediately,
    this.scheduledTime,
    this.isRecurring,
    this.endTime,
    this.sendViaSms,
    this.sendViaEmail,
  });

  // Factory constructor to create an instance from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    print("message");
    print(json["message"]);
    print('@@@@@@@@');
    print(json["subject"]);
    return NotificationModel(
      id: json['id'],
      recipients: List<String>.from(json['recipients']),
      message: json['message'],
      subject: json['subject'] ?? "title",
      notificationType: json['notification_type'],
      createdAt: DateTime.parse(json['created_at']),
      sendImmediately: json['send_immediately'],
      scheduledTime: json['scheduled_time'] != null
          ? DateTime.parse(json['scheduled_time'])
          : null,
      isRecurring: json['is_recurring'],
      endTime:
          json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      sendViaSms: json['send_via_sms'],
      sendViaEmail: json['send_via_email'],
    );
  }

  // Convert the model instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipients': recipients,
      'message': message,
      'subject': subject,
      'notification_type': notificationType,
      'created_at': createdAt!.toIso8601String(),
      'send_immediately': sendImmediately,
      'scheduled_time': scheduledTime?.toIso8601String(),
      'is_recurring': isRecurring,
      'end_time': endTime?.toIso8601String(),
      'send_via_sms': sendViaSms,
      'send_via_email': sendViaEmail,
    };
  }
}
