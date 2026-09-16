#!/bin/bash

# ==============================================================================
# Script: monitor_slack.sh
# Mục đích: Giám sát Uptime Container & Gửi Cảnh báo về Slack (Day 9 DevOps)
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SLACK_WEBHOOK_URL=${SLACK_WEBHOOK_URL:-"https://hooks.slack.com/services/DEMO/WEBHOOK/URL"}
CONTAINERS=("devops-postgres-db" "devops-backend-api" "devops-frontend-app")

send_slack_alert() {
    local message="$1"
    echo -e "${RED}[SLACK ALERT SENT] ${message}${NC}"
    curl -s -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"🚨 *[ALERT - DEV SERVER]* \\n${message}\"}" \
        "$SLACK_WEBHOOK_URL" > /dev/null 2>&1 || true
}

echo -e "${YELLOW}====================================================${NC}"
echo -e "${YELLOW}[MONITOR] ĐANG KIỂM TRA SỨC KHỎE HỆ THỐNG...${NC}"
echo -e "${YELLOW}====================================================${NC}"

for container in "${CONTAINERS[@]}"; do
    STATUS=$(docker inspect -f '{{.State.Status}}' "$container" 2>/dev/null || echo "not_found")
    if [ "$STATUS" == "running" ]; then
        echo -e "${GREEN}[OK] Container '$container' đang RUNNING.${NC}"
    else
        echo -e "${RED}[FAIL] Container '$container' ĐANG BỊ SẬP (Status: $STATUS)!${NC}"
        send_slack_alert "❌ Cảnh báo: Container \`$container\` trên Server Dev đang bị sập! Status: \`$STATUS\`."
    fi
done

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/health)
if [ "$HTTP_STATUS" == "200" ]; then
    echo -e "${GREEN}[OK] Backend Health Check: HTTP 200 OK.${NC}"
else
    echo -e "${RED}[FAIL] Backend Health Check thất bại! HTTP Status: $HTTP_STATUS${NC}"
    send_slack_alert "⚠️ Cảnh báo: Backend Service tại port 5000 không phản hồi! HTTP Code: \`$HTTP_STATUS\`."
fi

echo -e "${YELLOW}====================================================${NC}"
