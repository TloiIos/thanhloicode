# FloatingMenuDemo (app iOS độc lập, build ra .ipa qua GitHub Actions)

App SwiftUI độc lập, **không hook hệ thống, không đụng tới app khác** — chỉ
có 1 nút nổi kéo-thả ngay trong chính app, bấm vào mở ra panel demo với vài
switch (Battery Info, Clock Overlay...). Icon app dùng ảnh hoa bạn cung cấp.

Vì build `.ipa` cần máy macOS + Xcode thật (bạn không có Mac), project này
dùng **GitHub Actions** để build tự động trên máy ảo macOS miễn phí của
GitHub — bạn chỉ cần tài khoản GitHub, làm hoàn toàn trên Windows.

## Bước 1: Tạo tài khoản GitHub (nếu chưa có)

Vào https://github.com → Sign up.

## Bước 2: Tạo repository mới

1. Bấm **New repository**
2. Đặt tên bất kỳ, ví dụ `floating-menu-demo`
3. Chọn **Private** (khuyến nghị) hoặc Public
4. Bấm **Create repository**

## Bước 3: Upload project lên GitHub (không cần dùng lệnh `git` nếu ngại)

Cách dễ nhất trên Windows:

1. Giải nén file `FloatingMenuApp.zip` mình gửi ra 1 thư mục
2. Vào trang repository vừa tạo trên GitHub
3. Bấm **"uploading an existing file"** (hoặc **Add file → Upload files**)
4. Kéo **toàn bộ nội dung bên trong thư mục** `FloatingMenuApp` (không kéo cả
   thư mục cha) vào khung upload — bao gồm cả thư mục `.github` (ẩn, nếu
   Windows Explorer không hiện, bật "Show hidden items" trước khi kéo, hoặc
   dùng cách `git` bên dưới để chắc chắn không sót)
5. Bấm **Commit changes**

**Cách chắc chắn hơn (khuyến nghị) — dùng Git trong WSL, bạn đã có sẵn WSL rồi:**

```bash
cd ~
cp -r /mnt/c/Users/lmod8/Downloads/FloatingMenuApp ~/FloatingMenuApp
cd ~/FloatingMenuApp
git init
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin https://github.com/<ten-github-cua-ban>/floating-menu-demo.git
git push -u origin main
```

(Lần đầu push, GitHub sẽ hỏi đăng nhập — dùng Personal Access Token thay vì
mật khẩu, tạo tại: Settings → Developer settings → Personal access tokens)

## Bước 4: Chạy build

1. Vào tab **Actions** trong repository trên GitHub
2. Bạn sẽ thấy workflow **"Build IPA"**
3. Nếu nó không tự chạy, bấm **Run workflow** (nút màu xanh, do khai báo
   `workflow_dispatch` trong file `.github/workflows/build-ipa.yml`)
4. Đợi khoảng 3–6 phút để máy ảo macOS build xong

## Bước 5: Tải file .ipa về

1. Sau khi workflow chạy xong (dấu tick xanh ✓), bấm vào lần chạy đó
2. Kéo xuống phần **Artifacts**
3. Tải file **FloatingMenuDemo-ipa.zip** về — giải nén ra sẽ có
   `FloatingMenuDemo.ipa`

## Bước 6: Cài lên iPhone

File `.ipa` này **không ký** (unsigned) — TrollStore cài trực tiếp được
(TrollStore tự fake-sign khi cài):

1. Chuyển file `FloatingMenuDemo.ipa` sang iPhone (Google Drive/Zalo/email)
2. Mở bằng **TrollStore** → chọn **Install**

Nếu bạn không dùng TrossStore mà dùng Sideloadly/AltStore (máy chưa
jailbreak), 2 công cụ này cần ký bằng Apple ID free — chúng sẽ tự lo phần ký
khi bạn chọn file `.ipa` để cài, không cần bạn làm gì thêm.

## Cấu trúc project

```
FloatingMenuApp/
├── project.yml                        # định nghĩa project cho XcodeGen
├── .github/workflows/build-ipa.yml    # workflow build tự động
└── FloatingMenuApp/
    ├── FloatingMenuAppApp.swift       # entry point
    ├── ContentView.swift              # màn hình chính
    ├── FloatingBubbleOverlay.swift    # nút nổi + panel toggle demo
    ├── Info.plist
    └── Assets.xcassets/AppIcon.appiconset/   # icon app (ảnh hoa bạn gửi)
```

## Vì sao cách này không bị lỗi "Parse Error 301" như trước

File `.ipa` được build ra từ đây có đúng cấu trúc chuẩn Apple:

```
FloatingMenuDemo.ipa (zip)
└── Payload/
    └── FloatingMenuDemo.app/
        ├── Info.plist
        ├── FloatingMenuDemo (executable Mach-O thật)
        └── Assets.car (icon đã build)
```

Đây là 1 app thật, biên dịch từ Swift bằng Xcode/xcodebuild thật trên máy ảo
macOS — khác hoàn toàn với file `.deb` (tweak) không thể ép thành `.ipa` như
lần trước.
