# Data Requirement Specification

Đặc tả dữ liệu nghiệp vụ: fields, constraints, lifecycle, audit.

## Khi nào dùng
- Feature tạo/sửa dữ liệu
- Cần thống nhất data semantics trước design schema
- Có lifecycle hoặc audit requirements

## Output
| Field | Meaning | Type | Required | Validation | Sensitive | Audit |
|---|---|---|---|---|---|---|

## Include
- Entity definitions
- Relationships
- Defaults
- Validation rules
- Lifecycle states
- Retention/deletion rules
- Audit requirements

## Checklist
- [ ] Business meaning của fields rõ
- [ ] Sensitive data identified
- [ ] Lifecycle rõ
- [ ] Retention/deletion rõ
- [ ] Audit fields rõ
