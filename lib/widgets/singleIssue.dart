import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:cached_network_image/cached_network_image.dart';

class singleIssueSlider extends StatefulWidget {
  final String issueName;
  final List<String> issuePages;
  const singleIssueSlider({required this.issueName,required this.issuePages,Key? key}) : super(key: key);

  @override
  State<singleIssueSlider> createState() => _singleIssueSliderState();
}

class _singleIssueSliderState extends State<singleIssueSlider> {

  int? pagePosition;

  @override
  void initState() {
    super.initState();
    pagePosition = 0;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: _buildBuildAppBar(widget.issueName,context),
      body: ImageSlideshow(
        height: double.infinity,
        initialPage: 0,
        indicatorColor: mainScreenProperties.fontColor,
        indicatorBackgroundColor: mainScreenProperties.backgroundColorSecond,
        children: [
          //for(var i=0; i<widget.issuePages.length; i++) bozulursa alttaki döngüyü sil bunu al
          //Image.network(widget.issuePages[i]),




          for(var i=0; i<widget.issuePages.length; i++)
            CachedNetworkImage(
              imageUrl: widget.issuePages[i],
              placeholder: (context, url) => Center(child: SizedBox(width:50, height:50,child: CircularProgressIndicator(color: Colors.grey,))),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),

        ],
        onPageChanged: (value) {
          setState(() {
            this.pagePosition = value.toInt();
          });

          print('Page changed: $value');
        },

      ),
      bottomNavigationBar: buildBottomNavBar(pagePosition,widget.issuePages.length),


    );
  }

  Container buildPageViewBuilder() {
    return Container(
      child: PageView.builder(

          itemCount: widget.issuePages.length,
          itemBuilder: (context,pagePosition){
            this.pagePosition = pagePosition;
            return Container(
              child: CachedNetworkImage(
                imageUrl: widget.issuePages[pagePosition],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            );
          }


      ),

    );
  }

  Container buildBottomNavBar(int? pagePosition, int? pageCount) {
    return Container(
      color: Colors.black.withOpacity(.1),
      height: 56,
      width: double.infinity,
      child: Center(child: Text('$pagePosition / $pageCount')),


    );
  }
}



AppBar _buildBuildAppBar(issueName,context) {
  return AppBar(
    //toolbarHeight: height,
    leading: IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_ios_outlined,
        color: mainScreenProperties.fontColor,
      ),


    ),
    elevation: appBarProperties.elevation,
    backgroundColor: appBarProperties.color,
    title: Text('$issueName',style: TextStyle(
        color: Colors.black
    ),) ,//appBarProperties.title,
    centerTitle: true,

  );
}
