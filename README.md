# agent-skill

Kho lưu trữ trung tâm (Centralized Hub) chứa toàn bộ **AI Agents**, **Skills**, **Workflow Commands**, **Rules** và cấu hình **MCP Servers** cho **Claude Code** và **Codex CLI**.

Khi chuyển máy hoặc cài đặt môi trường mới, chỉ cần clone repo này về và chạy 1 lệnh sync là có đầy đủ toàn bộ công cụ.

---

## 1. Cấu trúc Thư mục

`	ext
agent-skill/
├── claude/                  # Toàn bộ cấu hình dành cho Claude Code (~/.claude)
│   ├── agents/              # Custom Claude Agents frontmatter (.md)
│   ├── skills/              # Claude Code Skills
│   ├── commands/            # Slash Commands
│   └── CLAUDE.md            # Global User Instructions
├── codex/                   # Toàn bộ cấu hình dành cho Codex CLI (~/.codex)
│   ├── agents/              # Codex Custom Agents
│   ├── skills/              # Codex Skills
│   ├── rules/               # Codex Engineering Rules
│   └── AGENTS.md            # Codex Global Instructions
├── mcp/                     # Cấu hình MCP Servers kết nối Obot & Local
│   └── .mcp.json            # Template MCP config chuẩn
└── scripts/                 # Scripts tự động đồng bộ
    ├── sync.ps1             # Đồng bộ cho Windows PowerShell
    └── sync.sh              # Đồng bộ cho Linux / macOS / Bash
`

---

## 2. Hướng dẫn Sử dụng & Đồng bộ

### Bước 1: Clone Repository về máy
`ash
git clone https://github.com/lamld01/agent-skill.git
cd agent-skill
`

### Bước 2: Chạy lệnh Đồng bộ

#### Trên Windows (PowerShell):
`powershell
.\scripts\sync.ps1
`

#### Trên Linux / macOS / Git Bash:
`ash
chmod +x scripts/sync.sh
./scripts/sync.sh
`

---

## 3. Cách thêm mới / cập nhật Agent hoặc Skill

1. Thêm hoặc chỉnh sửa Agent/Skill trong thư mục claude/ hoặc codex/ tương ứng.
2. Commit và push lên GitHub:
   `ash
   git add .
   git commit -m "feat: add new trading analysis skill"
   git push origin main
   `
3. Ở máy khác chỉ cần git pull và chạy lại sync.ps1 hoặc sync.sh.
