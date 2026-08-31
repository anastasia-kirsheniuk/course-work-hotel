# Telegram-бот для сповіщень про перевищення електроспоживання
# Варіант №2 - Контроль електроспоживання в готелі

import requests
import json
import time

# Налаштування бота (заміни на свої значення)
BOT_TOKEN = "YOUR_BOT_TOKEN_HERE"
CHAT_ID = "YOUR_CHAT_ID_HERE"

# Налаштування MQTT
MQTT_BROKER = "broker.hivemq.com"
MQTT_PORT = 1883
MQTT_TOPIC = "hotel/room/+"

# Ліміт споживання (кВт·год)
DAILY_LIMIT = 50.0
HOURLY_SPIKE_LIMIT = 10.0

def send_telegram_message(message):
    """Надсилання повідомлення в Telegram"""
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id": CHAT_ID,
        "text": message,
        "parse_mode": "HTML"
    }
    
    try:
        response = requests.post(url, json=payload)
        if response.status_code == 200:
            print(f"Повідомлення надіслано: {message}")
        else:
            print(f"Помилка: {response.status_code}")
    except Exception as e:
        print(f"Помилка надсилання: {e}")

def check_consumption(data):
    """Перевірка споживання та надсилання сповіщень"""
    room_id = data.get("room_id", "unknown")
    kwh_hour = data.get("kwh_hour", 0)
    kwh_total = data.get("kwh_total", 0)
    
    # Перевірка перевищення погодинного ліміту
    if kwh_hour > HOURLY_SPIKE_LIMIT:
        message = f"⚠️ <b>УВАГА!</b>\n\n"
        message += f"Номер: <b>{room_id}</b>\n"
        message += f"Різкий стрибок споживання!\n"
        message += f"За годину: <b>{kwh_hour:.2f} кВт·год</b>\n"
        message += f"Ліміт: {HOURLY_SPIKE_LIMIT} кВт·год"
        send_telegram_message(message)
    
    # Перевірка добового ліміту
    if kwh_total > DAILY_LIMIT:
        message = f"🚨 <b>КРИТИЧНО!</b>\n\n"
        message += f"Номер: <b>{room_id}</b>\n"
        message += f"Перевищено добовий ліміт!\n"
        message += f"Всього: <b>{kwh_total:.2f} кВт·год</b>\n"
        message += f"Ліміт: {DAILY_LIMIT} кВт·год"
        send_telegram_message(message)

def main():
    """Головна функція"""
    print("Telegram-бот для контролю електроспоживання запущено")
    print(f"Ліміт добовий: {DAILY_LIMIT} кВт·год")
    print(f"Ліміт погодинний: {HOURLY_SPIKE_LIMIT} кВт·год")
    
    # Приклад тестових даних
    test_data = {
        "room_id": "101",
        "timestamp": "2026-08-31T10:30:00Z",
        "kwh_total": 52.5,
        "kwh_hour": 11.2,
        "pulse_count": 52500
    }
    
    check_consumption(test_data)

if __name__ == "__main__":
    main()
