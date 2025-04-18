// Model class for Website
class Website {
  final String name;
  final String url;
  final String description;
  final String iconUrl;

  Website({
    required this.name,
    required this.url,
    required this.description,
    this.iconUrl = 'https://www.google.com/favicon.ico', // Default icon
  });
}

class WebsiteData {
  static final Map<String, List<Website>> categories = {
    'Technology': [
      Website(
        name: 'GitHub',
        url: 'https://github.com',
        description:
            'Platform for version control and collaboration for developers',
        iconUrl: 'https://github.githubassets.com/favicons/favicon.svg',
      ),
      Website(
        name: 'Stack Overflow',
        url: 'https://stackoverflow.com',
        description: 'Community for developers to learn and share knowledge',
        iconUrl: 'https://cdn.sstatic.net/Sites/stackoverflow/Img/favicon.ico',
      ),
      Website(
        name: 'Medium',
        url: 'https://medium.com',
        description: 'Platform for reading and writing tech articles',
        iconUrl: 'https://medium.com/favicon.ico',
      ),
    ],
    'Education': [
      Website(
        name: 'Coursera',
        url: 'https://www.coursera.org',
        description:
            'Online learning platform offering courses from universities',
        iconUrl:
            'https://d3njjcbhbojbot.cloudfront.net/web/images/favicons/favicon-32x32.png',
      ),
      Website(
        name: 'Khan Academy',
        url: 'https://www.khanacademy.org',
        description: 'Free educational resources for students and teachers',
        iconUrl: 'https://cdn.kastatic.org/images/favicon.ico',
      ),
      Website(
        name: 'edX',
        url: 'https://www.edx.org',
        description: 'Online courses from leading educational institutions',
        iconUrl: 'https://www.edx.org/favicon.ico',
      ),
    ],
    'Entertainment': [
      Website(
        name: 'Netflix',
        url: 'https://www.netflix.com',
        description: 'Streaming service for movies and TV shows',
        iconUrl:
            'https://assets.nflxext.com/us/ffe/siteui/common/icons/nficon2016.ico',
      ),
      Website(
        name: 'Spotify',
        url: 'https://www.spotify.com',
        description: 'Digital music streaming service',
        iconUrl: 'https://www.spotify.com/favicon.ico',
      ),
      Website(
        name: 'YouTube',
        url: 'https://www.youtube.com',
        description: 'Video sharing platform',
        iconUrl: 'https://www.youtube.com/favicon.ico',
      ),
    ],
    'News': [
      Website(
        name: 'BBC',
        url: 'https://www.bbc.com',
        description: 'British news broadcasting company',
        iconUrl:
            'https://static.bbci.co.uk/wwhp/1.140.0/responsive/img/favicon.ico',
      ),
      Website(
        name: 'CNN',
        url: 'https://www.cnn.com',
        description: 'Cable News Network',
        iconUrl: 'https://cdn.cnn.com/cnn/.e/img/3.0/global/misc/favicon.ico',
      ),
      Website(
        name: 'The Guardian',
        url: 'https://www.theguardian.com',
        description: 'British daily newspaper',
        iconUrl: 'https://assets.guim.co.uk/images/favicon-32x32.ico',
      ),
    ],
  };

  // Get all category names
  static List<String> get categoryNames => categories.keys.toList();
}
