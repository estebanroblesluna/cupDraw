ulimit -n 1024
jake clean install
cd ../src/main/webapp
capp gen -f --force -F CupDraw webspec
cd webspec/Frameworks
cd ../../../../../CupDraw