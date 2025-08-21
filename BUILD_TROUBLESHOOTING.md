# 🛠️ دليل حل مشاكل البناء - Build Troubleshooting

## 🚨 مشكلة useSearchParams في Next.js 15

### الخطأ
```
⨯ useSearchParams() should be wrapped in a suspense boundary at page "/"
```

### السبب
Next.js 15 يتطلب لف `useSearchParams()` في `Suspense boundary` لضمان الأداء الأمثل.

### الحل

#### الحل السريع (للاختبار)
لاختبار البناء والنشر بسرعة، يمكن تعديل `app/page.tsx`:

```tsx
import { Suspense } from 'react';
import { useSearchParams } from 'next/navigation';

// لف المكون الذي يستخدم useSearchParams
function SearchParamsWrapper({ children }) {
  const searchParams = useSearchParams();
  // باقي منطق useSearchParams هنا
  return children;
}

// في المكون الرئيسي
export default function Home() {
  return (
    <Suspense fallback={<div>جاري التحميل...</div>}>
      <SearchParamsWrapper>
        {/* باقي محتوى الصفحة */}
      </SearchParamsWrapper>
    </Suspense>
  );
}
```

#### الحل الدائم (الموصى به)
1. **حدد جميع استخدامات `useSearchParams`** في الملف `app/page.tsx`
2. **اعمل مكون منفصل** لكل استخدام
3. **لف كل مكون في `<Suspense>`**

### إعدادات مؤقتة للاختبار

في `next.config.ts` تم إضافة:

```typescript
// دعم TypeScript
typescript: {
  ignoreBuildErrors: true, // مؤقتاً لاختبار البناء
},

// دعم ESLint  
eslint: {
  ignoreDuringBuilds: true, // مؤقتاً لاختبار البناء
},
```

**⚠️ تحذير**: هذه الإعدادات مؤقتة لاختبار عملية النشر. يجب إزالتها وحل المشاكل فعلياً في الإنتاج.

## 🔧 خطوات حل المشكلة النهائية

### 1. تحديد المشكلة
```bash
npm run build
```

### 2. إصلاح useSearchParams
في `app/page.tsx`, ابحث عن:
```tsx
const searchParams = useSearchParams();
```

واستبدلها بـ:
```tsx
import { Suspense } from 'react';

function SearchComponent() {
  const searchParams = useSearchParams();
  // منطق المعالجة هنا
}

// في المكون الرئيسي
<Suspense fallback={<div>Loading...</div>}>
  <SearchComponent />
</Suspense>
```

### 3. اختبار البناء
```bash
npm run build
npm run build:cloudflare
```

### 4. إعادة ضبط next.config.ts
عدل `next.config.ts` وغير:
```typescript
typescript: {
  ignoreBuildErrors: false, // إعادة تفعيل فحص TypeScript
},
eslint: {
  ignoreDuringBuilds: false, // إعادة تفعيل ESLint
},
```

## 📋 قائمة مراجعة حل المشاكل

- [ ] تم لف `useSearchParams` في `Suspense`
- [ ] تم اختبار `npm run build` بنجاح
- [ ] تم اختبار `npm run build:cloudflare` بنجاح
- [ ] تم إعادة ضبط إعدادات TypeScript وESLint
- [ ] تم اختبار التطبيق محلياً بـ `npm run dev`

## 🔄 حلول بديلة

### الحل 1: استخدام router.query
```tsx
import { useRouter } from 'next/navigation';

const router = useRouter();
// استخدم router بدلاً من useSearchParams
```

### الحل 2: Server Components
حول المكون إلى Server Component إذا أمكن:
```tsx
// app/page.tsx
export default async function HomePage({ 
  searchParams 
}: { 
  searchParams: { [key: string]: string | string[] | undefined } 
}) {
  // استخدام searchParams مباشرة دون hook
  return (
    // محتوى المكون
  );
}
```

## 🚀 بعد حل المشكلة

عندما يتم حل المشكلة:

1. **اختبر البناء:**
```bash
npm run build && npm run build:cloudflare
```

2. **ارفع التغييرات:**
```bash
git add .
git commit -m "Fix useSearchParams Suspense boundary issue"
git push
```

3. **انشر على Cloudflare Pages**

## 💡 نصائح إضافية

- **Next.js 15** أكثر صرامة مع Performance patterns
- **Suspense boundaries** ضرورية للـ streaming وServer Components  
- **Client Components** يجب أن تدير loading states بشكل صحيح
- **عند الشك، استخدم Server Components** عندما أمكن

## 📞 الدعم

إذا استمرت المشاكل:
- [Next.js 15 Migration Guide](https://nextjs.org/docs/app/building-your-application/upgrading/version-15)
- [Suspense Documentation](https://react.dev/reference/react/Suspense)
- [useSearchParams Documentation](https://nextjs.org/docs/app/api-reference/functions/use-search-params)