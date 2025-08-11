#!/bin/bash

echo "🌤️ Running Forecast Feature Tests..."
echo "===================================="

# Run forecast tests with expanded output
flutter test test/features/forecast/ --reporter=expanded

echo ""
echo "✅ Forecast Feature Tests Complete!"
