export const useValidation = () => {
  const validateUrl = (str: string): { valid: boolean; message: string } => {
    if (!str || !str.trim()) {
      return { valid: false, message: 'URL is required' }
    }

    let url: URL
    try {
      url = new URL(
        str.startsWith('http://') || str.startsWith('https://') ? str : 'https://' + str,
      )
    } catch {
      return { valid: false, message: 'Invalid URL format' }
    }

    if (!url.hostname.includes('.')) {
      return { valid: false, message: 'URL must include a valid domain (e.g., example.com)' }
    }

    return { valid: true, message: '' }
  }

  return { validateUrl }
}
