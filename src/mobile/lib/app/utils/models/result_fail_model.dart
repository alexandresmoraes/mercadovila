class ResultError {
  String? code;
  String? property;
  String message;

  ResultError({
    this.code,
    this.property,
    required this.message,
  });

  ResultError.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        property = json['property'],
        message = json['message'];
}

class ResultFailModel {
  int? statusCode;
  bool isValid;
  bool hasError;
  List<ResultError> errors;

  ResultFailModel({
    this.statusCode,
    required this.isValid,
    required this.hasError,
    required this.errors,
  });

  factory ResultFailModel.fromJson(Map<String, dynamic>? json, int? statusCode) => ResultFailModel(
        statusCode: statusCode,
        isValid: json != null ? json['isValid'] : false,
        hasError: json != null ? json['hasError'] : false,
        errors: json != null && json['errors'] != null
            ? List<ResultError>.from(
                json['errors'].map((model) => ResultError.fromJson(model)),
              )
            : <ResultError>[],
      );

  String getMessageNotProperty() => errors.where((e) => e.property == null || e.property!.isEmpty).map((e) => e.message).join('\n');
  String getMessageByProperty(String propertyName) =>
      errors.where((e) => (e.property ?? '').toLowerCase() == propertyName.toLowerCase()).map((e) => e.message).join('\n');
}
