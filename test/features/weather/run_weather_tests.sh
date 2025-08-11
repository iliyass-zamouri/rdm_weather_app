#!/bin/bash

echo "🧪 Running Weather Feature Tests..."
echo "=================================="

# Run weather tests with expanded output
flutter test test/features/weather/ --reporter=expanded

echo ""
echo "✅ Weather Feature Tests Complete!"
