import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/search_page_controller.dart';
import 'package:seusuro/src/model/drug_info.dart';
import 'package:seusuro/src/responsive_transition.dart';
import 'package:seusuro/src/ui/search/bookmark_page.dart';
import 'package:seusuro/src/ui/search/drug_info_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchPageController());

    return Column(
      children: [
        _appBar(),
        Expanded(
          child: Container(
            color: AppColors().bgWhite,
            child: Column(
              children: [
                _searchBox(),
                Obx(() => !SearchPageController.to.isSearching.value
                    ? _recentSearch()
                    : _searchResult()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors().bgWhite,
      title: Text(
        '약품 검색',
        style: TextStyle(
          color: AppColors().textBlack,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(() => const BookmarkPage(), transition: rTransition());
          },
          icon: Icon(
            Icons.bookmark_outline_rounded,
            color: AppColors().bgBlack,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _searchBox() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: AppColors().lineBlack,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: SearchPageController.to.searchWordEditingController,
              style: TextStyle(
                color: AppColors().textBlack,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: AppColors().bgBlack,
              decoration: InputDecoration(
                hintText: '검색어를 입력해주세요',
                hintStyle: TextStyle(
                  color: AppColors().textGrey,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                SearchPageController.to.searchWord.value = value;
              },
              onSubmitted: (value) async {
                SearchPageController.to.isSearching.value = true;
                SearchPageController.to.resultList.clear();

                SearchPageController.to.recentSearchList.add(value);
                await SearchPageController.to.search(value);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              SearchPageController.to.searchWordEditingController.clear();
              SearchPageController.to.searchWord.value = '';

              SearchPageController.to.isSearching.value = false;
            },
            icon: Obx(() => Icon(
                  Icons.clear_rounded,
                  color: SearchPageController.to.searchWord.value.isEmpty
                      ? Colors.transparent
                      : AppColors().bgBlack,
                )),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _recentSearch() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  '최근 검색',
                  style: TextStyle(
                    color: AppColors().bgBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: SearchPageController.to.recentSearchList.clear,
                  child: Text(
                    '전체 삭제',
                    style: TextStyle(
                      color: AppColors().textGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColors().lineGrey,
          ),
          Expanded(
            child: Obx(() {
              if (SearchPageController.to.recentSearchList.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '최근 검색어가 없습니다',
                      style: TextStyle(
                        color: AppColors().bgBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '더 알고 싶은 약품을 검색해보세요',
                      style: TextStyle(
                        color: AppColors().bgBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: SearchPageController.to.recentSearchList
                        .map((element) => _recentSearchTile(element))
                        .toList(),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _recentSearchTile(String searchWord) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              SearchPageController.to.isSearching.value = true;
              SearchPageController.to.resultList.clear();

              SearchPageController.to.searchWord.value = searchWord;
              SearchPageController.to.searchWordEditingController.text =
                  searchWord;

              await SearchPageController.to.search(searchWord);
            },
            child: Text(
              searchWord,
              style: TextStyle(
                color: AppColors().textBlack,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () {
              SearchPageController.to.recentSearchList.remove(searchWord);
            },
            icon: const Icon(
              Icons.close_rounded,
              color: Color(0xFFB7B7B7),
            ),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _searchResult() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  '검색 결과',
                  style: TextStyle(
                    color: AppColors().bgBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Obx(() => Text(
                      SearchPageController.to.resultList.length.toString(),
                      style: TextStyle(
                        color: AppColors().keyBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                Text(
                  '건',
                  style: TextStyle(
                    color: AppColors().bgBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColors().lineGrey,
          ),
          Expanded(
            child: SearchPageController.to.obx(
              (state) {
                if (SearchPageController.to.resultList.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '검색 결과가 없습니다',
                        style: TextStyle(
                          color: AppColors().bgBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '단어의 철자가 정확한지 확인해주세요',
                        style: TextStyle(
                          color: AppColors().bgBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: SearchPageController.to.resultList.length,
                    itemBuilder: (context, index) {
                      var resultList = SearchPageController.to.resultList;

                      return _drugTile(drugInfo: resultList[index]);
                    },
                  );
                }
              },
              onLoading: Center(
                child: CircularProgressIndicator(
                  color: AppColors().keyBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drugTile({required DrugInfo drugInfo}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => DrugInfoPage(drugInfo: drugInfo),
                transition: rTransition());
          },
          child: Container(
            height: 96,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    drugInfo.itemImage == null
                        ? Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors().lineGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.medication_rounded,
                              size: 36,
                              color: AppColors().bgWhite,
                            ),
                          )
                        : ImageNetwork(
                            width: 64,
                            height: 64,
                            image: drugInfo.itemImage!,
                            onTap: () {
                              Get.to(() => DrugInfoPage(drugInfo: drugInfo),
                                  transition: rTransition());
                            },
                            onLoading: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors().keyGrey,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(() => Icon(
                            isBookmarked(drugInfo.itemName!)
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_outline_rounded,
                            color: AppColors().bgBlack,
                            size: 20,
                          )),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drugInfo.itemName!,
                        style: TextStyle(
                          color: AppColors().bgBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        drugInfo.entpName!,
                        style: TextStyle(
                          color: AppColors().textGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: AppColors().lineGrey,
        ),
      ],
    );
  }

  bool isBookmarked(String itemName) {
    bool isBookmarked = false;

    for (DrugInfo drugInfo in SearchPageController.to.bookmarkList) {
      if (drugInfo.itemName == itemName) {
        isBookmarked = true;
        break;
      }
    }

    return isBookmarked;
  }
}
