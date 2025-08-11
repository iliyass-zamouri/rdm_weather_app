#!/bin/bash

echo "🚀 Running All Feature Tests..."
echo "================================"

# Run app tests
echo ""
echo "📱 App Feature Tests:"
flutter test test/features/app/ --reporter=compact

# Run weather tests
echo ""
echo "🧪 Weather Feature Tests:"
flutter test test/features/weather/ --reporter=compact

echo ""
echo "🌤️ Forecast Feature Tests:"
flutter test test/features/forecast/ --reporter=compact

echo ""
echo "📊 Test Summary:"
flutter test test/ --reporter=compact

echo ""
echo "✅ All Tests Complete!"
