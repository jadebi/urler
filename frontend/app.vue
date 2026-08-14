<script setup lang="ts">
const { currentTheme, setTheme } = useTheme()
const { validateUrl } = useValidation()

// Form state
const url = ref('')
const metaUrl = ref('')
const advanced = ref(false)
const isLoading = ref(false)
const submitSuccess = ref<boolean | null>(null)
const themeDropdown = ref<HTMLDetailsElement | null>(null)

const urlError = computed(() => {
  if (!url.value) return ''
  const result = validateUrl(url.value)
  return result.valid ? '' : result.message
})

const metaUrlError = computed(() => {
  if (!advanced.value || !metaUrl.value) return ''
  const result = validateUrl(metaUrl.value)
  return result.valid ? '' : result.message
})

const isFormValid = computed(() => {
  const urlValid = validateUrl(url.value).valid
  const metaValid = !advanced.value || !metaUrl.value || validateUrl(metaUrl.value).valid
  return urlValid && metaValid
})

function selectTheme(theme: string) {
  setTheme(theme as Parameters<typeof setTheme>[0])
  themeDropdown.value?.removeAttribute('open')
}

async function handleSubmit() {
  if (!isFormValid.value) return
  isLoading.value = true
  submitSuccess.value = null

  try {
    const response = await fetch('/api/shorten', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        url: url.value,
        meta_url: metaUrl.value || null,
      }),
    })

    if (response.ok) {
      const data = await response.json()
      console.log(data)
    }
    submitSuccess.value = response.ok
  } catch {
    submitSuccess.value = false
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <nav class="container-fluid">
    <ul>
      <li>&nbsp;</li>
    </ul>
    <ul>
      <li>
        <details ref="themeDropdown" class="dropdown" id="theme-dropdown">
          <summary>
            <i :class="THEMES.find((t) => t.value === currentTheme)?.icon"></i>
            {{ THEMES.find((t) => t.value === currentTheme)?.label }}
          </summary>
          <ul>
            <li v-for="theme in THEMES" :key="theme.value">
              <a href="#" @click.prevent="selectTheme(theme.value)">
                <i :class="theme.icon"></i>
                {{ theme.label }}
              </a>
            </li>
          </ul>
        </details>
      </li>
    </ul>
  </nav>

  <main class="container">
    <section>
      <h2>urler</h2>
      <p>Enter a URL to shorten</p>
      <p>If you want the META Tags of another URL, enable the Advanced Mode.</p>
    </section>

    <form @submit.prevent="handleSubmit">
      <label for="advanced-toggle">
        <input type="checkbox" id="advanced-toggle" class="outline" v-model="advanced" />
        Advanced
      </label>

      <fieldset>
        <fieldset role="group">
          <fieldset>
            <input
              type="text"
              name="url"
              placeholder="URL to shorten"
              aria-label="url"
              required
              v-model="url"
            />
            <small v-if="urlError" class="url-error">{{ urlError }}</small>
          </fieldset>
          <input
            class="outline"
            type="submit"
            value="Short!"
            :disabled="!isFormValid || isLoading"
            :aria-busy="isLoading"
            :aria-invalid="
              submitSuccess === false ? 'true' : submitSuccess === true ? 'false' : undefined
            "
          />
        </fieldset>

        <fieldset v-show="advanced">
          <input
            type="text"
            name="meta-url"
            placeholder="URL for META tags"
            aria-label="meta-url"
            v-model="metaUrl"
          />
          <small v-if="metaUrlError" class="url-error">{{ metaUrlError }}</small>
        </fieldset>
      </fieldset>
    </form>
  </main>
</template>
