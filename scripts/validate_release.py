#!/usr/bin/env python3
"""
validate_release.py
Проверяет структуру пакета релиза перед запуском CI.
Если чего-то нет — выходит с кодом 1 (CI упадёт).

Использование:
  python scripts/validate_release.py --version 2.1.0 --mode all
"""

import os
import sys
import json
import argparse

# ─── Константы ────────────────────────────────────────────────
LOCALES = [
    "en-US", "ru", "es-ES", "de-DE", "ja",
    "zh-Hans", "fr-FR", "it-IT", "pt-BR", "ko", "ar-SA"
]
DEVICES = ["iPhone_6.7", "iPhone_6.5", "iPad_12.9"]

METADATA_FILES = [
    "name.txt",
    "subtitle.txt",
    "description.txt",
    "keywords.txt",
    "release_notes.txt"
]

EVENT_LOCALE_FILES = [
    "event_name.txt",
    "short_description.txt",
    "long_description.txt"
]

errors = []
warnings = []


def error(msg):
    errors.append(f"❌ {msg}")


def warn(msg):
    warnings.append(f"⚠️  {msg}")


def check_file_exists(path, label=""):
    if not os.path.isfile(path):
        error(f"Missing file: {path}" + (f" ({label})" if label else ""))
        return False
    if os.path.getsize(path) == 0:
        warn(f"Empty file: {path}")
    return True


def check_dir_not_empty(path, label=""):
    if not os.path.isdir(path):
        error(f"Missing directory: {path}" + (f" ({label})" if label else ""))
        return False
    pngs = [f for f in os.listdir(path) if f.endswith(".png")]
    if len(pngs) == 0:
        warn(f"No PNG files in: {path}")
    return True


# ─── Validators ───────────────────────────────────────────────

def validate_listing(base):
    print("🔍 Validating listing...")

    # Metadata
    for locale in LOCALES:
        for fname in METADATA_FILES:
            path = os.path.join(base, "listing", "metadata", locale, fname)
            check_file_exists(path)

    # Manifest
    manifest_path = os.path.join(base, "listing", "manifest.json")
    if check_file_exists(manifest_path, "listing manifest"):
        with open(manifest_path) as f:
            m = json.load(f)
        variant = m.get("variant_to_upload", "A")

        # Framed screenshots
        for locale in LOCALES:
            for device in DEVICES:
                path = os.path.join(base, "listing", "screenshots", "framed", variant, locale, device)
                check_dir_not_empty(path, f"framed/{variant}")


def validate_ppo(base):
    print("🔍 Validating PPO...")

    manifest_path = os.path.join(base, "ppo", "manifest.json")
    if not check_file_exists(manifest_path, "PPO manifest"):
        return

    with open(manifest_path) as f:
        m = json.load(f)

    for variant in m.get("variants", ["A", "B"]):
        for locale in m.get("locales", LOCALES):
            for device in m.get("devices", DEVICES):
                path = os.path.join(base, "ppo", variant, locale, device)
                check_dir_not_empty(path, f"PPO/{variant}")

    # Проверяем что у A и B одинаковое количество скринов
    counts = {}
    for variant in ["A", "B"]:
        total = 0
        for locale in LOCALES:
            for device in DEVICES:
                d = os.path.join(base, "ppo", variant, locale, device)
                if os.path.isdir(d):
                    total += len([f for f in os.listdir(d) if f.endswith(".png")])
        counts[variant] = total

    if counts.get("A", 0) != counts.get("B", 0):
        warn(f"PPO: variant A has {counts.get('A')} PNGs, B has {counts.get('B')} — should match")


def validate_cpp(base):
    print("🔍 Validating CPP...")

    manifest_path = os.path.join(base, "cpp", "manifest.json")
    if not check_file_exists(manifest_path, "CPP root manifest"):
        return

    with open(manifest_path) as f:
        m = json.load(f)

    for page in m.get("pages", []):
        key = page["key"]
        page_manifest = os.path.join(base, "cpp", key, "manifest.json")
        if not check_file_exists(page_manifest, f"CPP page manifest: {key}"):
            continue
        with open(page_manifest) as f:
            pm = json.load(f)
        for locale in pm.get("locales", LOCALES):
            for device in pm.get("devices", DEVICES):
                path = os.path.join(base, "cpp", key, locale, device)
                check_dir_not_empty(path, f"CPP/{key}/{locale}/{device}")


def validate_events(base):
    print("🔍 Validating Events...")

    manifest_path = os.path.join(base, "events", "manifest.json")
    if not check_file_exists(manifest_path, "Events manifest"):
        return

    with open(manifest_path) as f:
        m = json.load(f)

    for event_key in m.get("events", []):
        event_dir = os.path.join(base, "events", event_key)

        # config.json
        check_file_exists(os.path.join(event_dir, "config.json"), f"{event_key}/config.json")

        # card.png
        check_file_exists(os.path.join(event_dir, "media", "card.png"), f"{event_key}/card.png")

        # locales
        for locale in LOCALES:
            for fname in EVENT_LOCALE_FILES:
                path = os.path.join(event_dir, "locales", locale, fname)
                check_file_exists(path)


# ─── Main ─────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--version", required=True)
    parser.add_argument("--mode",    required=True,
                        choices=["all", "listing", "ppo", "cpp", "events"])
    args = parser.parse_args()

    base = os.path.join("releases", args.version)

    if not os.path.isdir(base):
        print(f"❌ Release directory not found: {base}")
        sys.exit(1)

    mode = args.mode

    if mode in ("listing", "all"):
        validate_listing(base)
    if mode in ("ppo", "all"):
        validate_ppo(base)
    if mode in ("cpp", "all"):
        validate_cpp(base)
    if mode in ("events", "all"):
        validate_events(base)

    # ── Итог ──
    print()
    if warnings:
        for w in warnings:
            print(w)
        print()

    if errors:
        for e in errors:
            print(e)
        print()
        print(f"🚫 Validation FAILED: {len(errors)} error(s). Fix them before release.")
        sys.exit(1)
    else:
        print(f"✅ Validation passed! (mode={mode}, version={args.version})")
        if warnings:
            print(f"   {len(warnings)} warning(s) — check them above.")


if __name__ == "__main__":
    main()
