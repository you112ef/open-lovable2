# Open Lovable

Chat with AI to build React apps instantly. An example app made by the [Firecrawl](https://firecrawl.dev/?ref=open-lovable-github) team. For a complete cloud solution, check out [Lovable.dev ❤️](https://lovable.dev/).

<img src="https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExbmZtaHFleGRsMTNlaWNydGdianI4NGQ4dHhyZjB0d2VkcjRyeXBucCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/ZFVLWMa6dVskQX0qu1/giphy.gif" alt="Open Lovable Demo" width="100%"/>



## Setup

1. **Clone & Install**
```bash
git clone https://github.com/mendableai/open-lovable.git
cd open-lovable
npm install
```

2. **Add `.env.local`**
```env
# Required
E2B_API_KEY=your_e2b_api_key  # Get from https://e2b.dev (Sandboxes)
FIRECRAWL_API_KEY=your_firecrawl_api_key  # Get from https://firecrawl.dev (Web scraping)

# Optional (need at least one AI provider)
ANTHROPIC_API_KEY=your_anthropic_api_key  # Get from https://console.anthropic.com
OPENAI_API_KEY=your_openai_api_key  # Get from https://platform.openai.com (GPT-5)
GEMINI_API_KEY=your_gemini_api_key  # Get from https://aistudio.google.com/app/apikey
GROQ_API_KEY=your_groq_api_key  # Get from https://console.groq.com (Fast inference - Kimi K2 recommended)
```

3. **Run**
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000)

## 🚀 Deploy to Cloudflare Pages

This project is fully configured and ready to deploy on Cloudflare Pages with all features intact.

### Quick Deploy Steps:

1. **Check Compatibility**
```bash
npm run check:cloudflare
```

2. **Build for Cloudflare**
```bash
npm run build
npm run build:cloudflare
```

3. **Deploy Options:**
   - **Dashboard**: Connect your GitHub repo to [Cloudflare Pages](https://pages.cloudflare.com/)
   - **CLI**: `npm run deploy` (requires Wrangler CLI setup)

4. **Environment Variables**: Add all variables from `.env.example` to your Cloudflare Pages settings

### Build Configuration:
- **Framework**: Next.js
- **Build Command**: `npm run build && npm run build:cloudflare`
- **Build Directory**: `.vercel/output/static`
- **Node Version**: 20.x

📖 **For detailed deployment instructions, see [`CLOUDFLARE_DEPLOYMENT.md`](./CLOUDFLARE_DEPLOYMENT.md)**

## 🔧 Additional Scripts

- `npm run preview` - Preview Cloudflare build locally
- `npm run check:cloudflare` - Validate Cloudflare compatibility
- `npm run deploy` - Build and deploy to Cloudflare (CLI)

## License

MIT
