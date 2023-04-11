import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';
import '../../../widgets/searchBar.dart';

class iconButtonAction extends StatelessWidget {
  const iconButtonAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => gridViewSearch()),
        );
      },
      icon: const Icon(
        Icons.search,
        color: mainScreenProperties.fontColor,
      ),
    )
    ;
  }
}