# Fix "No Space Left on Device" Error

## Quick Fix Commands

Run these commands in your terminal to free up disk space:

### 1. Clean Flutter Build Cache
```bash
cd /Users/mac/nodejs-projects/smart-coba/kms-mobile
flutter clean
```

### 2. Clean Gradle Cache (This is the main culprit)
```bash
# Clean Gradle transforms cache (where the error occurred)
rm -rf ~/.gradle/caches/transforms-4/*

# Clean Gradle build cache
rm -rf ~/.gradle/caches/build-cache-*

# Clean Gradle wrapper cache
rm -rf ~/.gradle/wrapper/dists/*

# Optional: Clean entire Gradle cache (more aggressive)
# rm -rf ~/.gradle/caches/*
```

### 3. Clean Android Build Cache
```bash
cd /Users/mac/nodejs-projects/smart-coba/kms-mobile/android
./gradlew clean
rm -rf .gradle
rm -rf build
rm -rf app/build
```

### 4. Clean Flutter Pub Cache (if needed)
```bash
flutter pub cache clean
```

### 5. Check Disk Space
```bash
# Check overall disk usage
df -h /

# Check specific directories
du -sh ~/.gradle/caches
du -sh ~/.gradle/daemon
du -sh ~/Library/Caches
du -sh /Users/mac/nodejs-projects/smart-coba/kms-mobile/build
```

### 6. Additional Cleanup (if still low on space)
```bash
# Clean Xcode derived data (if you have Xcode)
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Clean npm cache (if you have Node.js projects)
npm cache clean --force

# Clean Homebrew cache (if you use Homebrew)
brew cleanup --prune=all

# Clean system caches
rm -rf ~/Library/Caches/*
```

## After Cleanup

1. **Restart your terminal** or source your shell profile
2. **Try building again:**
   ```bash
   cd /Users/mac/nodejs-projects/smart-coba/kms-mobile
   flutter pub get
   flutter run
   ```

## Prevention

To prevent this in the future:

1. **Regularly clean Gradle cache:**
   ```bash
   # Add to your ~/.zshrc or ~/.bashrc
   alias gradle-clean='rm -rf ~/.gradle/caches/transforms-4/*'
   ```

2. **Monitor disk space:**
   ```bash
   # Check disk space regularly
   df -h /
   ```

3. **Use Gradle daemon stop** (if builds are hanging):
   ```bash
   cd /Users/mac/nodejs-projects/smart-coba/kms-mobile/android
   ./gradlew --stop
   ```

## If Still Having Issues

If you're still getting "No space left on device" after cleanup:

1. **Check for large files:**
   ```bash
   # Find large files in your home directory
   find ~ -type f -size +1G -exec ls -lh {} \; 2>/dev/null | head -20
   ```

2. **Check for large directories:**
   ```bash
   # Find large directories
   du -h ~ | sort -h | tail -20
   ```

3. **Empty Trash:**
   ```bash
   rm -rf ~/.Trash/*
   ```

4. **Consider moving projects to external drive** if disk is consistently full





