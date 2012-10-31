curl -X POST --data-urlencode name="Crowdtilt API" \
    --data-urlencode content@README.md \
    http://documentup.com/compiled > index.html

git add index.html
git commit -m "Update index.html"
