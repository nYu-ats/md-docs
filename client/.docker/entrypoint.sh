#!/bin/sh

if [ ! -e './app' ]; then
  echo "set up application..."
  npx create-next-app app --ts --eslint --tailwind --app --use-npm --src-dir --turbopack --import-alias "@/*"
else
  cd ./app
  npm install 
fi

exec "$@"