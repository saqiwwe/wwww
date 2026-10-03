# Blue Knight Gate — Render Edition

پنل VLESS / VMess / Trojan / XHTTP روی **Render** — پوشه را به گیت‌هاب بفرست، در Render یک **Blueprint** بساز و تمام. هیچ متغیری لازم نیست.

A VLESS / VMess / Trojan / XHTTP panel for **Render** — push the folder to GitHub, create a Render **Blueprint**, done. No variables required.

> ## ⚠️ اگر کانفیگ‌ها بعد از هر دیپلوی از کار می‌افتند، اول این را بخوان
> سرویس رایگان Render دیسک دائمی ندارد؛ یعنی با هر **Deploy**، هر ری‌استارت و هر بار بیدار شدن از خواب، پوشهٔ داده پاک می‌شود و **UUID، رمز پنل و توکن اشتراک دوباره ساخته می‌شوند**. نتیجه: کانفیگ‌هایی که قبلاً کپی کرده‌ای وصل می‌شوند ولی **هیچ ترافیکی رد نمی‌شود و پینگ نمی‌آید**.
>
> **راه‌حل ۱ (بدون هزینه، پیش‌فرض همین پروژه):** فایل `render.yaml` از قبل `UUID` و `SUB_TOKEN` را با `generateValue` ثابت می‌کند و `PANEL_PASSWORD` را موقع ساخت سرویس از تو می‌پرسد. پس هویت ثابت می‌ماند و کانفیگ‌ها سالم می‌مانند.
> **راه‌حل ۲ (پیشنهادی، نیاز به پلن پول‌دار):** در `render.yaml` مقدار `plan: free` را به یک پلن پول‌دار عوض کن و بلوک `disk:` را از حالت کامنت دربیاور. از آن به بعد همه‌چیز (UUID، رمز، شمارندهٔ مصرف و موتورهای دانلودشده) بین دیپلوی‌ها می‌ماند و هیچ متغیری لازم نیست.
>
> ## ⚠️ If your configs stop working after every deploy, read this first
> A free Render service has no persistent disk, so on every **deploy**, restart and wake-up the data folder is thrown away and the **UUID, panel password and subscription token are regenerated** — previously copied configs then connect but pass no traffic and ping fails.
>
> **Fix 1 (free, already the default here):** `render.yaml` pins `UUID` and `SUB_TOKEN` with `generateValue` and asks you for `PANEL_PASSWORD` when the service is created, so the identity stays stable.
> **Fix 2 (recommended, needs a paid instance):** change `plan: free` to a paid plan and uncomment the `disk:` block in `render.yaml`. Everything then survives deploys and no variable is needed.

---

## فارسی

### راه‌اندازی
1. این پوشه را در یک ریپوی گیت‌هاب بگذار (یا همان ریپوی فعلی، در پوشهٔ `render/`).
2. در Render: **New → Blueprint** → ریپو را انتخاب کن. Render خودش `render.yaml` را می‌خواند.
3. موقع ساخت سرویس، رمز پنل را وارد کن (حداقل ۸ کاراکتر) — یا خالی بگذار.
4. صبر کن تا دیپلوی تمام شود؛ آدرس `https://<name>.onrender.com` ساخته می‌شود.
5. برو به `https://<name>.onrender.com/knight` و کانفیگ‌ها یا لینک اشتراک را کپی کن. همه روی پورت **443** و با **TLS** هستند.

پورت، دامنه و محل ذخیره خودکار تشخیص داده می‌شوند. `PORT` و `RENDER_EXTERNAL_HOSTNAME` را Render خودش ست می‌کند؛ دست نزن.

