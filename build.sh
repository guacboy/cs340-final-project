#!/usr/bin/env bash
set -e

echo "Building frontend..."
cd frontend
npm install
npm run build
cd ..

echo "Setting up Python venv..."
cd backend
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
deactivate
cd ..

echo "Build complete."