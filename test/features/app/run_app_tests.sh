#!/bin/bash

echo "📱 Running App Feature Tests..."
echo "==============================="

# Run app tests with expanded output
flutter test test/features/app/ --reporter=expanded

echo ""
echo "✅ App Feature Tests Complete!"
