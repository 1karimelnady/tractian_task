import 'package:flutter/material.dart';
import 'package:tractian_task/core/utils/colors_manager.dart';
import 'package:tractian_task/features/assets_features/data/data_source/assets_remote_data_source.dart';
import 'package:tractian_task/features/assets_features/data/models/company_model.dart';
import 'package:tractian_task/features/assets_features/presentation/screen/assets_screens.dart';
import 'package:tractian_task/features/home_features/presentation/widgets/home_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TRACTIAN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorsManager.appBarColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Company>>(
        future: ApiService.getCompanies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading companies'));
          }

          final companies = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 22,
              vertical: 30,
            ),
            child: Column(
              children:
                  companies
                      .map(
                        (company) => Column(
                          children: [
                            HomeContainer(
                              title: company.name,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => AssetsScreen(
                                          companyId: company.id,
                                          companyName: company.name,
                                        ),
                                  ),
                                );
                              },
                            ),
                            if (company != companies.last) SizedBox(height: 40),
                          ],
                        ),
                      )
                      .toList(),
            ),
          );
        },
      ),
    );
  }
}
