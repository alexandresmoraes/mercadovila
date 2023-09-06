class PhotoUploadResponseModel {
  PhotoUploadResponseModel({required this.filename});
  late final String filename;

  PhotoUploadResponseModel.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
  }
}
