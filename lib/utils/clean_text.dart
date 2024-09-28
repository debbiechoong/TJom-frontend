String cleanText(String title) {
  // Use trim() to remove leading/trailing whitespace
  String trimmedTitle = title.trim();

  // Check if the first and last characters are quotation marks and remove them
  if (trimmedTitle.startsWith('"') && trimmedTitle.endsWith('"')) {
    trimmedTitle = trimmedTitle.substring(1, trimmedTitle.length - 1);
  }

  return trimmedTitle;
}
