import 'package:adm_estoque/app/shared/components/custom_button.dart';
import 'package:adm_estoque/app/shared/domain/entities/app_theme_constants.dart';
import 'package:adm_estoque/app/shared/domain/entities/card_menu_button.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class CardMenuWidget extends StatelessWidget {
  final String title;
  final List<CardMenuButtonEntity> myButtons;

  const CardMenuWidget({
    Key? key,
    required this.title,
    required this.myButtons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  margin: const EdgeInsets.only(
                    right: AppThemeConstants.padding / 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: context.colorScheme.secondaryContainer,
                        width: 5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppThemeConstants.padding / 4,
              ),
              child: Text(
                title,
                style: context.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          width: myButtons.length > 1 ? context.screenWidth : null,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: context.colorScheme.secondaryContainer,
          ),
          child: Wrap(
            alignment: myButtons.length > 1
                ? WrapAlignment.center
                : WrapAlignment.start,
            spacing: 20,
            runSpacing: 10,
            children: myButtons
                .map(
                  (CardMenuButtonEntity button) => AppCustomButton(
                    height: 80,
                    label: Text(
                      button.label,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.background,
                      ),
                    ),
                    icon: button.icon,
                    onPressed: () {
                      Navigator.pushNamed(context, button.route);
                    },
                    expands: true,
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
