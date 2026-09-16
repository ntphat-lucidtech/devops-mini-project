# 📖 RUNBOOK VẬN HÀNH & XỬ LÝ SỰ CỐ (DOCUMENTS.LUCIDTECH.VN)

**Sản phẩm:** Mini-Project Intern DevOps Stack  
**Môi trường:** Server Dev (`*.lucidtech.vn`)  
**Tác giả:** Intern DevOps Track  

---

## 1. TỔNG QUAN KIẾN TRÚC HỆ THỐNG

- **Web Server / Reverse Proxy:** Nginx (HTTPS 443 -> HTTP 80 -> Proxy 3000 / 5000)
- **Frontend Container:** Next.js (Node 20 Alpine) - Port `3000`
- **Backend Container:** .NET 8 Web API - Port `5000` (`8080` container)
- **Database Container:** PostgreSQL 16 Alpine - Port `5432` (Volume persistent `postgres_data`)
- **CI/CD:** GitHub Actions (Build, Test, Push GHCR, Auto-Deploy & Rollback)

---

## 2. QUY TRÌNH THAO TÁC VẬN HÀNH HÀNG NGÀY

### Khởi chạy hệ thống:
```bash
docker compose up -d
```

### Xem trạng thái & Log:
```bash
docker compose ps
docker logs -f devops-backend-api
```

---

## 3. QUY TRÌNH SAO LƯU & KHÔI PHỤC DATABASE

### Thực hiện Backup & Restore thử nghiệm:
```bash
chmod +x scripts/backup_restore.sh
./scripts/backup_restore.sh
```

### Restore khi xảy ra sự cố:
```bash
docker exec -i devops-postgres-db psql -U devops_admin -d devops_db < ./backups/<file_backup>.sql
```

---

## 4. CHECKLIST HƯỚNG DẪN XỬ LÝ SỰ CỐ (INCIDENT TROUBLESHOOTING)

- **502 Bad Gateway:** Kiểm tra Nginx (`sudo systemctl status nginx`) và container (`docker ps`).
- **Backend mất kết nối DB:** Kiểm tra health DB (`docker inspect -f '{{.State.Health.Status}}' devops-postgres-db`).
- **Cần Rollback:** Vào GitHub Actions -> Run workflow `Rollback Deployment`.

---

## 5. THÔNG TIN LIÊN HỆ BÁO BÁO SỰ CỐ
- **Mentors:** Shane (Thái Ngọc Tuấn Sang), Keith, Anna
- **Kênh Slack:** `#devops-alerts`
