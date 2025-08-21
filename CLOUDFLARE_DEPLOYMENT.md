# دليل نشر open-lovable2 على Cloudflare Pages

## 🚀 خطوات النشر السريع

### 1. إعداد المشروع محلياً

```bash
# تثبيت الاعتماديات
npm install

# أو باستخدام pnpm
pnpm install

# أو باستخدام yarn
yarn install
```

### 2. إعداد المتغيرات البيئية

انسخ الملف `.env.example` إلى `.env.local` وأضف قيم API الخاصة بك:

```bash
cp .env.example .env.local
```

املأ المتغيرات المطلوبة:
- `E2B_API_KEY` - للحصول عليه من [e2b.dev](https://e2b.dev)
- `FIRECRAWL_API_KEY` - للحصول عليه من [firecrawl.dev](https://firecrawl.dev) 
- `ANTHROPIC_API_KEY` - للحصول عليه من [console.anthropic.com](https://console.anthropic.com)
- `OPENAI_API_KEY` - للحصول عليه من [platform.openai.com](https://platform.openai.com)
- `GEMINI_API_KEY` - للحصول عليه من [aistudio.google.com](https://aistudio.google.com/app/apikey)
- `GROQ_API_KEY` - للحصول عليه من [console.groq.com](https://console.groq.com)

### 3. اختبار المشروع محلياً

```bash
# تشغيل الخادم المحلي
npm run dev
```

### 4. النشر على Cloudflare Pages

#### الطريقة الأولى: من خلال لوحة التحكم

1. سجل الدخول إلى [Cloudflare Dashboard](https://dash.cloudflare.com)
2. اذهب إلى **Pages**
3. انقر على **Create a Project**
4. اختر **Connect to Git** ثم **GitHub**
5. اختر مستودع `open-lovable2`
6. اختر إعدادات البناء:
   - **Framework preset**: Next.js
   - **Build command**: `npm run build && npm run build:cloudflare`
   - **Build output directory**: `.vercel/output/static`
   - **Root directory**: `/` (افتراضي)
   - **Environment variables**: أضف جميع المتغيرات من ملف `.env.example`

#### الطريقة الثانية: من خلال Wrangler CLI

```bash
# تثبيت Wrangler عالمياً
npm install -g wrangler

# تسجيل الدخول إلى Cloudflare
wrangler auth login

# بناء المشروع
npm run build
npm run build:cloudflare

# نشر المشروع
wrangler pages deploy .vercel/output/static --project-name=open-lovable2
```

### 5. إضافة المتغيرات البيئية في Cloudflare

1. اذهب إلى صفحة مشروعك في Cloudflare Pages
2. انقر على **Settings** ثم **Environment Variables**
3. أضف المتغيرات التالية في بيئة **Production**:

```
E2B_API_KEY=your_e2b_api_key_here
FIRECRAWL_API_KEY=your_firecrawl_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here
OPENAI_API_KEY=your_openai_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here
GROQ_API_KEY=your_groq_api_key_here
NODE_ENV=production
```

## 🔧 البرامج النصية المتاحة

- `npm run dev` - تشغيل الخادم المحلي
- `npm run build` - بناء المشروع
- `npm run build:cloudflare` - بناء للنشر على Cloudflare
- `npm run preview` - معاينة محلية للإصدار المبني لـ Cloudflare
- `npm run deploy` - بناء ونشر تلقائي
- `npm run lint` - فحص الكود

## 📦 المميزات المُحسنة لـ Cloudflare

- ✅ دعم كامل لـ API Routes
- ✅ تحسين الصور تلقائياً
- ✅ إعدادات الأمان المحسنة
- ✅ دعم Node.js runtime
- ✅ ضغط تلقائي للملفات
- ✅ headers أمان محسنة

## 🚨 ملاحظات مهمة

1. **المتغيرات البيئية**: تأكد من إضافة جميع المتغيرات المطلوبة في إعدادات Cloudflare Pages
2. **API Keys**: احتفظ بـ API keys آمنة ولا تضعها في الكود المصدري
3. **الدومين**: بعد النشر، ستحصل على رابط مثل `https://open-lovable2.pages.dev`
4. **التحديثات**: عند دفع تغييرات جديدة، سيتم إعادة البناء والنشر تلقائياً

## 🛠️ استكشاف الأخطاء

### خطأ في البناء
إذا فشل البناء، تحقق من:
- تثبيت جميع الاعتماديات بشكل صحيح
- وجود جميع المتغيرات البيئية المطلوبة
- عدم وجود أخطاء TypeScript

**⚠️ مشكلة شائعة**: إذا واجهت خطأ `useSearchParams() should be wrapped in a suspense boundary`، راجع [`BUILD_TROUBLESHOOTING.md`](./BUILD_TROUBLESHOOTING.md) للحل المفصل.

### مشاكل API Routes  
إذا لم تعمل API routes:
- تأكد من إضافة جميع المتغيرات البيئية
- تحقق من صحة API keys
- راجع logs في لوحة تحكم Cloudflare

### مشاكل الأداء
لتحسين الأداء:
- استخدم `npm run preview` للاختبار محلياً
- تحقق من حجم الحزمة في build output
- راجع Core Web Vitals في Cloudflare Analytics

## 📞 الدعم

إذا واجهت أي مشاكل:
1. راجع [Cloudflare Pages docs](https://developers.cloudflare.com/pages/)
2. تحقق من [Next.js on Cloudflare guide](https://developers.cloudflare.com/pages/framework-guides/nextjs/)
3. راجع logs في لوحة تحكم Cloudflare