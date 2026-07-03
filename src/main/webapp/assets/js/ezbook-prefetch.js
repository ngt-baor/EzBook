(function () {
    "use strict";

    const config = window.EZBOOK_PREFETCH || {};
    const urls = Array.from(new Set(Array.isArray(config.urls) ? config.urls : []))
        .filter((url) => typeof url === "string" && url.trim().length > 0);
    const healthUrl = typeof config.healthUrl === "string" ? config.healthUrl : "";
    const warmed = new Set();

    if (navigator.connection && navigator.connection.saveData) {
        return;
    }

    function runWhenIdle(callback) {
        if ("requestIdleCallback" in window) {
            window.requestIdleCallback(callback, {timeout: 1800});
            return;
        }
        window.setTimeout(callback, 900);
    }

    function wait(ms) {
        return new Promise((resolve) => window.setTimeout(resolve, ms));
    }

    async function warmUrl(url, timeoutMs) {
        if (!url || warmed.has(url)) {
            return;
        }
        warmed.add(url);

        const controller = new AbortController();
        const timer = window.setTimeout(() => controller.abort(), timeoutMs);

        try {
            await fetch(url, {
                method: "GET",
                credentials: "same-origin",
                cache: "force-cache",
                signal: controller.signal,
                headers: {
                    "X-EZBook-Prefetch": "1"
                }
            });
        } catch (ignored) {
            // Prefetch must never block the user-facing page.
        } finally {
            window.clearTimeout(timer);
        }
    }

    runWhenIdle(async function () {
        for (const url of urls) {
            if (document.visibilityState === "hidden") {
                break;
            }
            await warmUrl(url, 12000);
            await wait(450);
        }
    });

    document.addEventListener("pointerenter", function (event) {
        const link = event.target && event.target.closest ? event.target.closest("a[href]") : null;
        if (!link) {
            return;
        }
        const href = link.getAttribute("href");
        if (href && urls.includes(href)) {
            warmUrl(href, 8000);
        }
    }, true);

    if (healthUrl) {
        window.setInterval(function () {
            if (document.visibilityState !== "visible") {
                return;
            }
            warmUrl(healthUrl + "?t=" + Date.now(), 5000);
        }, 240000);
    }
})();
