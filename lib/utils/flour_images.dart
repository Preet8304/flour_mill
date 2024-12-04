class FlourImages {
  final Map<String, String> flourImages = {
    'Wheat Flour':
        'https://pics.craiyon.com/2023-09-11/de956556ea004e0cb90831c6c8997bcb.webp',
    'Rice Flour':
        'https://pics.craiyon.com/2023-10-05/a34a301c25e544c89d9f315dd0665256.webp',
    'Corn Flour':
        'https://pics.craiyon.com/2023-10-15/032a2f1739de4b4b9930e4f731cc4849.webp',
    'Plain Flour':
        'https://pics.craiyon.com/2023-10-15/7756a4de78a649948f9a30e8598338a3.webp',
    'Barley Flour':
        'https://pics.craiyon.com/2023-11-06/51770d6668434a35b69b4c58f40d1d32.webp',
    // Add more flour types and their corresponding image URLs
  };

  String getFlourImage(String flourType) {
    return flourImages[flourType] ??
        'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';
  }
}
