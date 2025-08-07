@echo off

echo Building frontend...
cd frontend
call npm install
call npm run build
cd ..

echo Setting up Python venv...
cd backend
python -m venv venv
call venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt
call venv\Scripts\deactivate
cd ..

echo Build complete.