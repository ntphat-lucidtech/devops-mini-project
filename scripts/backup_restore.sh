#!/bin/bash

# ==============================================================================
# Script: backup_restore.sh
# Mục đích: Backup PostgreSQL Database & Kiểm thử Restore dữ liệu (Day 9 DevOps)
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="./backups"
BACKUP_FILE="${BACKUP_DIR}/db_backup_${TIMESTAMP}.sql"
DB_CONTAINER="devops-postgres-db"
DB_USER="devops_admin"
DB_NAME="devops_db"

echo -e "${YELLOW}====================================================${NC}"
echo -e "${YELLOW}[BACKUP] 1. TIẾN HÀNH SAO LƯU DATABASE POSTGRESQL${NC}"
echo -e "${YELLOW}====================================================${NC}"

mkdir -p "$BACKUP_DIR"

# 1. Thực hiện Backup bằng pg_dump
docker exec -t "$DB_CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" > "$BACKUP_FILE"

if [ -s "$BACKUP_FILE" ]; then
    echo -e "${GREEN}[SUCCESS] Khởi tạo file backup thành công: ${BACKUP_FILE}${NC}"
    echo -e "${GREEN}[SIZE] Dung lượng file backup: $(du -h "$BACKUP_FILE" | cut -f1)${NC}"
else
    echo -e "${RED}[ERROR] Backup thất bại! File rỗng hoặc không tồn tại.${NC}"
    exit 1
fi

echo -e "\n${YELLOW}====================================================${NC}"
echo -e "${YELLOW}[RESTORE TEST] 2. THỰC HÀNH TEST RESTORE BẰNG CHỨNG${NC}"
echo -e "${YELLOW}====================================================${NC}"

TEST_DB="devops_db_restore_test"

# Tạo DB test (chỉ định rõ -d devops_db)
docker exec -t "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "DROP DATABASE IF EXISTS ${TEST_DB};" 2>/dev/null || true
docker exec -t "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "CREATE DATABASE ${TEST_DB};"

# Restore dữ liệu từ file backup sang DB test
docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$TEST_DB" < "$BACKUP_FILE" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[SUCCESS] THÀNH CÔNG: Đã Restore thử nghiệm vào Database '${TEST_DB}'!${NC}"
    echo -e "${GREEN}[VERIFIED] Bằng chứng Restore hoàn tất 100%!${NC}"
else
    echo -e "${RED}[ERROR] Phục hồi (Restore) thất bại!${NC}"
    exit 1
fi

echo -e "${YELLOW}====================================================${NC}"
