class PhotoUploadResponseModel {
  PhotoUploadResponseModel({required this.id});
  late final String id;

  PhotoUploadResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}
