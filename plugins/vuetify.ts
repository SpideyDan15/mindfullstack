import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'
import { createVuetify } from 'vuetify'

const themeColors = {
  light: {"Platinum":"#ebe9e9","Mint cream":"#f3f8f2","Steel blue":"#3581b8","Sandy brown":"#fcb07e","Alabaster":"#dee2d6"},
  dark: {"Poppy":"#da2c38","Baby powder":"#fffffa","Xanthous":"#e6af2e","Gunmetal":"#30343f","Eerie black":"#1b2021"}
}

const lightTheme: ThemeDefinition = {
  dark: false,
  colors: {
    background: '#FFFFFF',
    surface: '#FFFFFF',
    primary: '#6200EE',
    'primary-darken-1': '#3700B3',
    secondary: '#03DAC6',
    'secondary-darken-1': '#018786',
    error: '#B00020',
    info: '#2196F3',
    success: '#4CAF50',
    warning: '#FB8C00',
  },
}

const darkTheme: ThemeDefinition = {
  dark: true,
  colors: {
    background: themeColors.dark.Gunmetal,
    surface: themeColors.dark.Gunmetal,
    primary: themeColors.dark.Xanthous,
    'primary-darken-1': '#3700B3',
    secondary: themeColors.dark.Poppy,
    'secondary-darken-1': '#018786',
    error: '#B00020',
    info: themeColors.dark['Baby powder'],
    success: '#4CAF50',
    warning: '#FB8C00',
  },
}

export default defineNuxtPlugin((app) => {
  const vuetify = createVuetify({
    theme: {
      defaultTheme: 'darkTheme',
      themes: {
        lightTheme,
        darkTheme
      },
    },
  })
  app.vueApp.use(vuetify)
})
