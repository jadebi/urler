type ThemeOption = 'auto' | 'light' | 'dark' | 'emerald'

export const THEMES: { value: ThemeOption; label: string; icon: string }[] = [
  { value: 'auto', label: 'Auto', icon: 'ti ti-device-desktop' },
  { value: 'light', label: 'Light', icon: 'ti ti-sun' },
  { value: 'dark', label: 'Dark', icon: 'ti ti-moon' },
  { value: 'emerald', label: 'Emerald', icon: 'ti ti-diamond' },
]

export const useTheme = () => {
  const currentTheme = useState<ThemeOption>('theme', () => 'auto')

  const applyTheme = (theme: ThemeOption) => {
    if (!import.meta.client) return
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
    document.documentElement.dataset.theme =
      theme === 'auto' ? (prefersDark ? 'dark' : 'light') : theme
  }

  const setTheme = (theme: ThemeOption) => {
    currentTheme.value = theme
    if (import.meta.client) {
      localStorage.setItem('theme', theme)
      applyTheme(theme)
    }
  }

  const initTheme = () => {
    if (!import.meta.client) return
    const saved = (localStorage.getItem('theme') as ThemeOption) || 'auto'
    currentTheme.value = saved
    applyTheme(saved)

    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
      if (currentTheme.value === 'auto') applyTheme('auto')
    })
  }

  return { currentTheme, setTheme, initTheme }
}