### تفاوت‌های Render که در کد لحاظ شده
- **تشخیص پلتفرم:** `RENDER` / `RENDER_EXTERNAL_HOSTNAME` → پنل می‌داند پشت edge است، پس همهٔ لینک‌ها TLS روی ۴۴۳ ساخته می‌شوند (نه `security=none` و نه پورت داخلی).
- **دامنه:** از `RENDER_EXTERNAL_HOSTNAME` خوانده می‌شود. اگر دامنهٔ شخصی وصل کنی، همان دامنه‌ای که پنل را با آن باز می‌کنی اولویت دارد.
- **پوشهٔ داده:** `RENDER_DISK_PATH` (دیسک دائمی) خودکار شناسایی می‌شود؛ وگرنه `./bk-data`.
- **بایند سریع پورت:** Render اگر سرویس زود روی `PORT` گوش ندهد دیپلوی را ناسالم می‌داند. این پروژه همان اول یک listener سبک روی پورت باز می‌کند که `/healthz` و `/` را با ۲۰۰ جواب می‌دهد، بعد از دانلود موتورها پورت را به روتر اصلی تحویل می‌دهد.
- **جلوگیری از خواب:** هر ۱۰ دقیقه یک درخواست به `/healthz` روی آدرس عمومی خودش می‌زند (سرویس رایگان بعد از ~۱۵ دقیقه بی‌کاری می‌خوابد). با `KEEP_ALIVE=false` خاموش می‌شود.
- **هلث‌چک:** `healthCheckPath: /healthz` در `render.yaml` (بدون احراز هویت، ۲۰۰).

### نکات مهم پلن رایگان
- **بعد از ~۱۵ دقیقه بی‌کاری می‌خوابد** (با keep-awake این پروژه جلوگیری می‌شود). بیدار شدن حدود یک دقیقه طول می‌کشد.
- **۷۵۰ ساعت اینستنس در ماه.** نگه‌داشتن همیشه‌روشن تقریباً همهٔ آن را مصرف می‌کند.
- **دیسک دائمی ندارد** → راه‌حل‌های بالا.
- **ممکن است سرویس رایگانی که حجم زیادی ترافیک خروجی به اینترنت می‌فرستد تعلیق شود.** یک پروکسی طبیعتاً پرترافیک است؛ اگر جدی استفاده می‌کنی پلن پول‌دار بگیر.
- موتورها (sing-box و Xray) با هر بیدار شدن دوباره از گیت‌هاب دانلود می‌شوند. با دیسک دائمی این مشکل هم حل می‌شود.

### اگر `onrender.com` فیلتر است
یک **Cloudflare Worker** جلوی سرویس بگذار و این هدر را ست کن:

`headers.set("X-Forwarded-Host", new URL(request.url).hostname)`

بعد پنل را از آدرس Worker باز کن (`https://<worker>.workers.dev/knight`). پنل همان دامنه را به‌عنوان آدرس، SNI و Host همهٔ کانفیگ‌ها ذخیره می‌کند و دیگر لازم نیست لینک را دستی عوض کنی. بازدید مستقیم از `onrender.com` این دامنه را عوض نمی‌کند. اگر متغیر `DOMAIN` بگذاری، همان اولویت دارد.

```js
export default {
  async fetch(request) {
    const url = new URL(request.url);
    const ORIGIN = 'https://<name>.onrender.com'; // آدرس سرویس Render

    const target = new URL(url.pathname + url.search, ORIGIN);
    const headers = new Headers(request.headers);
    headers.delete('host');
    headers.set('X-Forwarded-Host', url.hostname); // پنل این را به‌عنوان آدرس/SNI/Host ذخیره می‌کند
    headers.set('X-Forwarded-Proto', url.protocol.replace(':', ''));

    const init = { method: request.method, headers, redirect: 'manual' };
    if (request.method !== 'GET' && request.method !== 'HEAD') init.body = await request.arrayBuffer();

    const res = await fetch(target, init);
    const out = new Headers(res.headers);
    out.delete('content-encoding');
    out.delete('content-length');
    return new Response(res.body, { status: res.status, headers: out });
  }
};
```

