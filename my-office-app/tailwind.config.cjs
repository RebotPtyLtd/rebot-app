/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {},
  },
  plugins: [require('daisyui')],
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "#1a237e", // Darker blue
          "primary-focus": "#000051",
          "primary-content": "#ffffff",
          "secondary": "#42a5f5",
          "accent": "#64b5f6",
          "neutral": "#3d4451",
          "base-100": "#e3f2fd", // Light blue background
          "info": "#2196f3",
          "success": "#4caf50",
          "warning": "#ffc107",
          "error": "#f44336",
        },
      },
      "light", // Fallback to light theme
    ],
  },
}