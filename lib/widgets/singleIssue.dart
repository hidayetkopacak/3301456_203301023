import 'package:flutter/material.dart';

import 'package:my_digital_library/constants/constants.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class singleIssueSlider extends StatefulWidget {
  final String issueName;
  final List<String> issuePages;

  const singleIssueSlider({required this.issueName, required this.issuePages, Key? key})
      : super(key: key);

  @override
  State<singleIssueSlider> createState() => _singleIssueSliderState();
}

class _singleIssueSliderState extends State<singleIssueSlider> {
  bool _isAppBarVisible = true;
  bool _isBottomNavBarVisible = true;
  int pagePosition = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight+30),
        child: AnimatedContainer(

          height: _isAppBarVisible ? kToolbarHeight+30 : 0,

          duration: Duration(milliseconds: 200),
          child: _buildBuildAppBar(widget.issueName, context),
        ),
      ),
      // Diğer widget'lar...
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isAppBarVisible = !_isAppBarVisible;
            _isBottomNavBarVisible = !_isBottomNavBarVisible;
          });
        },
        child: Container(
          color: Colors.black,
          child: PageView.builder(

            controller: pageController,
            itemCount: widget.issuePages.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.issuePages[index],
                imageBuilder: (context, imageProvider) => PhotoView(
                  imageProvider: imageProvider,
                ),
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(color: Colors.grey),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              );
            },
            onPageChanged: (int index) {
              setState(() {
                pagePosition = index;
              });
            },
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }

  Widget buildBottomNavBar() {
    return AnimatedContainer(
      height: _isBottomNavBarVisible ? kToolbarHeight : 0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        color: Colors.black.withOpacity(0.1),
        height: 56,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (pageController.page! > 0) {
                  pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            Text(
              '${pagePosition + 1} / ${widget.issuePages.length}',
              style: TextStyle(fontSize: 16),
            ),
            IconButton(
              onPressed: () {
                if (pageController.page! < widget.issuePages.length - 1) {
                  pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}

AppBar _buildBuildAppBar(issueName, context) {
  return AppBar(
    leading: IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(
        Icons.arrow_back_ios_outlined,
        color: mainScreenProperties.fontColor,
      ),
    ),
    elevation: appBarProperties.elevation,
    backgroundColor: appBarProperties.color,
    title: Text(
      '$issueName',
      style: TextStyle(
        color: Colors.black,
      ),
    ),
    centerTitle: true,
  );
}
