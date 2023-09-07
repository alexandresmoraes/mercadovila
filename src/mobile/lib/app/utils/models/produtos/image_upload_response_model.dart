class ImageUploadResponseModel {
  ImageUploadResponseModel({required this.filename});
  late final String filename;

  ImageUploadResponseModel.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
  }
}
