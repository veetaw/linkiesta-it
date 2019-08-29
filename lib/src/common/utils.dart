import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

Widget buildNetworkImage(String url) => CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, provider) => Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          borderRadius: borderRadiusFromRadiusSize(10),
          image: DecorationImage(
            image: provider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, string) => Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (_, __, ___) => Center(
        child: Icon(Icons.error_outline),
      ),
    );

BorderRadius borderRadiusFromRadiusSize(double radiusSize) => BorderRadius.all(
      Radius.circular(radiusSize),
    );

Text buildCategoryTitle(BuildContext context, String category) => Text(
      (category ?? "non disponibile").toUpperCase(),
      maxLines: 1,
      style: TextStyle(
        color: Theme.of(context).accentColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
