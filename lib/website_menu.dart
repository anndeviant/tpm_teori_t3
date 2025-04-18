import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<String> _favorites = []; // Track favorite URLs
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    // Set default category
    if (WebsiteData.categoryNames.isNotEmpty) {
      _selectedCategory = WebsiteData.categoryNames.first;
      _loadWebsites();
    }
  }

  void _onCategoryChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedCategory = newValue;
        _loadWebsites();
      });
    }
  }

  Future<void> _loadWebsites() async {
    setState(() {
      _isLoading = true;
    });
    
    if (_selectedCategory == 'Favorites') {
      await _loadFavoritesFromFirebase();
    } else {
      setState(() {
        _websites = WebsiteData.categories[_selectedCategory] ?? [];
      });
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        _favorites = snapshot.docs
            .map((doc) => doc.data()['url'] as String)
            .toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load favorites: $e')),
        );
      }
    }
  }

  Future<void> _loadFavoritesFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .get();

      final List<Website> favoriteWebsites = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        favoriteWebsites.add(Website(
          name: data['name'],
          url: data['url'],
          description: data['description'],
          iconUrl: data['iconUrl'],
        ));
      }

      setState(() {
        _websites = favoriteWebsites;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load favorites: $e')),
        );
      }
    }
  }

  Future<void> _toggleFavorite(Website website) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to save favorites')),
      );
      return;
    }

    final isFavorite = _favorites.contains(website.url);
    
    try {
      if (isFavorite) {
        // Remove from favorites
        final snapshot = await FirebaseFirestore.instance
            .collection('favorites')
            .where('userId', isEqualTo: user.uid)
            .where('url', isEqualTo: website.url)
            .get();
            
        if (snapshot.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('favorites')
              .doc(snapshot.docs.first.id)
              .delete();
        }
        
        setState(() {
          _favorites.remove(website.url);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from favorites: ${website.name}')),
        );
      } else {
        // Add to favorites
        await FirebaseFirestore.instance.collection('favorites').add({
          'userId': user.uid,
          'url': website.url,
          'name': website.name,
          'description': website.description,
          'iconUrl': website.iconUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
        
        setState(() {
          _favorites.add(website.url);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites: ${website.name}')),
        );
      }
      
      // Refresh the list if we're in the Favorites category
      if (_selectedCategory == 'Favorites') {
        _loadFavoritesFromFirebase();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorites: $e')),
      );
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
                      items: [...WebsiteData.categoryNames, 'Favorites']
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _websites.isEmpty
                      ? const Center(child: Text('No websites found'))
                      : ListView.builder(
                          itemCount: _websites.length,
                          itemBuilder: (context, index) {
                            final website = _websites[index];
                            final isFavorite = _favorites.contains(website.url);
                            
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : Colors.grey,
                                      ),
                                      onPressed: () => _toggleFavorite(website),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.open_in_browser,
                                          color: Colors.blue),
                                      onPressed: () => _launchUrl(website.url),
                                    ),
                                  ],
                                ),
                                // Disable card tap
                                onTap: null,
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
