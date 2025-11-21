# Progressive Web App (PWA) Setup ✅

Your website is now a fully functional Progressive Web App!

## What Was Added

### 1. **PWA Icons** (infinity-7-layered design)

- `docs/icon-192.png` - Small icon for Android/Chrome
- `docs/icon-512.png` - Large icon for splash screens
- `docs/favicon.svg` - SVG favicon for browsers

### 2. **Web App Manifest** (`docs/manifest.json`)

- App name, description, theme colors
- Icon definitions for different sizes
- Display mode and orientation settings

### 3. **Service Worker** (`docs/sw.js`)

- Caches website resources for offline access
- Provides fast loading on repeat visits
- Auto-updates when new version is available

### 4. **HTML Meta Tags**

- PWA manifest link
- Theme color for browser UI
- Apple touch icon for iOS
- iOS web app settings

## How It Works

Every time you run `./build-website.sh`, the PWA setup is automatically regenerated:

1. ✅ Copies `infinity-7-layered.svg` as favicon
2. ✅ Generates PNG icons (192px and 512px) from SVG
3. ✅ Creates manifest.json from template
4. ✅ Copies service worker
5. ✅ Injects PWA meta tags into HTML
6. ✅ Registers service worker

**Your PWA files are safe!** They're regenerated on every build, so they won't be lost.

## Testing the PWA

### Desktop (Chrome/Edge)

1. Open http://localhost:8001
2. Look for install icon in address bar (⊕ or 💻)
3. Click "Install" to add to desktop

### Mobile (Android)

1. Open the website in Chrome
2. Tap menu (⋮) → "Add to Home screen"
3. The app installs with your custom icon

### Mobile (iOS/Safari)

1. Open the website in Safari
2. Tap Share button → "Add to Home Screen"
3. Icon appears on home screen

## Features

✅ **Installable** - Add to home screen on mobile/desktop  
✅ **Offline Access** - Works without internet after first load  
✅ **Fast Loading** - Resources cached for instant access  
✅ **App-like** - Runs in standalone mode without browser UI  
✅ **Custom Icon** - Beautiful layered infinity symbol  
✅ **Themed** - Navy theme color matches website

## Manifest Details

```json
{
  "name": "The Uniform (Co-Irreducible) Dimension of Rings and Modules",
  "short_name": "Uniform Dimension",
  "theme_color": "#2c3e50",
  "background_color": "#f0f0f0"
}
```

## Customization

To change the icon, edit `manifest-template.json` and point to a different SVG in `build-website.sh`.

## GitHub Pages Deployment

The PWA will work perfectly on GitHub Pages. Just push the `docs/` folder and enable Pages in your repo settings.

All PWA files are generated during build, so they'll always be up-to-date!
