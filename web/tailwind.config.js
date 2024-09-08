/** @type {import('tailwindcss').Config} */
import withMT from "@material-tailwind/html/utils/withMT";

export default withMT ({
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {
      colors: {
        main: '#22232c',
        text: '#c1c2c5',
        secondary: '#22232c',
        'secondary-highlight': '#33343f',
        'background': '#1f2027',
      },
      fontFamily: {
        main: ['Roboto', 'sans-serif'],
      },
      backgroundImage: {
        'radial-gradient': 'radial-gradient(circle, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 0.4) 20%, rgba(0, 0, 0, 0.5) 50%, rgba(0, 0, 0, 0.8) 70%, rgba(0, 0, 0, 1) 100%)',
      },
      animation: {
        'pulse-slow': 'pulse 12s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      }
    },
  },
  plugins: [
    require('tailwindcss-animated')
  ],
})

