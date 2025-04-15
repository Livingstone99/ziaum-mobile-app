class BannerModel {
  String? cover;
  String? title;
  String? description;
  String? link;
  String? periodStart;
  String? periodEnd;
  String? adsType;
  int? status;
  BannerModel(
      {this.adsType,
      this.cover,
      this.description,
      this.link,
      this.periodEnd,
      this.periodStart,
      this.status,
      this.title});
  BannerModel.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    title = json['title'];
    status = json['status'];
    description = json['description'];
    link = json['link'] ?? "";
    periodStart = json['period_start'] ?? "";
    status = json['status'] ?? "";
    adsType = json['ads_type'];
  }
}
