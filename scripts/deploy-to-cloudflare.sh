#!/bin/bash
# ==========================================
# Cursor Automation Script - open-lovable4
# نشر تلقائي على Cloudflare Pages
# ==========================================

# ألوان للرسائل
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# دالة لطباعة الرسائل الملونة
print_message() {
    echo -e "${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

print_info() {
    echo -e "${BLUE}$1${NC}"
}

# دالة للتحقق من وجود الأوامر المطلوبة
check_requirements() {
    print_info "🔍 التحقق من المتطلبات الأساسية..."
    
    if ! command -v git &> /dev/null; then
        print_error "❌ Git غير مثبت. يرجى تثبيت Git أولاً."
        exit 1
    fi
    
    if ! command -v node &> /dev/null; then
        print_error "❌ Node.js غير مثبت. يرجى تثبيت Node.js أولاً."
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        print_error "❌ npm غير مثبت. يرجى تثبيت npm أولاً."
        exit 1
    fi
    
    if ! command -v wrangler &> /dev/null; then
        print_warning "⚠️ Wrangler غير مثبت. جاري التثبيت..."
        npm install -g wrangler
    fi
    
    if ! command -v gh &> /dev/null; then
        print_warning "⚠️ GitHub CLI غير مثبت. جاري التثبيت..."
        # تثبيت GitHub CLI حسب نظام التشغيل
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update
            sudo apt install gh
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install gh
        else
            print_error "❌ لا يمكن تثبيت GitHub CLI تلقائياً على هذا النظام. يرجى التثبيت يدوياً."
            exit 1
        fi
    fi
    
    print_message "✅ جميع المتطلبات متوفرة!"
}

# دالة للتحقق من حالة تسجيل الدخول
check_auth() {
    print_info "🔑 التحقق من حالة تسجيل الدخول..."
    
    # التحقق من GitHub CLI
    if ! gh auth status &> /dev/null; then
        print_warning "⚠️ لم يتم تسجيل الدخول إلى GitHub. جاري تسجيل الدخول..."
        gh auth login
    else
        print_message "✅ تم تسجيل الدخول إلى GitHub بالفعل"
    fi
    
    # التحقق من Cloudflare
    if ! wrangler whoami &> /dev/null; then
        print_warning "⚠️ لم يتم تسجيل الدخول إلى Cloudflare. جاري تسجيل الدخول..."
        wrangler login
    else
        print_message "✅ تم تسجيل الدخول إلى Cloudflare بالفعل"
    fi
}

# دالة لاستنساخ أو تحديث المستودع
setup_repository() {
    print_info "📂 إعداد المستودع..."
    
    REPO_NAME="open-lovable4"
    REPO_URL="https://github.com/ai-hub-2/open-lovable4.git"
    
    if [ -d "$REPO_NAME" ]; then
        print_info "المجلد موجود بالفعل، تحديث المستودع..."
        cd "$REPO_NAME"
        git pull origin main
        if [ $? -ne 0 ]; then
            print_error "❌ فشل في تحديث المستودع"
            exit 1
        fi
    else
        print_info "استنساخ المستودع..."
        git clone "$REPO_URL"
        if [ $? -ne 0 ]; then
            print_error "❌ فشل في استنساخ المستودع"
            exit 1
        fi
        cd "$REPO_NAME"
    fi
    
    print_message "✅ تم إعداد المستودع بنجاح!"
}

# دالة لتثبيت التبعيات
install_dependencies() {
    print_info "📦 تثبيت التبعيات..."
    
    # حذف node_modules إذا كان موجوداً لتجنب المشاكل
    if [ -d "node_modules" ]; then
        print_info "حذف node_modules القديم..."
        rm -rf node_modules
    fi
    
    # حذف package-lock.json إذا كان موجوداً
    if [ -f "package-lock.json" ]; then
        rm package-lock.json
    fi
    
    # تثبيت التبعيات
    npm install
    if [ $? -ne 0 ]; then
        print_error "❌ فشل في تثبيت التبعيات"
        exit 1
    fi
    
    print_message "✅ تم تثبيت التبعيات بنجاح!"
}

# دالة لبناء المشروع
build_project() {
    print_info "🏗️ بناء المشروع..."
    
    # التحقق من وجود script البناء
    if ! grep -q '"build"' package.json; then
        print_error "❌ لا يوجد script بناء في package.json"
        exit 1
    fi
    
    npm run build
    if [ $? -ne 0 ]; then
        print_error "❌ فشل في بناء المشروع"
        exit 1
    fi
    
    # التحقق من وجود مجلد البناء
    if [ ! -d "out" ] && [ ! -d ".next" ] && [ ! -d "dist" ]; then
        print_error "❌ لم يتم إنشاء مجلد البناء"
        exit 1
    fi
    
    print_message "✅ تم بناء المشروع بنجاح!"
}

# دالة لإعداد متغيرات البيئة
setup_environment() {
    print_info "🔧 إعداد متغيرات البيئة..."
    
    # يمكن إضافة متغيرات البيئة هنا
    # مثال:
    # if [ -f ".env.example" ]; then
    #     cp .env.example .env
    #     print_warning "⚠️ يرجى تعديل ملف .env بالمتغيرات المطلوبة"
    # fi
    
    # إعداد متغيرات Cloudflare (إذا كانت مطلوبة)
    # wrangler secret put VARIABLE_NAME
    
    print_message "✅ تم إعداد متغيرات البيئة!"
}

# دالة لنشر المشروع
deploy_project() {
    print_info "🌐 نشر المشروع على Cloudflare Pages..."
    
    PROJECT_NAME="open-lovable4"
    
    # تحديد مجلد البناء
    BUILD_DIR=""
    if [ -d "out" ]; then
        BUILD_DIR="out"
    elif [ -d ".next" ]; then
        BUILD_DIR=".next"
    elif [ -d "dist" ]; then
        BUILD_DIR="dist"
    else
        print_error "❌ لم يتم العثور على مجلد البناء"
        exit 1
    fi
    
    print_info "استخدام مجلد البناء: $BUILD_DIR"
    
    # نشر المشروع
    wrangler pages publish "$BUILD_DIR" --project-name="$PROJECT_NAME"
    if [ $? -ne 0 ]; then
        print_error "❌ فشل في نشر المشروع"
        exit 1
    fi
    
    print_message "✅ تم نشر المشروع بنجاح!"
}

# دالة للتحقق من آخر نشر
check_deployment() {
    print_info "✅ التحقق من آخر نشر..."
    
    PROJECT_NAME="open-lovable4"
    
    wrangler pages deployments list --project-name="$PROJECT_NAME"
    if [ $? -ne 0 ]; then
        print_warning "⚠️ لا يمكن التحقق من النشرات"
    fi
}

# دالة رئيسية
main() {
    print_message "🚀 بدء عملية النشر التلقائي على Cloudflare Pages"
    print_message "=========================================="
    
    # التحقق من المتطلبات
    check_requirements
    
    # التحقق من تسجيل الدخول
    check_auth
    
    # إعداد المستودع
    setup_repository
    
    # تثبيت التبعيات
    install_dependencies
    
    # إعداد متغيرات البيئة
    setup_environment
    
    # بناء المشروع
    build_project
    
    # نشر المشروع
    deploy_project
    
    # التحقق من النشر
    check_deployment
    
    print_message "🎉 تم النشر بنجاح على Cloudflare Pages!"
    print_message "=========================================="
}

# تشغيل الدالة الرئيسية
main "$@"