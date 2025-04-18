import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data/data_website.dart'; // Import the new data file

class WebsiteRecommendationScreen extends StatefulWidget {
  const WebsiteRecommendationScreen({super.key});

  @override
  WebsiteRecommendationScreenState createState() =>
      WebsiteRecommendationScreenState();
}

class WebsiteRecommendationScreenState
    extends State<WebsiteRecommendationScreen> {
  String? _selectedCategory;
  List<Website> _websites = [];

  @override
  void initState() {
    super.initState();
    // Set default category
    if (WebsiteData.categoryNames.isNotEmpty) {
      _selectedCategory = WebsiteData.categoryNames.first;
      _websites = WebsiteData.categories[_selectedCategory] ?? [];
    }
  }

  void _onCategoryChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedCategory = newValue;
        _websites = WebsiteData.categories[newValue] ?? [];
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category selection
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Website Category',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onChanged: _onCategoryChanged,
                      items: WebsiteData.categoryNames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Section title
            Text(
              'Recommended Websites for $_selectedCategory',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Website list
            Expanded(
              child: ListView.builder(
                itemCount: _websites.length,
                itemBuilder: (context, index) {
                  final website = _websites[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(website.iconUrl),
                      ),
                      title: Text(
                        website.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(website.description),
                          const SizedBox(height: 8),
                          Text(
                            website.url,
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_browser,
                            color: Colors.blue),
                        onPressed: () => _launchUrl(website.url),
                      ),
                      onTap: () => _launchUrl(website.url),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
