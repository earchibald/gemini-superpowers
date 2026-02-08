#!/usr/bin/env bash
set -e

echo "🔍 Verifying Superpowers Installation"
echo "======================================"

# Check cache exists
if [ ! -d ~/.cache/superpowers ]; then
    echo "❌ Cache not found at ~/.cache/superpowers"
    exit 1
fi
echo "✓ Cache found"





echo ""
echo "✅ Installation verified successfully!"
echo "📢 Restart your terminal session or Gemini CLI client to activate."
