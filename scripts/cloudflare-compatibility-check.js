#!/usr/bin/env node

// سكريبت للتحقق من التوافق مع Cloudflare Pages
// يتحقق من التوافق والإعدادات المطلوبة

import fs from 'fs';
import path from 'path';

console.log('🔍 التحقق من التوافق مع Cloudflare Pages...\n');

// التحقق من الملفات المطلوبة
const requiredFiles = [
  'next.config.ts',
  'package.json',
  'wrangler.toml',
  '.env.example'
];

const optionalFiles = [
  '.env.local',
  '.env.cloudflare'
];

let allFilesExist = true;

console.log('📁 التحقق من الملفات المطلوبة:');
requiredFiles.forEach(file => {
  if (fs.existsSync(file)) {
    console.log(`  ✅ ${file}`);
  } else {
    console.log(`  ❌ ${file} - مفقود!`);
    allFilesExist = false;
  }
});

console.log('\n📁 التحقق من الملفات الاختيارية:');
optionalFiles.forEach(file => {
  if (fs.existsSync(file)) {
    console.log(`  ✅ ${file}`);
  } else {
    console.log(`  ⚠️  ${file} - غير موجود (اختياري)`);
  }
});

// التحقق من package.json
if (fs.existsSync('package.json')) {
  const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
  
  console.log('\n📦 التحقق من البرامج النصية في package.json:');
  
  const requiredScripts = [
    'build',
    'build:cloudflare',
    'preview'
  ];
  
  requiredScripts.forEach(script => {
    if (packageJson.scripts && packageJson.scripts[script]) {
      console.log(`  ✅ ${script}: ${packageJson.scripts[script]}`);
    } else {
      console.log(`  ❌ ${script} - مفقود!`);
      allFilesExist = false;
    }
  });
  
  console.log('\n🔧 التحقق من الاعتماديات:');
  
  const requiredDevDeps = [
    '@cloudflare/next-on-pages',
    'wrangler'
  ];
  
  requiredDevDeps.forEach(dep => {
    if (packageJson.devDependencies && packageJson.devDependencies[dep]) {
      console.log(`  ✅ ${dep}: ${packageJson.devDependencies[dep]}`);
    } else {
      console.log(`  ❌ ${dep} - مفقود!`);
      allFilesExist = false;
    }
  });
}

// التحقق من wrangler.toml
if (fs.existsSync('wrangler.toml')) {
  console.log('\n⚙️ التحقق من wrangler.toml:');
  const wranglerContent = fs.readFileSync('wrangler.toml', 'utf8');
  
  const requiredConfig = [
    'name =',
    'compatibility_date =',
    'compatibility_flags =',
    'pages_build_output_dir ='
  ];
  
  requiredConfig.forEach(config => {
    if (wranglerContent.includes(config)) {
      console.log(`  ✅ ${config.trim()}`);
    } else {
      console.log(`  ❌ ${config.trim()} - مفقود!`);
    }
  });
}

// التحقق من next.config.ts
if (fs.existsSync('next.config.ts')) {
  console.log('\n⚙️ التحقق من next.config.ts:');
  const nextConfigContent = fs.readFileSync('next.config.ts', 'utf8');
  
  const requiredConfig = [
    'images:',
    'unoptimized: true'
  ];
  
  requiredConfig.forEach(config => {
    if (nextConfigContent.includes(config)) {
      console.log(`  ✅ ${config}`);
    } else {
      console.log(`  ⚠️  ${config} - قد يحتاج للتحقق`);
    }
  });
}

console.log('\n' + '='.repeat(50));

if (allFilesExist) {
  console.log('🎉 المشروع جاهز للنشر على Cloudflare Pages!');
  console.log('\n📋 الخطوات التالية:');
  console.log('1. تأكد من إضافة المتغيرات البيئية في Cloudflare Pages');
  console.log('2. قم بتشغيل: npm install');
  console.log('3. قم بتشغيل: npm run build');
  console.log('4. قم بتشغيل: npm run build:cloudflare');
  console.log('5. ارفع المشروع إلى GitHub');
  console.log('6. اربط المستودع بـ Cloudflare Pages');
} else {
  console.log('❌ المشروع يحتاج لبعض الإصلاحات قبل النشر');
  console.log('\n📋 يرجى إصلاح المشاكل المذكورة أعلاه');
}

console.log('\n📖 للمزيد من التفاصيل، راجع CLOUDFLARE_DEPLOYMENT.md');