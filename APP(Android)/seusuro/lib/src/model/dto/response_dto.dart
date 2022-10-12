class ResponseDto {
  final int status;
  final String message;
  final dynamic data;

  ResponseDto(
    this.status,
    this.message,
    this.data,
  );

  ResponseDto.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        data = json['data'];

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data,
      };
}
