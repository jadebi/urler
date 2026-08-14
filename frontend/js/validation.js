export function validateUrl(str) {
  if (!str || !str.trim()) {
    return { valid: false, message: "URL is required" };
  }
  let url;
  try {
    url = new URL(
      str.startsWith("http://") || str.startsWith("https://")
        ? str
        : "https://" + str,
    );
  } catch {
    return { valid: false, message: "Invalid URL format" };
  }
  if (!url.hostname.includes(".")) {
    return {
      valid: false,
      message: "URL must include a valid domain (e.g., example.com)",
    };
  }
  return { valid: true, message: "" };
}
