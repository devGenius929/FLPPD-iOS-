mv Podfile Podfile.back
rm Podfile.lock
rm -rf FLPPD.xcworkspace
rm -rf Pods
pod init
mv Podfile.back Podfile
pod install
open FLPPD.xcworkspace
