class SearchResponseDto {
  final String totalCount;
  final dynamic items;

  SearchResponseDto(
    this.totalCount,
    this.items,
  );

  SearchResponseDto.fromJson(Map<String, dynamic> json)
      : totalCount = json['totalCount'],
        items = json['items'];

  Map<String, dynamic> toJson() => {
        'totalCount': totalCount,
        'items': items,
      };
}
