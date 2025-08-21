import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // تحسين الأداء لـ Cloudflare Pages
  experimental: {
    runtime: 'nodejs',
  },
  
  // إعدادات الصور لـ Cloudflare
  images: {
    unoptimized: true,
  },
  
  // إعدادات عامة للتوافق مع Cloudflare Pages
  assetPrefix: process.env.NODE_ENV === 'production' ? '' : '',
  trailingSlash: false,
  
  // دعم ESLint
  eslint: {
    ignoreDuringBuilds: false,
  },
  
  // دعم TypeScript
  typescript: {
    ignoreBuildErrors: false,
  },
  
  // تحسينات إضافية
  compress: true,
  
  // إعدادات Headers للأمان
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block',
          },
        ],
      },
    ];
  },
};

export default nextConfig;