روی Render می‌توانی مستقیم هم **Custom Domain** وصل کنی (Settings → Custom Domains) — ساده‌ترین راه. کوکی ورود (`bk_session`) روی همان دامنه ست می‌شود.

### عوض کردن آدرس، SNI و Host از خود پنل
توی تب **Subscriptions** کارت **Switch address, SNI and Host** هست: آدرس Worker یا دامنهٔ شخصی را بنویس و **Apply to all** را بزن. همان لحظه آدرس، SNI و Host همهٔ کانفیگ‌ها، لینک‌های اشتراک و QR کدها عوض می‌شوند — بدون دیپلوی دوباره. **Use auto** برمی‌گرداند به تشخیص خودکار.

### مصرف (Usage)
تب **Usage** مصرف هر کانفیگ را نشان می‌دهد: آپلود و دانلود، امروز، این ماه (از ۰۰:۰۰ UTC روز اول) و کل، به‌اضافهٔ سرعت لحظه‌ای. این عدد تخمینی است و داخل خود پنل شمرده می‌شود؛ عدد واقعی را از تب **Metrics** سرویس در داشبورد Render ببین. شمارنده در پوشهٔ داده می‌ماند و بدون دیسک دائمی با هر دیپلوی صفر می‌شود. **Sync** عدد ماه را دستی ست می‌کند و **Reset counter** همه‌چیز را پاک می‌کند (فقط بعد از ورود). متغیر اختیاری `TRAFFIC_LIMIT_GB` نوار پیشرفت و هشدار ۸۰٪ و ۱۰۰٪ را روشن می‌کند.

### بهینه‌ساز کانفیگ
دکمهٔ **بهینه‌ساز کانفیگ** بالای پنل و کنار کانفیگ‌ها است: https://arastey.github.io/cf-optimizor/

---

## English

### Setup
1. Put this folder in a GitHub repo (or keep it as the `render/` folder of your existing repo).
2. Render: **New → Blueprint** → pick the repo. Render reads `render.yaml` and creates the service.
3. When prompted, enter a panel password (8+ characters) — or leave it blank.
4. Wait for the deploy to finish. You get `https://<name>.onrender.com`.
5. Open `https://<name>.onrender.com/knight` and copy the configs or the subscription. Every link is port **443** with **TLS**.

Port, domain and storage are detected automatically. `PORT` and `RENDER_EXTERNAL_HOSTNAME` are set by Render — leave them alone.

### What was adapted for Render
- **Platform detection:** `RENDER` / `RENDER_EXTERNAL_HOSTNAME` tell the panel it sits behind an edge, so every generated link is TLS on 443 — never `security=none` and never the internal port.
- **Domain:** read from `RENDER_EXTERNAL_HOSTNAME`. If you attach a custom domain, the hostname you open the panel with wins.
- **Data folder:** `RENDER_DISK_PATH` (the attached persistent disk) is detected automatically, otherwise `./bk-data`.
- **Fast port bind:** Render treats a service that does not bind `PORT` promptly as unhealthy, but the real multiplexer only binds after sing-box / Xray-core have downloaded. The app opens a lightweight listener on the port first that answers `/healthz` and `/` with 200, then hands the port over to the real router.
- **Anti-sleep:** every 10 minutes it requests `/healthz` on its own public URL, because a free instance sleeps after ~15 idle minutes. Disable with `KEEP_ALIVE=false`.
- **Health check:** `healthCheckPath: /healthz` in `render.yaml` (unauthenticated, returns 200).

### Free-plan caveats
- **Sleeps after ~15 idle minutes** (this project keeps itself awake by default). Waking up takes about a minute.
- **750 instance hours per month** — staying awake around the clock uses nearly all of them.
- **No persistent disk** — see the fixes at the top.
- **A free service that initiates a lot of outbound internet traffic may be suspended.** A proxy is by nature high-traffic; use a paid instance for real use.
- The engines (sing-box and Xray) are re-downloaded from GitHub on every cold start. A persistent disk removes that too.

