# إعداد EGO STORE

1. افتح `index.html` ببرنامج محرر نصوص مثل VS Code أو Notepad.
2. ابحث عن:
   - `PASTE_PROJECT_URL_HERE`
   - `PASTE_PUBLISHABLE_KEY_HERE`
3. استبدلهما بـ API URL و Publishable key من مشروع Supabase. لا تستخدم Secret key أبداً.
4. استبدل `201000000000` في `WHATSAPP_NUMBER` برقم واتساب المتجر بصيغة دولية بدون علامة + (مثال مصر يبدأ بـ 20).
5. في Supabase شغّل `supabase.sql` إذا لم تكن قد شغّلت SQL سابقاً. إذا كنت شغّلته بالفعل فلا تعِد تشغيله إلا عند الحاجة.
6. أنشئ مستخدم المدير من Authentication ثم أضف UUID الخاص به في جدول `public.admins` باستخدام SQL:
   `insert into public.admins (user_id) values ('UUID-HERE');`
7. ارفع مجلد المشروع إلى GitHub ثم اربطه بـ Vercel للنشر.

## ملاحظات
- لوحة الإدارة تتيح تسجيل الدخول وإضافة/تعديل/حذف المنتجات.
- تأكد من أن حساب المدير أُضيف إلى جدول admins.
- Publishable key مصمم للاستخدام في الواجهة مع سياسات RLS. Secret key سري ولا يوضع في المتصفح أو GitHub.
- هذه نسخة أولية: الدفع اليدوي، حساب الشحن، حفظ الطلبات في قاعدة البيانات، ورفع ملفات تصاميم العملاء تحتاج تطويراً قبل الإطلاق.
