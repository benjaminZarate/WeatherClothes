import 'dart:io';

import 'package:flutter/material.dart';

Widget outfitCard(File photoFile){
  const double _radiusCard = 20;

    return GestureDetector(
      onLongPress: (){
      },
      child: Container(
        width: 100,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              offset: const Offset(0,3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.file(photoFile),
        ),
      ),
    );
  }
  