### If `onrender.com` is filtered
Put a **Cloudflare Worker** in front of the service and set:

`headers.set("X-Forwarded-Host", new URL(request.url).hostname)`

Open the panel through the Worker (`https://<worker>.workers.dev/knight`). The panel saves that hostname and uses it as the address, SNI and Host in every config and subscription, so nobody edits a link by hand. A later visit through `onrender.com` does not replace it. A `DOMAIN` variable, if set, still wins. The Worker snippet is in the Persian section above.

You can also attach a **Custom Domain** directly on Render (Settings → Custom Domains) — the simplest option. The login cookie (`bk_session`) is set on that same domain.

### Switch address, SNI and Host from the panel
The **Subscriptions** tab has a **Switch address, SNI and Host** card: type the Worker or custom domain, press **Apply to all**, and the address, SNI and Host of every config — plus all subscription links and QR codes — switch instantly, with no redeploy. **Use auto** returns to automatic detection.

### Usage
The **Usage** tab shows upload and download per config for today, this month (from 00:00 UTC on the 1st) and all time, plus live speed. It is an estimate counted inside the panel; the real figure is on your service's **Metrics** tab in the Render dashboard. The counter lives in the data folder and is reset by any redeploy when no disk is attached. **Sync** sets this month's number by hand. **Reset counter** clears it (login required). Optional `TRAFFIC_LIMIT_GB` adds a progress bar and warnings at 80% and 100%.

### Config optimizer
The **بهینه‌ساز کانفیگ** button (header and next to the configs) opens https://arastey.github.io/cf-optimizor/ in a new tab.

### Other deployment options
- **Docker:** the bundled `Dockerfile` builds the same app on `node:22-bookworm-slim` with `tar` and CA certificates installed. In `render.yaml` set `runtime: docker` and delete `buildCommand` / `startCommand`.
- **Local run:** `npm ci && npm start`, then open `http://localhost:8080/knight`. Set `PANEL_PASSWORD` to skip the first-run setup. Locally the app treats itself as self-hosted (plain HTTP, port 8080); it only switches to edge/TLS mode when `RENDER` or the Replit variables are present.

<details>
<summary><b>Optional environment variables / متغیرهای اختیاری</b></summary>

| Variable | Default | Meaning |
|---|---|---|
| `UUID` | generated (pinned by render.yaml) | Fixed UUID |
| `PANEL_PASSWORD` | first-run setup in the panel | Fixed panel password (8+ characters) |
| `SUB_TOKEN` | generated (pinned by render.yaml) | Fixed subscription token |
| `SETUP_KEY` | empty | Extra key required when creating the password |
| `RESET_PANEL_PASSWORD` | – | `true`, redeploy, set a new password, then delete it |
| `DOMAIN` | Render hostname, or the host you opened the panel with | Force the domain in links |
| `FORCE_HOST` | – | Force the link address; SNI and Host stay on the domain |
| `KEEP_ALIVE` | `true` on Render | Ping our own public URL so the instance does not sleep |
| `KEEP_ALIVE_URL` | `RENDER_EXTERNAL_URL` + `/healthz` | Custom keep-alive target |
| `TRAFFIC_LIMIT_GB` | none | Monthly allowance (GiB) for the Usage bar |
| `BK_DATA_DIR` | auto (`RENDER_DISK_PATH`, then `./bk-data`) | Data folder |
| `LINK_FP` | `chrome` | uTLS fingerprint, or `none` |
| `LINK_ALPN` | `http/1.1` | ALPN for WebSocket links |
| `LINK_PORT` / `LINK_TLS` | `443` / on | Not needed on Render |
| `ENABLE_XHTTP` and the other `ENABLE_*` flags | on | Set `false` to hide one config |
| `PORT` | set by Render (`10000`) | Listening port — do not override |

</details>
